#!/bin/bash

NODE_USER="ty"
NODE_HOST="NovaPINode"
NODE_FILE="/home/ty/nova_speech.wav"

MESSAGE="$*"

if [ -z "$MESSAGE" ]; then
  echo "Usage: speak_node.sh \"message to speak\""
  exit 1
fi

mkdir -p ~/Nova/tmp

echo "$MESSAGE" | piper --model ~/Nova/voices/en_US-amy-medium.onnx --output_file ~/Nova/tmp/nova_speech.wav

scp ~/Nova/tmp/nova_speech.wav "$NODE_USER@$NODE_HOST:$NODE_FILE"

ssh "$NODE_USER@$NODE_HOST" "aplay $NODE_FILE"
