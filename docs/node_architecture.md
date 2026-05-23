# Nova Node Architecture

## Purpose

Nova should grow into a distributed assistant system instead of relying on one machine to do everything.

Each device should have a clear role.

---

# Current Nodes

## Nova Core Server
Device: HP Pro 3515  
Role:
- Dashboard
- Memory storage
- Monitoring
- Home Assistant
- Event logs
- Notifications
- Local lightweight AI
- System coordination

## Gaming PC
Role:
- Future GPU inference node
- Voice output/input node
- Heavy model execution
- Main development workstation

## Laptop
Role:
- Portable administration
- Remote development
- Field troubleshooting

## Raspberry Pi Nodes
Role:
- Robotics
- mower control
- sensors
- RTK GPS
- future edge automation

---

# Design Philosophy

Nova should not depend on one computer doing everything.

The core server should coordinate the system.
More powerful machines should handle heavier tasks.
Small devices should handle sensors, robotics, displays, or room-level interaction.

---

# Future Service Split

## Nova Core
Runs on HP server.
Handles:
- memory
- logs
- dashboard
- status monitoring
- event routing
- home automation

## Nova Inference Node
Runs on gaming PC or future GPU server.
Handles:
- larger AI models
- slow reasoning
- code assistance
- heavy memory answering

## Nova Voice Node
Runs on machine with speaker/microphone.
Handles:
- microphone input
- speech-to-text
- wake word detection
- text-to-speech
- room interaction

## Nova Robotics Nodes
Run on Raspberry Pis.
Handle:
- mower control
- RTK
- sensors
- motor systems
- telemetry

---

# Communication Plan

Preferred communication methods:
- SSH
- HTTP APIs
- Tailscale IPs
- local network
- structured JSON messages
- event logs

---

# Long-Term Goal

Nova becomes a distributed local AI operating environment.

Each node can fail independently without destroying the whole system.
The core memory, logs, scripts, and documentation remain portable and version-controlled.
