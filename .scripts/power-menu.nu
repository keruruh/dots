#! /usr/bin/env nu

def main [] {
    const options = [
        Lock
        Logout
        Reboot
        Shutdown
        Suspend
    ]

    let selection = echo ($options | str join "\n") | rofi -dmenu -p "Power Menu"

    match $selection {
        Lock => {
            nu ($nu.home-path | path join ".config/i3/scripts/i3lock.nu")
        },

        Logout => {
            i3-msg exit
        },

        Reboot => {
            systemctl reboot
        },

        Shutdown => {
            systemctl poweroff
        },

        Suspend => {
            systemctl suspend-then-hibernate
        }
    }
}
