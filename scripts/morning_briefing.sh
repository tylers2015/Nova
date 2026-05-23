#!/bin/bash

WEATHER=$(curl -s wttr.in/Fort+Mill?format="%C+%t")

MESSAGE="Good morning Tyler. It is $(date '+%I:%M %p on %A, %B %d'). Current weather in Fort Mill is $WEATHER. Nova is online."

echo "$MESSAGE"

echo ""
echo "Ollama models:"
ollama list

echo ""
echo "Nova services:"
docker ps --format "table {{.Names}}\t{{.Status}}"

/home/ai/Nova/scripts/notify.sh SUCCESS "Morning briefing completed"
/home/ai/Nova/scripts/speak_gaming_pc.sh "$MESSAGE"
