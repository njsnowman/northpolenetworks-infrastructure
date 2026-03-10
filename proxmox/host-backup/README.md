\# Proxmox Host Backup Procedure



\## Overview

This document describes how to back up the Proxmox host configuration for disaster recovery.



Host backups are stored on the VM datastore.



Backup Location

/vmdata/host-backups/



Example backup file:



host-backupspve-etcbackup-2026\_03\_09T23\_51.tar.gz

Backup Script Used



Community script:



https://github.com/community-scripts/ProxmoxVE



Executed with: bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/host-backup.sh)"



Files Backed Up



Important Proxmox configuration directories:



/etc/pve/

/etc/network/

/etc/iscsi/

/etc/systemd/

/etc/hosts

/etc/hostname

/root/



Restore Procedure



Install fresh Proxmox VE



Upload backup archive



Extract:



tar -xvzf host-backup.tar.gz -C /



Reboot server



Important



Backups stored on the host alone are not sufficient for disaster recovery.



Backups should also exist on:



Proxmox Backup Server (PBS)



External NAS



Offsite storage





---



\# 5️⃣ Add a `.gitignore`



Create file:





.gitignore





Add:





\*.tar.gz

\*.qcow2

\*.img

\*.iso

\*.vmdk





This prevents \*\*accidental backup uploads\*\*.



---



\# 6️⃣ Commit the Changes



Go back to \*\*GitHub Desktop\*\*



You’ll see the new files.



Write commit message:





Added Proxmox host backup documentation





Click:





Commit to main





Then click:





Push origin





---



\# 7️⃣ What Your Repo Will Start Becoming



You are building a \*\*real infrastructure runbook\*\*, like what enterprise engineers maintain.



Eventually you’ll have:



northpolenetworks-infrastructure

│

├── proxmox

│ ├── cluster-architecture.md

│ ├── vm-standards.md

│ ├── storage-layout.md

│ ├── backup-strategy.md

│ └── host-backup

│

├── networking

│

├── monitoring

│

└── diagrams





