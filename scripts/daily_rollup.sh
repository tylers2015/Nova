#!/bin/bash

DATE=$(date '+%Y-%m-%d')
DAILY_FILE="/home/ai/Nova/memory/daily/$DATE.md"
ROLLUP_FILE="/home/ai/Nova/memory/daily/$DATE-rollup.md"

EVENT_SUMMARY=$(
tail -n 200 /home/ai/Nova/logs/events/events.log | \
sed -E 's/^[0-9-]+ [0-9:]+ [APM]+ //' | \
sort | uniq -c | \
sed -E 's/^ *([0-9]+) /\1x /'
)

{
  echo "# Nova Daily Rollup - $DATE"
  echo ""
  echo "## Notes"
  cat "$DAILY_FILE" 2>/dev/null
  echo ""
  echo "## Event Summary"
  echo "$EVENT_SUMMARY"
} > "$ROLLUP_FILE"

/home/ai/Nova/scripts/notify.sh SUCCESS "Daily memory rollup completed"
