#!/bin/bash

LEVEL="$1"
shift
EVENT="$*"
TIMESTAMP=$(date '+%Y-%m-%d %I:%M:%S %p')

if [ -z "$EVENT" ]; then
    EVENT="$LEVEL"
    LEVEL="INFO"
fi

echo "$TIMESTAMP [$LEVEL] $EVENT" >> /home/ai/Nova/logs/events/events.log
