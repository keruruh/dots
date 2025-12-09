#! /usr/bin/env nu

xrdb ~/.Xresources

source $nu.config-path
source $nu.env-path

exec i3
