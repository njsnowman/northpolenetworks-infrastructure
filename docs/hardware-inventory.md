# North Pole Networks Hardware Inventory

## Purpose

This document tracks key infrastructure hardware, management IPs, and out-of-band access assignments for the North Pole Networks environment.

## Proxmox Nodes

| Hostname | IP Address | Role | Notes |
|---|---:|---|---|
| pve-north | 10.10.10.10 | Primary / advanced Proxmox node | Used for advanced lab and infrastructure workloads |
| pve | 10.10.10.11 | Secondary Proxmox node | Secondary/recovery-side Proxmox host |

## Out-of-Band Management

| Device | Assigned Host | Access | Purpose |
|---|---|---|---|
| PiKVM-01 | pve-north | LAN + LTE | Emergency console and power control |
| PiKVM-02 | pve | LAN + LTE | Emergency console and power control |

## Core Supporting Services

| Service | IP / Host | Purpose |
|---|---:|---|
| NGINX | 10.10.10.100 | Reverse proxy and dashboard hosting |
| ADS-B / Dashboard | 10.10.10.108 | ADS-B receiver stack and dashboard |
| Proxmox Backup Server | 10.10.10.12 | Proxmox backup datastore |
| Prometheus | vm-prometheus | Metrics collection and monitoring |
| Grafana | vm-grafana | Dashboards and visualization |

## Known Network

| Network | Purpose |
|---|---|
| 10.10.10.0/24 | North Pole Networks internal lab / management network |

## Documentation Notes

This file intentionally avoids storing passwords, tokens, LTE SIM account numbers, or other sensitive credentials.

Sensitive access details should be kept in a password manager or secure vault, not in GitHub documentation.

## Physical Labeling Standard

Use simple physical labels on devices and cables.

Recommended labels:

```text
PiKVM-01 -> pve-north -> 10.10.10.10
PiKVM-02 -> pve -> 10.10.10.11
```

Cable labels should identify:

- HDMI target
- USB target
- ATX power/reset target
- Ethernet switch/port
- LTE antenna/SIM assignment
