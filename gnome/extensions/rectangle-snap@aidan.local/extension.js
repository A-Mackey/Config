/* Rectangle Snap — Rectangle-style window snapping for GNOME Shell.
 *
 * Reproduces the keymap of macOS's Rectangle on Ctrl+Super. Windows stay
 * floating and freely draggable; a snap only happens when you press a
 * shortcut. Nothing is ever auto-tiled.
 *
 * Halves traverse monitors: treat every monitor as two half-panes laid side by
 * side. Snapping left when the window already fills the left half moves it to
 * the right half of the monitor to the left (and likewise for the other three
 * directions). At the outermost pane it stays put.
 *
 * Geometry comes from Mutter's per-monitor work area, so the top bar and the
 * bottom dock are accounted for automatically, on every monitor.
 *
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import Meta from 'gi://Meta';
import Shell from 'gi://Shell';

import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

/* Each handler gets the work area (with precomputed half/third boundaries) and
 * the window's current frame, and returns the target frame as [x, y, w, h].
 *
 * Boundaries are rounded once and then sliced between, so adjacent regions
 * tile the work area exactly — no rounding gap or overlap at the seams. */
const SNAPS = {
    // Halves
    'snap-left-half': a => [a.x0, a.y0, a.xm - a.x0, a.y2 - a.y0],
    'snap-right-half': a => [a.xm, a.y0, a.x3 - a.xm, a.y2 - a.y0],
    'snap-top-half': a => [a.x0, a.y0, a.x3 - a.x0, a.ym - a.y0],
    'snap-bottom-half': a => [a.x0, a.ym, a.x3 - a.x0, a.y2 - a.ym],

    // Quarters
    'snap-top-left': a => [a.x0, a.y0, a.xm - a.x0, a.ym - a.y0],
    'snap-top-right': a => [a.xm, a.y0, a.x3 - a.xm, a.ym - a.y0],
    'snap-bottom-left': a => [a.x0, a.ym, a.xm - a.x0, a.y2 - a.ym],
    'snap-bottom-right': a => [a.xm, a.ym, a.x3 - a.xm, a.y2 - a.ym],

    // Thirds
    'snap-left-third': a => [a.x0, a.y0, a.x1 - a.x0, a.y2 - a.y0],
    'snap-center-third': a => [a.x1, a.y0, a.x2 - a.x1, a.y2 - a.y0],
    'snap-right-third': a => [a.x2, a.y0, a.x3 - a.x2, a.y2 - a.y0],
    'snap-left-two-thirds': a => [a.x0, a.y0, a.x2 - a.x0, a.y2 - a.y0],
    'snap-right-two-thirds': a => [a.x1, a.y0, a.x3 - a.x1, a.y2 - a.y0],

    // Whole work area
    'snap-maximize': a => [a.x0, a.y0, a.x3 - a.x0, a.y2 - a.y0],

    // Rectangle's "Center" preserves the window's size and only re-positions it.
    'snap-center': (a, frame) => [
        a.x0 + Math.max(0, Math.round((a.width - frame.width) / 2)),
        a.y0 + Math.max(0, Math.round((a.height - frame.height) / 2)),
        frame.width,
        frame.height,
    ],
};

// Centering only repositions; everything else also resizes.
const MOVE_ONLY = new Set(['snap-center']);

/* Halves that step to the neighbouring monitor when repeated. `into` is the
 * half the window lands in on that monitor — the one facing the monitor it
 * came from. */
const TRAVERSE = {
    'snap-left-half': { dir: Meta.DisplayDirection.LEFT, into: 'snap-right-half' },
    'snap-right-half': { dir: Meta.DisplayDirection.RIGHT, into: 'snap-left-half' },
    'snap-top-half': { dir: Meta.DisplayDirection.UP, into: 'snap-bottom-half' },
    'snap-bottom-half': { dir: Meta.DisplayDirection.DOWN, into: 'snap-top-half' },
};

/* How far a frame may be from a snap target and still count as "already
 * there". Terminals and other apps with resize increments round their size
 * down to a whole cell, so size gets more slack than position. */
const POS_SLACK = 4;
const SIZE_SLACK = 40;

function workAreaGrid(area) {
    return {
        width: area.width,
        height: area.height,
        // Horizontal: left edge, thirds, midpoint, right edge.
        x0: area.x,
        x1: area.x + Math.round(area.width / 3),
        x2: area.x + Math.round((area.width * 2) / 3),
        x3: area.x + area.width,
        xm: area.x + Math.round(area.width / 2),
        // Vertical: top edge, midpoint, bottom edge.
        y0: area.y,
        ym: area.y + Math.round(area.height / 2),
        y2: area.y + area.height,
    };
}

function frameMatches(frame, [x, y, w, h]) {
    return Math.abs(frame.x - x) <= POS_SLACK &&
        Math.abs(frame.y - y) <= POS_SLACK &&
        Math.abs(frame.width - w) <= SIZE_SLACK &&
        Math.abs(frame.height - h) <= SIZE_SLACK;
}

export default class RectangleSnapExtension extends Extension {
    enable() {
        this._settings = this.getSettings();

        for (const name of Object.keys(SNAPS)) {
            // addKeybinding returns Meta.KeyBindingAction.NONE (0) when the
            // accelerator could not be grabbed — usually another binding owns
            // it. It fails silently otherwise, so log the failure.
            const action = Main.wm.addKeybinding(
                name,
                this._settings,
                Meta.KeyBindingFlags.IGNORE_AUTOREPEAT,
                Shell.ActionMode.NORMAL,
                () => this._snap(name)
            );

            if (action === Meta.KeyBindingAction.NONE) {
                const accel = this._settings.get_strv(name).join(', ') || 'unbound';
                console.warn(`rectangle-snap: could not grab ${name} (${accel})`);
            }
        }
    }

    disable() {
        for (const name of Object.keys(SNAPS))
            Main.wm.removeKeybinding(name);

        this._settings = null;
    }

    _snap(name) {
        const win = global.display.get_focus_window();
        if (!win || win.get_window_type() !== Meta.WindowType.NORMAL)
            return;

        const needsResize = !MOVE_ONLY.has(name);
        if (!win.allows_move() || (needsResize && !win.allows_resize()))
            return;

        let monitor = win.get_monitor();
        let frame = win.get_frame_rect();

        // Repeating a half steps to the neighbouring monitor. Decide this
        // before un-maximizing, which changes the frame. A maximized window
        // never matches a half, so it just snaps on its own monitor.
        const traverse = TRAVERSE[name];
        if (traverse && !win.get_maximized()) {
            const here = win.get_work_area_for_monitor(monitor);
            if (frameMatches(frame, SNAPS[name](workAreaGrid(here), frame))) {
                const next = global.display.get_monitor_neighbor_index(monitor, traverse.dir);
                if (next < 0)
                    return; // Outermost pane; nowhere further to go.
                monitor = next;
                name = traverse.into;
            }
        }

        // A maximized or fullscreen window ignores move_resize_frame, so it has
        // to be restored first.
        if (win.is_fullscreen())
            win.unmake_fullscreen();

        const maximized = win.get_maximized();
        if (maximized)
            win.unmaximize(maximized);

        if (monitor !== win.get_monitor())
            win.move_to_monitor(monitor);

        const area = win.get_work_area_for_monitor(monitor);
        if (!area)
            return;

        frame = win.get_frame_rect();
        const [x, y, w, h] = SNAPS[name](workAreaGrid(area), frame);
        win.move_resize_frame(true, x, y, w, h);
    }
}
