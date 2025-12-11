#! /usr/bin/env nu

def main [] {
    [
        { file: "environment", location: "/etc/environment" },
        { file: "pacman.conf", location: "/etc/pacman.conf" },
        { file: "locale.gen", location: "/etc/locale.gen" },
        { file: "ly.ini", location: "/etc/ly/config.ini" }
    ] | each { |i|
        sudo cp --force ($nu.home-path | path join ".etc" | path join $i.file) $i.location
    }

    sudo locale-gen | ignore
}
