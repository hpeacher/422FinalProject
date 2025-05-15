resource "null_resource" "app_service" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
    }

    inline = [
      "sudo bash -c 'cat <<EOF > /etc/systemd/system/myapp.service\n[Unit]\nDescription=My Python App\nAfter=network.target\n\n[Service]\nExecStartPre=/bin/bash -c \"[ -f /opt/app/app.py ] || git clone https://github.com/hpeacher/422FinalProject.git /opt/app\"\nExecStartPre=/usr/bin/python3 -m venv /opt/app/venv\nExecStartPre=/opt/app/venv/bin/python -m ensurepip --upgrade\nExecStartPre=/opt/app/venv/bin/pip install --no-cache-dir -r /opt/app/requirements.txt\nWorkingDirectory=/opt/app\nExecStart=/opt/app/venv/bin/python /opt/app/app.py\nRestart=always\nUser=ubuntu\n\n[Install]\nWantedBy=multi-user.target\nEOF'",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable myapp",
      "sudo systemctl start myapp"
    ]
  }
}
