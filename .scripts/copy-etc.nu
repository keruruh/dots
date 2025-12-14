#! /usr/bin/env nu

def main [] {
    let files = [
        { file: "environment", location: "/etc/environment" },
        { file: "pacman.conf", location: "/etc/pacman.conf" },
        { file: "locale.gen", location: "/etc/locale.gen" },
        { file: "ly.ini", location: "/etc/ly/config.ini" }
    ]

    $files | each { |f|
        sudo cp --force ($nu.home-path | path join $".etc/($f.file)") $f.location
    }

    sudo locale-gen | ignore
}
