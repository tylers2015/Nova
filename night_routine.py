import os
import subprocess
import requests
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

LIGHT_ENTITY = "light.smart_multicolor_bulb"

def dim_light():
    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }
    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": 8,
        "color_temp_kelvin": 2200
    }
    requests.post(url, headers=headers, json=data, timeout=10)

def speak_on_gaming_pc(message):
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        message
    ])

def night_routine():
    dim_light()

    message = (
        "Tyler, it is 10 P M. "
        "It is time to start winding down for bed. "
        "I have dimmed your bedroom light. "
        "Nova will keep monitoring the system overnight. "
        "Try to get some rest so tomorrow starts stronger."
    )

    speak_on_gaming_pc(message)

    subprocess.run([
        "/home/ai/Nova/scripts/notify.sh",
        "SUCCESS",
        "Night routine completed"
    ])

if __name__ == "__main__":
    night_routine()
