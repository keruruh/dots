#! /usr/bin/env nu

def "wallpaper restore" [] {
    feh --no-fehbg --bg-scale (glob ($nu.home-path | path join ".papes" "current.*") | get 0)
}

def "wallpaper set" [image: string] {
    let dir = $nu.home-path | path join ".papes"

    glob ($dir | path join "current.*") | each { |old|
        rm --force $old
    }

    let extension = ($image | path parse | get extension)
    let current = $dir | path join $"current.($extension)"

    rm --recursive --force ($nu.home-path | path join ".cache/hellwal/cache")
    cp $image $current

    feh --no-fehbg --bg-scale $current
    hellwal --quiet --bright-offset 1.0 --image $current

    i3-msg --quiet restart

    ps | where name =~ "kitty" | each { |kitty|
        kill --signal 10 $kitty.pid
    }
}

def main [
    --image (-i): string
    --random
    --restore
] {
    if ($restore) {
        wallpaper restore
        return
    }

    if (($image | is-empty) and not $random) {
        print "Rerun with --help to see the available flags."
        return
    }

    if $random {
        let dir = $nu.home-path | path join ".papes"

        let wallpapers = glob --no-dir $"($dir)/**" | where ($it | path parse).stem !~ ".keep"
        let current = $wallpapers | where ($it | path parse).stem =~ "current" | first

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
