# Proxmox Backup Server Current State

Last updated: 2026-05-10

## Purpose

This document records the current Proxmox Backup Server design and recovery state for the NorthPoleNetworks lab environment.

## Current PBS Server

| System | Role | Management IP | Web UI | Notes |
|---|---|---:|---|---|
| `pbs` | Proxmox Backup Server | `10.10.10.12` | `https://10.10.10.12:8007` | Dedicated backup target for Proxmox nodes |

## Current Proxmox Nodes

| Node | Management IP | Notes |
|---|---:|---|
| `pve-north` | `10.10.10.10` | Primary Proxmox node / lab workloads |
| `pve` | `10.10.10.11` | Secondary Proxmox node / lab workloads |
| `pbs` | `10.10.10.12` | Proxmox Backup Server |

## Network Design

Current PBS management network:

```text
PBS interface: enp1s0
PBS address:   10.10.10.12/24
Gateway:       10.10.10.1
PBS GUI:       https://10.10.10.12:8007
SSH:           root@10.10.10.12
```

Current `/etc/network/interfaces` reference:

```ini
auto lo
iface lo inet loopback

auto enp1s0
iface enp1s0 inet static
        address 10.10.10.12/24
        gateway 10.10.10.1

iface enp2s0 inet manual

iface wlp3s0 inet manual

source /etc/network/interfaces.d/*
```

## Current Issue Found

After display/kiosk adjustments for the 7-inch local screen, PBS booted locally but network access was unavailable from the LAN.

Symptoms observed:

- PBS web UI unreachable at `https://10.10.10.12:8007`
- PBS could not be pinged from the LAN
- Local console was still usable
- `proxmox-backup.service` was active and running
- Port `8007` was listening locally
- `enp1s0` was present but did not automatically receive/apply the expected IPv4 address at boot
- Manual IP assignment restored network access immediately

## Temporary/Persistent Recovery Fix Applied

A small systemd oneshot service was added to force the PBS management interface online during boot.

Script path:

```text
/usr/local/sbin/pbs-network-fix.sh
```

Script contents:

```bash
#!/bin/bash
ip link set enp1s0 up
ip addr flush dev enp1s0
ip addr add 10.10.10.12/24 dev enp1s0
ip route replace default via 10.10.10.1 dev enp1s0
```

Systemd service path:

```text
/etc/systemd/system/pbs-network-fix.service
```

Service contents:

```ini
[Unit]
Description=Force PBS Management Network Online
After=network-pre.target
Before=network-online.target proxmox-backup.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/pbs-network-fix.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Enable/start commands used:

```bash
systemctl daemon-reload
systemctl enable pbs-network-fix.service
systemctl start pbs-network-fix.service
```

Validation commands:

```bash
ip -br addr
ip route
ping -c 4 10.10.10.1
systemctl status proxmox-backup --no-pager
ss -tulpn | grep 8007
```

Expected good output includes:

```text
enp1s0 UP 10.10.10.12/24
default via 10.10.10.1 dev enp1s0
LISTEN *:8007
```

## 7-Inch Local Display Notes

The 7-inch screen is currently useful as a local recovery console for PBS. It can be used when SSH or the PBS web UI is unavailable.

Recommended uses:

- Local boot diagnostics
- PBS emergency recovery console
- Network recovery when the node is not reachable
- Backup server status screen

Console font was enlarged for readability on the small display.

Useful font command:

```bash
dpkg-reconfigure console-setup
setupcon
```

Recommended font family/size:

```text
Terminus / large console size such as 16x32 or larger
```

## Future Cleanup

The systemd network-fix service is intentionally simple and operationally useful, but the underlying `ifupdown2`/networking issue should still be investigated later.

Items to check later:

```bash
journalctl -u networking -b --no-pager -l
systemctl status networking --no-pager
ifreload -a
ifquery enp1s0
apt policy ifupdown2 python3-debian python3-configparser
```

Do not remove `pbs-network-fix.service` until PBS reliably brings `enp1s0` online after reboot without it.

## 10Gb Networking Status

10Gb networking was discussed as a future improvement for PBS and Proxmox backup throughput, but it is currently deferred.

Preferred future design:

- Keep `10.10.10.0/24` for management
- Add a dedicated 10Gb backup/storage network later
- Use no gateway on the 10Gb backup network
- Point Proxmox PBS storage traffic to the PBS 10Gb IP when implemented

Possible future 10Gb addressing:

| System | Future 10Gb Backup IP |
|---|---:|
| `pve-north` | `10.10.20.10` |
| `pve` | `10.10.20.11` |
| `pbs` | `10.10.20.12` |

Recommended future hardware direction:

- 10Gb SFP+ switch
- Intel X520-DA2 or similar Linux-friendly SFP+ NICs
- SFP+ DAC cables for short rack/server runs

Status: deferred / not currently implemented.
