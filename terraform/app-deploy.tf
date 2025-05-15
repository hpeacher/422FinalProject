resource "null_resource" "app_service" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = google_compute_instance.app_vm.network_interface[0].access_config[0].nat_ip
    }

    inline = [
      <<-EOT
        sudo bash -c 'cat <<EOF > /etc/systemd/system/myapp.service
[Unit]
Description=My Python App
After=network.target

[Service]
ExecStartPre=/bin/bash -c "[ -f /opt/app/app.py ] || git clone https://github.com/hpeacher/422FinalProject.git /opt/app"
ExecStartPre=/bin/bash -c "/usr/bin/python3 -m venv /opt/app/venv && /opt/app/venv/bin/python -m ensurepip --upgrade"
ExecStartPre=/opt/app/venv/bin/pip install --no-cache-dir -r /opt/app/requirements.txt
WorkingDirectory=/opt/app
ExecStart=/opt/app/venv/bin/python /opt/app/app.py
Restart=always
User=ubuntu

[Install]
WantedBy=multi-user.target
EOF'
      EOT,
      "sudo systemctl daemon-reexec",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable myapp",
      "sudo systemctl start myapp"
    ]
  }
}
