# LTE Failover Access

## Purpose

This document defines how LTE-backed PiKVM access should be treated in the North Pole Networks environment.

LTE access exists as a break-glass path when normal LAN, VPN, firewall, switch, or ISP connectivity is unavailable.

## Devices

| Device | Assigned Host | LTE Purpose |
|---|---|---|
| PiKVM-01 | pve-north | Emergency console path for 10.10.10.10 |
| PiKVM-02 | pve | Emergency console path for 10.10.10.11 |

## Access Priority

Use LTE only when preferred access paths are unavailable.

Recommended order:

1. LAN access
2. VPN / Tailscale / WireGuard access
3. PiKVM over LAN
4. PiKVM over LTE VPN path
5. Direct LTE emergency access, only if secured

## LTE Use Cases

Use LTE-backed PiKVM access when:

- Primary internet is down
- Firewall or routing is broken
- Switch/VLAN changes broke management access
- Proxmox networking is misconfigured
- A node is stuck before the OS loads
- Remote reboot or BIOS/UEFI access is required
- A rescue ISO must be mounted remotely

## Security Rules

Do not expose PiKVM directly to the public internet unless there is no safer alternative.

Minimum requirements:

- Strong unique password
- No default credentials
- Two-factor authentication if available
- Restrict access to trusted source IPs if possible
- Prefer LTE VPN or private overlay networking
- Keep PiKVM software updated
- Keep LTE SIM details out of GitHub

## Information to Track Securely

Store the following in a password manager or secure vault, not in this repo:

- LTE carrier
- SIM phone number
- SIM ICCID
- APN settings
- LTE account login
- PiKVM admin credentials
- VPN keys
- Recovery URLs

## Operational Notes

LTE should be treated as an emergency management path, not the normal daily access path.

When LTE is used to recover a node, document the incident afterward:

- Date/time
- Affected node
- Failure type
- PiKVM used
- Recovery actions taken
- Root cause
- Any permanent fix applied
