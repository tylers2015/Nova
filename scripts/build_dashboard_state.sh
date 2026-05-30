#!/bin/bash

mkdir -p /home/ai/Nova/state

DATE=$(date +%F)
VOICE_STATUS=$(systemctl --user is-active nova-listener.service 2>/dev/null)
UNKNOWN_COUNT=$(wc -l < /home/ai/Nova/logs/voice/unknown_commands.log 2>/dev/null || echo 0)
NOTES_COUNT=$(grep -c "^- " /home/ai/Nova/memory/daily/$DATE.md 2>/dev/null || echo 0)
LAST_COMMAND=$(tail -n 1 /home/ai/Nova/logs/voice/unknown_commands.log 2>/dev/null | sed 's/.* - //' || echo "none")

cat > /home/ai/Nova/state/dashboard_state.json << JSON
{
  "nova_mode": "day",
  "voice_listener": "$VOICE_STATUS",
  "last_unknown_command": "$LAST_COMMAND",
  "bedroom_light_mode": "unknown",
  "back_door_lock": "unknown",
  "spotify_watcher": "unknown",
  "notes_today": $NOTES_COUNT,
  "unknown_commands": $UNKNOWN_COUNT,
  "last_updated": "$(date '+%Y-%m-%d %I:%M:%S %p')"
}
JSON
