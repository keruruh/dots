#! /usr/bin/env sh

CACHE_DIR="$HOME/.cache/hellwal"
SCRIPTS_DIR="$HOME/.scripts"

cd "$SCRIPTS_DIR" || exit 1

# Ensure there is a default Hellwal theme that can be sourced on the first boot.
#   * If there is no ".default.*" file in ".papes/" it will choose a random one.
#   * If there are no files at all, it will fail.
./set-theme.nu --restore
./set-brightness.nu --restore

cd "$HOME" || exit 1

[ -f "$HOME/.config/nushell/config.nu" ] && . "$HOME/.config/nushell/config.nu"
[ -f "$HOME/.config/nushell/env.nu" ] && . "$HOME/.config/nushell/env.nu"
