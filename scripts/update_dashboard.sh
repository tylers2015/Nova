#!/bin/bash

HTML_FILE="/home/ai/Nova/dashboard/index.html"

RECENT_EVENTS=$(tail -n 8 /home/ai/Nova/logs/events/events.log 2>/dev/null)
WEATHER_CONDITION=$(curl -s "wttr.in/Fort+Mill?format=%C")
WEATHER_TEMP=$(curl -s "wttr.in/Fort+Mill?format=%t")
WEATHER_FEELS=$(curl -s "wttr.in/Fort+Mill?format=%f")
WEATHER_WIND=$(curl -s "wttr.in/Fort+Mill?format=%w")
WEATHER_HUMIDITY=$(curl -s "wttr.in/Fort+Mill?format=%h")
WEATHER_PRECIP=$(curl -s "wttr.in/Fort+Mill?format=%p")
TIME_NOW=$(date '+%I:%M %p')
DATE_NOW=$(date '+%A, %B %d, %Y')
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}')
RAM=$(free -h | awk '/Mem:/ {print $3 " used / " $2 " total | " $7 " available"}')
DISK=$(df -h / | awk 'NR==2 {print $3 " used / " $2 " total (" $5 ")"}')
IP_LAN=$(hostname -I | awk '{print $1}')
IP_TS=$(hostname -I | awk '{print $2}')
OLLAMA=$(curl -s http://127.0.0.1:11434/api/tags > /dev/null && echo "ONLINE" || echo "OFFLINE")
TAILSCALE=$(tailscale status > /dev/null 2>&1 && echo "ONLINE" || echo "OFFLINE")
DOCKER=$(docker ps --format "<div class='service good'>● {{.Names}} <span>{{.Status}}</span></div>")
MODELS=$(ollama list | tail -n +2 | awk '{print "<div>" $1 " — " $3 $4 "</div>"}')
RECENT_HEALTH=$(ls -t /home/ai/Nova/logs/health/*.log 2>/dev/null | head -1 | xargs -r tail -n 8)
LAST_UPDATE=$(date '+%I:%M:%S %p')

cat > "$HTML_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="refresh" content="60">
<title>Nova Dashboard</title>
<style>
body {
  background: #05070a;
  color: #e8e8e8;
  font-family: Arial, sans-serif;
  margin: 24px;
}
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
h1 {
  font-size: 52px;
  margin: 0;
}
.online { color: #7CFC00; }
.grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
  margin-top: 20px;
}
.card {
  background: #141922;
  padding: 18px;
  border-radius: 14px;
  border: 1px solid #303846;
}
.wide {
  grid-column: span 2;
}
.label {
  color: #aab2c0;
  font-size: 16px;
  margin-bottom: 6px;
}
.value {
  font-size: 26px;
}
.big {
  font-size: 34px;
}
.service {
  font-size: 20px;
  margin: 7px 0;
}
.service span {
  color: #aaa;
  font-size: 15px;
  margin-left: 10px;
}
.good { color: #7CFC00; }
.warn { color: #ffd166; }
.bad { color: #ff4d4d; }
pre {
  white-space: pre-wrap;
  font-size: 14px;
  color: #cbd5e1;
}
.footer {
  margin-top: 18px;
  color: #7b8494;
  font-size: 14px;
}
</style>
</head>
<body>

<div class="header">
  <div>
    <h1>Nova <span class="online">ONLINE</span></h1>
    <div>$DATE_NOW</div>
  </div>
  <div class="big">$TIME_NOW</div>
</div>

<div class="grid">
	
  <div class="card">
    <div class="label">Weather - Fort Mill</div>
    <div class="value">$WEATHER_CONDITION $WEATHER_TEMP</div>
    <div>Feels like: $WEATHER_FEELS</div>
    <div>Wind: $WEATHER_WIND</div>
    <div>Humidity: $WEATHER_HUMIDITY</div>
    <div>Precipitation: $WEATHER_PRECIP</div>
  </div>

  <div class="card">
    <div class="label">System Uptime</div>
    <div class="value">$UPTIME</div>
  </div>

  <div class="card">
    <div class="label">RAM</div>
    <div class="value">$RAM</div>
  </div>

  <div class="card">
    <div class="label">Disk</div>
    <div class="value">$DISK</div>
  </div>

  <div class="card">
    <div class="label">Ollama</div>
    <div class="value">$OLLAMA</div>
  </div>

  <div class="card">
    <div class="label">Tailscale</div>
    <div class="value">$TAILSCALE</div>
  </div>

  <div class="card wide">
    <div class="label">Docker Services</div>
    $DOCKER
  </div>

  <div class="card">
    <div class="label">Network</div>
    <div>LAN: $IP_LAN</div>
    <div>Tailscale: $IP_TS</div>
  </div>

  <div class="card">
    <div class="label">Installed Models</div>
    $MODELS
  </div>

  <div class="card wide">
    <div class="label">Recent Health Log</div>
    <pre>$RECENT_HEALTH</pre>
  </div>

    <div class="card wide">
    <div class="label">Recent Events</div>
    <pre>$RECENT_EVENTS</pre>
  </div>

</div>

<div class="footer">
Last dashboard update: $LAST_UPDATE | Auto-refresh: 60 seconds
</div>

</body>
</html>
EOF
/home/ai/Nova/scripts/log_event.sh "Dashboard updated"
