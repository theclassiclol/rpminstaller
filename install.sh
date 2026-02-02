#!/bin/bash

# RPM Installer Installation Script

echo "Installing RPM Installer..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo ./install.sh)"
    exit 1
fi

# Install system dependencies
echo "Installing system dependencies..."
if command -v dnf &> /dev/null; then
    dnf install -y python3-pyqt5 python3-pip
elif command -v zypper &> /dev/null; then
    zypper install -y python3-qt5 python3-pip
elif command -v apt &> /dev/null; then
    apt update && apt install -y python3-pyqt5 python3-pip
else
    echo "Unsupported package manager. Please install PyQt5 manually."
    exit 1
fi

# Create installation directory
INSTALL_DIR="/opt/rpminstaller"
mkdir -p "$INSTALL_DIR"

# Copy files
cp main.py requirements.txt "$INSTALL_DIR/"

# Install Python dependencies
cd "$INSTALL_DIR"
pip3 install -r requirements.txt

# Create desktop entry
DESKTOP_FILE="/usr/share/applications/rpminstaller.desktop"
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Name=RPM Installer
Comment=Graphical RPM Package Installer
Exec=python3 /opt/rpminstaller/main.py
Icon=package-x-generic
Terminal=false
Type=Application
Categories=System;PackageManager;
EOF

# Make executable
chmod +x "$DESKTOP_FILE"

echo "Installation complete! You can find RPM Installer in your applications menu."