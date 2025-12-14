#! /usr/bin/env nu

def "wallpaper restore" [] {
    let current_wallpaper = (glob
        --no-dir
        ($nu.home-path | path join ".papes/current.*") | get 0)

    feh --quiet --no-fehbg --bg-scale $current_wallpaper
}

def "wallpaper set" [image: string] {
    let dir = $nu.home-path | path join ".papes"

    glob ($dir | path join "current.*") | each { |old|
        rm --force $old
    }

    let extension = ($image | path parse | get extension)
    let current = $dir | path join $"current.($extension)"

    cp $image $current

    rm --recursive --force ($nu.home-path | path join ".cache/hellwal/cache")

    feh --no-fehbg --bg-scale $current
    hellwal --quiet --image $current

    (kitten @ set-colors
        --all
        --configured ($nu.home-path | path join ".cache/hellwal/kitty.conf"))

    exec nu
    i3-msg --quiet restart
}

def main [
    --image (-i): string
    --random (-r)
    --restore (-e)
] {
    if ($image | is-empty) and (not $random and not $restore) {
        print "Rerun with --help to see the available flags."
        return
    }

    if $restore {
        wallpaper restore
        return
    }

    if $random {
        let dir = $nu.home-path | path join ".papes"

        let wallpapers = glob --no-dir $"($dir)/**"
            | where ($it | path parse).stem !~ ".keep"

        let current = $wallpapers
            | where ($it | path parse).stem =~ "current"
            | first

        loop {
            let random_wallpaper = $wallpapers
                | where $it != $current
                | shuffle
                | first

            if ($random_wallpaper | is-empty) {
                break
            }

            wallpaper set $random_wallpaper
            break
        }

        return
    }

    wallpaper set $image
}
