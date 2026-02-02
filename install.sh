#!/bin/bash

# RPM Installer Installation Script

echo "Installing RPM Installer..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo ./install.sh)"
    exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    echo "Detected distribution: $DISTRO"
else
    echo "Cannot detect distribution"
    exit 1
fi

# Install system dependencies
echo "Installing system dependencies..."

# Install python3 and pip3
if [ -x /usr/bin/zypper ] || command -v zypper &> /dev/null; then
    echo "Using zypper to install python3 and pip..."
    zypper install -y python3 python3-pip
elif [ -x /usr/bin/dnf ] || command -v dnf &> /dev/null; then
    echo "Using dnf to install python3 and pip..."
    dnf install -y python3 python3-pip
elif [ -x /usr/bin/apt ] || command -v apt &> /dev/null; then
    echo "Using apt to install python3 and pip..."
    apt update && apt install -y python3 python3-pip
else
    echo "No supported package manager found."
    exit 1
fi

# Check if python3 is available
if ! command -v python3 &> /dev/null; then
    echo "Failed to install or find python3"
    exit 1
fi

echo "Installing PyQt5 via pip..."
python3 -m pip install PyQt5

if [ $? -ne 0 ]; then
    echo "Failed to install PyQt5"
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

if [ $? -ne 0 ]; then
    echo "Failed to install Python dependencies"
    exit 1
fi

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