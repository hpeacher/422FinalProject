#!/bin/bash
apt-get update
apt-get install -y python3-pip git

# Clone your repo or use deployment logic
git clone https://github.com/hpeacher/422FinalProject.git /opt/flask-app

cd /opt/flask-app
pip3 install -r requirements.txt

# Optional: set environment variables here
# export FLASK_ENV=production

# Run Flask app (adjust the app name if different)
nohup python3 app.py > /var/log/flask.log 2>&1 &
