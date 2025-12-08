#! /usr/bin/env nu

def main [] {
    let ss = "/tmp/lock_screen.png"

    rm --force $ss

    flameshot full --path $ss
    mogrify -scale 10% -blur 0x2.5 -resize 1000% -colorspace gray $ss

    i3lock --ignore-empty-password --tiling --image $ss
}
