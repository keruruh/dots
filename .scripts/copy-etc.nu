#! /usr/bin/env nu

def main [] {
    let files = [
        { file: "environment", location: "/etc/environment" },
        { file: "locale.gen", location: "/etc/locale.gen" },
        { file: "ly.ini", location: "/etc/ly/config.ini" }
        { file: "pacman.conf", location: "/etc/pacman.conf" },
	{ file: "xorg.conf", location: "/etc/X11/xorg.conf" }
    ]

    $files | each { |f|
        sudo (cp
            --force
            ($nu.home-path | path join $".etc/($f.file)")
            $f.location)
    }

    sudo locale-gen | ignore

    print "You might need to restart your system to apply some changes."
}
