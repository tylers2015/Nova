#!/bin/bash

curl -s -X POST \
-H "Authorization: Bearer $(grep HA_TOKEN ~/Nova/.env | cut -d= -f2)" \
-H "Content-Type: application/json" \
-d '{
  "entity_id":"light.smart_multicolor_bulb",
  "brightness_pct":28,
  "rgb_color":[255,140,40],
  "transition":5
}' \
$(grep HA_URL ~/Nova/.env | cut -d= -f2)/api/services/light/turn_on


