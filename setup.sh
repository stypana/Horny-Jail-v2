#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y wget unzip make ca-certificates

BYOND_VER=516.1659
cd /tmp
wget -q https://www.byond.com/download/build/${BYOND_VER%.*}/${BYOND_VER}_byond_linux.zip -O byond.zip
unzip -q byond.zip
cd byond
sudo make install

# Явно укажем DreamMaker для build.sh (если он читает DM_EXE)
if ! grep -q 'DM_EXE=' ~/.bashrc; then
    echo 'export DM_EXE=/usr/local/byond/bin/DreamMaker' >> ~/.bashrc
fi
export DM_EXE=/usr/local/byond/bin/DreamMaker

echo "BYOND installed. DreamMaker at: $DM_EXE"
DreamMaker -version || true
