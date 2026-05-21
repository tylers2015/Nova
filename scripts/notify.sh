#!/bin/bash

LEVEL="$1"
shift
MESSAGE="$*"

if [ -z "$MESSAGE" ]; then
  MESSAGE="$LEVEL"
  LEVEL="INFO"
fi

/home/ai/Nova/scripts/log_event.sh "$LEVEL" "$MESSAGE"

case "$LEVEL" in
  ERROR)
    /home/ai/Nova/scripts/speak.sh "Error. $MESSAGE"
    ;;
  WARN)
    /home/ai/Nova/scripts/speak.sh "Warning. $MESSAGE"
    ;;
  SUCCESS)
    if echo "$MESSAGE" | grep -qi "recovered"; then
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
