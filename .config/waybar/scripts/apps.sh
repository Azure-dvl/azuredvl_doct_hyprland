#!/bin/bash

# Menu de aplicaciones usando rofi
CHOICE=$(echo "Android Studio
Visual Studio Code
OBS Studio
Telegram
Thunderbird
Lutris
Discord" | rofi -dmenu -width 20 -p "Apps")

case "$CHOICE" in
    "Android Studio")
        /usr/bin/android-studio &
        ;;
    "Visual Studio Code")
        /usr/bin/code &
        ;;
    "OBS Studio")
        /usr/bin/obs &
        ;;
    "Telegram")
        /usr/bin/Telegram &
        ;;
    "Thunderbird")
        /usr/bin/thunderbird &
        ;;
    "Lutris")
        /usr/bin/lutris &
        ;;
    "Discord")
        gtk-launch discord-460807638964371468.desktop &
        ;;
esac