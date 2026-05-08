# PiKVM Out-of-Band Access Plan

## Purpose

This document defines the out-of-band management design for the North Pole Networks Proxmox environment using two PiKVM V4 units with LTE cards.

The goal is to maintain emergency access to each Proxmox node even when the operating system, Proxmox web interface, SSH, Tailscale, the management bridge, or the primary LAN path is unavailable.

## Design Summary

Each Proxmox node receives its own dedicated PiKVM V4 with LTE backup access.

This gives the environment a dedicated emergency console path similar to iDRAC/iLO functionality, but for custom Proxmox hardware and lab systems.

## Node Assignments

| Proxmox Node | Management IP | PiKVM Assignment | Purpose |
|---|---:|---|---|
| pve-north | 10.10.10.10 | PiKVM-01 | Primary / advanced Proxmox node emergency console |
| pve | 10.10.10.11 | PiKVM-02 | Secondary Proxmox node emergency console |

## Access Layers

### Primary Access

- Proxmox Web UI
- SSH
- LAN access
- Tailscale / VPN access

### Secondary Access

- PiKVM over LAN
- PiKVM through VPN

### Emergency Access

- PiKVM LTE connection
- PiKVM web console
- PiKVM keyboard/mouse emulation
- PiKVM virtual media
- PiKVM ATX power control, if wired

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

## Recommended Naming

| Device | Assigned Host | Suggested Hostname |
|---|---|---|
| PiKVM-01 | pve-north | pikvm-pve-north |
| PiKVM-02 | pve | pikvm-pve |

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
- Document LTE SIM/carrier information securely
- Label all physical wiring
- Keep PiKVM power on UPS if possible

## Operating Rule

Normal remote tools are for when the operating system is healthy.

PiKVM is for when the operating system, boot process, networking, or remote access stack is broken.
