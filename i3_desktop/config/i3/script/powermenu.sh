#!/bin/bash

menu=(
  "" "systemctl poweroff"
  "" "systemctl reboot"
  "" "~/.config/i3/script/lock.sh"
  "" "systemctl suspend"
  "" "i3-msg exit"
)

menu_key=$(printf '%s\n' "${menu[@]}" | awk 'NR % 2 == 1')

uptime=$(uptime -p | sed -e 's/up //g')

rofi_cmd="
  rofi
	  -dmenu
		-format i
		-selected-row 2
		-theme $HOME/.config/rofi/powermenu/full_circle.rasi"

selected="$(echo "$menu_key" | $rofi_cmd -p "Uptime: $uptime")"

if [[ ! -z "$selected" ]]; then
  i3-msg -q "exec ${menu[selected*2+1]}"
fi

