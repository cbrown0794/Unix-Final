#!/bin/bash
set -euo pipefail

# 1. Install Docker & LVM2 if not already present
if ! command -v docker &> /dev/null; then
  apt-get update
  apt-get install -y docker.io docker-compose-v2 lvm2 git curl
  systemctl enable --now docker
fi

# 2. Idempotent LVM setup on attached persistent disk
DISK="/dev/disk/by-id/google-rag-lvm-disk"
if [ -b "$DISK" ] && ! vgdisplay vg_rag &> /dev/null; then
  pvcreate "$DISK"
  vgcreate vg_rag "$DISK"
  lvcreate -L 15G -n lv_db vg_rag
  lvcreate -L 30G -n lv_models vg_rag
  mkfs.ext4 -F /dev/vg_rag/lv_db
  mkfs.ext4 -F /dev/vg_rag/lv_models
fi

mkdir -p /data/db /models

if ! grep -q "/data/db" /etc/fstab; then
  echo "/dev/vg_rag/lv_db /data/db ext4 defaults,nofail 0 2" >> /etc/fstab
fi
if ! grep -q "/models" /etc/fstab; then
  echo "/dev/vg_rag/lv_models /models ext4 defaults,nofail 0 2" >> /etc/fstab
fi
mount -a

# 3. Fetch secrets from GCP Secret Manager at boot
mkdir -p /run/rag-secrets
chmod 700 /run/rag-secrets
gcloud secrets versions access latest --secret="rag-db-password" > /run/rag-secrets/db_password
gcloud secrets versions access latest --secret="app-secret-key" > /run/rag-secrets/app_secret_key
chmod 600 /run/rag-secrets/*

# 4. Clone or update repo, generate runtime .env from .env.example, and start containers
REPO_DIR="/opt/unix-final"
if [ ! -d "$REPO_DIR/.git" ]; then
  git clone https://github.com/cbrown0794/Unix-Final.git "$REPO_DIR"
else
  git -C "$REPO_DIR" pull --ff-only || true
fi

if [ -f "$REPO_DIR/.env.example" ] && [ ! -f "$REPO_DIR/.env" ]; then
  cp "$REPO_DIR/.env.example" "$REPO_DIR/.env"
fi

if [ -f "$REPO_DIR/docker-compose.yml" ]; then
  export DB_PASSWORD=$(cat /run/rag-secrets/db_password)
  export APP_SECRET_KEY=$(cat /run/rag-secrets/app_secret_key)
  docker compose -f "$REPO_DIR/docker-compose.yml" up -d
fi
