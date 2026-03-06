\# Milestone NTP Configuration (Windows)



\## Architecture



Management Server → NTP Server  

Recording Servers → NTP Client  



Management Server IP:

192.168.101.108



---



\## Management Server Configuration



w32tm /config /manualpeerlist:"time.cloudflare.com time.google.com 0.pool.ntp.org 1.pool.ntp.org" /syncfromflags:manual /reliable:yes /update



net stop w32time

net start w32time



---



\## Enable Windows NTP Server



reg add HKLM\\SYSTEM\\CurrentControlSet\\Services\\W32Time\\TimeProviders\\NtpServer /v Enabled /t REG\_DWORD /d 1 /f



net stop w32time

net start w32time



---



\## Recording Server Configuration



w32tm /config /manualpeerlist:"192.168.101.108" /syncfromflags:manual /update



net stop w32time

net start w32time



w32tm /resync



---



\## Verification



w32tm /query /source



w32tm /stripchart /computer:192.168.101.108 /samples:5 /dataonly

