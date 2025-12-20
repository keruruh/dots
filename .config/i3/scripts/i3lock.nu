#! /usr/bin/env nu

def main [] {
    let screen = "/tmp/lock-screen.png"

    rm --force $screen

    flameshot full --path $screen
    mogrify -scale 10% -blur 0x2.5 -resize 1000% -colorspace gray $screen

    i3lock --ignore-empty-password --tiling --image $screen
}
