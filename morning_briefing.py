import os
import random
import subprocess
import time
import requests
from datetime import datetime
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

HA_URL = os.getenv("HA_URL")
HA_TOKEN = os.getenv("HA_TOKEN")

LIGHT_ENTITY = "light.smart_multicolor_bulb"

wake_messages = [
    "Good morning Tyler. Another opportunity to build the future you want is starting now.",
    "Good morning Tyler. Small progress every day becomes massive change over time.",
    "Wake up Tyler. Nova systems are online and today is another chance to move forward.",
    "Good morning Tyler. Momentum matters more than perfection. Lets make progress today.",
]

quotes = [
    "You have power over your mind, not outside events. Realize this, and you will find strength. Marcus Aurelius.",
    "Waste no more time arguing what a good man should be. Be one. Marcus Aurelius.",
    "Luck is what happens when preparation meets opportunity. Seneca.",
    "No man is free who is not master of himself. Epictetus.",
    "Difficulties strengthen the mind, as labor does the body. Seneca."
]

def get_weather():
    try:
        r = requests.get("https://wttr.in/Fort+Mill?format=%C+%t", timeout=10)
        return r.text.strip()
    except Exception:
        return "weather data unavailable"

def get_holiday_message():
    today = datetime.now()
    month_day = today.strftime("%m-%d")

    holidays = {
        "01-01": "New Years Day is here.",
        "07-04": "Independence Day is today.",
        "10-31": "Halloween is today.",
        "12-25": "Christmas Day is today."
    }

    upcoming = {
        "07-04": "Independence Day is approaching.",
        "10-31": "Halloween is getting close.",
        "12-25": "Christmas is getting closer."
    }

    if month_day in holidays:
        return holidays[month_day]

    current_month = today.month

    if current_month == 12:
        return upcoming["12-25"]

    if current_month == 10:
        return upcoming["10-31"]

    if current_month == 6 or current_month == 7:
        return upcoming["07-04"]

    return ""

def get_light_state():
    url = f"{HA_URL}/api/states/{LIGHT_ENTITY}"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }

    try:
        r = requests.get(url, headers=headers, timeout=10)
        r.raise_for_status()
        return r.json().get("state", "unknown")
    except Exception:
        return "unknown"


def set_light(brightness_pct=35, color_temp_kelvin=2700, transition=10):
    url = f"{HA_URL}/api/services/light/turn_on"
    headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json"
    }

    data = {
        "entity_id": LIGHT_ENTITY,
        "brightness_pct": brightness_pct,
        "color_temp_kelvin": color_temp_kelvin,
        "transition": transition
    }

    requests.post(url, headers=headers, json=data, timeout=10)


def turn_on_light():
    state = get_light_state()

    if state == "off":
        set_light(brightness_pct=1, color_temp_kelvin=2700, transition=1)
        time.sleep(2)
        set_light(brightness_pct=35, color_temp_kelvin=2700, transition=20)
    else:
        set_light(brightness_pct=35, color_temp_kelvin=2700, transition=10)

def speak_on_gaming_pc(message):
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        message
    ])

def start_spotify_on_gaming_pc():
    subprocess.run([
        "/home/ai/Nova/scripts/speak_gaming_pc.sh",
        "Starting Spotify."
    ])

    subprocess.run([
        "sshpass",
        "-p",
        "NovaTempPass123!",
        "ssh",
        "nova@100.114.205.101",
        "type nul > C:\\Nova\\start_spotify.trigger"
    ])

def morning_briefing():
    turn_on_light()

    quote = random.choice(quotes)

    wake_message = random.choice(wake_messages)
    weather = get_weather()
    holiday_message = get_holiday_message()



    wake_message = random.choice(wake_messages)
    weather = get_weather()
    holiday_message = get_holiday_message()



    message = (
        f"Current weather is {weather}. "
        f"{holiday_message} "
        "Your bedroom light is on. "
        "Today is a new opportunity to move forward. "
        f"Stoic quote for the day: {quote}"
    )

    speak_on_gaming_pc(wake_message)

    time.sleep(4)

    speak_on_gaming_pc("Nova systems are online.")

    time.sleep(4)

    speak_on_gaming_pc("It is time to wake up.")

    time.sleep(5)

    speak_on_gaming_pc(message)

    start_spotify_on_gaming_pc()

if __name__ == "__main__":
    morning_briefing()
