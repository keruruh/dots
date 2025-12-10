#! /usr/bin/env nu

def main [] {
    let screen = "/tmp/lock_screen.png"

    rm --force $screen

    # Take a screenshot of all the screens.
    flameshot full --path $screen

    # Blur and convert the screenshot to grayscale.
    mogrify -scale 10% -blur 0x2.5 -resize 1000% -colorspace gray $screen

    # Lock the screen using i3lock.
    i3lock --ignore-empty-password --tiling --image $screen
}
