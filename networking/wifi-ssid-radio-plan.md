# UniFi WiFi SSID and Radio Plan - North Pole Networks

## Purpose

This document tracks the current SSID, WiFi security, access point, and radio/channel configuration for North Pole Networks.

Last reviewed from UniFi screenshots: 2026-05-08.

---

## Access Points

| Access Point | IP Address | Uplink Device | Uplink Port | Notes |
|---|---:|---|---|---|
| NP-U7-1F | 192.168.10.7 | NP-Flex-1F-LOG | Port 2 | First-floor AP |
| NP-U7-2F | 192.168.10.6 | NP-USW-Flex-2F-Desk | Port 4 | Second-floor / desk area AP |

---

## SSID Inventory

| SSID | Backing Network | VLAN / Network ID | Broadcasting APs | Bands | Clients Observed | Security |
|---|---|---:|---|---|---:|---|
| N0rthP0le | Native Network | Native / VLAN 1 | All APs | 2.4 GHz, 5 GHz, 6 GHz | 3 | WPA2/WPA3 |
| TP-Link_IoT_5E58 | NP-Home IoT | VLAN 3 | All APs | 2.4 GHz, 5 GHz, 6 GHz | 14 | WPA2/WPA3 |
| North Pole Lab | NorthPole-Lab-WiFi | VLAN 6 | All APs | 2.4 GHz, 5 GHz, 6 GHz | - | WPA2/WPA3 |
| IDK | NP-Logan's World | VLAN 4 | All APs | 2.4 GHz, 5 GHz, 6 GHz | 2 | WPA2/WPA3 |

---

## Radio Snapshot

| AP | Band | Channel | Width | Tx Power | EIRP | Clients | Avg Signal | Usage / Interference Snapshot | Notes |
|---|---|---:|---:|---|---|---:|---:|---|---|
| NP-U7-1F | 2.4 GHz | 11 | 20 MHz | Auto / 23 dBm | 26 dBm | 6 | -51 dBm | Interference observed around 50.5% | Monitor; high 2.4 GHz interference |
| NP-U7-1F | 5 GHz | 140 | 80 MHz | Auto / 23 dBm | 28 dBm | 1 | -55 dBm | Low usage shown | DFS channel in use |
| NP-U7-2F | 2.4 GHz | 3 | 20 MHz | Auto / 23 dBm | 27 dBm | 9 | -38 dBm | Moderate usage shown | Channel 3 overlaps; move to 1/6/11 plan |
| NP-U7-2F | 5 GHz | 48 | 80 MHz | Auto / 26 dBm | 32 dBm | 2 | -56 dBm | Low usage shown | Healthy |
| NP-U7-2F | 6 GHz | 37 | 320 MHz | Auto / 24 dBm | 30 dBm | 1 | -76 dBm | Low usage shown | Weak signal; monitor stability |

---

## Global WiFi Settings Observed

| Setting | Value / State | Recommendation |
|---|---|---|
| Default WiFi Speeds | Maximum Speed | Good for lab/performance; use Conservative if stability issues appear |
| 2.4 GHz Channel Width | 20 MHz | Keep this setting |
| 5 GHz Channel Width | 80 MHz | Good balance of performance and reliability |
| 6 GHz Channel Width | 320 MHz | High performance; drop to 160 MHz if weak clients or instability appears |
| Extended 5 GHz Spectrum / DFS | Enabled | Good, but monitor DFS events/client compatibility |
| 5 GHz Roaming Assistant | Enabled at -75 dBm | Reasonable setting |
| Wireless Meshing | Enabled | Disable if every AP is hardwired and mesh is not needed |
| Mesh MLO STR | Auto / Labs | Experimental; monitor for weird client behavior |
| Mesh Monitor | Gateway | Acceptable |
| UniFi Auto-Link | Enabled | Useful; monitor topology |
| WiFiman Support | Enabled | Keep enabled for diagnostics |
| Channel AI | Configured | Review decisions manually, especially 2.4 GHz channel 3 |

---

## Recommended Channel Plan

### 2.4 GHz

Use only non-overlapping channels:

| AP | Recommended 2.4 GHz Channel | Width |
|---|---:|---:|
| NP-U7-1F | 11 | 20 MHz |
| NP-U7-2F | 1 or 6 | 20 MHz |

Avoid channels 2, 3, 4, 5, 7, 8, 9, and 10 because they overlap with the standard 1/6/11 plan.

### 5 GHz

Current 80 MHz layout is acceptable. DFS is enabled and one AP is using channel 140.

- Keep 80 MHz for now.
- If clients have DFS issues, move affected APs to non-DFS channels.
- If interference appears, reduce to 40 MHz in high-density areas.

### 6 GHz

Current 320 MHz layout is maximum-performance oriented.

- Keep 320 MHz if stable.
- Move to 160 MHz if signal/client stability becomes inconsistent.
- The observed -76 dBm 6 GHz client should be monitored because 6 GHz attenuates faster through walls/floors.

---

## Cleanup / Improvement Tasks

1. Confirm whether all SSIDs really need all three bands enabled.
2. Move NP-U7-2F 2.4 GHz away from channel 3.
3. Monitor NP-U7-1F 2.4 GHz interference and tune power/channel if needed.
4. Consider disabling Wireless Meshing if both APs are hardwired.
5. Review whether `IDK` should be renamed to a more intentional SSID name.
6. Review whether IoT devices need 5 GHz/6 GHz or should be forced to 2.4 GHz only for compatibility and stability.
7. Confirm WPA2/WPA3 compatibility for older IoT devices.
