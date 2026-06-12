# Weekly Operations Summary

**Window:** 2026-06-06 through 2026-06-12  
**Environment:** North Pole Networks Homelab / Operations Stack

## Executive Summary
Over the past week, the North Pole Networks environment expanded from individual ADS-B, RF, ProScan, MQTT, Meshtastic, Node-RED, and reverse-proxy services into a more unified operations platform.

Major work completed:
- Built and published the Weather Operations Center at `weather.northpolenetworks.com`.
- Integrated live ADS-B intelligence from `vm-adsb` / Tar1090.
- Added local APIs for weather, aviation, ADS-B, infrastructure status, activity feed, and sun/moon data.
- Stabilized ProScan / scanner web access and audio stream behavior.
- Continued iNTERCEPT, ADS-B, RF, and Meshtastic/MQTT integrations.
- Refined NGINX reverse proxy routing and public service access.
- Identified Node-RED network loss condition and restored/checkpointed the correct IP.

## Core Hosts and Services

### Proxmox / Core Hosts
- `pve-north`: primary Proxmox node.
- `vm-nginxp`: public NGINX reverse proxy host.
- `ct-weather`: Weather Operations Center host.
- `vm-adsb`: ADS-B and aviation feed host.
- `ct-mqtt`: MQTT broker host.
- `ct-nodered`: Node-RED host.
- `ct-meshtastic`: Meshtastic web host.
- `ct-intercept` / iNTERCEPT host: RF operations service.

## Weather Operations Center

### Host
- CT: `ct-weather`
- IP: `10.10.10.78`
- Public URL: `https://weather.northpolenetworks.com`
- Web root: `/var/www/weather`
- API path: `/var/www/weather/api`

### Features Added
- Custom North Pole Networks dashboard styling.
- Current conditions for Batesville, Indiana.
- 7-period forecast.
- NOAA alerts.
- Live radar embed.
- Aviation METAR/TAF cards.
- ADS-B intelligence panel.
- Sun/Moon conditions panel.
- Infrastructure live status row.
- Recent operations activity feed.

### APIs Added
- `/api/adsb.php`
- `/api/metar.php`
- `/api/status.php`
- `/api/activity.php`
- `/api/sunmoon.php`

### ADS-B Metrics Exposed
From `10.10.10.108/tar1090`:
- Total aircraft
- Aircraft with position
- Highest altitude
- Fastest aircraft
- Messages per minute
- Signal/noise
- Tracks per 15 minutes

Example stable readings observed during build:
- Aircraft tracked: ~60-70
- Aircraft with position: ~38-44
- Highest aircraft: ~41,000-45,450 ft
- Fastest aircraft: ~490+ kt
- Messages/minute: ~11,000-12,000+

### Notes
- Avoid full-page meta-refresh; section-level JavaScript refresh is safer.
- ADS-B JavaScript should safely check for missing element IDs before writing values.
- Cloudflare/NGINX caching can make dashboard updates appear stale; hard refresh or purge cache when needed.

## ADS-B / vm-adsb

### Host
- VM: `vm-adsb`
- IP: `10.10.10.108`

### Relevant URLs
- Tar1090: `http://10.10.10.108/tar1090/`
- SkyAware: `http://10.10.10.108/skyaware/`
- Aircraft JSON: `http://10.10.10.108/tar1090/data/aircraft.json`
- Stats JSON: `http://10.10.10.108/tar1090/data/stats.json`

### Validation Commands
```bash
curl -s http://10.10.10.108/tar1090/data/aircraft.json | jq '.aircraft | length'
curl -s http://10.10.10.108/tar1090/data/aircraft.json | jq '[.aircraft[] | select(.lat != null)] | length'
curl -s http://10.10.10.108/tar1090/data/stats.json | head
```

## Aviation Weather

### Source
- AviationWeather.gov API via local PHP proxy.

### Airports Used
- `KCVG`
- `KIND`
- `KLUK`
- `KBMG`

### Dashboard Behavior
Raw METAR/TAF data is proxied through `/api/metar.php` and rendered into visual airport cards.

## Infrastructure Status

### Status API
`/api/status.php` checks TCP connectivity to core services.

Current monitored services:
- ADS-B VM: `10.10.10.108:80`
- Weather VM: `10.10.10.78:80`
- MQTT: `10.10.10.215:1883`
- Meshtastic Web: `10.10.10.147:8080`
- iNTERCEPT: `10.10.10.132:5050`
- Node-RED: `10.10.10.91:1880`

### Node-RED Incident
Observed `ct-nodered` with `eth0` down and no IPv4 address.  
Correct IP confirmed later as:
- `10.10.10.91`

Recovery commands used/expected:
```bash
ip link set eth0 up
dhclient -v eth0
ip a
systemctl restart nodered
ss -tlnp | grep 1880
```

## ProScan / Scanner / Radio Web Work

### Public Service
- ProScan public site: `https://proscan.northpolenetworks.com/`

### Work Performed
- Troubleshot radio display issues.
- Rebooted radio/service when display stopped rendering correctly.
- Locked down scanner/ProScan access.
- Added/managed users as required.
- Continued reverse proxy and authentication tuning.

### Notes
Do not commit passwords or credential values to GitHub.

## iNTERCEPT / RF Operations

### Current Role
RF and signal intelligence service integrated into the broader North Pole Networks operations ecosystem.

### Known Connections
- iNTERCEPT public endpoint: `https://intercept.northpolenetworks.com/`
- Internal host referenced in status monitoring: `10.10.10.132:5050`
- ADS-B source integration from `10.10.10.108`

### Capabilities Discussed/Used
- ADS-B visibility
- Wireless scan
- Bluetooth scan
- Receiver/audio stream testing
- GPS integration considerations

## Meshtastic / MeshCore / MQTT / Node-RED

### MQTT
- Broker: `10.10.10.215:1883`
- MQTT root/topic work around Meshtastic messages continued.

### Meshtastic
- Web host monitored as `10.10.10.147:8080`.
- May show offline if service is down or IP changes.

### Node-RED
- Expected host: `10.10.10.91:1880`
- Used for MQTT flow/dashboard concepts.
- Network loss was observed and should be watched.

## NGINX / Reverse Proxy

### Public Services Involved
- `weather.northpolenetworks.com`
- `intercept.northpolenetworks.com`
- `proscan.northpolenetworks.com`
- Status/watchtower dashboards

### Lessons Learned
- Run dashboard-local edits on `ct-weather`, not `vm-nginxp`.
- Public reverse proxy errors on `vm-nginxp` may involve unrelated TLS/certificate files.
- Test local service first, then proxy path.

### Useful Tests
```bash
curl -I http://10.10.10.78/
curl -s http://10.10.10.78/api/adsb.php | jq
curl -I https://weather.northpolenetworks.com
nginx -t && systemctl reload nginx
```

## Recovery / Backup Recommendations

### Weather Dashboard Backup
```bash
mkdir -p /opt/weather/backups
cp /var/www/weather/index.html /opt/weather/backups/index.html-working-$(date +%F-%H%M)
cp -r /var/www/weather/api /opt/weather/backups/api-working-$(date +%F-%H%M)
```

### Local Git on ct-weather
```bash
cd /var/www/weather
git init
git add .
git commit -m "Weather Operations Center stable build"
```

## Open Items
- Add Meshtastic/MQTT live activity panel.
- Add aircraft map or interactive operations map.
- Add sky camera section.
- Validate Node-RED service persistence.
- Validate Meshtastic web host availability.
- Add recovery runbook for weather dashboard.
- Consider committing live dashboard source files once sanitized.
