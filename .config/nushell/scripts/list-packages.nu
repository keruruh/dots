#! /usr/bin/env nu

def main [] {
    let current_date = date now | format date "%Y-%m-%d %H:%M:%S"
    let file_header = $"# Generated at ($current_date)\n"
    let package_list = pacman --query --quiet --explicit --native

    let save_file = $"($nu.home-path)/.config/packages.txt"

    $file_header + (char newline) | save --force $save_file
    $package_list + (char newline) | save --force --append $save_file
}
