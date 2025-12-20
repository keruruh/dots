#! /usr/bin/env nu

# Ensure there is a default Hellwal theme that can be sourced on the first boot.
#   - If there is no "_default.*" file in ".papes/" it will choose a random one.
#   - If there are no files at all, it will fail.
if not ($nu.home-path | path join ".cache/hellwal" | path exists) {
    cd ($nu.home-path | path join ".scripts")
    set-wallpaper.nu --default
    cd
}

source $nu.config-path
source $nu.env-path

exec i3
