# PiKVM Out-of-Band Access Plan

## Purpose

This document defines the out-of-band management design for the North Pole Networks Proxmox environment using two PiKVM V4 units with LTE-capable backup access.

The goal is to maintain emergency access to each Proxmox node even when the operating system, Proxmox web interface, SSH, Tailscale, the management bridge, or the primary LAN path is unavailable.

## Design Summary

Each Proxmox node receives its own dedicated PiKVM V4 with optional LTE backup access.

This gives the environment a dedicated emergency console path similar to iDRAC/iLO functionality, but for custom Proxmox hardware and lab systems.

## Current Status

- Proxmox nodes have been reconnected to Tailscale after sitting for a couple of months.
- One PiKVM was observed on the LAN at `10.10.10.114`.
- One PiKVM root password may have been typoed during setup and should be recovered/reset locally before final production use.
- Final PiKVM-to-node assignments should be confirmed after both units are labeled and mounted.

## Node Assignments

| Proxmox Node | Management IP | PiKVM Assignment | Known PiKVM LAN IP | Purpose |
|---|---:|---|---:|---|
| pve-north | 10.10.10.10 | PiKVM-01 | TBD | Primary / advanced Proxmox node emergency console |
| pve | 10.10.10.11 | PiKVM-02 | 10.10.10.114 | Secondary Proxmox node emergency console |

## Recommended Naming

| Device | Assigned Host | Suggested Hostname | Notes |
|---|---|---|---|
| PiKVM-01 | pve-north | `pikvm-pve-north` | Primary Proxmox node |
| PiKVM-02 | pve | `pikvm-pve` | Secondary Proxmox node; one unit was seen on `10.10.10.114` |

## Hardware Notes

- PiKVM V4 units are being used for out-of-band console access.
- LTE expansion hardware purchased: `SIMCom SIM7600G-H R2 LTE mPCIe + Antenna Pack`.
- LTE SIM plan/carrier still needs to be documented once activated.
- Each PiKVM should be physically labeled with assigned host, hostname, LAN IP, LTE/SIM details if used, and HDMI/USB/ATX cable destination.

## Access Layers

### Primary Access

- Proxmox Web UI
- SSH
- LAN access
- Tailscale / VPN access

### Secondary Access

- PiKVM over LAN
- PiKVM through Tailscale / VPN

### Emergency Access

- PiKVM LTE connection
- PiKVM web console
- PiKVM keyboard/mouse emulation
- PiKVM virtual media
- PiKVM ATX power control, if wired

## Tailscale Reconnection Notes

The Proxmox nodes were reconnected to Tailscale after likely remaining enrolled but unused for a couple of months.

Verification commands:

```bash
tailscale status
tailscale ip -4
systemctl status tailscaled --no-pager
```

Recommended validation after reconnecting:

```bash
ping <tailscale-ip-of-pve-north>
ping <tailscale-ip-of-pve>
ssh root@<tailscale-ip>
```

Keep Tailscale as a normal remote access path, but do not treat it as a full replacement for PiKVM. PiKVM remains the break-glass path when OS, SSH, bridge, firewall, or boot access is broken.

## Why PiKVM Is Critical

PiKVM should be used when software-based access is not available or cannot be trusted.

Common examples:

- Proxmox web UI is unreachable
- SSH is down
- The wrong NIC is assigned to the management bridge
- Linux bridge configuration is broken
- VFIO or GPU passthrough breaks local video output
- The node is stuck at BIOS, GRUB, initramfs, or maintenance mode
- The node needs rescue ISO boot
- The firewall, switch, VLAN, or local network path is unavailable

## Required Connections Per Node

Each PiKVM should be connected to its assigned Proxmox host using:

- HDMI from Proxmox node to PiKVM HDMI input
- USB from PiKVM to Proxmox node for keyboard and mouse emulation
- ATX power/reset wiring if the host supports it
- Ethernet to the management network
- LTE modem/SIM for backup access
- UPS-backed power where possible

## PiKVM Hostname Change Procedure

Use this after logging into the PiKVM over SSH or local console.

```bash
rw
hostnamectl set-hostname pikvm-pve-north
nano /etc/hosts
ro
reboot
```

For the second unit:

```bash
rw
hostnamectl set-hostname pikvm-pve
nano /etc/hosts
ro
reboot
```

Make sure `/etc/hosts` contains the matching hostname for `127.0.1.1` if present.

## Root Password Recovery Note

If the root password was typoed or lost during setup, recover from local console or PiKVM-supported recovery workflow rather than exposing the device externally.

Recommended recovery path:

1. Use local console or the PiKVM-supported recovery method.
2. Remount filesystem read/write if required.
3. Reset the root password.
4. Confirm SSH/web login.
5. Remount read-only if required by PiKVM OS.
6. Document the credential in the secure password vault, not in GitHub.

Do not store PiKVM passwords, SIM ICCIDs, APN passwords, Tailscale auth keys, or VPN keys in this repository.

## Security Rules

PiKVM should not be exposed directly to the public internet.

Recommended access methods:

1. LAN
2. Tailscale or WireGuard
3. LTE VPN path
4. Direct LTE access only as a last-resort emergency method and only if properly secured

Minimum security requirements:

- Change all default credentials
- Use strong unique passwords
- Enable two-factor authentication if available
- Restrict public exposure
- Keep PiKVM updated
- Document LTE SIM/carrier information securely outside GitHub
- Label all physical wiring
- Keep PiKVM power on UPS if possible

## Operating Rule

Normal remote tools are for when the operating system is healthy.

PiKVM is for when the operating system, boot process, networking, or remote access stack is broken.
