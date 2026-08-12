#!/usr/bin/env bash
# osc52-copy.sh — write stdin to the terminal clipboard via an OSC 52 escape
# sequence, instead of xclip. OSC 52 rides the same byte stream as ordinary
# terminal output, so it reaches the clipboard of whatever terminal is at the
# other end of the connection (Ghostty) even when tmux is running on a
# remote host over SSH with no local X server/DISPLAY for xclip to use.
#
# When run inside tmux, the sequence is wrapped in tmux's DCS passthrough
# format (see `allow-passthrough` in 20-clipboard.conf) so tmux forwards it
# to the real outer terminal instead of swallowing it.
set -euo pipefail

b64=$(base64 | tr -d '\n')
osc52=$'\033]52;c;'"${b64}"$'\007'

# tmux runs copy-pipe/run-shell commands as background jobs with no
# controlling terminal, so /dev/tty isn't available here (unlike an
# interactive shell). Ask tmux for the originating pane's tty and write
# there instead -- tmux resolves the (deliberately empty) target to the
# pane the job came from.
target=/dev/tty
if [ -n "${TMUX:-}" ]; then
  pane_tty=$(tmux display-message -p '#{pane_tty}' 2>/dev/null || true)
  [ -n "$pane_tty" ] && target="$pane_tty"
  osc52=$'\033Ptmux;'"${osc52//$'\033'/$'\033\033'}"$'\033\\'
fi

printf '%s' "$osc52" > "$target"
