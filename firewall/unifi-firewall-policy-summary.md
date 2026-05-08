# UniFi Firewall Policy Summary - North Pole Networks

## Purpose

This document summarizes the current UniFi firewall/security posture based on the controller screenshots reviewed on 2026-05-08.

This is not a complete export of every firewall rule. It is an operational summary and review checklist. Sensitive WAN details should remain redacted.

---

## Security Posture Snapshot

| Area | Observed State | Notes |
|---|---|---|
| Default Security Posture | Allow All | Inter-network segmentation depends on explicit block/allow rules |
| Region Blocking | Enabled | China, Russia, North Korea, Germany, and Algeria blocked in both directions |
| Encrypted DNS | Off | Consider Auto or predefined resolver after testing |
| Honeypot | Enabled | Honeypot addresses configured across multiple networks |
| Simple App Blocking | Enabled | Logan nighttime block policy exists |
| Port Forwarding | Enabled / multiple rules | Requires regular review |
| Masquerade NAT | Present | Used for translated network access |
| mDNS | Allowed / Gateway mDNS Proxy Auto | Useful but should be controlled between VLANs |
| IGMP Snooping | Enabled | Good for multicast handling |

---

## Region Blocking

Current blocked regions observed:

| Region | Direction |
|---|---|
| China | Both directions |
| Russia | Both directions |
| North Korea | Both directions |
| Germany | Both directions |
| Algeria | Both directions |

Notes:

- Region blocking can reduce casual exposure, but it is not a replacement for strong firewall policy.
- Some legitimate cloud services may route through unexpected regions.
- Keep a rollback note if a needed service breaks.

---

## Honeypot Networks

| Network | Subnet | Honeypot Address |
|---|---:|---:|
| NP-Default | 192.168.10.0/24 | 192.168.10.3 |
| NP-Lab | 10.10.10.0/24 | 10.10.10.3 |
| NP-Logan's World | 192.168.4.0/24 | 192.168.4.3 |
| NP-Home IoT | 192.168.3.0/24 | 192.168.3.3 |
| Not Default | 192.168.5.0/24 | 192.168.5.3 |

---

## Observed Rule Categories

| Rule / Category | Policy Type | Action | Notes |
|---|---|---|---|
| Ubuntu - SSH Port | Port Forwarding | Translate | Exposed service; review source restrictions |
| Ubuntu - 443 | Port Forwarding | Translate | Exposed service; likely web/HTTPS |
| Ubuntu - 80 | Port Forwarding | Translate | Exposed service; likely web/HTTP |
| Linkwarden - Umbrel | Port Forwarding | Translate | Review whether public exposure is needed |
| vm-utils SSH | Port Forwarding | Translate | SSH exposure should be restricted or VPN-only |
| vm-nginx-p 80 | Port Forwarding | Translate | Public HTTP reverse proxy/service |
| vm-nginx-p 443 | Port Forwarding | Translate | Public HTTPS reverse proxy/service |
| ha-8123 | Port Forwarding | Translate | Home Assistant; consider Cloudflare Access/VPN if not public-required |
| SDS200-5000 | Port Forwarding | Translate | Scanner/ProScan-related exposure; verify need |
| SDS200-5001 | Port Forwarding | Translate | Scanner/ProScan-related exposure; verify need |
| Synology-SFTP | Port Forwarding | Translate | SFTP exposure should be restricted |
| Scanner RTSP | Port Forwarding | Translate | RTSP exposure should be restricted or VPN-only |
| Translate Network ... | Masquerade NAT | Translate | Existing NAT translation rules |
| Default-to-Lab | Firewall | Allow | Allows NP-Default to NP-Lab; keep scoped as tightly as practical |
| Default-to-Lab Return | Firewall | Allow | Return path rule observed |
| Milestone | Firewall | Allow | Allows Milestone-related internal access |
| Milestone Return | Firewall | Allow | Return rule observed |
| ProScan Server 5001 | Firewall | Allow | Internal/external service rule for scanner stack |
| SDS200 Internal Allow | Firewall | Allow | Allows scanner/internal access |
| Zabbix-Laptop | Firewall | Allow | Monitoring/client access rule |
| Zabbix-Laptop Return | Firewall | Allow | Return path rule observed |
| Allow Neighbor Advertisement | Firewall | Allow | ICMPv6 gateway support |
| Allow Neighbor Solicitation | Firewall | Allow | ICMPv6 gateway support |
| Allow Port Forward ... | Firewall | Allow | Auto/linked allow rules for port forwards |
| Allow Return Traffic | Firewall | Allow | Important for stateful return traffic |
| Allow mDNS | Firewall | Allow | Enables discovery, but should be limited between VLANs |
| Block Invalid Traffic | Firewall | Block | Good hygiene |
| Isolated Networks | Firewall | Block | Used to block internal cross-network access |
| Logan Night Time Block | Firewall | Block | Child device/app/time policy |
| Allow All Traffic | Firewall | Allow | Verify placement and scope |
| Block All Traffic | Firewall | Block | Verify placement and scope |

---

## Review Priority

### Highest Priority

1. Review every port forward where source is `Any`.
2. Move administrative access behind VPN/Tailscale/WireGuard/Cloudflare Access where possible.
3. Restrict SSH/SFTP/RTSP/Home Assistant/scanner services to trusted source IPs or VPN-only access.
4. Confirm rule order so `Block All Traffic` / isolation rules do not break required return traffic and do not get bypassed by broad allow rules.
5. Confirm that `Allow All Traffic` is scoped properly and not unintentionally flattening VLAN segmentation.

### Medium Priority

1. Review `Default-to-Lab` and determine exactly which systems/services need access.
2. Scope mDNS to only networks that need discovery/casting/home automation.
3. Confirm whether Encrypted DNS should be set to Auto or a predefined provider.
4. Confirm region blocking is not affecting legitimate external services.
5. Add descriptions to every firewall rule in UniFi where possible.

### Lower Priority

1. Standardize naming convention for firewall rules.
2. Export rule list periodically and compare against GitHub documentation.
3. Document why each exposed service exists and who/what needs it.

---

## Recommended Rule Naming Standard

```text
[ACTION] [SOURCE] -> [DESTINATION] [SERVICE/PORT] [REASON]
```

Examples:

```text
ALLOW NP-Default -> NP-Lab Milestone Client Access
ALLOW NP-Lab -> NP-Default Zabbix Return
BLOCK IoT -> Lab All Traffic
NAT WAN -> NGINX HTTPS 443
NAT WAN -> HomeAssistant 8123 Review Needed
```

---

## Sensitive Data Handling

Do not commit:

- Passwords
- API tokens
- VPN keys
- Cloudflare tokens
- Tailscale auth keys
- Customer credentials
- SIM/LTE account details
- Full public attack surface details without redaction

Acceptable placeholders:

```text
WAN_PUBLIC_IP_REDACTED
TRUSTED_ADMIN_IP_REDACTED
CLOUDFLARE_PROTECTED
VPN_ONLY
INTERNAL_ONLY
```
