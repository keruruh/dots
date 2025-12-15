#! /usr/bin/env python3

import datetime
import glob
import json
import locale
import os
import psutil
import re
import socket
import subprocess
import time

wallpaper_color = None

def get_wallpaper_color() -> str:
    global wallpaper_color

    # If the wallpaper color has been previously fetched, return the globally
    # stored value.
    if wallpaper_color:
        return wallpaper_color

    wallpapers = glob.glob(os.path.expanduser("~/.papes/_current.*"))
    default_color = "#ffffff"

    if not wallpapers:
        wallpaper_color = default_color
        return default_color

    wallpaper = wallpapers[0]

    out = subprocess.check_output([
        "hellwal",
        "--quiet",
        "--json",
        "--skip-term-colors",
        "--no-cache",
        "--image",
        wallpaper
    ], text=True)

    data = json.loads(out)
    wallpaper_color = data.get("colors", {}).get("color10", default_color)

    return wallpaper_color

# Interval (in seconds) to wait for updates of blocks (except datetime).
# This is useful for blocks where frequent updates might not be necessary.
SLOW_UPDATE_INTERVAL = 10.0

# The number of pixels to leave as a gap after a block.
# A separator symbol will be drawn in the middle of this gap.
SEPARATOR_BLOCK_WIDTH = 25

# Specifies the locale used for formatting the current date and time.
# Note that the specified locale must be installed on the system beforehand for
# it to work.
DATETIME_LOCALE = "ja_JP"

# Custom format for displaying the current date and time using strftime(3).
# Supports pango formatting to style the output.
DATETIME_FORMAT = (
    f"%F (<b><span foreground='{get_wallpaper_color()}'>%a</span></b>) %T"
)

def wrap_name(title: str, text: str) -> str:
    return (
        f"<b><span foreground='{get_wallpaper_color()}'>{title}</span></b>: "
        f"{text}"
    )

def format_bytes(size: int) -> str:
    return f"{(size / (1024 ** 3)):.2f} GiB"

def pretty_wifi() -> dict:
    stats = psutil.net_if_stats()
    addrs = psutil.net_if_addrs()

    interface = None

    for name in stats:
        if name.startswith(("wl", "wlan")):
            interface = name
            break

    if interface is None or not stats[interface].isup:
        return {
            "name": "id_wifi",
            "full_text": wrap_name("WLS", "Disconnected")
        }

    def get_ssid() -> dict:
        try:
            out = subprocess.check_output([
                "iw",
                interface,
                "link"
            ], stderr=subprocess.DEVNULL, text=True)


            if m := re.search(r"SSID: (.+)", out):
                return m.group(1).strip()
        except Exception:
            pass

        return "N/A"

    def get_ping() -> str:
        try:
            out = subprocess.check_output([
                "ping",
                "-c",
                "1",
                "-w",
                "1",
                "8.8.8.8"
            ], stderr=subprocess.DEVNULL, text=True)

            if m := re.search(r"time=([\d.]+) ms", out):
                return f"{int(float(m.group(1)))} ms"
        except Exception:
            pass

        return "N/A"

    ipv4 = "No IP"

    for a in addrs[interface]:
        if a.family == socket.AF_INET:
            ipv4 = a.address
            break

    return {
        "name": "id_wifi",
        "full_text": wrap_name("WLS", f"{get_ssid()} at {get_ping()}")
    }

def pretty_ethernet() -> dict:
    stats = psutil.net_if_stats()
    addrs = psutil.net_if_addrs()

    eth = None

    for name in stats:
        if name.startswith(("en", "eth")):
            eth = name
            break

    if eth is None or not stats[eth].isup:
        return {
            "name": "id_ethernet",
            "full_text": wrap_name("ETH", "Disconnected")
        }

    ipv4 = "No IP"

    for a in addrs[eth]:
        if a.family == socket.AF_INET:
            ipv4 = a.address
            break

    return {
        "name": "id_ethernet",
        "full_text": wrap_name("ETH", f"{eth} ({ipv4})")
    }

def pretty_cpu() -> dict:
    cpu_percent = psutil.cpu_percent()
    temps = psutil.sensors_temperatures()

    current_temp = None

    for key in ["acpitz", "coretemp"]:
        if key in temps and temps[key]:
            current_temp = int(temps[key][0].current)
            break

    temp_text = f"{current_temp}°C" if current_temp is not None else "N/A"

    return {
        "name": "id_cpu",
        "full_text": wrap_name("CPU", f"{cpu_percent:.2f}% at {temp_text}")
    }

def pretty_memory() -> str:
    memory = psutil.virtual_memory()

    used = format_bytes(memory.used)
    total = format_bytes(memory.total)
    percent = f"{(memory.used / memory.total * 100):.2f}"

    return {
        "name": "id_memory",
        "full_text": wrap_name("RAM", (
            f"{used} of {total} ({percent}%)"
        ))
    }

def pretty_battery() -> str:
    battery = psutil.sensors_battery()

    if not battery:
        return {
            "name": "id_battery",
            "full_text": wrap_name("BAT", "None")
        }

    percent = "Full" if int(battery.percent) == 100 else f"{battery.percent:.2f}%"
    plugged = "Plugged" if battery.power_plugged else "Not Plugged"
    left = str(datetime.timedelta(seconds=battery.secsleft))

    return {
        "name": "id_battery",
        "full_text": wrap_name("BAT", f"{percent} left {left} ({plugged})")
    }

def pretty_uptime() -> str:
    seconds = int(time.time() - psutil.boot_time())

    weeks, seconds = divmod(seconds, 604800)
    days, seconds = divmod(seconds, 86400)
    hours, seconds = divmod(seconds, 3600)
    minutes, seconds = divmod(seconds, 60)

    parts = []

    parts.append(f"{weeks} weeks") if weeks > 0 else None
    parts.append(f"{days} days") if days > 0 else None
    parts.append(f"{hours} hours") if hours > 0 else None
    parts.append(f"{minutes} minutes") if minutes > 0 else None

    return {
        "name": "id_uptime",
        "full_text": wrap_name("UP", f'{", ".join(parts) or "Waking..."}')
    }

def pretty_now() -> dict:
    try:
        locale.setlocale(locale.LC_TIME, f"{DATETIME_LOCALE}.UTF-8")
    except locale.Error:
        # Use default locale.
        pass

    now = datetime.datetime.now().strftime(DATETIME_FORMAT)

    return {
        "name": "id_time",
        "full_text": f"<big>{now}</big> "
    }

def get_slow_blocks() -> list[dict]:
    return [
        pretty_wifi(),
        pretty_ethernet(),
        pretty_cpu(),
        pretty_memory(),
        pretty_battery(),
        pretty_uptime(),
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
            block.setdefault("markup", "pango")
            block.setdefault("separator_block_width", SEPARATOR_BLOCK_WIDTH)

        print(f", {json.dumps(blocks)}", flush=True)

        time.sleep(1.0)
