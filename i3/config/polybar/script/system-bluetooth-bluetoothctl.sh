#!/bin/bash

bluetooth_print() {
    bluetoothctl | while read -r; do
        if [[ "$(systemctl is-active "bluetooth.service")" == "active" ]] && bluetoothctl show | grep -q "Powered: yes"; then
            printf '%%{T3}%%{T-}'

            devices_connected=$(bluetoothctl devices Connected | cut -d ' ' -f 2)
            counter=0

            for device in $devices_connected; do
                device_alias=$(bluetoothctl info "$device" | grep "Alias" | cut -d ' ' -f 2-)

                if [[ $counter > 0 ]]; then
                    printf ", %s" "$device_alias"
                else
                    printf " %s" "$device_alias"
                fi

                counter=$((counter + 1))
            done

            printf '\n'
        else
            echo "%{T3}%{T-}"
        fi
    done
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl devices Paired | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_connected=$(bluetoothctl devices Connected | cut -d ' ' -f 2)
        echo "$devices_connected" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac

