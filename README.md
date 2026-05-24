## Nova
#nova ai assistant
# Nova

#Nova is a distributed local AI assistant and automation environment designed around persistence, modularity, observability, and long-term expandability.

The project combines:

* Local AI inference with Ollama
* Semantic memory and project recall
* Home Assistant automation
* Autonomous monitoring and notifications
* Distributed node architecture
* Remote voice output
* Dashboard telemetry and logging
* Robotics and future edge-device integration

Nova is designed to evolve into a persistent AI operating environment rather than a single chatbot or script.

---

# Current Architecture

## Current Infrastructure

### HP Core Server

Hostname: ai-HP-Pro-3515-Series

Roles:

* Core infrastructure node
* Semantic memory
* Dashboard
* Monitoring
* Notifications
* Home Assistant
* Ollama
* Automation coordinator

Current known local IP:

* 192.168.0.144

Dashboard:

* [http://192.168.0.144:5050](http://192.168.0.144:5050)

Open WebUI:

* [http://192.168.0.144:3000](http://192.168.0.144:3000)

Home Assistant:

* [http://192.168.0.144:8123](http://192.168.0.144:8123)

Ollama API:

* [http://127.0.0.1:11434](http://127.0.0.1:11434)

### Gaming PC Voice Node

Hostname: DESKTOP-RAVOV92

Roles:

* Remote voice node
* Future GPU inference node
* Future conversational interface
* Future wake-word processing

Current Tailscale IP:

* 100.114.205.101

SSH Example:

```bash
ssh nova@100.114.205.101
```

Voice execution example:

```bash
~/Nova/scripts/speak_gaming_pc.sh "Nova voice node online"
```

### Networking

Nova currently communicates between nodes using:

* Tailscale
* SSH
* local network routing
* distributed scripts
* future API communication

```text
[HP Pro 3515 Server]
Core Infrastructure Node
- Dashboard
- Monitoring
- Semantic Memory
- Event Logging
- Notifications
- Home Assistant
- Ollama
- Automation
        ↓
[Tailscale + SSH]
        ↓
[Gaming PC]
Voice Node / Future GPU Inference Node
- Remote speech output
- Future conversational interface
- Future GPU acceleration
        ↓
[Future Raspberry Pi Nodes]
Robotics / RTK / Sensors / Edge Systems
```

---

# Current Features

## Monitoring

Nova continuously monitors:

* Ollama API
* Docker containers
* Internet connectivity
* Tailscale connectivity
* RAM usage
* Disk usage
* Service recovery state

## Dashboard

Live updating dashboard with:

* System telemetry
* Event feed
* Status indicators
* Weather
* Service health
* Recent events
* Operational identity panel

Dashboard auto-starts on boot.

## Voice System

Distributed voice node architecture.

The HP server sends speech commands to the gaming PC over SSH/Tailscale.

Current capabilities:

* Spoken morning briefings
* Spoken WARN alerts
* Spoken ERROR alerts
* Spoken recovery announcements
* Autonomous scheduled speech

## Semantic Memory

Nova uses:

* Ollama embeddings
* Local indexed memory
* Semantic search
* Project history retrieval

Memory sources include:

* logs
* documentation
* markdown notes
* architecture files
* development history

## Home Assistant

Home Assistant is running in Docker.

Current integrations include:

* Matter device integration
* Lighting automation
* Morning routine automation
* Future room-level orchestration

## Notifications

Structured notification system with:

* INFO
* SUCCESS
* WARN
* ERROR

Includes:

* cooldown protection
* recovery detection
* speech routing
* event logging

## Event Logging

Nova maintains structured logs for:

* health checks
* automation
* incidents
* development
* events

---

# Repository Structure

```text
Nova/
├── brain/
│   ├── chunks/
│   └── index/
├── dashboard/
├── docs/
├── logs/
│   ├── automation/
│   ├── dev/
│   ├── events/
│   ├── health/
│   └── incidents/
├── memory/
├── scripts/
├── state/
├── venv/
└── README.md
```

---

# Important Scripts

## Dashboard

### update_dashboard.sh

Generates the live dashboard HTML.

### start_dashboard.sh

Starts the dashboard web server.

---

## Monitoring

### system_status.sh

Runs health checks and monitoring.

Handles:

* online/offline detection
* recovery announcements
* telemetry gathering
* alert generation

### notify.sh

Central notification routing layer.

Handles:

* event logging
* speech alerts
* cooldown protection
* severity handling

### log_event.sh

Structured event logger.

---

## Voice System

### speak.sh

Local Linux speech output.

### speak_gaming_pc.sh

Remote speech execution on Windows gaming PC.

Uses:

* SSH
* Tailscale
* Windows SpeechSynthesizer

---

## Semantic Memory

### index_memory.py

Indexes Nova memory into embeddings.

### semantic_search.py

Performs semantic memory retrieval.

### ask_nova.py

Combines semantic memory with Ollama for contextual question answering.

### remember.sh

Simple semantic memory search wrapper.

---

# Python Virtual Environment

Nova uses a Python virtual environment for:

* semantic memory
* indexing
* future APIs
* AI tooling

Activate:

```bash
source ~/Nova/venv/bin/activate
```

Deactivate:

```bash
deactivate
```

---

# Major Technologies

## AI

* Ollama
* llama3.2:3b
* nomic-embed-text

## Infrastructure

* Docker
* Home Assistant
* Tailscale
* SSH

## Dashboard

* HTML
* Bash-generated telemetry
* Python HTTP server

## Automation

* cron
* atd
* Bash scripts

## Voice

* Windows SpeechSynthesizer
* espeak-ng

---

# Current Automation Flow

```text
Scheduled Event
        ↓
Cron
        ↓
Monitoring / Morning Briefing
        ↓
notify.sh
        ↓
Event Logs + Voice Output
        ↓
Gaming PC Voice Node
```

---

# Morning Routine (Current)

Current morning routine includes:

* dashboard startup
* weather retrieval
* spoken morning briefing
* smart light activation through Home Assistant
* remote voice playback on gaming PC
* system status announcements

Future plans:

* Spotify playlist launch
* calendar integration
* reminders/tasks
* dynamic AI summaries
* room-aware automation

---

# Design Philosophy

Nova is designed around:

* modularity
* portability
* observability
* local-first AI
* distributed systems
* long-term maintainability
* infrastructure resilience

The project intentionally separates:

* monitoring
* notifications
* memory
* inference
* voice
* automation
* robotics

This allows Nova to scale into a multi-node AI ecosystem.

---

# Future Direction

## Near-Term Goals

* GPU inference node
* microphone input
* wake word detection
* Spotify automation
* improved dashboard visualization
* conversational voice interaction
* autonomous routines

## Long-Term Goals

* robotics integration
* RTK mower control
* room-aware voice nodes
* distributed inference
* self-healing infrastructure
* autonomous task execution
* persistent contextual memory
* AI-assisted engineering workflows

---

# Setup Notes

## Dashboard

```bash
python3 -m http.server 5050
```

Dashboard available at:

```text
http://<server-ip>:5050
```

---

## Cron Jobs

Morning briefing:

```bash
0 7 * * * /home/ai/Nova/scripts/morning_briefing.sh >> /home/ai/Nova/logs/morning.log 2>&1
```

Dashboard updates:

```bash
* * * * * /home/ai/Nova/scripts/update_dashboard.sh >> /home/ai/Nova/logs/automation/dashboard_update.log 2>&1
```

---

## Memory Indexing

Rebuild memory index:

```bash
~/Nova/scripts/index_memory.py
```

Ask Nova:

```bash
~/Nova/scripts/ask_nova.sh "what did we build for notifications"
```

---

# Current Status

Nova currently operates as:

* a persistent local AI environment
* a distributed automation system
* a semantic engineering memory system
* a voice-enabled infrastructure assistant
* a future robotics coordination platform

This repository serves as the operational source of truth for the Nova project.

# Current Working Infrastructure

## Core Nova Server

- Hostname: ai-HP-Pro-3515-Series
- Local IP: 192.168.0.144
- Dashboard: http://192.168.0.144:5050
- Open WebUI: http://192.168.0.144:3000
- Home Assistant: http://192.168.0.144:8123
- Ollama: http://127.0.0.1:11434

### Roles
- Semantic memory
- Monitoring
- Dashboard
- Home Assistant integration
- Weather alerts
- Automation orchestration
- Voice coordination

## Gaming PC Node

- Hostname: DESKTOP-RAVOV92
- Tailscale IP: 100.114.205.101

### Roles
- Bedroom voice node
- Spotify media node
- Polk soundbar controller
- Future microphone node
- Future GPU inference node

# Audio Routing

## Conference Speaker
- WARN alerts
- ERROR alerts
- Severe weather alerts

## Gaming PC Speakers
- Morning briefings
- Night reminders
- Bedroom notifications

## Polk Soundbar
- Spotify playback
- Ambient music
- Morning routines

# Persistent Spotify Automation

Nova uses a trigger-file architecture.

Flow:
Nova Server -> SSH -> Trigger File -> Watcher -> Spotify -> Playback

## Trigger File
C:\Nova\start_spotify.trigger

## Watcher Script
C:\Nova\spotify_watcher.ps1

## Startup VBS
C:\Nova\start_spotify_watcher.vbs

## Working Remote Trigger Command
sshpass -p 'NovaTempPass123!' ssh nova@100.114.205.101 'type nul > C:\Nova\start_spotify.trigger'

# Morning Routine

Flow:
- Light turns on
- Nova speaks briefing
- Spotify launches
- Music starts automatically
- Polk soundbar wakes

File:
~/Nova/morning_briefing.py

# Night Routine

Flow:
- Light dims blue
- Nova bedtime reminder
- Overnight monitoring mode

File:
~/Nova/night_routine.py

# Severe Weather Alerts

Flow:
- Light turns red
- Voice warning plays
- Monitoring continues
- Light restores after alert

# Important Commands

## Test Morning Routine
python3 ~/Nova/morning_briefing.py

## Test Night Routine
python3 ~/Nova/night_routine.py

## Trigger Spotify
sshpass -p 'NovaTempPass123!' ssh nova@100.114.205.101 'type nul > C:\Nova\start_spotify.trigger'

## Start Watcher Manually
powershell.exe -ExecutionPolicy Bypass -File C:\Nova\spotify_watcher.ps1
