# North Pole Networks Topology Diagram

## Purpose

This document points to the current Mermaid topology diagram for the UniFi backbone.

Diagram source:

- `diagrams/north-pole-network-topology.mmd`

---

## Rendered Mermaid Source

```mermaid
flowchart TD
    WAN[Frontier Communications WAN]
    GW[NP-GW-Ultra<br/>Gateway / Router<br/>192.168.10.1]

    WAN --> GW

    GW -- Port 2 / GbE --> LIV[NP-Flex-1F-LIV<br/>192.168.10.206]
    GW -- Port 3 / GbE --> CORE[NP-SW-CORE-R1<br/>192.168.10.8]
    GW -- Port 4 / GbE --> LOG[NP-Flex-1F-LOG<br/>192.168.10.221]

    LIV -- Port 2 / FE --> TV[Living Room Hisense TV<br/>192.168.10.126]
    LOG -- Port 2 / GbE --> U71F[NP-U7-1F AP<br/>192.168.10.7]

    CORE -- Port 6 / GbE --> DESK[NP-USW-Flex-2F-Desk<br/>192.168.10.2]
    CORE -- Ports 7/8 LAG --> ACCR2[NP-SW-ACC-R2<br/>192.168.10.245]

    DESK -- Port 4 / GbE --> U72F[NP-U7-2F AP<br/>192.168.10.6]

    ACCR2 -- Ports 7/8 LAG --> ACCR3[NP-SW-ACC-R3<br/>192.168.10.164]
    ACCR2 -- Port 1 / GbE --> NAS[NP-NAS-NIC1<br/>10.10.10.5]
    ACCR2 -. Ports 3/4 .-> PBS[NP-PBS / Proxmox Backup Server<br/>Verify active port]

    ACCR3 -- Port 1 / GbE --> PVE[PVE South / pve<br/>10.10.10.11]
    ACCR3 -- Port 2 / GbE --> PVENORTH[pve-north / NP-MS-MAN-S<br/>10.10.10.10]
    ACCR3 -- Port 3 / GbE --> LAPTOP[Legion i9 Laptop<br/>192.168.10.127]
    ACCR3 -- Port 6 / FE --> SDS[Uniden SDS200<br/>10.10.10.241]
```

---

## Notes

- This diagram intentionally avoids storing public WAN IP details.
- PBS cabling/status needs verification from the physical rack/switch.
- Some port labels in UniFi still need cleanup.
- Use `networking/switch-port-map.md` as the detailed port source.
