#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

xset +fp /usr/share/fonts/local
xset fp rehash

#set GTK2

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#Habilita as configuracoes presentes no arquivo .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

#xsetroot -solid "#192c2c"

#Poe papel de parede do Feh
sh ~/.fehbg &

#Secoes

session=${1:-ratpoison}

case $session in
		dwm) $HOME/.dwm_bar.sh & exec dwm;;
		openbox) exec openbox-session;;
		i3) exec i3;;
		ratpoison) exec ratpoison;;
		# No known session, try to run it as command
		*) exec $1;;

esac

#Secoes - configuracao manual

#---OPENBOX---
#Configura e executa sessao do Openbox
#tint2 &
#exec openbox-session

#while true; do

#	DWM_VOL=$( amixer -c0 sget Master | awk -vORS=' ' '/Mono:/{print($6$4)}');
#	DWM_CLOCK=$( date '+[%e %b %Y %a][%I:%M]');

#    DWM_STATUS="| $DWM_VOL| $DWM_CLOCK";
#	xsetroot -name "$DWM_STATUS";

#	sleep 1s;

#	done & exec dwm

#---dwm---
#Start dwm with conky status bar
#conky | while read -r; do xsetroot -name "$REPLY"; done &
#exec dwm

#---ratpoison---
#exec ratpoison

#---i3---
#exec i3

#---bspwm---
#sxhkd &
#exec bspwm


