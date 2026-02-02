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

# Try to install system PyQt5 package, with fallback to pip
install_pyqt5() {
    if [ -x /usr/bin/zypper ] || command -v zypper &> /dev/null; then
        echo "Using zypper for installation..."
        zypper install -y python3-qt5 python3-pip || {
            echo "Failed to install python3-qt5, trying alternative..."
            zypper install -y python311-qt5 python3-pip || pip3 install PyQt5
        }
    elif [ -x /usr/bin/dnf ] || command -v dnf &> /dev/null; then
        echo "Using dnf for installation..."
        dnf install -y python3-pyqt5 python3-pip || {
            echo "Failed to install python3-pyqt5, trying with pip..."
            dnf install -y python3-pip
            pip3 install PyQt5
        }
    elif [ -x /usr/bin/apt ] || command -v apt &> /dev/null; then
        echo "Using apt for installation..."
        apt update && apt install -y python3-pyqt5 python3-pip || {
            echo "Failed to install python3-pyqt5, trying with pip..."
            apt install -y python3-pip
            pip3 install PyQt5
        }
    else
        echo "No supported package manager found. Attempting pip install..."
        if ! command -v pip3 &> /dev/null; then
            echo "pip3 not found. Please install PyQt5 manually."
            return 1
        fi
        pip3 install PyQt5
    fi
}

install_pyqt5 || {
    echo "Failed to install system dependencies"
    exit 1
}

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