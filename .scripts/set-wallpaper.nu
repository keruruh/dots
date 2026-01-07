#! /usr/bin/env nu

const PAPES_DIR = $nu.home-path | path join ".papes"

def "wallpaper reload" [image: string] {
    feh --no-fehbg --bg-scale $image
    hellwal --quiet --image $image

    (kitten @ set-colors
        --all
        --configured ($nu.home-path | path join ".cache/hellwal/kitty.conf"))

    if (pgrep dunst | is-not-empty) {
        pkill dunst
    }

    i3-msg --quiet restart

    # Reload Nu's colorscheme in the current shell.
    # Other shells will need to be manually restarted.
    #
    # I don't know if there is a better way to do this, or if I'm missing something,
    # since I've tried using Kitty's remote control to source `$nu.config-path` in all
    # Kitty instances but the results were very ugly.
    exec nu
}

def "wallpaper set" [image: string] {
    # In the extremely rare case that there is more than a single `.current.*` file,
    # delete all of them to prevent weird stuff from breaking the script.
    glob ($PAPES_DIR | path join ".current.*") | each { |old|
        rm --force $old
    }

    let extension = ($image | path parse | get extension)
    let current = $PAPES_DIR | path join $".current.($extension)"

    cp $image $current

    # Force-delete Hellwal's old cache before generating a new colorscheme.
    rm --recursive --force ($nu.home-path | path join ".cache/hellwal/cache")

    wallpaper reload $current
}

def "wallpaper random" [] {
    let papes = glob --no-dir $"($PAPES_DIR)/**"
        | where ($it | path parse).stem !~ ".keep"

    loop {
        let random_pape = $papes
            | where ($it | path parse).stem !~ "(.current|.default)"
            | shuffle
            | first

        if ($random_pape | is-empty) {
            print "Could not find a valid wallpaper to choose from."
            exit 1
        }

        let current_pape = $papes
            | where ($it | path parse).stem =~ ".current"
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

def "wallpaper restore" [] {
    # Default to the current wallpaper.
    mut pape = glob ($nu.home-path | path join ".papes/.current.*")

    if ($pape | is-empty) {
        # If there is no current wallpaper, use the "default" one.
        $pape = glob ($nu.home-path | path join ".papes/.default.*")

        if ($pape | is-empty) {
            wallpaper random
            return
        }
    }

    # The result is a list of a single path-like element, hence the `| get 0`.
    wallpaper reload ($pape | get 0)
}

def main [
    --image (-i): string
    --restore (-e)
    --random (-r)
] {
    if ($image | is-not-empty) {
        if ($image | path parse).stem =~ "(.current|.default)" {
            wallpaper restore
        }

        wallpaper set $image
    } else if $restore {
        wallpaper restore
    } else if $random {
        wallpaper random
    } else {
        print "Invalid usage. Rerun with `--help` to see the available flags."
    }
}
