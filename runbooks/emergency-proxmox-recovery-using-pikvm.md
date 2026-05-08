# Emergency Proxmox Recovery Using PiKVM

## Purpose

Use this runbook when a Proxmox node is powered on but cannot be reached through normal access methods such as SSH, the Proxmox web UI, RDP, Tailscale, or the primary LAN.

## Node to PiKVM Map

| Proxmox Node | Management IP | PiKVM |
|---|---:|---|
| pve-north | 10.10.10.10 | PiKVM-01 |
| pve | 10.10.10.11 | PiKVM-02 |

## Common Failure Scenarios

Use PiKVM when:

- Proxmox web UI on port 8006 is unreachable
- SSH fails
- The node boots but networking is down
- The wrong network card was assigned
- The Linux bridge configuration is broken
- VFIO/GPU passthrough causes no usable local video
- The node is stuck in maintenance mode
- The node is stuck at GRUB or initramfs
- BIOS/UEFI changes are required
- A rescue ISO or installer ISO must be mounted remotely

## Recovery Steps

### 1. Connect to the Correct PiKVM

Access the PiKVM assigned to the affected node.

| Affected Node | Use This PiKVM |
|---|---|
| pve-north | PiKVM-01 |
| pve | PiKVM-02 |

### 2. Verify Video Output

Confirm the PiKVM console shows one of the following:

- BIOS/UEFI screen
- Proxmox boot screen
- GRUB menu
- Linux console
- Maintenance mode
- Login prompt

If no video is visible, check HDMI input, target power state, and PiKVM video settings.

### 3. Check Power State

If the server is off or frozen, use PiKVM ATX control if wired.

Available actions may include:

- Power on
- Graceful reset
- Hard reset
- Hard power off

Only use hard power-off if the system is frozen or unreachable through safer methods.

### 4. Log Into Console

Log in as root or the appropriate recovery account.

### 5. Check Network State

Run:

```bash
ip addr
ip link
ip route
cat /etc/network/interfaces
```

Look for:

- Missing management IP
- Wrong physical NIC name
- Bridge not up
- Missing gateway
- Incorrect bond or bridge membership
- Disabled interface

### 6. Restart Networking

For Proxmox, run:

```bash
ifreload -a
systemctl restart networking
```

If networking does not recover, review `/etc/network/interfaces` before rebooting.

### 7. Restore Known-Good Network Configuration

If a bad bridge, bond, or NIC change caused the issue, restore the last known good interface file.

Example:

```bash
cp /etc/network/interfaces.bak /etc/network/interfaces
ifreload -a
```

If the backup filename is different, locate it first:

```bash
ls -lah /etc/network/interfaces*
```

### 8. Reboot If Required

After verifying the network configuration:

```bash
reboot
```

Watch the full boot process through PiKVM.

### 9. Verify Remote Access

From another machine on the management network, test:

```bash
ping 10.10.10.10
ping 10.10.10.11
ssh root@10.10.10.10
ssh root@10.10.10.11
```

Check the Proxmox web interfaces:

```text
https://10.10.10.10:8006
https://10.10.10.11:8006
```

## Notes

PiKVM is the last-resort access path when software-based remote access is unavailable.

Do not make unnecessary changes from the PiKVM console. Use it to regain stable access, then continue normal administration over SSH or the Proxmox web UI.
