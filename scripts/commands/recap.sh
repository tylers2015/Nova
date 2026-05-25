#!/bin/bash

SUMMARY=$(
tail -n 20 /home/ai/Nova/logs/events/events.log | \
sed -E '
s/^[0-9:-]+ [0-9: ]+[APM]+ //;
s/\[SUCCESS\] //g;
s/\[INFO\] //g;
s/\[WARNING\] //g;
s/\[ERROR\] //g;
' | \
sort | uniq -c
)

MESSAGE="Here is your latest Nova recap."

while read -r count event
do
    if [ "$count" -gt 1 ]; then
        MESSAGE="$MESSAGE $event occurred $count times."
    else
        MESSAGE="$MESSAGE $event."
    fi
done <<< "$SUMMARY"

echo "$MESSAGE"

/home/ai/Nova/scripts/speak.sh "$MESSAGE"
