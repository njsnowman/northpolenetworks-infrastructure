# UniFi Switch Port Map - North Pole Networks

## Purpose

This document tracks the current observed UniFi switch port layout for the North Pole Networks backbone.

Last reviewed from UniFi screenshots: 2026-05-08.

> This file should be treated as a working port map. Some ports still need physical verification and cleanup because several ports show historical clients, Auto status, or labels such as `Available` while still showing a known device/MAC.

---

## NP-GW-Ultra Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | Master Bedroom | - | Auto | - | NP-Default | Verify unused/available state |
| 2 | Living Room | NP-Flex-1F-LIV | GbE | 192.168.10.206 | NP-Default | Downlink to living room Flex switch |
| 3 | UPLINK-GW | NP-SW-CORE-R1 | GbE | 192.168.10.8 | NP-Default | Core switch uplink |
| 4 | Logan's Bedroom | NP-Flex-1F-LOG | GbE | 192.168.10.221 | NP-Default | Downlink to Logan/1F Flex switch |
| 5 | WAN | Frontier Communications | GbE | WAN_PUBLIC_IP_REDACTED | - | WAN uplink |

---

## NP-Flex-1F-LIV Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | Port 1 | NP-GW-Ultra | GbE | 192.168.10.1 | NP-Default | Uplink to gateway |
| 2 | Port 2 | Living Room Hisense TV | FE | 192.168.10.126 | NP-Default | 100 Mbps device |
| 3 | Port 3 | Sony Playstation | Auto | - | NP-Default | Historical/inactive client shown |
| 4 | Port 4 | - | Auto | - | NP-Default | Available |
| 5 | Port 5 | - | Auto | - | NP-Default | Available |

---

## NP-Flex-1F-LOG Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | Port 1 | NP-GW-Ultra | GbE | 192.168.10.1 | NP-Default | Uplink to gateway |
| 2 | Port 2 | NP-U7-1F | GbE | 192.168.10.7 | NP-Default | Access point uplink |
| 3 | Port 3 | Logan Origin PC | Auto | - | NP-Logan's World | Historical/inactive client shown |
| 4 | Port 4 | - | Auto | - | NP-Default | Available |
| 5 | Port 5 | NP-U7-1F | Auto | - | NP-Default | Verify if historical/duplicate AP entry |

---

## NP-SW-ACC-R2 Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | P1 - NP-NAS UPLINK | NP-NAS-NIC1 | GbE | 10.10.10.5 | NP-Lab | NAS uplink |
| 2 | Port 2 | - | GbE | - | NP-Lab | Verify if truly active/unused |
| 3 | P3 - Available | NP-PBS | Auto | - | NP-Lab | Verify PBS wiring/status |
| 4 | P4 - Proxmox Backup Server | NP-PBS | Auto | - | NP-Lab | Verify PBS wiring/status |
| 5 | P5 - LAG-to-R1 (5/??) | NP-SW-CORE-R1 | GbE | 192.168.10.8 | NP-Default | LAG member; verify pair |
| 6 | Port 6 | NP-SW-CORE-R1 | GbE | 192.168.10.8 | NP-Default | LAG/uplink member; verify with port 5 |
| 7 | P7 - LAG-to-R3 (7/8) | NP-SW-ACC-R3 | GbE | 192.168.10.164 | NP-Default | LAG member to R3 |
| 8 | Port 8 | NP-SW-ACC-R3 | GbE | 192.168.10.164 | NP-Default | LAG member to R3 |

---

## NP-SW-ACC-R3 Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | P1 - Available | d8:43:ae:29:42:99 | GbE | 10.10.10.11 | NP-Lab | Likely pve / PVE South; rename after confirmation |
| 2 | P2 - Available | NP-MS-MAN-S | GbE | 10.10.10.10 | NP-Lab | Likely pve-north / management server; rename after confirmation |
| 3 | P3 - Available | Legion i9 Laptop | GbE | 192.168.10.127 | NP-Default | Laptop/client |
| 4 | P4 - Available | PVE South | Auto | - | NP-Lab | Verify if historical/inactive |
| 5 | P5 - Available | 1c:86:0b:28:3f:3d | Auto | - | NP-Default | Unknown/historical MAC |
| 6 | P6 - SDS200-Scanner | Uniden-SDS200 | FE | 10.10.10.241 | NP-Lab | Scanner connection |
| 7 | P7 - LAG-to-R2 (7/8) | NP-SW-ACC-R2 | GbE | 192.168.10.245 | NP-Default | LAG member to R2 |
| 8 | Port 8 | NP-SW-ACC-R2 | GbE | 192.168.10.245 | NP-Default | LAG member to R2 |

---

## NP-SW-CORE-R1 Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | P1 - UPLINK-GW | NP-GW-Ultra | GbE | 10.10.10.1 / 192.168.10.1 | NP-Default | Gateway uplink |
| 2 | P2 - CCTV - Server Rack | Server Camera | Auto | - | NP-Lab | Verify device/status |
| 3 | P3 - Windows-PC | NP-MS-MAN-S | Auto | - | NP-Lab | Verify if historical/inactive |
| 4 | UPLINK-PVE-SOUTH-BOND | NP-FR24-S | Auto | - | NP-Lab | Verify label/device |
| 5 | Port 5 | NP-FR24-S | Auto | - | NP-Lab | Verify label/device |
| 6 | P6 - Desk | NP-USW-Flex-2F-Desk | GbE | 192.168.10.2 | NP-Default | Desk switch downlink |
| 7 | P7/8 - LAG-to-R2 (7/8) | NP-SW-ACC-R2 | GbE | 192.168.10.245 | NP-Default | LAG member to R2 |
| 8 | Port 8 | NP-SW-ACC-R2 | GbE | 192.168.10.245 | NP-Default | LAG member to R2 |

---

## NP-USW-Flex-2F-Desk Ports

| Port | Label / Name | Connection | Speed | Connected IP | Native VLAN / Network | Notes |
|---:|---|---|---|---:|---|---|
| 1 | DOWNLINK-RackSwitch | NP-SW-CORE-R1 | GbE | 192.168.10.8 | NP-Default | Uplink to core switch |
| 2 | SDS200 | NP-MS-MAN-S | Auto | - | NP-Lab | Verify if historical/inactive |
| 3 | Port 3 | - | Auto | - | NP-Default | Available |
| 4 | DOWNLINK-U7-2F | NP-U7-2F | GbE | 192.168.10.6 | NP-Default | Access point uplink |
| 5 | DOWNLINK-LAP-Desk | Legion i9 Laptop | Auto | - | NP-Default | Historical/inactive client shown |

---

## Cleanup Tasks

1. Rename ports labeled `Available` when a known device is attached.
2. Verify LAG pairs between CORE-R1, ACC-R2, and ACC-R3.
3. Confirm PBS physical port and active link status.
4. Confirm pve-north and pve physical ports and IP mappings.
5. Confirm whether NP-U7-1F appearing on Flex-1F-LOG Port 5 is historical or an actual connection issue.
6. Replace unknown MAC-only entries with friendly device names after identifying them.
7. Export a fresh UniFi port map after cleanup and update this file.
