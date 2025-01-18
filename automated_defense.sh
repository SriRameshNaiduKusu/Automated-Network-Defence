#!/bin/bash

# Cyber Defense Automation Script
# Author: Sri Ramesh Naidu K
# Date: 18-01-2025
# Version: 1.0
# Description:
#   Monitors network traffic for suspicious activity and blocks IPs exceeding a request threshold.
# Usage: sudo ./automated_defense.sh
# Requirements: Kali Linux or any Linux distro with tcpdump and iptables.
# License: MIT

# Variables
THRESHOLD=50  # Requests per minute threshold to identify suspicious activity
LOG_FILE="/var/log/automated_defense.log"
MONITOR_INTERFACE="eth0"  # Change this to the appropriate network interface
BLOCKED_IPS="/tmp/blocked_ips.txt"

# Ensure the blocked IPs file exists
if [ ! -f "$BLOCKED_IPS" ]; then
    touch "$BLOCKED_IPS"
fi

MONITOR_DURATION=60  # Duration for monitoring in seconds

# Setup logging function
initialize_logging() {
    echo "[INFO] Defense Script Initialized - $(date)" | tee -a "$LOG_FILE"
}

# Monitor traffic for malicious patterns
monitor_network() {
    echo "[INFO] Monitoring traffic on $MONITOR_INTERFACE for $MONITOR_DURATION seconds..." | tee -a "$LOG_FILE"
    tcpdump -nn -i "$MONITOR_INTERFACE" -c 2000 'tcp' 2>/dev/null | awk '{print $3}' | cut -d. -f1-4 | sort | uniq -c > /tmp/traffic_counts.txt
    while read -r count ip; do
        if [[ $count -gt $THRESHOLD ]]; then
            if ! grep -q "$ip" "$BLOCKED_IPS"; then
                echo "[ALERT] Suspicious activity detected from $ip - Requests: $count" | tee -a "$LOG_FILE"
                block_ip "$ip"
            fi
        fi
    done < /tmp/traffic_counts.txt
}

# Block identified malicious IPs
block_ip() {
    local ip=$1
    echo "[ACTION] Blocking IP: $ip" | tee -a "$LOG_FILE"
    iptables -A INPUT -s "$ip" -j DROP
    iptables -A FORWARD -s "$ip" -j DROP
    echo "$ip" >> "$BLOCKED_IPS"
    echo "[INFO] IP $ip blocked and logged." | tee -a "$LOG_FILE"
}

# Reset iptables and cleanup
reset_defenses() {
    echo "[INFO] Resetting firewall rules and cleaning up..." | tee -a "$LOG_FILE"
    iptables -F
    rm -f /tmp/traffic_counts.txt "$BLOCKED_IPS"
    echo "[INFO] Cleanup complete. Exiting." | tee -a "$LOG_FILE"
}

# Trap interrupt signals for cleanup
trap reset_defenses EXIT

# Main Execution
initialize_logging
while true; do
    monitor_network
    echo "[INFO] Monitoring cycle completed. Sleeping for $MONITOR_DURATION seconds..." | tee -a "$LOG_FILE"
    sleep "$MONITOR_DURATION"
done
