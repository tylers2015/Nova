import os
import random
import subprocess
import requests
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

LIGHT_ENTITY = "light.smart_multicolor_bulb"

quotes = [
    "You have power over your mind, not outside events. Realize this, and you will find strength. Marcus Aurelius.",
    "Waste no more time arguing what a good man should be. Be one. Marcus Aurelius.",
    "Luck is what happens when preparation meets opportunity. Seneca.",
    "No man is free who is not master of himself. Epictetus.",
    "Difficulties strengthen the mind, as labor does the body. Seneca."
]

def turn_on_light():
    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }
    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": 35,
        "color_temp_kelvin": 2700
    }
    requests.post(url, headers=headers, json=data, timeout=10)

def speak_on_gaming_pc(message):
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        message
    ])

def start_spotify_on_gaming_pc():
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        "Starting your liked songs on Spotify."
    ])
    # We’ll wire actual Spotify launch next after speech is stable.

def morning_briefing():
    turn_on_light()

    quote = random.choice(quotes)

    message = (
        "Good morning Tyler. "
        "It is 7 A M. "
        "Your bedroom light is on. "
        "Today is a new opportunity to move forward. "
        f"Stoic quote for the day: {quote}"
    )

    speak_on_gaming_pc(message)
    start_spotify_on_gaming_pc()

if __name__ == "__main__":
    morning_briefing()
