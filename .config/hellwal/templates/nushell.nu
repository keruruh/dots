#! /usr/bin/env nu

let c0 = "#%% color0.hex %%"
let c1 = "#%% color1.hex %%"
let c2 = "#%% color2.hex %%"
let c3 = "#%% color3.hex %%"
let c4 = "#%% color4.hex %%"
let c5 = "#%% color5.hex %%"
let c6 = "#%% color6.hex %%"
let c7 = "#%% color7.hex %%"
let c8 = "#%% color8.hex %%"
let c9 = "#%% color9.hex %%"
let c10 = "#%% color10.hex %%"
let c11 = "#%% color11.hex %%"
let c12 = "#%% color12.hex %%"
let c13 = "#%% color13.hex %%"
let c14 = "#%% color14.hex %%"
let c15 = "#%% color15.hex %%"

let base16_theme = {
    separator: $c3
    leading_trailing_space_bg: $c4
    header: $c11
    datetime: $c14
    filesize: $c13
    row_index: $c12
    bool: $c8
    int: $c11
    duration: $c8
    range: $c8
    float: $c8
    string: $c4
    nothing: $c8
    binary: $c8
    cell-path: $c8
    hints: dark_gray

    shape_garbage: { fg: $c7 bg: $c8 attr: b }
    shape_bool: $c13
    shape_int: { fg: $c14 attr: b }
    shape_float: { fg: $c14 attr: b }
    shape_range: { fg: $c10 attr: b }
    shape_internalcall: { fg: $c12 attr: b }
    shape_external: $c12
    shape_externalarg: { fg: $c11 attr: b }
    shape_literal: $c13
    shape_operator: $c10
    shape_signature: { fg: $c11 attr: b }
    shape_string: $c11
    shape_filepath: $c13
    shape_globpattern: { fg: $c13 attr: b }
    shape_variable: $c14
    shape_flag: { fg: $c13 attr: b }
    shape_custom: { attr: b }
}

$env.config.color_config = $base16_theme

$env.config.ls.use_ls_colors = true
$env.config.use_ansi_coloring = true
