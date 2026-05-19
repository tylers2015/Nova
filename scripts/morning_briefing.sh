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
