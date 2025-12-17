#! /usr/bin/env nu

# Ensure there is a default Hellwal theme that can be sourced on the first boot.
#   - If there is no "default.*" file in ".papes/" it will choose a random one.
#   - If there are no files at all, it will fail.
if not ($nu.home-path | path join ".cache/hellwal" | path exists) {
    cd ($nu.home-path | path join ".scripts")
    set-wallpaper.nu --default
    cd
}

source $nu.config-path
source $nu.env-path

# Redirect all i3 output to "/dev/null".
# You can remove or modify everything after "exec i3" if you don't like this.
exec i3 o+e> (std null-device)
