# Node Health Monitor 🛠️

This repository contains a simple bash script for monitoring and managing a blockchain node running on Linux. The script can automatically check if the node service is running, monitor system resource usage (CPU and memory), and check logs for errors. If the node is down, it will attempt to restart it.

## Features 🌟

- Checks if the node service is active and restarts it if needed.
- Monitors CPU and memory usage and sends warnings if usage exceeds specified thresholds.
- Scans the node logs for recent errors and provides an overview.
- Can be easily scheduled with cron for regular health checks.

## Usage 🚀

### Prerequisites

- A blockchain node service running on your machine (e.g., Polkadot or Kusama).
- The service should be managed by `systemd` (e.g., `systemctl` commands).
- Make sure your node writes logs to a known location (update the `LOG_FILE` path in the script).

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/node-health-monitor.git
   cd node-health-monitor
