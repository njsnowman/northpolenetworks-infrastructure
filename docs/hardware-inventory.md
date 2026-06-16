# North Pole Networks Hardware Inventory

_Last updated: 2026-06-16_

## Purpose

This document tracks key infrastructure hardware, management IPs, and out-of-band access assignments for the North Pole Networks environment.

## Proxmox / Server Nodes

| Hostname | IP Address | Current State | Role | Notes |
|---|---:|---|---|---|
| pve-north | 10.10.10.10 | Active | Primary Proxmox node | Current source of truth for VM/LXC workloads |
| pve | 10.10.10.11 | Legacy/deferred | Secondary Proxmox node | Not currently active; re-audit before using as production documentation |
| pbs | 10.10.10.12 | Active/defined | Proxmox Backup Server | Backup datastore and recovery services |

## Active pve-north Bridge Summary

| Bridge | IP / Mode | Physical Interface | Purpose |
|---|---|---|---|
| vmbr0 | 10.10.10.10/24 | enp2s0 | Host management, Proxmox Web UI, SSH, and active VM/LXC network |
| vmbr1 | Manual / VLAN-aware | enx6c1ff71a00d4 | Future/dedicated VM LAN over USB 2.5G adapter |
| vmbr2 | Manual / VLAN-aware | enx6c6e0713ab69 | Backup, lab, or secondary network over USB 1G adapter |

## Out-of-Band Management

| Device | Assigned Host | Access | Purpose |
|---|---|---|---|
| PiKVM-01 | pve-north | LAN + LTE | Emergency console and power control for the active Proxmox node |
| PiKVM-02 | pve | LAN + LTE | Legacy/deferred secondary node emergency console |

## Core Supporting Services

| Service | IP / Host | Purpose |
|---|---:|---|
| Proxmox Web UI | 10.10.10.10:8006 | Active Proxmox management |
| NGINX Primary | 10.10.10.100 | Reverse proxy and dashboard hosting |
| ADS-B / Dashboard | 10.10.10.108 | ADS-B receiver stack and dashboard |
| MQTT Broker | 10.10.10.215 | MQTT broker for radio/mesh integrations |
| Homepage / Mission Control | 10.10.10.107 | Internal service portal |
| MeshMonitor | 10.10.10.223 | MeshMonitor service |
| InfluxDB | 10.10.10.117 | Metrics/time-series storage |
| Tailscale Gateway | 10.10.10.244 | Internal route advertisement / VPN gateway |
| Weather Dashboard | 10.10.10.78 | Weather/home dashboard service |
| ntfy | 10.10.10.157 | Self-hosted push notifications |
| Intercept | 10.10.10.132 | Intercept/radio service |
| Proxmox Backup Server | 10.10.10.12 | Proxmox backup datastore |
| Prometheus | 10.10.10.105 | Metrics collection and monitoring |
| Grafana | 10.10.10.106 | Dashboards and visualization |

## Known Network

| Network | Purpose |
|---|---|
| 10.10.10.0/24 | North Pole Networks internal lab / management network |
| 192.168.10.0/24 | Main/default LAN |
| 192.168.3.0/24 | IoT network |
| 192.168.4.0/24 | Logan network |
| 192.168.5.0/24 | Miscellaneous / holding network |
| 192.168.6.0/24 | Lab WiFi network |

## Detailed Inventory References

- `docs/proxmox-current-layout.md` — Current active `pve-north` bridge, route, VM, and LXC layout
- `data/proxmox-pve-north-inventory.csv` — Sanitized CSV export of the `pve-north` VM/LXC inventory

## Documentation Notes

This file intentionally avoids storing secrets or sensitive access material.

Detailed access material should stay outside of public documentation.

## Physical Labeling Standard

Use simple physical labels on devices and cables.

Recommended labels:

```text
PiKVM-01 -> pve-north -> 10.10.10.10
PiKVM-02 -> pve -> 10.10.10.11 [legacy/deferred]
```

Cable labels should identify:

- HDMI target
- USB target
- ATX power/reset target
- Ethernet switch/port
- LTE antenna assignment
