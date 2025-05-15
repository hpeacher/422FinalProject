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
ExecStartPre=/usr/bin/mkdir -p /opt/app
ExecStartPre=/bin/bash -c '[ -f /opt/app/app.py ] || git clone https://github.com/hpeacher/422FinalProject.git /opt/app'
ExecStartPre=/usr/bin/pip3 install -r /opt/app/requirements.txt
User=root
WorkingDirectory=/
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
