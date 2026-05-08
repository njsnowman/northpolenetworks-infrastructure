# Proxmox Node Access Plan

## Purpose

This document defines the normal, backup, and emergency access paths for the North Pole Networks Proxmox nodes.

The purpose is to avoid being locked out during networking changes, bridge changes, VFIO/GPU testing, boot issues, or management service failures.

## Proxmox Nodes

| Node | IP Address | Role | Emergency Console |
|---|---:|---|---|
| pve-north | 10.10.10.10 | Primary / advanced Proxmox node | PiKVM-01 |
| pve | 10.10.10.11 | Secondary Proxmox node | PiKVM-02 |

## Access Priority

### 1. Normal Access

Use normal access when the node is healthy.

- Proxmox Web UI
- SSH
- LAN access
- Tailscale / VPN access

### 2. Backup Access

Use backup access when normal routes are partially degraded.

- Direct LAN connection
- Alternate management workstation
- Tailscale/WireGuard path
- NGINX or internal jump host if applicable

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

- Do not rely on only one management path.
- Before changing NICs, bridges, bonds, or VFIO settings, verify PiKVM access first.
- Before rebooting a remote node after a network change, verify the emergency console is reachable.
- Keep a backup of `/etc/network/interfaces` before making network changes.
- Label all PiKVM, HDMI, USB, ATX, Ethernet, and LTE connections.

## Pre-Change Checklist

Before making a risky Proxmox change:

- [ ] Confirm the correct PiKVM is online
- [ ] Confirm video is visible through PiKVM
- [ ] Confirm keyboard input works through PiKVM
- [ ] Confirm the PiKVM has a backup access path
- [ ] Backup `/etc/network/interfaces`
- [ ] Document the current working IP and bridge configuration
- [ ] Confirm which physical NIC is being changed

## Suggested Interface Backup Command

```bash
cp /etc/network/interfaces /etc/network/interfaces.bak.$(date +%F-%H%M%S)
```

## Recovery Principle

When a node cannot be reached over the network, stop troubleshooting from the network side and switch to PiKVM.

PiKVM provides the console view needed to determine whether the issue is power, boot, operating system, storage, network, or Proxmox service related.
