#!/bin/bash

NOTE="$*"
DATE=$(date '+%Y-%m-%d')
DAY_FILE="/home/ai/Nova/memory/daily/$DATE.md"

mkdir -p /home/ai/Nova/memory/daily

if [ ! -f "$DAY_FILE" ]; then
  echo "# Nova Daily Notes - $DATE" > "$DAY_FILE"
  echo "" >> "$DAY_FILE"
fi

echo "- $(date '+%I:%M %p') - $NOTE" >> "$DAY_FILE"
echo "- $NOTE" >> /home/ai/Nova/memory/today.txt

/home/ai/Nova/scripts/speak.sh "I added that to today's notes."
/home/ai/Nova/scripts/notify.sh SUCCESS "Added daily note"
