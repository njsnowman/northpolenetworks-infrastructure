# North Pole Networks Weather Operations Center

## Overview
Custom operations dashboard hosted on `ct-weather` (`10.10.10.78`) for Batesville, Indiana.

This dashboard has evolved from a simple weather page into the **North Pole Networks Operations Intelligence Center**, combining weather, aviation, ADS-B, radar, infrastructure status, and operations telemetry.

## Production URL
- Public: `https://weather.northpolenetworks.com`
- LAN: `http://10.10.10.78/`

## Host Details
- Container/Host: `ct-weather`
- IP: `10.10.10.78`
- Web root: `/var/www/weather`
- API path: `/var/www/weather/api`
- Web server: NGINX
- PHP runtime: PHP-FPM

## Current Dashboard Features
- Live Weather.gov/NWS conditions for Batesville, Indiana
- Active NOAA alerts
- 7-period Batesville forecast
- Aviation weather cards using METAR/TAF data
- ADS-B Intelligence from `vm-adsb` / Tar1090
- Sun/Moon phase data
- Sunrise and sunset
- Live radar display
- Infrastructure live status bar
- Operations activity feed

## Coordinates
- Latitude: `39.2970`
- Longitude: `-85.2202`
- Approx elevation: `971 ft AMSL`
- Coverage area: Batesville / Southeast Indiana / Ohio Valley

## APIs

### `/api/adsb.php`
Pulls live aircraft and dump1090/Tar1090 statistics from:
- `http://10.10.10.108/tar1090/data/aircraft.json`
- `http://10.10.10.108/tar1090/data/stats.json`

Metrics exposed:
- Total aircraft
- Aircraft with position
- Highest altitude
- Fastest aircraft
- Strongest RSSI
- Messages per minute
- Signal/noise
- Tracks in 15 minutes

### `/api/metar.php`
Pulls raw aviation weather for:
- `KCVG`
- `KIND`
- `KLUK`
- `KBMG`

Used by the dashboard to build aviation condition cards.

### `/api/status.php`
Checks core infrastructure services:
- ADS-B VM: `10.10.10.108:80`
- Weather VM: `10.10.10.78:80`
- MQTT: `10.10.10.215:1883`
- Meshtastic Web: `10.10.10.147:8080`
- iNTERCEPT: `10.10.10.132:5050`
- Node-RED: `10.10.10.91:1880`

### `/api/activity.php`
Generates a lightweight recent activity feed using current ADS-B and weather API data.

### `/api/sunmoon.php`
Provides moon phase, moon illumination, sunrise, sunset, and solar data for the Batesville site.

## Important Design Notes
- The browser should fetch local `/api/*.php` endpoints whenever possible.
- Avoid browser-side cross-origin calls directly to AviationWeather or ADS-B hosts.
- ADS-B JavaScript should use safe `setText()` logic because some legacy element IDs may not exist after layout changes.
- Do not add a full-page meta refresh unless tested; the dashboard already refreshes sections independently.

## Known Status Notes
- Meshtastic may show offline if `10.10.10.147:8080` is down or if its IP changed.
- Node-RED may show offline if the LXC loses its IP or the service is not listening on `1880`.
- Node-RED recently showed `eth0` down and had to be brought back online.

## Recovery Commands

### Test APIs
```bash
curl -s http://127.0.0.1/api/adsb.php | jq
curl -s http://127.0.0.1/api/metar.php
curl -s http://127.0.0.1/api/status.php | jq
curl -s http://127.0.0.1/api/sunmoon.php | jq
```

### Test NGINX
```bash
nginx -t && systemctl reload nginx
```

### Backup current dashboard
```bash
mkdir -p /opt/weather/backups
cp /var/www/weather/index.html /opt/weather/backups/index.html-working-$(date +%F-%H%M)
cp -r /var/www/weather/api /opt/weather/backups/api-working-$(date +%F-%H%M)
```

## Current Stable Build
Current stable build includes:
- Weather.gov data
- Aviation METAR/TAF cards
- ADS-B intelligence
- Live radar
- Sun/Moon section
- Infrastructure live status
- Recent activity feed

Last documented update: 2026-06-12.