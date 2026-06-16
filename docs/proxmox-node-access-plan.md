# Proxmox Node Access Plan

_Last updated: 2026-06-16_

## Purpose

This document defines the normal, backup, and emergency access paths for the North Pole Networks Proxmox environment.

The current active Proxmox node is `pve-north`. The previous secondary node entry remains documented as legacy/deferred until it is brought back online and re-audited.

## Proxmox Nodes

| Node | IP Address | Current State | Role | Emergency Console |
|---|---:|---|---|---|
| pve-north | 10.10.10.10 | Active | Primary Proxmox node | PiKVM-01 |
| pve | 10.10.10.11 | Legacy/deferred | Secondary Proxmox node | PiKVM-02 |

## Active Access Paths

### pve-north

| Access Method | Address / Method | Use Case |
|---|---|---|
| Proxmox Web UI | `https://10.10.10.10:8006` | Normal management |
| SSH | `root@10.10.10.10` | CLI management and recovery |
| PiKVM-01 | Console path | Emergency console / remote hands |

## Network Baseline

| Item | Current Value |
|---|---|
| Host | pve-north |
| Management bridge | vmbr0 |
| Management IP | 10.10.10.10/24 |
| Gateway | 10.10.10.1 |
| Primary physical NIC | enp2s0 |
| Secondary VM bridge | vmbr1, VLAN-aware, currently not primary |
| Backup/lab bridge | vmbr2, VLAN-aware, currently not primary |

## Access Priority

### 1. Normal Access

Use normal access when the active node is healthy.

- Proxmox Web UI
- SSH
- LAN access
- Tailscale / VPN access where available

### 2. Backup Access

Use backup access when normal routes are partially degraded.

- Direct LAN connection
- Alternate management workstation
- VPN path if available
- Internal jump host if applicable

### 3. Emergency Access

Use emergency access when the OS, network, or management services are broken.

- PiKVM console
- PiKVM LTE path
- PiKVM virtual media
- PiKVM ATX power/reset control

## Access Matrix

| Situation | Preferred Access Method |
|---|---|
| Proxmox GUI works | Web UI |
| Web UI fails but SSH works | SSH |
| SSH and Web UI fail but node is powered on | PiKVM |
| Network bridge is broken | PiKVM |
| Node is stuck before boot | PiKVM |
| Node needs BIOS/UEFI changes | PiKVM |
| Node needs rescue ISO | PiKVM virtual media |
| Node is frozen | PiKVM ATX reset/power control |

## Operating Guidelines

- Treat `pve-north` as the current source of truth for live VM/LXC workloads.
- Do not assume `pve` is active until it has been powered on, audited, and documented again.
- Do not rely on only one management path.
- Before changing NICs, bridges, bonds, or VFIO settings, verify PiKVM access first.
- Before rebooting after a network change, verify the emergency console is reachable.
- Keep a backup of `/etc/network/interfaces` before making network changes.
- Label all PiKVM, HDMI, USB, ATX, Ethernet, and LTE connections.

## Pre-Change Checklist

Before making a risky Proxmox change:

- [ ] Confirm PiKVM-01 is online
- [ ] Confirm video is visible through PiKVM
- [ ] Confirm keyboard input works through PiKVM
- [ ] Confirm backup access path is reachable
- [ ] Backup `/etc/network/interfaces`
- [ ] Document the current working IP and bridge configuration
- [ ] Confirm which physical NIC is being changed

## Suggested Interface Backup Command

```bash
cp /etc/network/interfaces /etc/network/interfaces.bak.$(date +%F-%H%M%S)
```

## Recovery Principle

When `pve-north` cannot be reached over the network, stop troubleshooting from the network side and switch to PiKVM.

PiKVM provides the console view needed to determine whether the issue is power, boot, operating system, storage, network, or Proxmox service related.
