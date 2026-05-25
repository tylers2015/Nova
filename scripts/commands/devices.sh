#!/bin/bash

python3 - << 'PY'
import json

path = "/home/ai/Nova/config/devices.json"

with open(path) as f:
    devices = json.load(f)

print("Nova Device Registry")
print("====================")

for name, info in devices.items():
    device_type = info.get("type", "unknown")
    state = info.get("state", "unknown")
    integration = info.get("integration", "unknown")
    model = info.get("model", "")

    print(f"{name}: {device_type}, {model}, state {state}, integration {integration}")
PY
