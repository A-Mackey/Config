#!/bin/bash
# Small helpers for the tmux status-right segments (see conf.d/30-statusbar.conf).

case "$1" in
  cpu)
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf "%.0f%%", 100 - $1}'
    ;;
  ram)
    free -m | awk '/Mem:/{printf "%.0f%%", $3/$2*100}'
    ;;
  disk)
    df -h / | awk 'NR==2{print $5}'
    ;;
esac
