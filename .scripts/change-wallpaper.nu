#! /usr/bin/env nu

def set-wallpaper [image: string] {
    let extension = $image | path parse | get extension
    let current = $nu.home-path | path join ".papes" $"current.($extension)"

    rm --recursive --force ($nu.home-path | path join ".cache/hellwal/cache")
    cp $image $current

    # Set wallpaper.
    feh --no-fehbg --bg-scale $current

    # Generate color pallette.
    hellwal --quiet --bright-offset 1.0 --image $current

    # Restart i3.
    i3-msg --quiet restart

    # Restart kitty.
    ps | where name =~ "kitty" | each { |k|
        kill --signal 10 $k.pid
    }
}

def main [
    --image (-i): string
    --random
] {
    if (($image | is-empty) and not $random) {
        print "Rerun with --help to see the available flags."
        return
    }

    if ($random) {
        loop {
            let wallpapers = glob --no-dir ($nu.home-path | path join ".papes/**")
                | path parse
                | where $it.stem !~ ".keep"
                | shuffle

            let random_wallpaper = $wallpapers | where $it.stem !~ "current" | first
            let current_wallpaper = $wallpapers | where $it.stem =~ "current" | first

            if ($current_wallpaper | is-empty) {
                print "Couldn't detect the current wallpaper."
                print "Manually set a wallpaper before using --random."

                return
            } else {
                let random_hash = ($random_wallpaper | path join) | hash md5
                let current_hash = ($current_wallpaper | path join) | hash md5

                if $random_hash != $current_hash {
                    set-wallpaper ($random_wallpaper | path join)
                    break
                }
            }
        }

        return
    }

    set-wallpaper $image
}
