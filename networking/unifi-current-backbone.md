# UniFi Current Backbone - North Pole Networks

## Purpose

This document tracks the current UniFi backbone for the North Pole Networks home lab / home production network. It is based on the current UniFi controller screenshots reviewed on 2026-05-08.

This file is intended to be the operational source of truth for:

- Gateway and core switching layout
- VLAN and subnet assignments
- Access switch uplinks
- Wireless access points and SSID design
- Known security controls
- Follow-up cleanup items

> Security note: Do not commit passwords, VPN keys, API tokens, SIM account details, customer credentials, or full sensitive WAN exposure details to GitHub. Use placeholders where needed.

---

## Gateway

| Device | Role | Management / Gateway IP | Notes |
|---|---|---:|---|
| NP-GW-Ultra | UniFi Cloud Gateway Ultra / primary router | 192.168.10.1 | Primary gateway, DHCP, routing, firewall, NAT, VLAN gateway services |

---

## Adopted UniFi Devices

| Device | Type | IP Address | Uplink | Parent / Upstream | Observed Connected Clients |
|---|---|---:|---|---|---:|
| NP-GW-Ultra | Gateway | 192.168.10.1 | GbE | WAN / Frontier Communications | 3 |
| NP-Flex-1F-LOG | Flex switch | 192.168.10.221 | GbE | NP-GW-Ultra Port 4 | 0 |
| NP-Flex-1F-LIV | Flex switch | 192.168.10.206 | GbE | NP-GW-Ultra Port 2 | 1 |
| NP-USW-Flex-2F-Desk | Desk switch | 192.168.10.2 | GbE | NP-SW-CORE-R1 Port 6 | 0 |
| NP-SW-ACC-R2 | Access switch | 192.168.10.245 | 2 GbE | NP-SW-CORE-R1 Port 7 | 1 |
| NP-SW-ACC-R3 | Access switch | 192.168.10.164 | 2 GbE | NP-SW-ACC-R2 Port 7 | 14 |
| NP-SW-CORE-R1 | Core switch | 192.168.10.8 | GbE | NP-GW-Ultra Port 3 | 0 |
| NP-U7-1F | Wireless AP | 192.168.10.7 | GbE | NP-Flex-1F-LOG Port 2 | 7 |
| NP-U7-2F | Wireless AP | 192.168.10.6 | GbE | NP-USW-Flex-2F-Desk Port 4 | 12 |

---

## Network / VLAN Plan

| Network Name | VLAN ID | Subnet | Router | DHCP | Current Leases | Available | Purpose |
|---|---:|---:|---|---|---:|---:|---|
| NP-Default | 1 | 192.168.10.0/24 | NP-GW-Ultra | Server | 10 / 249 | 239 | Main/default LAN and trusted client network |
| NP-Lab | 2 | 10.10.10.0/24 | NP-GW-Ultra | Server | 25 / 249 | 222 | Lab/server infrastructure network |
| NP-Home IoT | 3 | 192.168.3.0/24 | NP-GW-Ultra | Server | 21 / 249 | 227 | IoT / smart home devices |
| NP-Logan's World | 4 | 192.168.4.0/24 | NP-GW-Ultra | Server | 3 / 249 | 246 | Logan / child device network |
| Not Default | 5 | 192.168.5.0/24 | NP-GW-Ultra | Server | 13 / 249 | 236 | Secondary / holding / miscellaneous network |
| NorthPole-Lab-WiFi | 6 | 192.168.6.0/24 | NP-GW-Ultra | Server | 0 / 151 | 151 | Lab WiFi network |

---

## WiFi / SSID Plan

| SSID | Network | Broadcasting APs | Bands | Clients | Security |
|---|---|---|---|---:|---|
| N0rthP0le | Native Network | All APs | 2.4 GHz, 5 GHz, 6 GHz | 3 | WPA2/WPA3 |
| TP-Link_IoT_5E58 | NP-Home IoT | All APs | 2.4 GHz, 5 GHz, 6 GHz | 14 | WPA2/WPA3 |
| North Pole Lab | NorthPole-Lab-WiFi | All APs | 2.4 GHz, 5 GHz, 6 GHz | - | WPA2/WPA3 |
| IDK | NP-Logan's World | All APs | 2.4 GHz, 5 GHz, 6 GHz | 2 | WPA2/WPA3 |

---

## Current Radio Snapshot

| AP | Band | Channel | Width | Tx Power | EIRP | Clients | Avg Signal | Notes |
|---|---|---:|---:|---|---|---:|---:|---|
| NP-U7-1F | 2.4 GHz | 11 | 20 MHz | Auto / 23 dBm | 26 dBm | 6 | -51 dBm | Interference observed around 50.5%; monitor/tune |
| NP-U7-1F | 5 GHz | 140 | 80 MHz | Auto / 23 dBm | 28 dBm | 1 | -55 dBm | DFS channel in use |
| NP-U7-2F | 2.4 GHz | 3 | 20 MHz | Auto / 23 dBm | 27 dBm | 9 | -38 dBm | Consider moving to 1/6/11 plan; channel 3 overlaps |
| NP-U7-2F | 5 GHz | 48 | 80 MHz | Auto / 26 dBm | 32 dBm | 2 | -56 dBm | Healthy |
| NP-U7-2F | 6 GHz | 37 | 320 MHz | Auto / 24 dBm | 30 dBm | 1 | -76 dBm | Weak 6 GHz signal; consider 160 MHz if stability issues appear |

### WiFi Global Settings Observed

| Setting | Current Value / State | Notes |
|---|---|---|
| Default WiFi Speeds | Maximum Speed | Performance-focused profile |
| 2.4 GHz Width | 20 MHz | Correct for reliability |
| 5 GHz Width | 80 MHz | Good balance of speed and stability |
| 6 GHz Width | 320 MHz | Maximum speed; monitor stability |
| Extended 5 GHz Spectrum / DFS | Enabled | Provides extra 5 GHz channels |
| 5 GHz Roaming Assistant | Enabled at -75 dBm | Reasonable threshold |
| Wireless Meshing | Enabled | Review whether needed; disable if all APs are wired and no mesh is required |
| Mesh MLO STR | Auto / Labs | Experimental; monitor for client issues |
| UniFi Auto-Link | Enabled | Useful but monitor unexpected topology behavior |
| WiFiman Support | Enabled | Useful for diagnostics |
| Channel AI | Configured | Confirm it does not place 2.4 GHz on overlapping channels |

---

## High-Level Topology

```text
Frontier WAN
    |
NP-GW-Ultra (192.168.10.1)
    |-- Port 2 -> NP-Flex-1F-LIV (192.168.10.206)
    |-- Port 3 -> NP-SW-CORE-R1 (192.168.10.8)
    |              |-- Port 6 -> NP-USW-Flex-2F-Desk (192.168.10.2)
    |              |              |-- Port 4 -> NP-U7-2F (192.168.10.6)
    |              |-- Port 7/8 -> LAG to NP-SW-ACC-R2 (192.168.10.245)
    |                             |-- Port 7/8 -> LAG to NP-SW-ACC-R3 (192.168.10.164)
    |
    |-- Port 4 -> NP-Flex-1F-LOG (192.168.10.221)
                   |-- Port 2 -> NP-U7-1F (192.168.10.7)
```

---

## Security Controls Observed

| Control | Current State | Notes |
|---|---|---|
| Region Blocking | Enabled | Blocking China, Russia, North Korea, Germany, Algeria in both directions |
| Encrypted DNS | Off | Consider enabling Auto or known secure resolver after testing |
| Honeypot | Enabled | Present on NP-Default, NP-Lab, NP-Logan's World, NP-Home IoT, and Not Default |
| Simple App Blocking | Enabled | Logan nighttime block policy exists for 4 devices / 10 apps / weekly schedule |
| Default Security Posture | Allow All | Segmentation depends heavily on explicit firewall rules |
| IGMP Snooping | Enabled | Good for multicast-heavy environments |
| Gateway mDNS Proxy | Auto | Useful for discovery across selected networks, but should be controlled |

---

## Firewall / NAT Summary

The current policy set includes:

- Port forwarding / translate rules for selected internal services
- Masquerade NAT rules
- Inter-VLAN allow rules for required lab/client access
- Block rules for selected external IPs
- Isolated network block rule
- Allow return traffic rule
- mDNS allow rule
- Internal service allow rules for Milestone, ProScan/SDS200, Zabbix, and server access
- Broad allow and block catch-all rules visible near the bottom of the policy table

Detailed firewall tracking is maintained in:

- `firewall/unifi-firewall-policy-summary.md`
- `firewall/port-forward-review.md`

---

## Immediate Cleanup Items

1. Review all external port forwards with source set to `Any`.
2. Move admin access services behind VPN, Tailscale, WireGuard, Cloudflare Access, or fixed trusted source IPs where possible.
3. Change 2.4 GHz AP channel plan to non-overlapping channels only: 1, 6, and 11.
4. Watch NP-U7-1F 2.4 GHz interference and tune channel/power if needed.
5. Watch NP-U7-2F 6 GHz signal and consider 160 MHz width if client stability is poor.
6. Clean up port labels that say `Available` while still showing known clients or device history.
7. Confirm LAG labels and physical wiring for R2/R3/core links.
8. Decide whether Wireless Meshing is required. If all APs are wired, disabling mesh can reduce accidental wireless uplink behavior.
9. Document every exposed service with business/lab reason, port, destination, and desired security posture.
10. Keep GitHub documentation redacted where sensitive WAN IP or service exposure is involved.
