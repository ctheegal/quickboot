#!/bin/bash
# quickboot-apps-installer.sh
# Helper script to install Quickboot apps and configs from recipe directories.
# Run this script from the root of the cloned quickboot repository.

set -e

echo "====================================================="
echo "       Quickboot Apps & Configuration Installer      "
echo "====================================================="

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (or with sudo)."
  exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "=> Installing Quickboot assets from: $SCRIPT_DIR"
echo ""

# Ensure target directories exist
mkdir -p /etc/udev/rules.d/
mkdir -p /etc/modules.d/
mkdir -p /etc/modprobe.d/
mkdir -p /etc/systemd/system/
mkdir -p /usr/bin/
mkdir -p /usr/share/sounds/

NEED_SYSTEMD_RELOAD=0
NEED_UDEV_RELOAD=0
EARLY_SERVICES=()

# Iterate over all quickboot-* components
for COMPONENT_DIR in "$SCRIPT_DIR"/quickboot-*/files; do
    if [ -d "$COMPONENT_DIR" ]; then
        echo "-----------------------------------------------------"
        echo "Processing: $(basename $(dirname "$COMPONENT_DIR"))"
        echo "-----------------------------------------------------"
        
        # 1. Install Udev Rules (*.rules)
        if ls "$COMPONENT_DIR"/*.rules 1> /dev/null 2>&1; then
            cp -v "$COMPONENT_DIR"/*.rules /etc/udev/rules.d/
            NEED_UDEV_RELOAD=1
        fi
        
        # 2. Install Module Configs (*.conf)
        if ls "$COMPONENT_DIR"/*.conf 1> /dev/null 2>&1; then
            for conf_file in "$COMPONENT_DIR"/*.conf; do
                if [[ $(basename "$conf_file") == *"-modules.conf" ]]; then
                    cp -v "$conf_file" /etc/modules.d/
                else
                    cp -v "$conf_file" /etc/modprobe.d/
                fi
            done
        fi
        
        # 3. Install Systemd Services (*.service)
        if ls "$COMPONENT_DIR"/*.service 1> /dev/null 2>&1; then
            cp -v "$COMPONENT_DIR"/*.service /etc/systemd/system/
            
            # Keep track of early_* services to enable them later
            for svc in "$COMPONENT_DIR"/early_*.service; do
                if [ -f "$svc" ]; then
                    EARLY_SERVICES+=("$(basename "$svc")")
                fi
            done
            
            NEED_SYSTEMD_RELOAD=1
        fi

        # 4. Install Systemd Sockets (*.socket)
        if ls "$COMPONENT_DIR"/*.socket 1> /dev/null 2>&1; then
            cp -v "$COMPONENT_DIR"/*.socket /etc/systemd/system/
            NEED_SYSTEMD_RELOAD=1
        fi
        
        # 5. Install Shell Scripts (*.sh)
        if ls "$COMPONENT_DIR"/*.sh 1> /dev/null 2>&1; then
            cp -v "$COMPONENT_DIR"/*.sh /usr/bin/
            chmod +x /usr/bin/*.sh
        fi
        
        # 6. Install Audio Samples (*.wav)
        if ls "$COMPONENT_DIR"/*.wav 1> /dev/null 2>&1; then
            cp -v "$COMPONENT_DIR"/*.wav /usr/share/sounds/
        fi
        
        echo ""
    fi
done

# ---------------------------------------------------------
# Apply System Re-loads
# ---------------------------------------------------------
echo "====================================================="
if [ "$NEED_SYSTEMD_RELOAD" -eq 1 ]; then
    echo "=> Reloading systemd daemon..."
    systemctl daemon-reload
fi

if [ ${#EARLY_SERVICES[@]} -gt 0 ]; then
    echo "=> Enabling early boot services..."
    for svc in "${EARLY_SERVICES[@]}"; do
        echo "   systemctl enable $svc"
        systemctl enable "$svc"
    done
fi

if [ "$NEED_UDEV_RELOAD" -eq 1 ]; then
    echo "=> Reloading udev rules..."
    udevadm control --reload-rules
    udevadm trigger
fi

sync
sleep 3

echo "====================================================="
echo "=> Installation Complete!"
echo "   All configs, scripts, and services have been deployed."
echo "   Note: Ensure the paths inside your .service and .sh files "
echo "   match the installed paths (/usr/bin/ for scripts,"
echo "   /usr/share/sounds/ for wav files)."
echo "====================================================="
