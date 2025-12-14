#! /usr/bin/env nu

def l [args?: string] {
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

alias yh = y $nu.home-path
alias yc = y ($nu.home-path | path join ".config")
alias ys = y ($nu.home-path | path join ".scripts")

alias upgrade = sudo pacman --sync --refresh --refresh --sysupgrade --confirm
alias orphans = pacman --query --unrequired --deps

alias gs = git status --short --branch
alias ga = git add
alias gaa = git add --all
alias gc = git commit --all --message

alias f = fzf --preview "bat --color always --style numbers {}"
alias rf = rm --force --recursive --permanent

