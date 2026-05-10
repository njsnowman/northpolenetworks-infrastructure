# UniFi Current Backbone - NorthPoleNetworks

Last updated: 2026-05-10

## Purpose

This document tracks the current UniFi backbone for the NorthPoleNetworks home lab / home production network. It is intended to be the operational source of truth for the current gateway, switching, wireless, VLAN, VPN, port-forwarding, and lab infrastructure layout.

This is not a basic home network. The current environment is structured like a small infrastructure operations platform with segmented networks, access switching, wireless distribution, Proxmox virtualization, PBS backups, monitoring, RF/ADS-B telemetry, and remote recovery planning.

> Security note: Do not commit passwords, VPN keys, API tokens, SIM account details, customer credentials, or unnecessary sensitive WAN exposure details to GitHub. Use placeholders where needed.

---

## Core Gateway

| Device | Role | Management / Gateway IP | WAN Provider | WAN Port | Notes |
|---|---|---:|---|---:|---|
| `NP-GW-Ultra` | UniFi Cloud Gateway Ultra / primary router | `192.168.10.1` | Frontier Communications | Port 5 | Primary gateway, routing, DHCP, firewall, NAT, VLAN gateway services, WireGuard VPN client, port-forwarding, and UniFi control plane |

Observed WAN:

```text
ISP: Frontier Communications
WAN interface: WAN1
WAN public IP observed in UniFi: REDACTED_IN_DOCS
Gateway LAN IP: 192.168.10.1
```

---

## Adopted UniFi Devices

| Device | Model | IP Address | Uplink | Parent / Upstream | Experience |
|---|---|---:|---|---|---|
| `NP-GW-Ultra` | UCG Ultra | `192.168.10.1` | GbE | Frontier Communications | GbE |
| `NP-Flex-1F-LOG` | USW Flex Mini | `192.168.10.221` | GbE | `NP-GW-Ultra` Port 4 | GbE |
| `NP-Flex-1F-LIV` | USW Flex Mini | `192.168.10.206` | GbE | `NP-GW-Ultra` Port 2 | GbE |
| `NP-USW-Flex-2F-Desk` | USW Flex Mini | `192.168.10.2` | GbE | `NP-SW-CORE-R1` Port 6 | GbE |
| `NP-SW-ACC-R2` | USW Lite 8 PoE | `192.168.10.245` | 2 GbE | `NP-SW-CORE-R1` Port 7 | 2 GbE |
| `NP-SW-ACC-R3` | USW Lite 8 PoE | `192.168.10.164` | 2 GbE | `NP-SW-ACC-R2` Port 7 | 2 GbE |
| `NP-SW-CORE-R1` | USW Lite 8 PoE | `192.168.10.8` | GbE | `NP-GW-Ultra` Port 3 | GbE |
| `NP-U7-1F` | U6+ | `192.168.10.7` | GbE | `NP-Flex-1F-LOG` Port 2 | Excellent |
| `NP-U7-2F` | U7 Pro | `192.168.10.6` | GbE | `NP-USW-Flex-2F-Desk` Port 4 | Excellent |

---

## Current Physical / Switching Topology

```text
Frontier Communications WAN
        |
        | Port 5 / GbE
        v
NP-GW-Ultra / UCG Ultra / 192.168.10.1
        |
        |-- Port 2 / GbE --> NP-Flex-1F-LIV / 192.168.10.206
        |                     |-- Port 2 / FE  --> Living Room Hisense TV / 192.168.10.126
        |
        |-- Port 3 / GbE --> NP-SW-CORE-R1 / 192.168.10.8
        |                     |-- Port 1 / GbE --> NP-GW-Ultra uplink
        |                     |-- Port 2 / Auto --> Server Camera / NP-Lab / planned or inactive
        |                     |-- Port 3 / Auto --> NP-MS-MAN-S / NP-Lab / planned or inactive
        |                     |-- Port 4 / Auto --> Legion i9 Laptop / NP-Lab / planned or inactive
        |                     |-- Port 5 / Auto --> NP-FR24-S / NP-Lab / planned or inactive
        |                     |-- Port 6 / GbE --> NP-USW-Flex-2F-Desk / 192.168.10.2
        |                     |                     |-- Port 4 / GbE --> NP-U7-2F / 192.168.10.6
        |                     |                     |-- Port 5 / GbE --> Legion i9 Laptop / 192.168.10.127
        |                     |
        |                     |-- Port 7 / GbE --> NP-SW-ACC-R2 / 192.168.10.245
        |                     |-- Port 8 / GbE --> NP-SW-ACC-R2 / 192.168.10.245
        |
        |-- Port 4 / GbE --> NP-Flex-1F-LOG / 192.168.10.221
        |                     |-- Port 2 / GbE --> NP-U7-1F / 192.168.10.7
        |                     |-- Port 3 / GbE --> Logan Origin PC / 192.168.4.189
        |
        |-- Port 5 / GbE --> Frontier Communications WAN

NP-SW-ACC-R2 / 192.168.10.245
        |-- Port 1 / GbE --> NP-NAS-NIC1 / 10.10.10.5 / NP-Lab
        |-- Port 2 / GbE --> available / NP-Lab
        |-- Port 3 / Auto --> NP-PBS / planned or inactive link / NP-Lab
        |-- Port 4 / Auto --> NP-PBS / planned or inactive link / NP-Lab
        |-- Port 5 / GbE --> NP-SW-CORE-R1 / 192.168.10.8
        |-- Port 6 / GbE --> NP-SW-CORE-R1 / 192.168.10.8
        |-- Port 7 / GbE --> NP-SW-ACC-R3 / 192.168.10.164
        |-- Port 8 / GbE --> NP-SW-ACC-R3 / 192.168.10.164

NP-SW-ACC-R3 / 192.168.10.164
        |-- Port 1 / GbE --> PVE South / pve / 10.10.10.11 / NP-Lab
        |-- Port 2 / GbE --> NP-MS-MAN-S / pve-north / 10.10.10.10 / NP-Lab
        |-- Port 3 / GbE --> NP-PBS / 10.10.10.12 / NP-Lab
        |-- Port 4 / Auto --> PVE South / planned or inactive / NP-Lab
        |-- Port 5 / Auto --> device history / NP-Lab
        |-- Port 6 / FE  --> Uniden-SDS200 / 10.10.10.241 / NP-Lab
        |-- Port 7 / GbE --> NP-SW-ACC-R2 / 192.168.10.245
        |-- Port 8 / GbE --> NP-SW-ACC-R2 / 192.168.10.245
```

---

## Network / VLAN Plan

| Network Name | VLAN ID | Router | Subnet | DHCP | Purpose |
|---|---:|---|---:|---|---|
| `NP-Default` | 1 | `NP-GW-Ultra` | `192.168.10.0/24` | Server | Main/default LAN and trusted client network |
| `NP-Lab` | 2 | `NP-GW-Ultra` | `10.10.10.0/24` | Server | Lab/server infrastructure network |
| `NP-Home IoT` | 3 | `NP-GW-Ultra` | `192.168.3.0/24` | Server | IoT / smart home devices |
| `NP-Logan's World` | 4 | `NP-GW-Ultra` | `192.168.4.0/24` | Server | Logan / child device network |
| `Not Default` | 5 | `NP-GW-Ultra` | `192.168.5.0/24` | Server | Secondary / holding / miscellaneous network |
| `NorthPole-Lab-WiFi` | 6 | `NP-GW-Ultra` | `192.168.6.0/24` | Server | Dedicated lab WiFi network |

---

## WiFi / SSID Plan

| SSID | Network | VLAN / Network Mapping | Broadcasting APs | Radio Bands | Security | Current Client Count Observed |
|---|---|---|---|---|---|---:|
| `N0rthP0le` | Native Network | Native / default | All APs | 2.4 GHz, 5 GHz, 6 GHz | WPA2/WPA3 | 4 |
| `TP-Link_IoT_5E58` | `NP-Home IoT` | VLAN 3 | All APs | 2.4 GHz, 5 GHz, 6 GHz | WPA2/WPA3 | 15 |
| `North Pole Lab` | `NorthPole-Lab-WiFi` | VLAN 6 | All APs | 2.4 GHz, 5 GHz, 6 GHz | WPA2/WPA3 | - |
| `IDK` | `NP-Logan's World` | VLAN 4 | All APs | 2.4 GHz, 5 GHz, 6 GHz | WPA2/WPA3 | - |

---

## Wireless Global Settings Observed

| Setting | Current State | Notes |
|---|---|---|
| Default WiFi Speeds | Maximum Speed | Performance-focused profile |
| 2.4 GHz width | 20 MHz | Correct for IoT and legacy reliability |
| 5 GHz width | 80 MHz | Balanced performance and stability |
| 6 GHz width | 320 MHz | Maximum performance / WiFi 7 style configuration; monitor stability |
| Extended 5 GHz Spectrum / DFS | Enabled | Expands usable 5 GHz channel options |
| 5 GHz Roaming Assistant | Enabled at `-75 dBm` | Encourages sticky clients to roam |
| Wireless Meshing | Enabled | Review later; if all APs are wired, consider disabling to prevent accidental wireless uplinks |
| Mesh MLO STR | Auto / Labs | Experimental feature; monitor client behavior |
| Mesh Monitor | Gateway | Uses gateway as monitor target |
| UniFi Auto-Link | Enabled | Useful for simple topology adoption; monitor for unexpected behavior |
| WiFiman Support | Enabled | Useful for diagnostics |
| Channel AI | Available / configured from controller | Confirm final 2.4 GHz non-overlap behavior |

---

## Radio / Channel Strategy

Observed channel planning supports 2.4 GHz, 5 GHz, and 6 GHz operations.

Notable items:

- 2.4 GHz uses 20 MHz channel width, which is appropriate for reliability and IoT compatibility.
- 5 GHz uses 80 MHz channel width with DFS spectrum enabled.
- 6 GHz uses 320 MHz channel width for maximum speed capability.
- U7 Pro gives the network modern WiFi 7/6 GHz capability.
- U6+ provides additional strong coverage for multi-floor / multi-zone wireless distribution.

Recommended operating posture:

1. Keep 2.4 GHz at 20 MHz.
2. Prefer non-overlapping 2.4 GHz channels: 1, 6, and 11.
3. Continue monitoring DFS behavior on 5 GHz.
4. Monitor 6 GHz reliability at 320 MHz. If client instability appears, test 160 MHz.
5. If all APs are wired, consider disabling Wireless Meshing later.

---

## Current Infrastructure Clients Observed

The UniFi client table shows a serious lab/server environment on `NP-Lab`.

| Client / Service | IP Address | Network | Notes |
|---|---:|---|---|
| `NP-MS-MAN-S` | `10.10.10.10` | NP-Lab | pve-north / management server / primary Proxmox node |
| `NP-PBS` | `10.10.10.12` | NP-Lab | Proxmox Backup Server |
| `NP-Bitwarden` | `10.10.10.85` | NP-Lab | Password vault / Bitwarden service |
| `NP-Grafana` | `10.10.10.106` | NP-Lab | Grafana monitoring dashboard server |
| `NP-Prometheus` | `10.10.10.105` | NP-Lab | Metrics collection server |
| `NP-HA-S` | `10.10.10.218` | NP-Lab | Home Assistant server |
| `NP-NAS-NIC1` | `10.10.10.5` | NP-Lab | NAS interface |
| `NP-NAS-S` | `10.10.10.101` | NP-Lab | NAS / storage service |
| `NP-NextCloud` | `10.10.10.200` | NP-Lab | Nextcloud service |
| `NP-NGINX-P` | `10.10.10.100` | NP-Lab | NGINX reverse proxy / web edge |
| `NP-VM-Spare` | `10.10.10.103` | NP-Lab | Spare VM / future use |
| `vm-adsb` | `10.10.10.108` | NP-Lab | ADS-B / aircraft telemetry server |
| `Uniden-SDS200` | `10.10.10.241` | NP-Lab | Scanner / ProScan / RF monitoring |
| `DESKTOP-ESDAGPS` | `10.10.10.154` | NP-Lab | ProScan/SDS200 related workstation/server |
| `Desk Reporting Computer` | `10.10.10.201` | NP-Lab | Lab reporting workstation |
| `CT109` | `10.10.10.165` | NP-Lab | Lab client/device |

---

## IoT / Family Network Clients Observed

Examples of current segmented IoT and family devices:

| Device | IP Address | Network | Notes |
|---|---:|---|---|
| Alexa Living Room | `192.168.3.187` | NP-Home IoT | IoT voice device |
| Alexa Logan's Room | `192.168.3.50` | NP-Home IoT | IoT voice device |
| Bat Cam 1 | `192.168.3.123` | NP-Home IoT | Camera / IoT |
| Bat Cam 2 | `192.168.3.185` | NP-Home IoT | Camera / IoT |
| Cat Feeder | `192.168.3.184` | NP-Home IoT | IoT device |
| Govee LED Strip | `192.168.3.120` | NP-Home IoT | Smart lighting |
| Govee LED Strip | `192.168.3.103` | NP-Home IoT | Smart lighting |
| HS300 | `192.168.3.34` | NP-Home IoT | Smart power strip |
| HS300 | `192.168.3.242` | NP-Home IoT | Smart power strip |
| Nest Protect | `192.168.3.224` | NP-Home IoT | Safety/IoT device |
| Vobot | `192.168.3.140` | NP-Home IoT | IoT device |
| Logan Origin PC | `192.168.4.189` | NP-Logan's World | Logan network client |
| iPhone | `192.168.10.119` | NP-Default | Trusted mobile client |
| Snowman-Legion | `192.168.10.36` | NP-Default | Main laptop/workstation |

---

## VPN Configuration Observed

| VPN Name | Type | Tunnel IP / Subnet | Server Address | Port | Notes |
|---|---|---:|---|---:|---|
| `WireGuardVPN Client` | WireGuard | `192.168.13.2/32` | WAN public IP redacted in docs | `51820` | Remote access / VPN client configuration present |

---

## Port Forwarding / Published Services Observed

> Security note: WAN IP is intentionally redacted in documentation. Several forwards currently show source `Any`; review and restrict where practical.

| Rule Name | Protocol | Source | Forward Destination | Purpose / Notes |
|---|---|---|---|---|
| Ubuntu - SSH Port | TCP/UDP | Any | `10.10.10.85:22` | SSH access to Ubuntu/Bitwarden host; consider VPN-only |
| Ubuntu - 443 | TCP/UDP | Any | `10.10.10.85:443` | HTTPS service |
| Ubuntu - 80 | TCP/UDP | Any | `10.10.10.85:80` | HTTP service |
| Linkwarden - Umbrel | TCP/UDP | Any | `10.10.10.125:8233` | Linkwarden/Umbrel service |
| vm-utils SSH | TCP/UDP | Any | `10.10.10.107:22` | SSH to utility VM; consider VPN-only |
| vm-nginx-p 80 | TCP/UDP | Any | `10.10.10.100:80` | NGINX HTTP reverse proxy |
| vm-nginx-p 443 | TCP/UDP | Any | `10.10.10.100:443` | NGINX HTTPS reverse proxy |
| ha-8123 | TCP/UDP | Any | `10.10.10.218:8123` | Home Assistant |
| Linkwarden-Umbrel-80 | TCP/UDP | Any | `10.10.10.125:80` | Umbrel/Linkwarden HTTP |
| Linkwarden-Umbrel-443 | TCP/UDP | Any | `10.10.10.125:443` | Umbrel/Linkwarden HTTPS |
| SDS200-5000 | TCP/UDP | Any | `10.10.10.154:5000` | ProScan/SDS200 service |
| SDS200-5001 | TCP/UDP | Any | `10.10.10.154:5001` | ProScan/SDS200 service |
| Synology-SFTP | TCP/UDP | Any | `10.10.10.5:50605` | Synology SFTP |
| Scanner RTSP | TCP/UDP | Any | `192.168.10.241:554` | Scanner/RTSP access |

Recommended future posture:

1. Keep public HTTP/HTTPS primarily terminating at `NP-NGINX-P`.
2. Move SSH-style access behind WireGuard, Tailscale, or trusted source IP restrictions.
3. Keep published service inventory updated in `firewall/port-forward-review.md`.
4. Avoid exposing administrative ports directly to the WAN where practical.

---

## Policy Engine / Content Filtering Observed

| Control | Current State | Notes |
|---|---|---|
| Safe Search Logan | Enabled | Applies to Logan-related devices / group; includes Basic filtering and Ad Block |
| Safe Search Providers | Google, Microsoft, YouTube | Family/content safety enforcement |
| Milestone Management Server list | Port list object | Includes key management service ports such as `7563`, `80`, `443`, `22331` |
| Milestone Ports list | Port list object | Larger reusable VMS port group; count observed as 34 ports |

This is important because it shows reusable network objects and operational policy design rather than one-off unmanaged rules.

---

## Operational Summary

The current UniFi network is built around a core/access topology:

```text
Gateway -> Core Switch -> Access Switches -> APs / Servers / Lab Clients
```

Strengths:

- Proper VLAN segmentation
- Dedicated infrastructure lab subnet
- IoT isolation
- Dedicated child/family network
- WiFi 6/6E/7 style capability with 6 GHz support
- Dedicated monitoring and infrastructure services
- PBS-backed Proxmox environment
- VPN and remote access services present
- Port groups for Milestone/VMS work
- Local and future out-of-band recovery planning

Immediate improvement items:

1. Restrict public port forwards where possible.
2. Keep WAN IPs and sensitive details redacted in public GitHub docs.
3. Finalize PiKVM deployment once hardware arrives.
4. Update diagrams after PiKVMs are installed.
5. Continue tuning WiFi channel plans and verify APs are using wired uplinks.
6. Document 10Gb networking as deferred until hardware is purchased.
