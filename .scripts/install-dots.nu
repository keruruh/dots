#! /usr/bin/env nu

def main [] {
    let packages = [
        autotiling
        breeze
        breeze-gtk
        breeze-icons
        clang
        dunst
        feh
        ffmpeg
        firefox
        flameshot
        i3-wm
        i3lock
        i3status
        imagemagick
        keepassxc
        kitty
        lua
        luajit
        luarocks
        llvm
        lxappearance
        ly
        mpv
        nushell
        pavucontrol
        picom
        python
        python-pipx
        qt5ct
        qt6ct
        rofi
        rustup
        starship
        yazi
        zig
        zls
    ]

    rustup default stable

    git clone https://aur.archlinux.org/paru.git; cd paru/
    makepkg --syncdeps --install --noconfirm; cd

    rm --force --recursive --permanent * .*
    git clone https://github.com/keruruh/dots.git .

    sudo pacman --sync --noconfirm ($packages | str join " ")

    ~/.scripts/copy-etc.nu
    ~/.scripts/list-packages.nu

    sudo systemctl enable ly@tty1.service
    sudo systemctl disable getty@tty1.service
}

