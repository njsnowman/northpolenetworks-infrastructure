# UniFi VLAN and IP Plan - North Pole Networks

## Purpose

This document tracks the current VLANs, subnets, gateway roles, DHCP status, and intended use for the North Pole Networks UniFi environment.

Last reviewed from UniFi controller screenshots: 2026-05-08.

---

## VLAN / Subnet Table

| Network Name | VLAN ID | Subnet | Gateway / Router | DHCP Mode | Current IP Leases | Available IPs | Purpose |
|---|---:|---:|---|---|---:|---:|---|
| NP-Default | 1 | 192.168.10.0/24 | NP-GW-Ultra | Server | 10 / 249 | 239 | Main default LAN and trusted household devices |
| NP-Lab | 2 | 10.10.10.0/24 | NP-GW-Ultra | Server | 25 / 249 | 222 | Infrastructure, servers, Proxmox, monitoring, lab workloads |
| NP-Home IoT | 3 | 192.168.3.0/24 | NP-GW-Ultra | Server | 21 / 249 | 227 | IoT and smart-home devices |
| NP-Logan's World | 4 | 192.168.4.0/24 | NP-GW-Ultra | Server | 3 / 249 | 246 | Logan / child devices and policy-controlled access |
| Not Default | 5 | 192.168.5.0/24 | NP-GW-Ultra | Server | 13 / 249 | 236 | Miscellaneous / holding / temporary device network |
| NorthPole-Lab-WiFi | 6 | 192.168.6.0/24 | NP-GW-Ultra | Server | 0 / 151 | 151 | WiFi access into lab-oriented network space |

---

## Existing Lab / Infrastructure IPs Referenced

| IP Address | Known / Observed Role | Notes |
|---:|---|---|
| 10.10.10.1 | NP-GW-Ultra gateway on NP-Lab | Lab VLAN gateway |
| 10.10.10.5 | NP-NAS-NIC1 | NAS uplink observed on NP-SW-ACC-R2 Port 1 |
| 10.10.10.10 | NP-MS-MAN-S / pve-north | Primary Proxmox node / management-side server reference |
| 10.10.10.11 | PVE South / pve | Secondary Proxmox node reference |
| 10.10.10.100 | NGINX / reverse proxy | Public-facing reverse proxy and dashboard host |
| 10.10.10.107 | Observed port-forward destination | Review exact service ownership |
| 10.10.10.108 | ADS-B / dashboard stack | Known ADS-B host from infrastructure inventory |
| 10.10.10.125 | Zabbix / laptop destination | Referenced in firewall policies |
| 10.10.10.154 | ProScan / SDS200-related service | Referenced in firewall policies and monitoring stack |
| 10.10.10.218 | Observed port-forward destination | Review exact service ownership |
| 10.10.10.241 | Uniden-SDS200 | Scanner device |

---

## Design Notes

- `NP-Default` remains the main user/client network.
- `NP-Lab` is the most important technical network and should be treated as the infrastructure/server zone.
- `NP-Home IoT` should remain isolated from lab/server systems unless specific services require access.
- `NP-Logan's World` should remain policy-controlled and isolated from management/server networks.
- `NorthPole-Lab-WiFi` should be reviewed carefully because WiFi access into lab networks can weaken segmentation if not firewalled correctly.
- `Not Default` should be clarified. If it is a temporary or staging network, document the intended device types and allowed access.

---

## Recommended Policy Direction

| Source Network | Destination | Default Desired Direction |
|---|---|---|
| NP-Default | Internet | Allow |
| NP-Default | NP-Lab | Allow only required management/services |
| NP-Lab | Internet | Allow, with logging for exposed servers if needed |
| NP-Lab | NP-Default | Allow only required return/management flows |
| NP-Home IoT | Internet | Allow limited outbound |
| NP-Home IoT | NP-Lab / NP-Default | Block by default except required mDNS/casting/device control |
| NP-Logan's World | Internet | Allow with app/time controls |
| NP-Logan's World | NP-Lab | Block |
| Not Default | Internal Networks | Block unless explicitly required |
| NorthPole-Lab-WiFi | NP-Lab | Allow only if intended; otherwise restrict |

---

## Cleanup / Validation Tasks

1. Confirm every static/reserved IP in UniFi and update this file.
2. Confirm whether `10.10.10.10` and `10.10.10.11` map exactly to `pve-north` and `pve` in the current UniFi client list.
3. Create DHCP reservations for critical infrastructure if not already reserved.
4. Confirm no customer systems or secrets are documented here.
5. Validate firewall rules against the intended source/destination matrix.
