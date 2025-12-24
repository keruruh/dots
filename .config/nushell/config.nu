#! /usr/bin/env nu

source $nu.env-path
source ($nu.default-config-dir | path join "aliases.nu")
source ($nu.home-path | path join ".cache/hellwal/nushell.nu")

$env.config.history = {
    file_format: plaintext
    max_size: 5_000_000
    isolation: false
}

$env.config.show_banner = false

$env.config.edit_mode = "vi"
$env.config.buffer_editor = $env.EDITOR

$env.config.table = {
    mode: compact
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

mkdir ($nu.data-dir | path join "vendor/autoload")

starship init nu
    | save --force ($nu.data-dir | path join "vendor/autoload/starship.nu")
