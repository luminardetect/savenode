#!/bin/bash

# Name of the node service
NODE_SERVICE="polkadot-node"

# CPU usage threshold for triggering a warning (in percentage)
CPU_THRESHOLD=80

# Memory usage threshold for triggering a warning (in percentage)
MEM_THRESHOLD=75

# Path to the node's log file
LOG_FILE="/var/log/$NODE_SERVICE.log"

# Function to check the node's status
check_node_status() {
    echo "Checking node service status..."
    if ! systemctl is-active --quiet "$NODE_SERVICE"; then
        echo "Node is not running! Restarting the service..."
        systemctl restart "$NODE_SERVICE"
        if systemctl is-active --quiet "$NODE_SERVICE"; then
            echo "Node successfully restarted."
        else
            echo "Failed to restart the node. Check the logs for more details."
        fi
    else
        echo "Node is running."
    fi
}

# Function to monitor CPU and memory usage
monitor_resources() {
    echo "Monitoring system resources..."
    
    # Get current CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    
    # Get current memory usage
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    
    # Check if CPU usage exceeds the threshold
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "Warning: CPU usage is above ${CPU_THRESHOLD}% (Current: ${CPU_USAGE}%)"
    fi
    
    # Check if memory usage exceeds the threshold
    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "Warning: Memory usage is above ${MEM_THRESHOLD}% (Current: ${MEM_USAGE}%)"
    fi
}

# Function to check node logs for errors
check_logs_for_errors() {
    echo "Checking node logs for errors..."
    
    # Search for recent errors in the logs
    ERROR_COUNT=$(grep -i "error" "$LOG_FILE" | tail -n 100 | wc -l)
    
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "Found $ERROR_COUNT errors in the last 100 lines of logs. Check $LOG_FILE for details."
    else
        echo "No errors found in the logs."
    fi
}

# Main execution block
echo "Starting node health check..."

check_node_status
monitor_resources
check_logs_for_errors

echo "Node health check completed."
