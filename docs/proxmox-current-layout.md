# Current Proxmox Layout - pve-north

_Last updated: 2026-06-16_

## Current State

`pve-north` is the active Proxmox node for the North Pole Networks environment.

The previous secondary Proxmox node documentation should be treated as legacy/deferred until that host is brought back online and re-audited.

## Host Network Summary

| Host | Role | Management IP | Gateway | Primary Bridge | Primary NIC |
|---|---|---:|---:|---|---|
| pve-north | Active Proxmox host | 10.10.10.10/24 | 10.10.10.1 | vmbr0 | enp2s0 |

## Bridge Layout

| Bridge | Status from Audit | Addressing | Physical Port | Purpose |
|---|---|---|---|---|
| vmbr0 | UP | 10.10.10.10/24 | enp2s0 | HOST-MGMT - Proxmox Web UI, SSH, and current VM/LXC traffic |
| vmbr1 | DOWN | Manual / VLAN-aware | enx6c1ff71a00d4 | VM-LAN-USB-2.5G - future or dedicated main VM network traffic |
| vmbr2 | UNKNOWN | Manual / VLAN-aware | enx6c6e0713ab69 | VM-BACKUP-LAB-USB-1G - backup, lab, or secondary network |

## Routing

| Destination | Route |
|---|---|
| Default | 10.10.10.1 via vmbr0 |
| 10.10.10.0/24 | Directly connected on vmbr0 |

## Active VM Inventory

| VMID | Name | Status | Primary LAN IP | Bridge | Notes |
|---:|---|---|---:|---|---|
| 100 | vm-proscan | running | 10.10.10.154 | vmbr0 | ProScan / scanner service VM |
| 103 | vm-bitwarden | running | 10.10.10.85 | vmbr0 | Bitwarden / vault services; Docker bridge IPs also detected |
| 112 | vm-ADS-B | running | 10.10.10.108 | vmbr0 | ADS-B receiver stack and dashboards |
| 116 | haos15.2 | running | 10.10.10.218 | vmbr0 | Home Assistant OS |
| 118 | vm-nginx-p | running | 10.10.10.100 | vmbr0 | Primary reverse proxy |
| 120 | vm-node-exporter | running | 10.10.10.103 | vmbr0 | Monitoring/exporter VM |
| 121 | vm-nginx-s | running | Not detected | vmbr0 | Running, but no LAN IPv4 detected in audit |
| 122 | vm-nextcloud | running | 10.10.10.200 | vmbr0 | Nextcloud; Docker bridge IPs also detected |
| 123 | vm-mattermost | running | 10.10.10.104 | vmbr0 | Mattermost collaboration stack |
| 124 | vm-prometheus | running | 10.10.10.105 | vmbr0 | Prometheus metrics collection |
| 125 | vm-grafana | running | 10.10.10.106 | vmbr0 | Grafana dashboards |
| 126 | vm-utils | running | Not detected | vmbr0 | Running, but no LAN IPv4 detected in audit |
| 135 | vm-intercept | running | 10.10.10.132 | vmbr0 | Intercept/radio services |
| 136 | vm-watchtower | running | Not detected | vmbr0 | Running, but no LAN IPv4 detected in audit |
| 139 | vm-meshops-dev | running | Not detected | vmbr0 | MeshOps development VM |

## Active LXC Inventory

| CTID | Name | Status | Primary LAN IP | Bridge | Notes |
|---:|---|---|---:|---|---|
| 106 | ct-mqtt | running | 10.10.10.215 | vmbr0 | MQTT broker services |
| 107 | ct-homepage | running | 10.10.10.107 | vmbr0 | Homepage / Mission Control dashboard; Docker bridge IPs also detected |
| 114 | ct-meshmonitor | running | 10.10.10.223 | vmbr0 | MeshMonitor service container |
| 117 | ct-influxdb | running | 10.10.10.117 | vmbr0 | InfluxDB metrics/time-series storage |
| 119 | np-tailscale-gateway | running | 10.10.10.244 | vmbr0 | Tailscale gateway / route advertisement host |
| 134 | ct-nodered | running | Not detected | vmbr0 | Running, but no LAN IPv4 detected in audit |
| 137 | ct-weather | running | 10.10.10.78 | vmbr0 | Weather/home dashboard service |
| 138 | ct-ntfy | running | 10.10.10.157 | vmbr0 | Self-hosted ntfy push notifications |

## Stopped / Template / Deferred Workloads

| ID | Type | Name | Status | Bridge | Notes |
|---:|---|---|---|---|---|
| 101 | VM | Windows-11-Template | stopped | vmbr0 | Template |
| 102 | VM | vm-op25 | stopped | vmbr0 | OP25 radio VM |
| 104 | VM | Milestone-Template-old | stopped | vmbr0 | Legacy template |
| 105 | VM | Ubuntu-Template | stopped | vmbr0 | Template |
| 108 | VM | VM-WIN11-Template | stopped | vmbr0 | Template |
| 110 | VM | VM-TEST-1 | stopped | vmbr1 | Test VM on secondary bridge |
| 113 | VM | AAS-VM-S-1 | stopped | vmbr0 | Deferred / inactive |
| 115 | VM | vm-dragonos | stopped | vmbr0 | DragonOS radio/security lab VM |
| 127 | VM | vm-frigate | stopped | vmbr0 | Frigate NVR / video analytics VM |
| 130 | VM | vm-matrix | stopped | vmbr0 | Matrix service VM |
| 133 | VM | vm-sdrtrunk | stopped | vmbr0 | SDRTrunk radio VM |
| 109 | LXC | ct-rustdesk | stopped | vmbr0 | RustDesk container |
| 111 | LXC | ct-TAK | stopped | vmbr0 | TAK container |
| 128 | LXC | ct-aprstac-rf | stopped | vmbr0 | APRS/TAC RF container |
| 129 | LXC | ct-hookshot | stopped | vmbr0 | Hookshot integration container |
| 131 | LXC | ct-meshcore | stopped | vmbr0 | Static IP recorded as 10.10.10.147 while stopped |
| 132 | LXC | ct-vrs | stopped | vmbr0 | Virtual Radar Server container |
| 140 | LXC | ct-portainer | stopped | vmbr0 | Portainer container |

## Audit Notes

- Inventory was generated from the active Proxmox host using `qm`, `pct`, host interface output, and guest/container IP discovery.
- MAC addresses were intentionally omitted from this public documentation.
- VPN overlay, IPv6 link-local, and Docker bridge addresses were not treated as primary service IPs.
- Any running VM/LXC showing `Not detected` should be checked for static IP configuration, DHCP lease visibility, and QEMU Guest Agent status where applicable.

## Recommended Next Checks

Run the following on `pve-north` to resolve missing LAN IPv4 entries:

```bash
for ID in 121 126 136 139; do
  echo "===== VM $ID ====="
  qm guest cmd "$ID" network-get-interfaces 2>/dev/null || echo "No QEMU guest agent data"
done

for ID in 134; do
  echo "===== LXC $ID ====="
  pct exec "$ID" -- ip -br addr
  pct exec "$ID" -- hostname -I
done
```

## Security Note

Do not commit passwords, tokens, private keys, customer credentials, public WAN IP allowlists, or recovery secrets to GitHub.
