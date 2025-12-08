let base00 = "#%% color0.hex %%"
let base01 = "#%% color1.hex %%"
let base02 = "#%% color2.hex %%"
let base03 = "#%% color3.hex %%"
let base04 = "#%% color4.hex %%"
let base05 = "#%% color5.hex %%"
let base06 = "#%% color6.hex %%"
let base07 = "#%% color7.hex %%"
let base08 = "#%% color8.hex %%"
let base09 = "#%% color9.hex %%"
let base0a = "#%% color10.hex %%"
let base0b = "#%% color11.hex %%"
let base0c = "#%% color12.hex %%"
let base0d = "#%% color13.hex %%"
let base0e = "#%% color14.hex %%"
let base0f = "#%% color15.hex %%"

let base16_theme = {
    separator: $base03
    leading_trailing_space_bg: $base04
    header: $base0b
    datetime: $base0e
    filesize: $base0d
    row_index: $base0c
    bool: $base08
    int: $base0b
    duration: $base08
    range: $base08
    float: $base08
    string: $base04
    nothing: $base08
    binary: $base08
    cell-path: $base08
    hints: dark_gray

    shape_garbage: { fg: $base07 bg: $base08 attr: b }
    shape_bool: $base0d
    shape_int: { fg: $base0e attr: b }
    shape_float: { fg: $base0e attr: b }
    shape_range: { fg: $base0a attr: b }
    shape_internalcall: { fg: $base0c attr: b }
    shape_external: $base0c
    shape_externalarg: { fg: $base0b attr: b }
    shape_literal: $base0d
    shape_operator: $base0a
    shape_signature: { fg: $base0b attr: b }
    shape_string: $base0b
    shape_filepath: $base0d
    shape_globpattern: { fg: $base0d attr: b }
    shape_variable: $base0e
    shape_flag: { fg: $base0d attr: b }
    shape_custom: { attr: b }
}

$env.config.color_config = $base16_theme
$env.config.ls.use_ls_colors = true
$env.config.use_ansi_coloring = true
