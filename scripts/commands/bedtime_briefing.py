#!/usr/bin/env python3
import os
import requests
import subprocess
from datetime import datetime
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")
LIGHT_ENTITY = "light.smart_multicolor_bulb"

def speak(message):
    subprocess.run(["/home/ai/Nova/scripts/speak_gaming_pc.sh", message])

def notify(level, message):
    subprocess.run(["/home/ai/Nova/scripts/notify.sh", level, message])

def set_night_light():
    if not HA_URL or not HA_TOKEN:
        return

    requests.post(
        f"{HA_URL}/api/services/light/turn_on",
        headers={
            "Authorization": f"Bearer {HA_TOKEN}",
            "Content-Type": "application/json"
        },
        json={
            "entity_id": LIGHT_ENTITY,
            "brightness_pct": 8,
            "rgb_color": [0, 0, 255],
            "transition": 10
        },
        timeout=10
    )

def get_current_weather():
    try:
        return requests.get(
            "https://wttr.in/Fort+Mill?format=%C+%t",
            timeout=10
        ).text.strip()
    except Exception:
        return "weather unavailable"

def get_morning_weather():
    try:
        return requests.get(
            "https://wttr.in/Fort+Mill?format=Tomorrow+morning:+%C+%t",
            timeout=10
        ).text.strip()
    except Exception:
        return "tomorrow morning weather unavailable"

def get_system_summary():
    try:
        out = subprocess.check_output(
            ["/home/ai/Nova/scripts/system_status.sh"],
            text=True,
            timeout=45
        )

        if "WARNING" in out:
            return "I noticed at least one system warning today. Check the dashboard when you can."
        return "Nova systems ran normally today. Core services are online."
    except Exception:
        return "I could not complete the system summary."

def bedtime_briefing():
    set_night_light()

    current_weather = get_current_weather()
    morning_weather = get_morning_weather()
    system_summary = get_system_summary()

    message = (
        "Tyler, it is time to start winding down. "
        "Your bedroom light is now in night mode. "
        f"Current weather is {current_weather}. "
        f"For tomorrow morning, {morning_weather}. "
        f"{system_summary} "
        "If you are still awake, this is your reminder to stop scrolling, close things down, and get some rest."
    )

    speak(message)
    notify("SUCCESS", "Bedtime briefing completed")

if __name__ == "__main__":
    bedtime_briefing()
