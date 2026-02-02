import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QFileDialog, QLabel, QVBoxLayout, QMessageBox, QProgressBar, QHBoxLayout
from PyQt5.QtCore import QThread, pyqtSignal, Qt
from PyQt5.QtGui import QIcon, QFont
import subprocess
import os

def get_package_manager():
    try:
        with open('/etc/os-release', 'r') as f:
            content = f.read()
            if 'ID=opensuse' in content or 'ID=sles' in content:
                return 'zypper'
            elif 'ID=fedora' in content or 'ID=centos' in content or 'ID=rhel' in content:
                return 'dnf'
            else:
                return 'rpm'  # fallback
    except:
        return 'rpm'

class InstallThread(QThread):
    finished = pyqtSignal(bool, str)

    def __init__(self, rpm_file):
        super().__init__()
        self.rpm_file = rpm_file
        self.pm = get_package_manager()

    def run(self):
        if self.pm == 'zypper':
            command = ['pkexec', 'zypper', 'install', '-y', self.rpm_file]
        elif self.pm == 'dnf':
            command = ['pkexec', 'dnf', 'install', '-y', self.rpm_file]
        else:
            command = ['pkexec', 'rpm', '-i', self.rpm_file]
        try:
            result = subprocess.run(command, capture_output=True, text=True)
            if result.returncode == 0:
                self.finished.emit(True, 'Installation successful! ✅')
            else:
                self.finished.emit(False, f'Installation failed: {result.stderr.strip()} ❌')
        except subprocess.CalledProcessError as e:
            self.finished.emit(False, f'Installation failed: {e} ❌')

class RPMInstaller(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle('RPM Installer')
        self.setGeometry(300, 300, 500, 300)
        self.setWindowIcon(QIcon.fromTheme('package-x-generic'))

        layout = QVBoxLayout()

        title = QLabel('RPM Package Installer')
        title.setFont(QFont('Arial', 18, QFont.Bold))
        title.setAlignment(Qt.AlignCenter)
        layout.addWidget(title)

        self.label = QLabel('Select an RPM file to install')
        self.label.setFont(QFont('Arial', 12))
        self.label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.label)

        button_layout = QHBoxLayout()
        self.btn_select = QPushButton('Select RPM File')
        self.btn_select.setIcon(QIcon.fromTheme('document-open'))
        self.btn_select.clicked.connect(self.selectFile)
        button_layout.addWidget(self.btn_select)

        self.btn_install = QPushButton('Install Package')
        self.btn_install.setIcon(QIcon.fromTheme('system-run'))
        self.btn_install.clicked.connect(self.installRPM)
        self.btn_install.setEnabled(False)
        button_layout.addWidget(self.btn_install)

        layout.addLayout(button_layout)

        self.progress = QProgressBar()
        self.progress.setVisible(False)
        layout.addWidget(self.progress)

        self.status_label = QLabel('')
        self.status_label.setAlignment(Qt.AlignCenter)
        layout.addWidget(self.status_label)

        self.setLayout(layout)

        # Modern dark theme stylesheet
        self.setStyleSheet("""
            QWidget {
                background-color: #2b2b2b;
                color: #ffffff;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            QLabel {
                color: #ffffff;
            }
            QPushButton {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 12px 24px;
                font-size: 14px;
                border-radius: 8px;
                min-width: 120px;
            }
            QPushButton:hover {
                background-color: #45a049;
            }
            QPushButton:pressed {
                background-color: #3e8e41;
            }
            QPushButton:disabled {
                background-color: #555555;
                color: #aaaaaa;
            }
            QProgressBar {
                border: 2px solid #555555;
                border-radius: 5px;
                text-align: center;
            }
            QProgressBar::chunk {
                background-color: #4CAF50;
                width: 10px;
            }
        """)

    def selectFile(self):
        options = QFileDialog.Options()
        fileName, _ = QFileDialog.getOpenFileName(self, "Select RPM File", "", "RPM Files (*.rpm);;All Files (*)", options=options)
        if fileName:
            self.rpm_file = fileName
            file_info = os.path.basename(fileName)
            self.label.setText(f'Selected: {file_info}')
            self.btn_install.setEnabled(True)
            self.status_label.setText('')

    def installRPM(self):
        if hasattr(self, 'rpm_file'):
            self.btn_select.setEnabled(False)
            self.btn_install.setEnabled(False)
            self.progress.setVisible(True)
            self.progress.setRange(0, 0)  # Indeterminate progress
            self.status_label.setText('Installing...')

            self.thread = InstallThread(self.rpm_file)
            self.thread.finished.connect(self.onInstallFinished)
            self.thread.start()

    def onInstallFinished(self, success, message):
        self.progress.setVisible(False)
        self.btn_select.setEnabled(True)
        self.btn_install.setEnabled(False)
        self.status_label.setText(message)
        if success:
            QMessageBox.information(self, 'Success', 'Installation successful! ✅')
            self.label.setText('Select an RPM file to install')
        else:
            QMessageBox.critical(self, 'Error', message)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setStyle('Fusion')  # Modern style
    ex = RPMInstaller()
    ex.show()
    sys.exit(app.exec_())