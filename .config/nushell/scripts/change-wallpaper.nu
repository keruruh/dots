#! /usr/bin/env nu

def set-wallpaper [image: string] {
    let papes_dir = $"($nu.home-path)/Pictures/Wallpapers"

    let extension = $image | path parse | get extension
    let current = $"($papes_dir)/current.($extension)"

    rm --recursive --force $"($nu.home-path)/.cache/hellwal/cache/"
    cp $image $current

    feh --no-fehbg --bg-scale $current
    hellwal --quiet --image $current

    i3-msg --quiet restart
}

def main [
    --image (-i): string,
    --random
] {
    if (($image | is-empty) and not $random) {
        print "Rerun with --help to see available flags."
        return
    }

    if ($random) {
        loop {
            let wallpapers = ls $"($nu.home-path)/Pictures/Wallpapers/"

            let random_wallpaper = $wallpapers
                | where $it.name !~ current
                | shuffle
                | first

            let current_wallpaper = $wallpapers
                | where $it.name =~ current
                | first

            let random_hash = open ($random_wallpaper | get name) | hash md5
            let current_hash = open ($current_wallpaper | get name) | hash md5

            if ($random_hash != $current_hash) {
                set-wallpaper ($random_wallpaper | get name)
                break
            }
        }

        return
    }

    set-wallpaper $image
}
