#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y nginx

# Define colour palette (name and gradient pair)
declare -A COLORS
COLORS["Amethyst"]="135deg, #667eea 0%, #764ba2 100%"
COLORS["Crimson"]="135deg, #f5515f 0%, #9f041b 100%"
COLORS["Ocean"]="135deg, #2196f3 0%, #0d47a1 100%"
COLORS["Emerald"]="135deg, #11998e 0%, #38ef7d 100%"
COLORS["Sunset"]="135deg, #f7971e 0%, #ffd200 100%"
COLORS["Slate"]="135deg, #434343 0%, #000000 100%"
COLORS["Rose"]="135deg, #f953c6 0%, #b91d73 100%"
COLORS["Arctic"]="135deg, #4facfe 0%, #00f2fe 100%"

# Pick a random colour and number
COLOR_NAMES=(${!COLORS[@]})
RANDOM_NAME=${COLOR_NAMES[$RANDOM % ${#COLOR_NAMES[@]}]}
RANDOM_GRADIENT=${COLORS[$RANDOM_NAME]}
RANDOM_NUMBER=$(( RANDOM % 90 + 10 ))
SERVER_NAME="$RANDOM_NAME $RANDOM_NUMBER"

echo "Selected colour: $SERVER_NAME"

# Create HTML page
sudo tee /var/www/html/index.html > /dev/null <<EOF
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
            background: linear-gradient($RANDOM_GRADIENT);
        }
        .container {
            text-align: center;
            color: white;
            padding: 40px;
        }
        .icon {
            margin-bottom: 20px;
        }
        .icon svg {
            width: 80px;
            height: 80px;
            fill: white;
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
        <div class="icon">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2L3 6v6c0 5.25 3.75 10.15 9 11.25C17.25 22.15 21 17.25 21 12V6L12 2z"/>
            </svg>
        </div>
        <h1>Host $SERVER_NAME</h1>
        <p class="tagline">Protected by Fortinet</p>
        <div class="status">Service Online</div>
    </div>
</body>
</html>
EOF

# Start and enable nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Show status
echo "Web server is running!"
echo "Server name: $SERVER_NAME"
echo "Access your page at: http://$(hostname -I | awk '{print $1}')"
sudo systemctl status nginx --no-pager
