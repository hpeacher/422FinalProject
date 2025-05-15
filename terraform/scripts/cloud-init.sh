#!/bin/bash

# Install dependencies
apt update
apt install -y python3-pip

# Clone your app or unpack it from storage
git clone https://github.com/hpeacher/422FinalProject.git /opt/app

# Optional: install Python dependencies
cd /opt/app
pip3 install -r requirements.txt

# Create a systemd service to auto-start app
cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=Start My App on Boot
After=network.target

[Service]
User=root
WorkingDirectory=/opt/app
ExecStart=/usr/bin/python3 /opt/app/app.py
Restart=always
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable myapp
systemctl start myapp
