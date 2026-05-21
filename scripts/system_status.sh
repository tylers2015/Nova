#!/bin/bash

DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "====================================="
echo "Nova System Status"
echo "Timestamp: $DATE"
echo "====================================="
echo ""

# RAM
echo "RAM Usage:"
free -h
echo ""

# Disk Usage
echo "Disk Usage:"
df -h /
echo ""

# Docker Containers
echo "Docker Containers:"
docker ps --format "table {{.Names}}\t{{.Status}}"
echo ""

# Ollama Check
echo "Ollama Status:"
if curl -s http://127.0.0.1:11434/api/tags > /dev/null; then
    echo "Ollama API ONLINE"
else
    echo "WARNING: Ollama API OFFLINE"
fi
echo ""

# Internet Check
echo "Internet Status:"
if ping -c 1 8.8.8.8 > /dev/null; then
    echo "Internet ONLINE"
else
    echo "WARNING: Internet OFFLINE"
fi
echo ""

# Tailscale Check
echo "Tailscale Status:"
if tailscale status > /dev/null 2>&1; then
    echo "Tailscale ONLINE"
else
    echo "WARNING: Tailscale OFFLINE"
fi
echo ""

# Weather Check
echo "Weather Check:"
curl -s wttr.in/Fort+Mill?format="%C+%t"
echo ""
echo ""

# System Uptime
echo "System Uptime:"
uptime
echo ""

echo "====================================="
echo "Nova status check complete."
echo "====================================="
