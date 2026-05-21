#!/bin/bash

LEVEL="$1"
ALERT_DIR="/home/ai/Nova/state/alerts"
mkdir -p "$ALERT_DIR"
shift
MESSAGE="$*"

if [ -z "$MESSAGE" ]; then
  MESSAGE="$LEVEL"
  LEVEL="INFO"
fi

/home/ai/Nova/scripts/log_event.sh "$LEVEL" "$MESSAGE"

case "$LEVEL" in
  ERROR)
    ALERT_FILE="$ALERT_DIR/error_$(echo "$MESSAGE" | tr " " "_")"
    if [ ! -f "$ALERT_FILE" ]; then
      touch "$ALERT_FILE"
      /home/ai/Nova/scripts/speak.sh "Error. $MESSAGE"
    fi
    ;;
  WARN)
    ALERT_FILE="$ALERT_DIR/warn_$(echo "$MESSAGE" | tr " " "_")"
    if [ ! -f "$ALERT_FILE" ]; then
      touch "$ALERT_FILE"
      /home/ai/Nova/scripts/speak.sh "Warning. $MESSAGE"
    fi
    ;;
  SUCCESS)
    if echo "$MESSAGE" | grep -qi "recovered"; then
      rm -f "$ALERT_DIR"/* 2>/dev/null
      /home/ai/Nova/scripts/speak.sh "$MESSAGE"
    fi
    ;;
  INFO)
    # Info events are logged but not spoken
    ;;
  *)
    # Unknown levels are logged only
    ;;
esac
