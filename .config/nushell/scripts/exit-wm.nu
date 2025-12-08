#! /usr/bin/env nu

def main [] {
    (i3-nagbar
        --primary
        --type warning
        --font "pango:DejaVu Sans Mono 16"
        --message "Do you really want to exit i3?"
        --button-no-terminal "Exit i3" "i3-msg exit"
        --button-no-terminal "System Shutdown" "systemctl poweroff")
}
