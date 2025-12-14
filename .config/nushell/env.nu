#! /usr/bin/env nu

$env.EDITOR = "nvim"
$env.BROWSER = "firefox"
$env.MANPAGER = "bat -plman"

$env.PATH = ($env.PATH | append ($nu.home-path | path join ".scripts" ))
