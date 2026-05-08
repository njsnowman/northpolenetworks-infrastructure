# UniFi Port Forward Review - North Pole Networks

## Purpose

This document tracks public/external service exposure that should be reviewed and hardened.

Last reviewed from UniFi screenshots: 2026-05-08.

> This document intentionally avoids storing sensitive public WAN details. Use placeholders and keep secrets in a vault.

---

## Port Forward / Public Exposure Inventory

| Rule Name | Observed Type | Destination / Service | Risk Level | Recommendation |
|---|---|---|---|---|
| Ubuntu - SSH Port | Port Forwarding / Translate | Ubuntu SSH | High | Restrict to VPN/trusted IPs; avoid public SSH if possible |
| Ubuntu - 443 | Port Forwarding / Translate | Ubuntu HTTPS | Medium | Confirm service, patching, TLS, reverse proxy/WAF posture |
| Ubuntu - 80 | Port Forwarding / Translate | Ubuntu HTTP | Medium | Redirect to HTTPS if public; confirm required |
| Linkwarden - Umbrel | Port Forwarding / Translate | Linkwarden / Umbrel | Medium | Prefer Cloudflare Access, VPN, or SSO protection |
| vm-utils SSH | Port Forwarding / Translate | vm-utils SSH | High | Move to VPN-only or trusted-source only |
| vm-nginx-p 80 | Port Forwarding / Translate | NGINX HTTP | Medium | Public web reverse proxy; redirect to HTTPS |
| vm-nginx-p 443 | Port Forwarding / Translate | NGINX HTTPS | Medium | Public web reverse proxy; ensure TLS and upstream isolation |
| ha-8123 | Port Forwarding / Translate | Home Assistant | High | Strongly prefer Cloudflare Access, VPN, or strict source limits |
| SDS200-5000 | Port Forwarding / Translate | SDS200 / ProScan | High | Restrict if not intentionally public |
| SDS200-5001 | Port Forwarding / Translate | SDS200 / ProScan | High | Restrict if not intentionally public |
| Synology-SFTP | Port Forwarding / Translate | Synology SFTP | High | Use VPN or trusted source IPs; public SFTP gets attacked heavily |
| Scanner RTSP | Port Forwarding / Translate | Scanner RTSP | High | RTSP should generally not be exposed publicly |

---

## Required Review Fields

For each port forward, document the following before considering it approved:

| Field | Required? | Notes |
|---|---|---|
| Rule name | Yes | Must match UniFi |
| External port | Yes | Redact only if necessary |
| Internal IP | Yes | Can use internal IP if private repo; redact if desired |
| Internal port | Yes | Required for support |
| Protocol | Yes | TCP, UDP, or both |
| Source restriction | Yes | Any, country, IP group, VPN, Cloudflare, etc. |
| Business/lab reason | Yes | Why it needs to exist |
| Public exposure approved | Yes | Yes/No/Temporary |
| Owner | Yes | Who maintains service |
| Last reviewed | Yes | Date |

---

## Preferred Exposure Model

| Service Type | Preferred Exposure Method |
|---|---|
| SSH | VPN/Tailscale/WireGuard only; no public SSH unless emergency-only and restricted |
| SFTP | VPN or fixed trusted source IPs |
| Home Assistant | VPN, Cloudflare Access, or Nabu Casa; avoid raw public 8123 where possible |
| NGINX web services | Public 443 acceptable if hardened and proxied properly |
| HTTP 80 | Public only for redirect/acme challenge; redirect to HTTPS |
| RTSP | VPN-only |
| ProScan / SDS200 | VPN-only or strict source IP allowlist |
| Admin dashboards | VPN/SSO/Cloudflare Access only |

---

## Review Checklist

- [ ] Confirm which port forwards are still needed.
- [ ] Disable stale port forwards.
- [ ] Replace public SSH/SFTP with VPN-only access where possible.
- [ ] Confirm all public web apps have current patching.
- [ ] Confirm NGINX terminates TLS correctly.
- [ ] Confirm Cloudflare proxy/access rules where used.
- [ ] Confirm Home Assistant exposure method.
- [ ] Confirm scanner/RTSP services are not publicly exposed unless intentionally required.
- [ ] Add source IP restrictions for any rule that cannot be VPN-only.
- [ ] Add descriptions to each UniFi rule.
- [ ] Update this file after every firewall change.

---

## Redaction Standard

Use these placeholders when needed:

```text
WAN_PUBLIC_IP_REDACTED
TRUSTED_ADMIN_IP_REDACTED
CLOUDFLARE_PROTECTED
VPN_ONLY
TAILSCALE_ONLY
INTERNAL_ONLY
TEMPORARY_RULE_REVIEW_REQUIRED
```
