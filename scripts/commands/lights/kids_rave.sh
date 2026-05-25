#!/bin/bash

HA_URL=$(grep HA_URL ~/Nova/.env | cut -d= -f2)
HA_TOKEN=$(grep HA_TOKEN ~/Nova/.env | cut -d= -f2)
STOP_FILE="/home/ai/Nova/state/stop_rave.flag"

rm -f "$STOP_FILE"

COLORS=(
'[255,0,0]'
'[0,255,0]'
'[0,0,255]'
'[255,0,255]'
'[255,255,0]'
'[0,255,255]'
'[255,120,0]'
'[120,0,255]'
)

# 5 minutes max, checks stop flag every half-second
for i in {1..600}
do
    if [ -f "$STOP_FILE" ]; then
        break
    fi

    COLOR=${COLORS[$RANDOM % ${#COLORS[@]}]}

    curl -s -X POST \
    -H "Authorization: Bearer $HA_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"entity_id\":\"light.smart_multicolor_bulb\",
      \"brightness_pct\":100,
      \"rgb_color\":$COLOR,
      \"transition\":0
    }" \
    $HA_URL/api/services/light/turn_on > /dev/null

    sleep 0.5
done

# Restore calm chill mode after stopping/completing
/home/ai/Nova/scripts/commands/lights/chill.sh > /dev/null 2>&1

rm -f "$STOP_FILE"
