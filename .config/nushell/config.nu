#! /usr/bin/env nu

$env.config.history = {
    file_format: plaintext
    max_size: 5_000_000
    isolation: false
}

$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.buffer_editor = $env.EDITOR

$env.config.table = {
    mode: "light"
    show_empty: false
    trim: {
        methodology: "truncating"
        truncating_suffix: "..."
    }
}

$env.config.datetime_format = {
    table: "%y-%m-%d %H:%M:%S"
    normal: "%y-%m-%d %H:%M:%S"
}

$env.config.filesize = {
    unit: "binary"
    precision: 2
}

#
# CUSTOM FUNCTIONS
#

def ll [args?: string] {
    ls --all ($args | default "./") | sort-by type name
}

def --env y [...args: string] {
    let tmp = mktemp --tmpdir "yazi-cwd.XXXXXX"
    let cwd = open $tmp

    yazi ...$args --cwd-file $tmp

    if $cwd != "" and $cwd != $env.PWD {
        cd $cwd
    }

    rm --force --permanent $tmp
}

#
# CUSTOM ALIASES
#

alias yh = y $nu.home-path
alias yc = y $nu.home-path | path join ".config"
alias ys = y $nu.home-path | path join ".config/nushell/scripts"

alias upgrade = sudo pacman --sync --refresh --refresh --sysupgrade --confirm
alias orphans = pacman --query --unrequired --deps

#
# MISC STUFF
#

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save --force ($nu.data-dir | path join "vendor/autoload/starship.nu")
