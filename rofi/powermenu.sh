#!/usr/bin/env bash

lock="lock"
suspend="suspend"
reboot="reboot"
shutdown="poweroff"

chosen=$(printf "%s\n%s\n%s\n%s" "$lock" "$suspend" "$reboot" "$shutdown" | rofi -dmenu -i -p "Power Menu" -theme ~/dotfiles/rofi/powermenu.rasi)
confirm_exit() {
  echo -e "No\nYes" | rofi -dmenu -i -p "Are you sure?" -theme ~/dotfiles/rofi/confirm.rasi
}
case "$chosen" in
  "$lock")
      swaylock -C ~/dotfiles/mango/modules/lock.conf
    ;;
  "$suspend")
        ans=$(confirm_exit)
        if [ "$ans" = "Yes" ]; then
            loginctl suspend
        fi
        ;;
    "$reboot")
        ans=$(confirm_exit)
        if [ "$ans" = "Yes" ]; then
            loginctl reboot
        fi
        ;;
    "$shutdown")
        ans=$(confirm_exit)
        if [ "$ans" = "Yes" ]; then
            loginctl poweroff
        fi
        ;;
    esac
