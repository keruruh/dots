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

# Interval (in seconds) to wait for updates of the "slow" blocks.
SLOW_UPDATE_INTERVAL = 60

# The amount of pixels to leave blank after the block.
# In the middle of this gap, a separator symbol will be drawn.
SEPARATOR_BLOCK_WIDTH = 25

# Set a custom locale for the datetime now format.
# Note that the locale must be installed in the system beforehand
DATETIME_LOCALE = "ja_JP"

# Custom strftime(3) format (supports pango).
DATETIME_FORMAT = "%F (<b>%a</b>) %T"

#########
# UTILS #
#########

def _get_wallpaper_color() -> str:
    wallpapers = glob.glob(os.path.expanduser("~/.papes/current.*"))
    default_color = "#ffffff"

    if not wallpapers:
        return default_color

    wallpaper = wallpapers[0]

    try:
        out = subprocess.check_output(["hellwal", "--json", "--image", wallpaper], text=True)
        data = json.loads(out)

        return data.get("colors", {}).get("color10", "#ffffff")
    except Exception:
        return default_color

def _wrap_name(title: str, text: str) -> str:
    return f'<b><span foreground="{_get_wallpaper_color()}">{title}</span></b>: {text}'

def _format_bytes(size: int) -> str:
    return f"{(size / (1024 ** 3)):.2f} GiB"

##############
# CONNECTION #
##############

def _get_iw_info(interface: str) -> dict:
    try:
        out = subprocess.check_output(["iw", interface, "link"], stderr=subprocess.DEVNULL, text=True)
    except Exception:
        return {
            "ssid": None,
            "signal": None,
            "bitrate": None
        }

    ssid = None
    signal = None
    bitrate = None

    # SSID.
    if m := re.search(r"SSID: (.+)", out):
        ssid = m.group(1).strip()

    # Signal.
    if m := re.search(r"signal: (-?\d+) dBm", out):
        dbm = int(m.group(1))
        signal = max(0, min(100, 2 * (dBm + 90)))

    # Bitrate.
    if m := re.search(r"tx bitrate: ([\d.]+)", out):
        bitrate = f"{m.group(1)} Mb/s"

    return {
        "ssid": ssid,
        "signal": signal,
        "bitrate": bitrate
    }

def _get_ping_latency() -> str:
    try:
        out = subprocess.check_output(["ping", "-c", "1", "-w", "1", "8.8.8.8"], stderr=subprocess.DEVNULL, text=True)

        if m := re.search(r"time=([\d.]+) ms", out):
            return f"{float(m.group(1)):.1f} ms"
    except Exception:
        pass

    return "N/A"

def pretty_wifi() -> dict:
    stats = psutil.net_if_stats()
    addrs = psutil.net_if_addrs()

    wifi = None

    for name in stats:
        if name.startswith(("wl", "wlan")):
            wifi = name
            break

    if wifi is None or not stats[wifi].isup:
        return {
            "name": "id_wifi",
            "full_text": _wrap_name("WLS", "Disconnected")
        }

    ipv4 = "No IP"

    for a in addrs[wifi]:
        if a.family == socket.AF_INET:
            ipv4 = a.address
            break

    info = _get_iw_info(wifi)
    ping = _get_ping_latency()

    ssid = info["ssid"] or "Unknown"
    signal = f"{info['signal']}%" if info["signal"] is not None else "N/A"

    return {
        "name": "id_wifi",
        "full_text": _wrap_name("WLS", f"{ssid} ({ipv4}) {signal} ping {ping}")
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
            "full_text": _wrap_name("ETH", "Disconnected")
        }

    ipv4 = "No IP"

    for a in addrs[eth]:
        if a.family == socket.AF_INET:
            ipv4 = a.address
            break

    return {
        "name": "id_ethernet",
        "full_text": _wrap_name("ETH", f"{eth} ({ipv4})")
    }

#######
# CPU #
#######

def pretty_cpu() -> dict:
    cpu_percent = psutil.cpu_percent()
    temps = psutil.sensors_temperatures()

    current_temp = None

    for key in ["acpitz", "coretemp"]:
        if key in temps and temps[key]:
            current_temp = temps[key][0].current
            break

    temp_text = f"{current_temp:.2f}°C" if current_temp is not None else "N/A"

    return {
        "name": "id_cpu",
        "full_text": _wrap_name("CPU", f"{cpu_percent:.2f}% at {temp_text}")
    }

##########
# MEMORY #
##########

def pretty_memory() -> str:
    memory = psutil.virtual_memory()

    memory_used = _format_bytes(memory.used)
    memory_total = _format_bytes(memory.total)
    memory_percent = f"{(memory.used / memory.total * 100):.2f}"

    return {
        "name": "id_memory",
        "full_text": _wrap_name("RAM", f"{memory_used} of {memory_total} ({memory_percent}%)")
    }

##########
# UPTIME #
##########

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
        "full_text": _wrap_name("UP", f"{", ".join(parts) or "Waking..."}")
    }

############
# DATETIME #
############

def pretty_now() -> dict:
    try:
        locale.setlocale(locale.LC_TIME, f"{DATETIME_LOCALE}.UTF-8")
    except locale.Error:
        pass

    now = datetime.datetime.now().strftime(DATETIME_FORMAT)

    return {
        "name": "id_time",
        "full_text": f"<big>{now}</big> "
    }

################
# MAIN PROGRAM #
################

def get_slow_blocks() -> list[dict]:
    return [
        pretty_wifi(),
        pretty_ethernet(),
        pretty_cpu(),
        pretty_memory(),
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
