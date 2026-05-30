#!/bin/bash
/bin/bash /home/ai/Nova/scripts/build_dashboard_state.sh

HTML_FILE="/home/ai/Nova/dashboard/index.html"

NOVA_VERSION="Nova OS v0.1"
NOVA_MODE="Monitoring"
NOVA_ROLE="Local AI Assistant Node"
RECENT_EVENTS=$(tail -n 8 /home/ai/Nova/logs/events/events.log 2>/dev/null | \
sed -e 's/\[SUCCESS\]/<span class="event-success">[SUCCESS]<\/span>/g' \
    -e 's/\[WARN\]/<span class="event-warn">[WARN]<\/span>/g' \
    -e 's/\[ERROR\]/<span class="event-error">[ERROR]<\/span>/g' \
    -e 's/\[INFO\]/<span class="event-info">[INFO]<\/span>/g')
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
if curl -s http://127.0.0.1:11434/api/tags > /dev/null; then
  OLLAMA_LIGHT="green"
else
  OLLAMA_LIGHT="red"
fi

if tailscale status > /dev/null 2>&1; then
  TAILSCALE_LIGHT="green"
else
  TAILSCALE_LIGHT="red"
fi

if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
  INTERNET_LIGHT="green"
else
  INTERNET_LIGHT="red"
fi

if docker ps > /dev/null 2>&1; then
  DOCKER_LIGHT="green"
else
  DOCKER_LIGHT="red"
fi


DOCKER=$(docker ps --format "<div class='service good'>● {{.Names}} <span>{{.Status}}</span></div>")
MODELS=$(ollama list | tail -n +2 | awk '{print "<div>" $1 " — " $3 $4 "</div>"}')
RECENT_HEALTH=$(ls -t /home/ai/Nova/logs/health/*.log 2>/dev/null | head -1 | xargs -r tail -n 8)
LAST_UP

EVENT_SUMMARY=$(tail -n 80 /home/ai/Nova/logs/events/events.log 2>/dev/null | \
sed -E 's/^[0-9-]+ [0-9:]+ [APM]+ //' | \
sort | uniq -c | \
sed -E 's/^ *([0-9]+) /\1x /' | \
tail -n 8)

DASH_STATE="/home/ai/Nova/state/dashboard_state.json"

if [ -f "$DASH_STATE" ]; then
  VOICE_LISTENER=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("voice_listener","unknown"))')
  LAST_UNKNOWN=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("last_unknown_command","none"))')
  NOTES_TODAY=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("notes_today",0))')
  UNKNOWN_COMMANDS=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("unknown_commands",0))')
  BACK_DOOR=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("back_door_lock","unknown"))')
  LIGHT_MODE=$(python3 -c 'import json;print(json.load(open("/home/ai/Nova/state/dashboard_state.json")).get("bedroom_light_mode","unknown"))')
else
  VOICE_LISTENER="unknown"
  LAST_UNKNOWN="none"
  NOTES_TODAY="0"
  UNKNOWN_COMMANDS="0"
  BACK_DOOR="unknown"
  LIGHT_MODE="unknown"
fi

DATE=$(date '+%I:%M:%S %p')

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
.info { color: #7dcfff; }
.event-success { color: #7CFC00; }
.event-warn { color: #ffd166; }
.event-error { color: #ff4d4d; }
.event-info { color: #7dcfff; }

.status-light {
  display: inline-block;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  margin-right: 10px;
}
.green { background: #7CFC00; box-shadow: 0 0 10px #7CFC00; }
.yellow { background: #ffd166; box-shadow: 0 0 10px #ffd166; }
.red { background: #ff4d4d; box-shadow: 0 0 10px #ff4d4d; }

.small {
  font-size: 15px;
  line-height: 1.5;
}

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
    <div>$NOVA_VERSION</div>
    <div>$NOVA_ROLE</div>
    <div>Mode: $NOVA_MODE</div>
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
    <div class="label">Nova State</div>
    <div class="service good">● Voice Listener <span>$VOICE_LISTENER</span></div>
    <div class="service info">● Bedroom Light Mode <span>$LIGHT_MODE</span></div>
    <div class="service warn">● Back Door Lock <span>$BACK_DOOR</span></div>
    <div class="service info">● Notes Today <span>$NOTES_TODAY</span></div>
    <div class="service warn">● Unknown Commands <span>$UNKNOWN_COMMANDS</span></div>
    <div class="small">Last unknown command: $LAST_UNKNOWN</div>
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
    <pre>$EVENT_SUMMARY</pre>
  </div>

</div>

<div class="footer">
Last dashboard update: $LAST_UPDATE | Auto-refresh: 60 seconds
</div>

</body>
</html>
EOF
/home/ai/Nova/scripts/log_event.sh "Dashboard updated"
