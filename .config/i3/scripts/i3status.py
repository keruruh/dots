#! /usr/bin/env python3

import datetime
import glob
import json
import locale
import os
import re
import shlex
import socket
import subprocess
import time

import psutil

wallpaper_color = None


def run_process(command: str) -> str | None:
    try:
        return subprocess.check_output(
            shlex.split(command), stderr=subprocess.DEVNULL, text=True
        ).strip()
    except subprocess.CalledProcessError:
        return None


def get_wallpaper_color() -> str:
    global wallpaper_color

    # If the wallpaper color has been previously fetched, return the stored value.
    # This is very important since otherwise we would call Hellwal every time the
    # blocks are updated, which produces a lot of lag.
    if wallpaper_color:
        return wallpaper_color

    wallpapers = glob.glob(os.path.expanduser("~/.papes/_current.*"))
    default_color = "#ffffff"

    if not wallpapers:
        wallpaper_color = default_color
        return default_color

    wallpaper = wallpapers[0]

    out = run_process(f"hellwal --skip-term-colors --no-cache -q -j -i {wallpaper}")
    wallpaper_color = json.loads(out).get("colors", {}).get("color11", default_color)

    return wallpaper_color


# Interval (in seconds) to wait for updates of blocks (except datetime).
# This is useful for blocks where frequent updates might not be necessary.
SLOW_UPDATE_INTERVAL: float = 5.0

# The number of pixels to leave as a gap after a block.
# A separator symbol will be drawn in the middle of this gap.
SEPARATOR_BLOCK_WIDTH: int = 20

# Specifies the locale used for formatting the current date and time.
# The specified locale must be installed on the system beforehand for it to work.
DATETIME_LOCALE: str = "ja_JP"

# Custom format for displaying the current date and time using strftime(3).
# Supports pango formatting to style the output.
DATETIME_FORMAT: str = (
    f"<big>%F (<b><span foreground='{get_wallpaper_color()}'>%a</span></b>) %T</big>"
)


def wrap_name(title: str, text: str) -> str:
    return f"<b><span foreground='{get_wallpaper_color()}'>{title}</span></b>: {text}"


def format_bytes(size: int) -> str:
    return f"{(size / (1024**3)):.2f} GiB"


def pretty_wifi() -> dict:
    stats = psutil.net_if_stats()

    interface = next((name for name in stats if name.startswith(("wl", "wlan"))), None)

    if interface is None or not stats[interface].isup:
        return

    def _nm_active_connection() -> str | None:
        out = run_process("nmcli -t -f DEVICE,NAME connection show --active")

        for line in out.splitlines():
            device, name = line.split(":", 1)

            if name and device == interface:
                return name

    def _nm_active_ssid() -> str | None:
        out = run_process(f"nmcli -t -f IN-USE,SSID dev wifi list ifname {interface}")

        for line in out.splitlines():
            in_use, ssid = line.split(":", 1)

            if in_use == "*":
                return ssid or None

    def _get_ping() -> str:
        out = run_process("ping -c 1 -w 1 8.8.8.8")

        for token in out.split():
            if token.startswith("time="):
                return f"{int(float(token[5:]))} ms"

        return "N/A"

    connection = _nm_active_connection()

    ssid = (
        run_process(f"nmcli -g 802-11-wireless.ssid connection show {connection}")
        if connection
        else _nm_active_ssid()
    )

    wifi_text = f"{connection or ssid or 'N/A'}, {_get_ping()}"

    return {
        "name": "id_wifi",
        "full_text": wrap_name("WLS", wifi_text),
    }


def pretty_ethernet() -> dict:
    stats = psutil.net_if_stats()
    addresses = psutil.net_if_addrs()

    ethernet = None

    for name in stats:
        if name.startswith(("en", "eth")):
            ethernet = name
            break

    if ethernet is None or not stats[ethernet].isup:
        return

    ipv4 = "No IP"

    for a in addresses[ethernet]:
        if a.family == socket.AF_INET:
            ipv4 = a.address
            break

    ethernet_text = f"{ethernet} ({ipv4})"

    return {
        "name": "id_ethernet",
        "full_text": wrap_name("ETH", ethernet_text),
    }


def pretty_cpu() -> dict:
    percent = psutil.cpu_percent()
    temps = psutil.sensors_temperatures()

    current_temp = None

    for key in ["acpitz", "coretemp"]:
        if key in temps and temps[key]:
            current_temp = int(temps[key][0].current)
            break

    current_temp = f"{current_temp}°C" if current_temp is not None else "N/A"

    cpu_text = f"{percent:.2f}% at {current_temp}"

    return {
        "name": "id_cpu",
        "full_text": wrap_name("CPU", cpu_text),
    }


def pretty_memory() -> str:
    memory = psutil.virtual_memory()

    used = format_bytes(memory.used)
    total = format_bytes(memory.total)
    percent = f"{(memory.used / memory.total * 100):.2f}"

    memory_text = f"{used} of {total} ({percent}%)"

    return {
        "name": "id_memory",
        "full_text": wrap_name("RAM", memory_text),
    }


def pretty_battery() -> str:
    battery = psutil.sensors_battery()

    if not battery:
        return

    percent = "Full" if int(battery.percent) == 100 else f"{battery.percent:.2f}%"

    battery_text = f"{percent} (Plugged)"

    if not battery.power_plugged:
        if int(battery.secsleft / 3600) == 0:
            battery_text = f"{int(battery.secsleft / 60)}m left, {percent}"
        else:
            battery_text = f"{int(battery.secsleft / 3600)}h left, {percent}"

    return {
        "name": "id_battery",
        "full_text": wrap_name("BAT", battery_text),
    }


def pretty_uptime() -> str:
    seconds = int(time.time() - psutil.boot_time())

    weeks, seconds = divmod(seconds, 604800)
    days, seconds = divmod(seconds, 86400)
    hours, seconds = divmod(seconds, 3600)
    minutes, seconds = divmod(seconds, 60)

    parts = []

    parts.append(f"{weeks}w") if weeks > 0 else None
    parts.append(f"{days}d") if days > 0 else None
    parts.append(f"{hours}h") if hours > 0 else None
    parts.append(f"{minutes}m") if minutes > 0 else None

    uptime_text = " ".join(parts) or "Waking..."

    return {
        "name": "id_uptime",
        "full_text": wrap_name("UP", uptime_text),
    }


def pretty_keyboard() -> dict:
    out = run_process("setxkbmap -print -verbose 10")

    if match := re.search(r"layout:(?: +)?([a-z]+)", out):
        keyboard_text = match.group(1).upper() or "N/A"

        return {
            "name": "id_keyboard",
            "full_text": wrap_name("KB", keyboard_text),
        }


def pretty_now() -> dict:
    try:
        locale.setlocale(locale.LC_TIME, f"{DATETIME_LOCALE}.UTF-8")
    except locale.Error:
        # Use default locale.
        pass

    now_text = datetime.datetime.now().strftime(DATETIME_FORMAT)

    return {
        "name": "id_time",
        "full_text": now_text,
    }


def get_slow_blocks() -> list[dict]:
    return [
        pretty_wifi(),
        pretty_ethernet(),
        pretty_cpu(),
        pretty_memory(),
        pretty_battery(),
        pretty_uptime(),
        pretty_keyboard(),
    ]


if __name__ == "__main__":
    print('{ "version": 1, "click_events": false }')
    print("[")
    print("[]")

    slow_blocks = get_slow_blocks()
    slow_last_update = 0

    while True:
        now = time.time()

        if now - slow_last_update >= SLOW_UPDATE_INTERVAL:
            slow_blocks = get_slow_blocks()
            slow_last_update = now

        blocks = slow_blocks + [pretty_now()]

        for block in blocks:
            if block:
                block.setdefault("markup", "pango")
                block.setdefault("separator_block_width", SEPARATOR_BLOCK_WIDTH)

        print(f", {json.dumps(blocks)}", flush=True)

        time.sleep(1.0)
