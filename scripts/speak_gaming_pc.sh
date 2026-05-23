#!/bin/bash

MESSAGE="$*"

sshpass -p 'NovaTempPass123!' ssh -o StrictHostKeyChecking=no nova@100.114.205.101 \
"powershell -c \"[console]::beep(800,700); Start-Sleep -Seconds 2; Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('$MESSAGE')\""
