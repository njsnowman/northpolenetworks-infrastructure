#!/usr/bin/env bash
set -euo pipefail

HOSTNAME_SHORT="pve-north"
TIMESTAMP="$(date +%F-%H%M)"
LOCAL_BACKUP_DIR="/vmdata/host-backups"
LOCAL_LOG_DIR="/vmdata/logs"
BACKUP_FILE="${LOCAL_BACKUP_DIR}/${HOSTNAME_SHORT}-host-config-${TIMESTAMP}.tar.gz"

NEXTCLOUD_MOUNT="/mnt/nextcloud"
NEXTCLOUD_URL="https://nextcloud.northpolenetworks.com/remote.php/dav/files/admin/"
NEXTCLOUD_DEST="${NEXTCLOUD_MOUNT}/Infrastructure/Proxmox/${HOSTNAME_SHORT}"

BACKUP_ITEMS=(
  /etc/pve
  /etc/network/interfaces
  /etc/hosts
  /etc/hostname
  /etc/apt
  /etc/ssh
  /root
)

mkdir -p "$LOCAL_BACKUP_DIR" "$LOCAL_LOG_DIR" "$NEXTCLOUD_MOUNT"

LOG_FILE="${LOCAL_LOG_DIR}/${HOSTNAME_SHORT}-host-backup.log"

log() {
  echo "[$(date '+%F %T')] $1" | tee -a "$LOG_FILE"
}

is_mounted() {
  mountpoint -q "$NEXTCLOUD_MOUNT"
}

mount_nextcloud() {
  if is_mounted; then
    log "Nextcloud already mounted at ${NEXTCLOUD_MOUNT}"
    return
  fi

  log "Mounting Nextcloud WebDAV..."
  mount -t davfs "$NEXTCLOUD_URL" "$NEXTCLOUD_MOUNT"
  log "Nextcloud mounted successfully"
}

log "Starting host config backup for ${HOSTNAME_SHORT}"

tar czf "$BACKUP_FILE" "${BACKUP_ITEMS[@]}"
log "Backup created: $BACKUP_FILE"

mount_nextcloud

mkdir -p "$NEXTCLOUD_DEST"
cp "$BACKUP_FILE" "$NEXTCLOUD_DEST/"
log "Backup copied to Nextcloud: $NEXTCLOUD_DEST"

log "Backup job completed successfully"
