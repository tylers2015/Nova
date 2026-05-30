#!/bin/bash

ROOM="$1"
shift

MESSAGE="$*"

if [ -z "$ROOM" ] || [ -z "$MESSAGE" ]; then
    echo 'Usage: speak_room.sh room_name "message"'
    exit 1
fi

NODE=$(grep "^$ROOM=" ~/Nova/config/nodes.conf | cut -d'=' -f2)

if [ -z "$NODE" ]; then
    echo "Room '$ROOM' not found."
    exit 1
fi

mkdir -p ~/Nova/tmp

echo "$MESSAGE" | piper \
  --model ~/Nova/voices/en_US-amy-medium.onnx \
  --output_file ~/Nova/tmp/nova_speech.wav

scp ~/Nova/tmp/nova_speech.wav "$NODE:/home/ty/nova_speech.wav" >/dev/null

ssh "$NODE" "aplay -q /home/ty/nova_speech.wav"
