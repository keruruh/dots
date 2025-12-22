#! /usr/bin/env nu

def main [--logout] {
    let files = [
        { file: "environment", location: "/etc/environment" },
        { file: "locale.gen", location: "/etc/locale.gen" },
        { file: "ly.ini", location: "/etc/ly/config.ini" },
        { file: "ly.sh", location: "/etc/ly/setup.sh" },
        { file: "pacman.conf", location: "/etc/pacman.conf" },
        { file: "xorg.conf", location: "/etc/X11/xorg.conf" },
    ]

    $files | each { |f|
        if ($f.location | path exists) {
            mv $f.location + ".bak"
        }

        sudo cp --force $"/home/motxi/.etc/($f.file)" $f.location
    }

    sudo locale-gen | ignore

    if $logout {
        sudo systemctl restart ly@tty1.service
    }

    print "You might need to restart your system to apply some changes."
}
