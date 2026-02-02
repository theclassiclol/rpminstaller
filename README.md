# RPM Installer

A modern graphical installer for RPM packages on Linux distributions that support RPM.

## Features

- Select RPM files via file dialog
- Install with elevated privileges using pkexec
- Modern UI with PyQt5

## Requirements

- Python 3.6+
- PyQt5
- rpm command (available on RPM-based distros)
- pkexec (for GUI sudo)

## Installation

1. Clone or download the repository.
2. Install dependencies: `pip install -r requirements.txt`
3. Run: `python main.py`

## Usage

1. Click "Select RPM File" to choose an RPM package.
2. Click "Install" to install it.

Note: You may be prompted for password via pkexec.