#! /usr/bin/env nu

def main [
    --value (-v): string
    --restore (-r)
] {
    if ($value | is-empty) and (not $restore) {
        print "Rerun with --help to see the available flags."
        return
    }

    if $restore {
        brightnessctl --quiet --restore | ignore
        return
    }

    brightnessctl --quiet --save set $value

    let current_brightness = brightnessctl get | into int
    let max_brightness = brightnessctl max | into int

    let percent = ($current_brightness / $max_brightness * 100) | into int

    dunstify --close 101
    dunstify --replace 101 --timeout 1000 i3 $"Current Brightness: ($percent)%"
}
