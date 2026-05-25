#!/bin/bash

IDLE_SECONDS=$(sshpass -p 'NovaTempPass123!' ssh nova@100.114.205.101 \
'powershell.exe -ExecutionPolicy Bypass -File C:\Nova\idle_check.ps1' | tr -dc '0-9')

if [ -z "$IDLE_SECONDS" ]; then
  /home/ai/Nova/scripts/notify.sh WARN "Could not read gaming PC idle time"
  exit 1
fi

# If active within the last 10 minutes
if [ "$IDLE_SECONDS" -lt 600 ]; then
  /home/ai/Nova/scripts/speak_gaming_pc.sh "Tyler, it is 1 A M. You are still active. You should seriously start winding down and go to bed."
  /home/ai/Nova/scripts/notify.sh WARN "Tyler active at 1 AM bedtime warning triggered"
else
  /home/ai/Nova/scripts/notify.sh INFO "1 AM check passed. Gaming PC appears idle."
fi

