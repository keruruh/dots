#! /usr/bin/env nu

def "wallpaper reload" [image: string] {
    feh --no-fehbg --bg-scale $image
    hellwal --quiet --image $image

    (kitten @ set-colors
        --all
        --configured ($nu.home-path | path join ".cache/hellwal/kitty.conf"))

    i3-msg --quiet restart

    # Reload Nu's theme in the current shell.
    # Other shells will need to be manually restarted.
    #
    # I don't know if there is a better way to do this, or if I'm missing something,
    # since I've tried using Kitty's remote control to source "$nu.config-path" in all
    # Kitty instances but the results are very ugly.
    exec nu
}

def "wallpaper restore" [] {
    # Default to the current wallpaper.
    mut pape = glob ($nu.home-path | path join ".papes/_current.*")

    if ($pape | is-empty) {
        # If there is no current wallpaper, use the "default" one.
        $pape = glob ($nu.home-path | path join ".papes/_default.*")

        if ($pape | is-empty) {
            print "Set a default wallpaper first."
            exit 1
        }
    }

    # The result is a list of a single path-like element, hence "| get 0".
    wallpaper reload ($pape | get 0)
}

def "wallpaper set" [image: string] {
    let dir = $nu.home-path | path join ".papes"

    # In the extremely rare case that there is more than a single "_current.*" file,
    # delete all of them to prevent weird stuff from happening.
    glob ($dir | path join "_current.*") | each { |old|
        rm --force $old
    }

    let extension = ($image | path parse | get extension)
    let current = $dir | path join $"_current.($extension)"

    cp $image $current

    # Force-delete Hellwal's old cache before generating a new colorscheme.
    rm --recursive --force ($nu.home-path | path join ".cache/hellwal/cache")

    wallpaper reload $current
}

def main [
    --image (-i): string
    --restore (-e)
    --random (-r)
] {
    if ($image | is-empty) and (not $random and not $restore) {
        print "Rerun with "--help" to see the available flags."
        exit 1
    }

    if (
        $restore
        or (
            ($image | is-not-empty)
            and (($image | path parse).stem =~ "(_current|_default)")
        )
    ) {
        wallpaper restore
        exit 0
    }

    if $random {
        let dir = $nu.home-path | path join ".papes"

        let papes = glob --no-dir $"($dir)/**"
            | where ($it | path parse).stem !~ ".keep"

        loop {
            let random_pape = $papes
                | where ($it | path parse).stem !~ "(_current|_default)"
                | shuffle
                | first

            if ($random_pape | is-empty) {
                print "Could not find a valid wallpaper to choose from."
                exit 1
            }

            let current_pape = $papes
                | where ($it | path parse).stem =~ "_current"
                | first

            if (
                ($current_pape | is-empty)
                or (
                    (open $current_pape | hash md5)
                    != (open $random_pape | hash md5)
                )
            ) {
                wallpaper set $random_pape
            }
        }
    }

    wallpaper set $image
}
