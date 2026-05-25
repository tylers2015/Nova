#!/bin/bash

QUERY="$*"

RESULT=$(grep -i -A3 -B1 "$QUERY" ~/Nova/memory/project_notes.txt | head -12)

if [ -z "$RESULT" ]; then
    RESULT="I could not find anything about $QUERY."
fi

echo "$RESULT"

/home/ai/Nova/scripts/speak.sh "$RESULT"
