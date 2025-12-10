#! /usr/bin/env python3

import datetime
import json
import psutil
import subprocess
import time

# Interval (in seconds) to wait for updates of the "slow" blocks.
SLOW_UPDATE_INTERVAL = 60

# The amount of pixels to leave blank after the block.
# In the middle of this gap, a separator symbol will be drawn.
SEPARATOR_BLOCK_WIDTH = 25

def _format_size(size_in_bytes: int) -> str:
    return f"{(size_in_bytes / (1024 ** 3)):.2f} GiB"

def pretty_cpu() -> dict:
    cpu_percent = psutil.cpu_percent(interval=0.1)

    temps = psutil.sensors_temperatures()
    current_temp = None

    for key in ["acpitz", "coretemp"]:
        if key in temps and temps[key]:
            current_temp = temps[key][0].current
            break

    temp_text = f"{current_temp:.2f}°C" if current_temp is not None else "N/A"

    return {
        "name": "id_cpu",
        "full_text": f"CPU: {cpu_percent:.1f}% at {temp_text}"
    }

def pretty_memory() -> str:
    memory = psutil.virtual_memory()

    memory_used = _format_size(memory.used)
    memory_total = _format_size(memory.total)
    memory_percent = f"{(memory.used / memory.total * 100):.2f}"

    return {
        "name": "id_memory",
        "full_text": f"RAM: {memory_used} of {memory_total} ({memory_percent}%)"
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
        "full_text": f"UP: {", ".join(parts)}"
    }

def pretty_now() -> dict:
    return {
        "name": "id_time",
        "full_text": datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

def get_slow_blocks() -> list[dict]:
    return [
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
            block.setdefault("separator_block_width", SEPARATOR_BLOCK_WIDTH)

        print(f", {json.dumps(blocks)}", flush=True)
        time.sleep(1.0)
