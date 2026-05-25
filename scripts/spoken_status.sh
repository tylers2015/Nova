#!/bin/bash

RAM=$(free -h | awk '/Mem:/ {print $3 " used out of " $2}')
DISK=$(df -h / | awk 'NR==2 {print $5 " used"}')
WEATHER=$(curl -s "wttr.in/Fort+Mill?format=%C+%t")

OLLAMA="offline"
curl -s http://127.0.0.1:11434/api/tags > /dev/null && OLLAMA="online"

INTERNET="offline"
curl -s --max-time 5 https://example.com > /dev/null && INTERNET="online"

TAILSCALE="offline"
tailscale status > /dev/null 2>&1 && TAILSCALE="online"

MESSAGE="Nova status. Ollama is $OLLAMA. Internet is $INTERNET. Tailscale is $TAILSCALE. Memory usage is $RAM. Disk is $DISK. Weather is $WEATHER."

/home/ai/Nova/scripts/speak.sh "$MESSAGE"
