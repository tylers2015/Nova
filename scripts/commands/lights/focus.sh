#!/bin/bash

curl -s -X POST \
-H "Authorization: Bearer $(grep HA_TOKEN ~/Nova/.env | cut -d= -f2)" \
-H "Content-Type: application/json" \
-d '{
  "entity_id":"light.smart_multicolor_bulb",
  "brightness_pct":85,
  "color_temp_kelvin":5000,
  "transition":3
}' \
$(grep HA_URL ~/Nova/.env | cut -d= -f2)/api/services/light/turn_on

/home/ai/Nova/scripts/speak.sh "Focus mode enabled."
