#!/usr/bin/perl
# clipboard-filter.pl — sanitize text on its way to the system clipboard.
#
# tmux pipes copied text through this before handing it to xclip. It removes
# characters that other applications (browsers, chat apps, GUI toolkits) often
# mishandle or crash on, while preserving ordinary readable Unicode such as
# accented letters, CJK, emoji, and box-drawing characters.
#
# Deleted:
#   - C0 control characters except tab (\t) and newline (\n); also DEL (\x7F)
#   - C1 control characters (U+0080-U+009F)
#   - Soft hyphen, zero-width chars, joiners, BOM, and bidirectional controls
#   - Private Use Area glyphs (Powerline / Nerd Font icons):
#       U+E000-U+F8FF, U+F0000-U+FFFFD, U+100000-U+10FFFD
# Normalized:
#   - No-break / exotic spaces -> a regular space (so words don't fuse together)

use strict;
use warnings;

binmode STDIN,  ':encoding(UTF-8)';
binmode STDOUT, ':encoding(UTF-8)';

local $/;                       # slurp all of stdin
my $text = <STDIN>;
exit 0 unless defined $text;

# No-break and exotic spaces -> a normal space.
$text =~ s/[\x{00A0}\x{2007}\x{202F}]/ /g;

# Delete control, invisible, bidirectional, and Private Use Area characters.
# Single line / no /x so that real spaces and newlines are never matched.
$text =~ s/[\x{00}-\x{08}\x{0B}-\x{1F}\x{7F}\x{80}-\x{9F}\x{AD}\x{200B}-\x{200F}\x{202A}-\x{202E}\x{2060}\x{2066}-\x{2069}\x{FEFF}\x{E000}-\x{F8FF}\x{F0000}-\x{FFFFD}\x{100000}-\x{10FFFD}]//g;

print $text;
