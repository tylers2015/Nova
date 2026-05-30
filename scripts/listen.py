#!/usr/bin/env python3
import os
import queue
import sounddevice as sd
import vosk
import json
import subprocess
import time
from dotenv import load_dotenv

load_dotenv("/home/ai/Nova/.env")

MODEL_PATH = "/home/ai/Nova/models/vosk-model-small-en-us-0.15"
MIC_DEVICE = 1
ACTIVE_SECONDS = 12

q = queue.Queue()
active_until = 0
pending_note_mode = False

conversation_state = {
    "pending_question": None,
    "expires": 0
}

routine_state = {
    "active": False,
    "steps": [],
    "current": 0
}


def speak(text):
    subprocess.run(["/home/ai/Nova/scripts/speak.sh", text])

def callback(indata, frames, time_info, status):
    if status:
        print(status)
    q.put(bytes(indata))

def run_command(text):
    global active_until, pending_note_mode, conversation_state, routine_state


    # Passive wake mode
    if time.time() > active_until:
        if "hey nova" in text or "okay nova" in text or "ok nova" in text or "nova" in text or "no va" in text or "noda" in text or "novah" in text or "computer" in text:
            active_until = time.time() + ACTIVE_SECONDS
            subprocess.run(["/home/ai/Nova/scripts/speak_fast.sh", "Yes Tyler."])
        return

    # Contextual conversation replies
    if conversation_state["pending_question"] and time.time() < conversation_state["expires"]:

        pending = conversation_state["pending_question"]

        if text in ["yes", "yeah", "yep", "okay", "ok", "sure"]:

            if pending == "lock_back_door":
                speak("Locking the back door.")
                speak("Back door lock integration is not implemented yet.")

                speak("Should I turn off the lights?")

                conversation_state["pending_question"] = "turn_off_lights"
                conversation_state["expires"] = time.time() + 20
                return

            elif pending == "turn_off_lights":

                subprocess.run([
                    "/home/ai/Nova/scripts/commands/lights/off.sh"
                ])

                speak("Should I stop Spotify?")

                conversation_state["pending_question"] = "spotify_off"
                conversation_state["expires"] = time.time() + 20
                return

            elif pending == "spotify_off":

                speak("Okay Tyler. House secure routine complete.")

                conversation_state["pending_question"] = None
                routine_state["active"] = False
                return

            conversation_state["pending_question"] = None
            return

        elif text in ["no", "nope", "cancel", "later"]:

            speak("Okay.")
            conversation_state["pending_question"] = None
            return

            subprocess.run(["/home/ai/Nova/scripts/speak_fast.sh", "Yes Tyler."])
        return

    # Active command mode
    if "hey nova" in text or "okay nova" in text or "ok nova" in text or "nova" in text or "no va" in text or "noda" in text or "novah" in text or "computer" in text:
        text = text.replace("hey nova", "").replace("okay nova", "").replace("ok nova", "").replace("nova", "").replace("no va", "").replace("noda", "").replace("novah", "").replace("computer", "").strip()

    active_until = time.time() + ACTIVE_SECONDS

    # Contextual conversation replies
    if conversation_state["pending_question"] and time.time() < conversation_state["expires"]:

        pending = conversation_state["pending_question"]

        if text in ["yes", "yeah", "yep", "okay", "ok", "sure"]:

            if pending == "lock_back_door":
                speak("Locking the back door.")
                speak("Back door lock integration is not implemented yet.")

                speak("Should I turn off the lights?")

                conversation_state["pending_question"] = "turn_off_lights"
                conversation_state["expires"] = time.time() + 20
                return

            elif pending == "turn_off_lights":

                subprocess.run([
                    "/home/ai/Nova/scripts/commands/lights/off.sh"
                ])

                speak("Should I stop Spotify?")

                conversation_state["pending_question"] = "spotify_off"
                conversation_state["expires"] = time.time() + 20
                return

            elif pending == "spotify_off":

                speak("Okay Tyler. House secure routine complete.")

                conversation_state["pending_question"] = None
                routine_state["active"] = False
                return

            conversation_state["pending_question"] = None
            return

        elif text in ["no", "nope", "cancel", "later"]:

            speak("Okay.")
            conversation_state["pending_question"] = None
            return


    if text in ["status", "nova status"] or "nova status" in text:
        speak("Checking Nova status.")
        subprocess.run(["/home/ai/Nova/scripts/spoken_status.sh"])
        subprocess.run(["/home/ai/Nova/scripts/system_status.sh"])

    elif "ecosystem status" in text or "full status" in text or "system status" in text:
        speak("Running full ecosystem status.")
        subprocess.run(["/home/ai/Nova/scripts/system_status.sh"])
        speak("Full ecosystem status complete.")

    elif "weather" in text or "whether" in text or "forecast" in text or "temperature" in text:
        weather = subprocess.check_output([
            "curl",
            "-s",
            "wttr.in/Fort+Mill?format=Current+weather:+%C+%t"
        ], text=True).strip()
        speak(weather)

    elif text.startswith("remember ") or text.startswith("search memory "):
        query = text.replace("remember ", "").replace("search memory ", "").strip()

        speak(f"Searching memory for {query}.")

        subprocess.run([
            "/home/ai/Nova/scripts/commands/memory_search.sh",
            query
        ])

    elif "today" in text or "todays focus" in text or "today's focus" in text:
        speak("Here is today's focus.")
        subprocess.run([
            "/home/ai/Nova/scripts/commands/today.sh"
        ])

    elif "new note" in text or "add note" in text or "take note" in text:
        pending_note_mode = True
        speak("What should I remember?")


    elif "secure the house" in text:

        routine_state["active"] = True
        routine_state["steps"] = [
            "lock_back_door",
            "turn_off_lights",
            "spotify_off"
        ]
        routine_state["current"] = 0

        speak("Should I lock the back door?")

        conversation_state["pending_question"] = "lock_back_door"
        conversation_state["expires"] = time.time() + 20

    elif "devices" in text or "device registry" in text or "known devices" in text:
        speak("Reading known devices.")
        subprocess.run([
            "/home/ai/Nova/scripts/commands/devices.sh"
        ])

    elif "recap" in text:
        speak("Generating recap.")
        subprocess.run(["/home/ai/Nova/scripts/recap.sh"])

    elif "morning briefing" in text:
        speak("Starting morning briefing.")
        subprocess.run([
            "/home/ai/Nova/venv/bin/python",
            "/home/ai/Nova/morning_briefing.py"
        ])

    elif "bedtime" in text or "night briefing" in text:
        speak("Starting 10 P M bedtime briefing.")
        subprocess.run([
            "/home/ai/Nova/venv/bin/python",
            "/home/ai/Nova/scripts/commands/bedtime_briefing.py"
        ])

    elif "good night" in text or "goodnight" in text or "go to sleep" in text:
        speak("Okay Tyler. Get some rest. I will keep things running from here. We will continue tomorrow.")
        notify("SUCCESS", "Tyler said goodnight")


model = vosk.Model(MODEL_PATH)
recognizer = vosk.KaldiRecognizer(model, 16000)

speak("Nova voice listener online.")

with sd.RawInputStream(
    samplerate=16000,
    dtype="int16",
    channels=1,
    device="default",
    callback=callback
):
    print("Listening...")
    while True:
        data = q.get()
        if recognizer.AcceptWaveform(data):
            result = json.loads(recognizer.Result())
            text = result.get("text", "")
            if text:
                print("Heard:", text)
                run_command(text)
