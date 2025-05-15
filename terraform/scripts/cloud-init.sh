#!/bin/bash

# Install dependencies
apt update
apt install -y python3-pip
apt install -y git

# Clone your app or unpack it from storage
git clone https://github.com/hpeacher/422FinalProject.git /opt/app

# Optional: install Python dependencies
#cd /opt/app
#pip3 install -r requirements.txt

# Create a systemd service to auto-start app
cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=Start My App on Boot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/app

# Create app directory
ExecStartPre=/bin/bash -c 'set -x; mkdir -p /opt/app'

# Clone repo if app.py not present
ExecStartPre=/bin/bash -c 'set -x; if [ ! -f /opt/app/app.py ]; then git clone https://github.com/hpeacher/422FinalProject.git /opt/app; fi'

# Create python virtual environment if missing
ExecStartPre=/bin/bash -c 'set -x; if [ ! -d /opt/app/venv ]; then python3 -m venv /opt/app/venv; fi'

# Ensure pip is installed/upgraded in the venv
ExecStartPre=/bin/bash -c 'set -x; /opt/app/venv/bin/python -m ensurepip --upgrade'

# Upgrade pip (optional, recommended)
ExecStartPre=/bin/bash -c 'set -x; /opt/app/venv/bin/pip install --upgrade pip'

# Install python dependencies inside venv
ExecStartPre=/bin/bash -c 'set -x; /opt/app/venv/bin/pip install --no-cache-dir -r /opt/app/requirements.txt'

# Start the app with the venv python
ExecStart=/opt/app/venv/bin/python /opt/app/app.py

Restart=on-failure
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp
