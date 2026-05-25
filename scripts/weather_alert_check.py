#!/usr/bin/env python3
import json
import os
import requests
import subprocess
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

LAT = "35.0074"
LON = "-80.9451"
STATE_FILE = "/home/ai/Nova/state/weather_alerts_seen.json"
LIGHT_ENTITY = "light.smart_multicolor_bulb"

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

def load_seen():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return set(json.load(f))
    return set()

def save_seen(seen):
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        json.dump(list(seen), f)

def notify(level, message):
    subprocess.run([
        "/home/ai/Nova/scripts/notify.sh",
        level,
        message
    ])

def speak(message):
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        message
    ])

def flash_light_red():
    if not HA_URL or not HA_TOKEN:
        return

    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }

    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": 50,
        "rgb_color": [255, 0, 0]
    }

    try:
        requests.post(url, headers=headers, json=data, timeout=10)
    except Exception:
        pass

def restore_light():
    if not HA_URL or not HA_TOKEN:
        return

    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }

    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": 8,
        "rgb_color": [0, 0, 255]
    }

    try:
        requests.post(url, headers=headers, json=data, timeout=10)
    except Exception:
        pass

def restore_light():
    if not HA_URL or not HA_TOKEN:
        return

    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }

    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": 8,
        "rgb_color": [0, 0, 255]
    }

    try:
        requests.post(url, headers=headers, json=data, timeout=10)
    except Exception:
        pass

def main():
    url = f"https://api.weather.gov/alerts/active?point={LAT},{LON}"
    headers = {
        "User-Agent": "Nova local assistant weather alert monitor"
    }

    try:
        r = requests.get(url, headers=headers, timeout=15)
        r.raise_for_status()
        data = r.json()
    except Exception as e:
        notify("WARN", f"Weather alert check failed: {e}")
        return

    seen = load_seen()
    new_seen = set(seen)

    alerts = data.get("features", [])

    if not alerts:
        restore_light()
        notify("INFO", "No active severe weather alerts")
        save_seen(new_seen)
        return

    for alert in alerts:
        props = alert.get("properties", {})
        alert_id = props.get("id") or alert.get("id")
        event = props.get("event", "Weather alert")
        severity = props.get("severity", "Unknown")
        headline = props.get("headline", event)

        if alert_id in seen:
            continue

        new_seen.add(alert_id)

        message = f"Severe weather alert. {event}. Severity {severity}. {headline}"

        notify("WARN", message)
        flash_light_red()
        speak(message)

    save_seen(new_seen)

if __name__ == "__main__":
    main()
