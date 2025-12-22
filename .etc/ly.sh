#! /usr/bin/env sh

exec > /dev/null 2>&1

if [ "$XDG_SESSION_TYPE" = "x11" ]; then
    if [ -d "/etc"/X11/xinit/xinitrc.d ]; then
        for i in "/etc"/X11/xinit/xinitrc.d/* ; do
            if [ -x "$i" ]; then
                . "$i"
            fi
        done
    fi

    [ -f "$HOME"/.Xresources ] && xrdb -merge "$HOME"/.Xresources
fi

exec "$@"
