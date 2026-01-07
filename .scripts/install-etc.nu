#! /usr/bin/env nu

def main [
    --user (-u): string
    --logout (-x)
] {
    if (whoami) != "root" {
        print "Rerun the script as sudo."
        return
    }

    if ($user | is-empty) {
        print "You must specify a user."
        return
    }

    let files = [
        { file: "environment", location: "/etc/environment" },
        { file: "locale.gen", location: "/etc/locale.gen" },
        { file: "ly.ini", location: "/etc/ly/config.ini" },
        { file: "pacman.conf", location: "/etc/pacman.conf" },
        { file: "xorg.conf", location: "/etc/X11/xorg.conf" },
    ]

    let source_dir = $"/home/($user)/.etc"

    $files | each { |f|
        let source_file = ($source_dir | path join $f.file)
        let backup_file = $f.location + ".bak"

        if not ($source_file | path exists) {
            print $"Skipping missing file: ($source_file)"
            return
        }

        if ($f.location | path exists) and not ($backup_file | path exists) {
            mv $f.location $backup_file
        }

        cp --force $source_file $f.location
    }

    locale-gen | ignore

    if $logout {
        systemctl restart ly@tty1.service
    }

    print "You might need to restart your system to apply some changes."
}
