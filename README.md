# NorthPoleNetworks Infrastructure

Infrastructure architecture, deployment templates, automation scripts, and engineering documentation for NorthPoleNetworks.

## Structure

- `proxmox/` — Cluster, storage, VM templates, PBS
- `networking/` — VLANs, switching, routing, WAN patterns
- `firewall/` — OPNsense, NAT, hardening, access control
- `vms/` — Milestone/Avigilon deployment + tuning notes
- `scripts/` — PowerShell/Bash helpers and automation
- `documentation/` — SOPs, runbooks, templates
- `diagrams/` — Topology and architecture diagrams
- `docs/` — Infrastructure reference documentation
- `runbooks/` — Step-by-step operational recovery procedures

## Current Documentation

### PiKVM / Out-of-Band Access

- `docs/pikvm-out-of-band-access.md` — PiKVM V4 + LTE out-of-band access design
- `docs/proxmox-node-access-plan.md` — Access model for pve-north and pve
- `docs/lte-failover-access.md` — LTE failover rules and security guidance
- `docs/hardware-inventory.md` — Node, PiKVM, and supporting service inventory
- `runbooks/emergency-proxmox-recovery-using-pikvm.md` — Emergency recovery procedure when SSH, Proxmox UI, or normal networking is unavailable

## Current Proxmox Node Assignments

| Node | Management IP | Emergency Console |
|---|---:|---|
| pve-north | 10.10.10.10 | PiKVM-01 |
| pve | 10.10.10.11 | PiKVM-02 |

## Security Note

Do not store passwords, API keys, SIM account details, VPN keys, or customer credentials in this repository. Keep sensitive information in a secure password manager or vault.
