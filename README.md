# Cyber Defense Automation Script

## Overview
This script automates the detection and mitigation of suspicious network activity. It monitors traffic, identifies malicious patterns, and blocks IP addresses exhibiting potentially harmful behavior. Designed for Kali Linux, this script enhances network security by leveraging tools like `tcpdump` and `iptables`.

## Features
- Monitors network traffic on a specified interface.
- Identifies and logs suspicious IP addresses exceeding a configurable threshold.
- Automatically blocks malicious IPs using `iptables`.
- Provides real-time logs for enhanced visibility.
- Cleans up temporary files and resets firewall rules on termination.

## Requirements
- **Operating System**: Linux (Tested on Kali Linux)
- **Dependencies**:
  - `tcpdump`
  - `iptables`
  - Bash Shell

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/SriRameshNaiduKusu/Automated-Network-Defence.git
   ```
2. Navigate to the directory:
   ```bash
   cd Automated-Network-Defence
   ```
3. Make the script executable:
   ```bash
   chmod +x automated_defense.sh
   ```

## Usage
Run the script with elevated privileges:
```bash
sudo ./automated_defense.sh
```

### Configuration
- **`THRESHOLD`**: Adjust the number of requests per minute to classify an IP as malicious.
- **`MONITOR_INTERFACE`**: Specify the network interface to monitor (default: `eth0`).
- **`MONITOR_DURATION`**: Set the monitoring interval in seconds (default: `60`).

### Logs
Logs are stored in:
```bash
/var/log/automated_defense.log
```

## Cleanup
The script automatically resets firewall rules and deletes temporary files on exit.
To manually reset, run:
```bash
sudo iptables -F
rm -f /tmp/blocked_ips.txt /tmp/traffic_counts.txt
```

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contributing
Feel free to fork this repository and submit pull requests. For major changes, please open an issue to discuss proposed changes.

## Disclaimer
This script is provided as-is for educational purposes. Use it responsibly and ensure you comply with applicable laws and regulations.