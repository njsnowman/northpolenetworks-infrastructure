\# Proxmox Host Configuration Backups



Each Proxmox node automatically backs up its configuration to Nextcloud.



\## Backup Script

/usr/local/bin/proxmox-host-backup-to-nextcloud.sh



\## Backup Contents



The following host configuration is backed up:



\- /etc/pve

\- /etc/network/interfaces

\- /etc/hostname

\- /etc/hosts

\- /etc/apt

\- /etc/ssh

\- /root



\## Local Storage



Backups are first written locally:



/vmdata/host-backups



\## Remote Storage



Backups are copied to:



Nextcloud → Infrastructure → Proxmox



Nodes:



pve-north  

pve-south



\## Backup Schedule



pve-south → 02:15 daily  

pve-north → 02:45 daily



\## Mount Method



WebDAV via davfs2



Mount location:



/mnt/nextcloud



URL:



https://nextcloud.northpolenetworks.com/remote.php/dav/files/admin/

