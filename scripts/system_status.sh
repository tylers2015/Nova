#!/bin/bash

STATE_DIR="/home/ai/Nova/state"
mkdir -p "$STATE_DIR"

check_state () {
  NAME="$1"
  CURRENT="$2"
  LEVEL_DOWN="$3"

  FILE="$STATE_DIR/$NAME.state"
  PREVIOUS=$(cat "$FILE" 2>/dev/null || echo "UNKNOWN")

  if [ "$PREVIOUS" != "$CURRENT" ]; then
    echo "$CURRENT" > "$FILE"

    if [ "$CURRENT" = "OFFLINE" ]; then
      /home/ai/Nova/scripts/notify.sh "$LEVEL_DOWN" "$NAME went offline"
    elif [ "$CURRENT" = "ONLINE" ] && { [ "$PREVIOUS" = "OFFLINE" ] || [ "$PREVIOUS" = "offline" ]; }; then
      /home/ai/Nova/scripts/notify.sh SUCCESS "$NAME recovered and is back online"
    fi
  fi
}

echo "====================================="
echo "Nova System Status"
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo "====================================="
echo ""

echo "RAM Usage:"
free -h
echo ""

echo "Disk Usage:"
df -h /
echo ""

echo "Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
echo ""

echo "Ollama Status:"
if curl -s http://127.0.0.1:11434/api/tags > /dev/null; then
  echo "Ollama API ONLINE"
  check_state "Ollama" "ONLINE" "ERROR"
else
  echo "WARNING: Ollama API OFFLINE"
  check_state "Ollama" "OFFLINE" "ERROR"
fi
echo ""

echo "Internet Status:"
if curl -s --max-time 5 https://example.com > /dev/null; then
  echo "Internet ONLINE"
  check_state "Internet" "ONLINE" "WARN"
else
  echo "WARNING: Internet OFFLINE"
  check_state "Internet" "OFFLINE" "WARN"
fi
echo ""

echo "Tailscale Status:"
if tailscale status > /dev/null 2>&1; then
  echo "Tailscale ONLINE"
  check_state "Tailscale" "ONLINE" "WARN"
else
  echo "WARNING: Tailscale OFFLINE"
  check_state "Tailscale" "OFFLINE" "WARN"
fi
echo ""

echo "Weather Check:"
curl -s wttr.in/Fort+Mill?format="%C+%t"
echo ""
echo ""

echo "System Uptime:"
uptime
echo ""

echo "====================================="
echo "Nova status check complete."
echo "====================================="

# Resource Alerts

DISK_USE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')
if [ "$DISK_USE" -ge 85 ]; then
  /home/ai/Nova/scripts/notify.sh WARN "Disk usage is high at ${DISK_USE} percent"
fi

RAM_USE=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
if [ "$RAM_USE" -ge 90 ]; then
  /home/ai/Nova/scripts/notify.sh WARN "Memory usage is high at ${RAM_USE} percent"
fi

if ! docker ps --format '{{.Names}}' | grep -q "homeassistant"; then
  /home/ai/Nova/scripts/notify.sh ERROR "Home Assistant container is not running"
fi

if ! docker ps --format '{{.Names}}' | grep -q "open-webui"; then
  /home/ai/Nova/scripts/notify.sh ERROR "Open WebUI container is not running"
fi

/home/ai/Nova/scripts/notify.sh SUCCESS "System health check completed"
