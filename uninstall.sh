#!/bin/bash

# RPM Installer Uninstallation Script

echo "Uninstalling RPM Installer..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo ./uninstall.sh)"
    exit 1
fi

# Remove installation directory
INSTALL_DIR="/opt/rpminstaller"
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "Removed installation directory."
fi

# Remove desktop entry
DESKTOP_FILE="/usr/share/applications/rpminstaller.desktop"
if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
    echo "Removed desktop entry."
fi

echo "Uninstallation complete!"