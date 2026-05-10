# NorthPoleNetworks Infrastructure

Infrastructure architecture, deployment templates, automation scripts, and engineering documentation for NorthPoleNetworks.

## Structure

- `proxmox/` — Cluster, storage, VM templates, PBS
- `networking/` — VLANs, switching, routing, WAN patterns
- `firewall/` — UniFi/OPNsense, NAT, hardening, access control
- `vms/` — Milestone/Avigilon deployment + tuning notes
- `scripts/` — PowerShell/Bash helpers and automation
- `documentation/` — SOPs, runbooks, templates
- `diagrams/` — Topology and architecture diagrams
- `docs/` — Infrastructure reference documentation
- `runbooks/` — Step-by-step operational recovery procedures

## Current Documentation

### UniFi / Home Network Backbone

- `networking/unifi-current-backbone.md` — Current UniFi gateway, switching, VLAN, WiFi, and security overview
- `networking/vlan-ip-plan.md` — VLAN IDs, subnets, DHCP status, and intended network purpose
- `networking/switch-port-map.md` — Current switch port map and cleanup items
- `networking/wifi-ssid-radio-plan.md` — SSIDs, APs, channel plan, and radio tuning notes
- `firewall/unifi-firewall-policy-summary.md` — UniFi firewall/security posture summary
- `firewall/port-forward-review.md` — Public exposure and port-forward hardening checklist
- `diagrams/north-pole-network-topology.md` — Markdown topology documentation
- `diagrams/north-pole-network-topology.mmd` — Mermaid topology source

### PiKVM / Out-of-Band Access

- `docs/pikvm-out-of-band-access.md` — PiKVM V4 + LTE out-of-band access design
- `docs/proxmox-node-access-plan.md` — Access model for pve-north and pve
- `docs/lte-failover-access.md` — LTE failover rules and security guidance
- `docs/hardware-inventory.md` — Node, PiKVM, and supporting service inventory
- `runbooks/emergency-proxmox-recovery-using-pikvm.md` — Emergency recovery procedure when SSH, Proxmox UI, or normal networking is unavailable

### Proxmox Backup Server

- `docs/pbs-current-state.md` — Current PBS network design, recovery procedures, emergency network restoration service, and future 10Gb planning

## Current Proxmox Node Assignments

| Node | Management IP | Emergency Console |
|---|---:|---|
| pve-north | 10.10.10.10 | PiKVM-01 |
| pve | 10.10.10.11 | PiKVM-02 |
| pbs | 10.10.10.12 | Local 7-inch recovery console |

## Current Core Network Summary

| Network | VLAN | Subnet | Purpose |
|---|---:|---:|---|
| NP-Default | 1 | 192.168.10.0/24 | Main/default LAN |
| NP-Lab | 2 | 10.10.10.0/24 | Lab/server infrastructure |
| NP-Home IoT | 3 | 192.168.3.0/24 | IoT devices |
| NP-Logan's World | 4 | 192.168.4.0/24 | Logan / child device network |
| Not Default | 5 | 192.168.5.0/24 | Miscellaneous / holding network |
| NorthPole-Lab-WiFi | 6 | 192.168.6.0/24 | Lab WiFi network |

## Current Infrastructure Notes

### PBS Recovery State

PBS currently uses a persistent systemd oneshot recovery service to ensure `enp1s0` reliably comes online after boot.

Management services:

```text
PBS Web UI: https://10.10.10.12:8007
PBS SSH:    root@10.10.10.12
```

### Deferred 10Gb Plan

10Gb networking was evaluated and documented but intentionally deferred for now.

Future preferred architecture:

- Dedicated SFP+ 10Gb backup network
- DAC cabling between nodes and PBS
- Separate management and storage traffic
- Intel X520/X710 class NICs
- MikroTik CRS309 or similar SFP+ switch

## Security Note

Do not store passwords, API keys, SIM account details, VPN keys, or customer credentials in this repository. Keep sensitive information in a secure password manager or vault.

For firewall/port-forward documentation, use placeholders such as `WAN_PUBLIC_IP_REDACTED`, `TRUSTED_ADMIN_IP_REDACTED`, `VPN_ONLY`, or `CLOUDFLARE_PROTECTED` where appropriate.
