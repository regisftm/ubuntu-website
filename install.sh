#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y nginx jq

# Get metadata
HOSTNAME=$(hostname)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
OS_VERSION=$(lsb_release -d | cut -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU_INFO=$(lscpu | grep "Model name" | cut -d':' -f2 | xargs)
MEMORY=$(free -h | grep Mem | awk '{print $2}')
DISK=$(df -h / | tail -1 | awk '{print $2}')

# Create HTML page
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Metadata - $HOSTNAME</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #E95420;
            border-bottom: 3px solid #E95420;
            padding-bottom: 10px;
        }
        .metadata {
            margin: 20px 0;
        }
        .metadata-item {
            display: flex;
            padding: 12px;
            border-bottom: 1px solid #eee;
        }
        .metadata-label {
            font-weight: bold;
            width: 150px;
            color: #333;
        }
        .metadata-value {
            color: #666;
            flex: 1;
        }
        .footer {
            margin-top: 30px;
            text-align: center;
            color: #999;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🖥️ Ubuntu Server Metadata</h1>
        <div class="metadata">
            <div class="metadata-item">
                <div class="metadata-label">Hostname:</div>
                <div class="metadata-value">$HOSTNAME</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">IP Address:</div>
                <div class="metadata-value">$IP_ADDRESS</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">OS Version:</div>
                <div class="metadata-value">$OS_VERSION</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">Kernel:</div>
                <div class="metadata-value">$KERNEL</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">Uptime:</div>
                <div class="metadata-value">$UPTIME</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">CPU:</div>
                <div class="metadata-value">$CPU_INFO</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">Total Memory:</div>
                <div class="metadata-value">$MEMORY</div>
            </div>
            <div class="metadata-item">
                <div class="metadata-label">Disk Size:</div>
                <div class="metadata-value">$DISK</div>
            </div>
        </div>
        <div class="footer">
            Generated on $(date '+%Y-%m-%d %H:%M:%S %Z')
        </div>
    </div>
</body>
</html>
EOF

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Show status
echo "✅ Web server is running!"
echo "📍 Access your metadata page at: http://$IP_ADDRESS"
sudo systemctl status nginx --no-pager
