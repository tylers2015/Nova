#!/bin/bash

MESSAGE="$*"

sshpass -p 'NovaTempPass123!' ssh -o StrictHostKeyChecking=no nova@100.114.205.101 \
"powershell.exe -ExecutionPolicy Bypass -File C:\Nova\speak_zira.ps1 -Message \"$MESSAGE\""
