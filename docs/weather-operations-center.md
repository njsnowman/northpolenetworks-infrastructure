# North Pole Networks Weather Operations Center

## Overview
Custom operations dashboard hosted on ct-weather (10.10.10.78) for Batesville, Indiana.

### Features
- Live NOAA weather conditions
- Active NOAA alerts
- 7-day forecast
- Aviation weather (METAR/TAF)
- ADS-B Intelligence from vm-adsb (10.10.10.108)
- Sun/Moon phase data
- Live radar display
- Infrastructure status monitoring
- Operations activity feed

### Infrastructure
- CT: ct-weather
- IP: 10.10.10.78
- Web Root: /var/www/weather
- APIs: /var/www/weather/api

### ADS-B Integration
Source: vm-adsb (10.10.10.108)
Data Source: tar1090 JSON feeds
Metrics:
- Aircraft tracked
- Aircraft with position
- Highest altitude
- Fastest aircraft
- Messages per minute
- Signal/noise ratio
- Tracks per 15 minutes

### Infrastructure Status Monitoring
- ADS-B VM
- Weather VM
- MQTT Broker
- Meshtastic Web
- iNTERCEPT
- Node-RED

### Notes
Current stable build includes weather, aviation, ADS-B, radar, sun/moon data, infrastructure status, and operations telemetry.