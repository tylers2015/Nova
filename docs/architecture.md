# Nova Architecture

## Overview

Nova is Tyler's local AI assistant and automation ecosystem.

Primary goals:
- Long-term project memory
- Local AI assistance
- Automation and scheduling
- Home Assistant integration
- Voice interaction
- System monitoring
- Robotics support
- Permanent and portable architecture

---

# Core Philosophy

Nova's permanent core consists of:
- scripts
- memory
- configuration
- documentation
- Git version history

External services are modular and replaceable.

Nova should:
- remain portable
- avoid vendor lock-in
- survive hardware replacement
- eventually self-monitor and partially self-repair

---

# Current Hardware

## Nova Server
- HP Pro 3515 Series
- Linux
- 16GB DDR3 RAM
- AMD Radeon HD 7540D
- Docker installed
- Tailscale installed

## Gaming PC
Purpose:
- Primary workstation
- VS Code remote development
- Future speaker/audio output
- Future voice interaction
- Future GPU acceleration

## Laptop
Purpose:
- Portable Nova administration
- Remote VS Code editing
- Diagnostics and field development

## Raspberry Pi Systems
Planned purposes:
- RTK GPS
- Robotics
- Sensors
- Mower systems
- Distributed automation nodes

---

# Current Software Stack

## AI
- Ollama
- Open WebUI
- llama3.2:3b
- qwen2.5-coder planned

## Automation
- Home Assistant
- Docker containers

## Development
- VS Code Remote SSH
- Git
- GitHub planned

## Networking
- Tailscale
- SSH remote access

---

# Current Nova Features

- Local AI chat interface
- Morning briefing script
- Weather reporting
- Dockerized services
- Git version control
- Structured memory folders
- Remote editing from multiple machines

---

# Folder Structure

```text
Nova/
├── memory/
├── scripts/
├── logs/
├── docs/
├── backups/
├── tools/
├── configs/
└── agents/
