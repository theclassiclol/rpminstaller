# RPM Installer

A modern graphical installer for RPM packages on Linux distributions that support RPM.

## Features

- Select RPM files via file dialog
- Install with elevated privileges using pkexec
- Automatic dependency resolution using system package manager
- Modern dark UI with progress indication
- Works on Fedora (dnf), openSUSE (zypper), and other RPM-based distros
- Non-blocking installation with threaded execution

## Installation

### One-Command Installation

Install the application system-wide and add it to the start menu with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/theclassiclol/rpminstaller/main/install.sh | sudo bash
```

Or using git:

```bash
git clone https://github.com/theclassiclol/rpminstaller.git && cd rpminstaller && sudo ./install.sh
```

This will:
- Install system dependencies (PyQt5, pip)
- Copy files to `/opt/rpminstaller`
- Install Python dependencies
- Create a desktop entry in the applications menu

### Manual Installation

1. Clone the repository: `git clone https://github.com/theclassiclol/rpminstaller.git`
2. Navigate to the directory: `cd rpminstaller`
3. Install dependencies: `pip install -r requirements.txt`
4. Run: `python main.py`

## Uninstallation

### One-Command Uninstallation

Remove the application and desktop entry:

```bash
curl -sSL https://raw.githubusercontent.com/theclassiclol/rpminstaller/main/uninstall.sh | sudo bash
```

Or using git (if repo is cloned):

```bash
cd rpminstaller && sudo ./uninstall.sh
```

## Uninstallation

To remove the application and desktop entry:

```bash
sudo ./uninstall.sh
```

## Usage

- Launch from the applications menu or run `python3 /opt/rpminstaller/main.py`
- Click "Select RPM File" to choose a package
- Click "Install Package" to install with dependency resolution
- The app detects your distribution and uses the appropriate package manager

## Requirements

- Python 3.6+
- PyQt5 (installed automatically by install script)
- rpm-based Linux distribution (Fedora, CentOS, openSUSE, etc.)
- pkexec for GUI privilege escalation

## Supported Distributions

- Fedora / CentOS / RHEL: Uses `dnf` for dependency resolution
- openSUSE / SLES: Uses `zypper` for dependency resolution
- Other RPM distros: Falls back to `rpm` (no dependency resolution)