#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y nginx

# Create HTML page - Simple Landing Page (No Metadata Exposed)
sudo tee /var/www/html/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .container {
            text-align: center;
            color: white;
            padding: 40px;
        }
        .icon {
            font-size: 80px;
            margin-bottom: 20px;
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 300;
        }
        .tagline {
            font-size: 1.2em;
            opacity: 0.9;
            margin-bottom: 30px;
        }
        .status {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 10px 25px;
            border-radius: 25px;
            font-size: 0.9em;
        }
        .status::before {
            content: "●";
            color: #4ade80;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="icon">🛡️</div>
        <h1>Secure Cloud Workload</h1>
        <p class="tagline">Protected by FortiGate on Azure</p>
        <div class="status">Service Online</div>
    </div>
</body>
</html>
EOF

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Show status
echo "✅ Web server is running!"
echo "📍 Access your page at: http://$(hostname -I | awk '{print $1}')"
sudo systemctl status nginx --no-pager
