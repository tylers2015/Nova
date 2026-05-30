#!/bin/bash

MESSAGE="$*"
OUT="/tmp/nova_speech.wav"

echo "$MESSAGE" | /home/ai/Nova/venv/bin/piper \
  --model /home/ai/Nova/voices/en_US-amy-low.onnx \
  --output_file "$OUT" >/dev/null 2>&1

aplay "$OUT" >/dev/null 2>&1
