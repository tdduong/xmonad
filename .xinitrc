#!/bin/bash
#noted the currently state of the system
pacman -Q > /data/Infrastructure/tdduong/archlinux_daily_update/`date '+%F'`_packages.txt
stalonetray &
xscreensaver -no-splash &
parcellite &
xsetroot -cursor_name left_ptr
setxkbmap -layout en
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -x -d
xrdb -merge ~/.Xresources &
exec xmonad
