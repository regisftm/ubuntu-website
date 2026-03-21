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
SERVER_NAME="Host $RANDOM_NAME $RANDOM_NUMBER"

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
            transition: background 0.8s ease;
        }
        body.attacked {
            background: linear-gradient(135deg, #1a1a1a 0%, #8b0000 100%) !important;
            animation: flicker 1.5s infinite alternate;
        }
        @keyframes flicker {
            0%   { filter: brightness(1); }
            100% { filter: brightness(0.85); }
        }
        .container {
            text-align: center;
            color: white;
            padding: 40px;
        }
        .icon svg {
            width: 80px;
            height: 80px;
            fill: white;
            transition: fill 0.5s;
        }
        body.attacked .icon svg {
            fill: #ff4444;
            filter: drop-shadow(0 0 12px #ff0000);
            animation: pulse 0.8s infinite alternate;
        }
        @keyframes pulse {
            0%   { transform: scale(1); }
            100% { transform: scale(1.1); }
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            font-weight: 300;
            transition: all 0.5s;
        }
        body.attacked h1 {
            color: #ff4444;
            text-shadow: 0 0 20px #ff0000;
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
            transition: all 0.5s;
        }
        body.attacked .status {
            background: rgba(255, 0, 0, 0.3);
            border: 1px solid #ff4444;
        }
        .status::before {
            content: "●";
            color: #4ade80;
            margin-right: 8px;
        }
        body.attacked .status::before {
            color: #ff4444;
            animation: blink 0.5s infinite;
        }
        @keyframes blink {
            0%, 100% { opacity: 1; }
            50%       { opacity: 0; }
        }

        /* Attack alert banner */
        .alert-banner {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            background: #ff0000;
            color: white;
            text-align: center;
            padding: 12px;
            font-weight: bold;
            font-size: 0.95em;
            letter-spacing: 1px;
            z-index: 999;
            animation: slideDown 0.5s ease;
        }
        @keyframes slideDown {
            from { transform: translateY(-100%); }
            to   { transform: translateY(0); }
        }
        body.attacked .alert-banner {
            display: block;
        }

        /* Attack details box */
        .attack-details {
            display: none;
            margin-top: 20px;
            background: rgba(0,0,0,0.5);
            border: 1px solid #ff4444;
            border-radius: 10px;
            padding: 15px 25px;
            font-size: 0.85em;
            text-align: left;
            max-width: 480px;
            word-break: break-all;
        }
        body.attacked .attack-details {
            display: block;
        }
        .attack-details .label {
            color: #ff9999;
            font-size: 0.75em;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 4px;
            margin-top: 10px;
        }
        .attack-details .value {
            color: #ffffff;
            font-family: monospace;
            font-size: 0.95em;
        }
    </style>
</head>
<body>
    <div class="alert-banner" id="alertBanner">
        ⚠ ATTACK DETECTED — MALICIOUS REQUEST RECEIVED ⚠
    </div>

    <div class="container">
        <div class="icon">
            <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path d="M12 2L3 6v6c0 5.25 3.75 10.15 9 11.25C17.25 22.15 21 17.25 21 12V6L12 2z"/>
            </svg>
        </div>
        <h1 id="serverName">$SERVER_NAME</h1>
        <p class="tagline" id="tagline">Application Server</p>
        <div class="status" id="statusBadge">Service Online</div>

        <div class="attack-details" id="attackDetails">
            <div class="label">Attack Type</div>
            <div class="value" id="attackType">—</div>
            <div class="label">Detected Payload</div>
            <div class="value" id="attackPayload">—</div>
            <div class="label">Parameter</div>
            <div class="value" id="attackParam">—</div>
            <div class="label">Source</div>
            <div class="value" id="attackSource">—</div>
        </div>
    </div>

    <script>
        // Attack signature patterns
        const ATTACK_SIGNATURES = [
            {
                type: "SQL Injection",
                patterns: [
                    /(\%27|')\s*(or|and)\s*('|\%27)/i,
                    /\bor\b.+?=.+/i,
                    /union.*select/i,
                    /select.*from/i,
                    /insert\s+into/i,
                    /drop\s+table/i,
                    /--\s*$/,
                    /;\s*--/,
                    /xp_cmdshell/i,
                    /exec(\s|\+)+\(/i
                ]
            },
            {
                type: "Cross-Site Scripting (XSS)",
                patterns: [
                    /<script.*?>/i,
                    /javascript:/i,
                    /onerror\s*=/i,
                    /onload\s*=/i,
                    /alert\s*\(/i,
                    /<img.*?src.*?=/i
                ]
            },
            {
                type: "Path Traversal",
                patterns: [
                    /\.\.\//,
                    /\.\.%2f/i,
                    /%2e%2e/i,
                    /etc\/passwd/i,
                    /etc\/shadow/i
                ]
            },
            {
                type: "Command Injection",
                patterns: [
                    /;\s*(ls|cat|rm|wget|curl|bash|sh)\b/i,
                    /\|\s*(ls|cat|rm|wget|curl|bash|sh)\b/i,
                    /\x60.*\x60/
                ]
            }
        ];

        function detectAttack(value) {
            for (const attack of ATTACK_SIGNATURES) {
                for (const pattern of attack.patterns) {
                    if (pattern.test(value)) {
                        return attack.type;
                    }
                }
            }
            return null;
        }

        function triggerAttackUI(paramName, paramValue, attackType) {
            document.body.classList.add("attacked");
            document.getElementById("serverName").textContent = "⚠ SERVER UNDER ATTACK ⚠";
            document.getElementById("tagline").textContent   = "Threat Detected";
            document.getElementById("statusBadge").textContent = "Server Under Attack";
            document.getElementById("attackType").textContent   = attackType;
            document.getElementById("attackPayload").textContent = decodeURIComponent(paramValue);
            document.getElementById("attackParam").textContent   = paramName;
            document.getElementById("attackSource").textContent  = window.location.href;
        }

        // Parse URL parameters and check for attacks
        const params = new URLSearchParams(window.location.search);
        let attackFound = false;

        for (const [key, value] of params.entries()) {
            const attackType = detectAttack(value);
            if (attackType) {
                triggerAttackUI(key, value, attackType);
                attackFound = true;
                break;
            }
            // Also check key names
            const keyAttack = detectAttack(key);
            if (keyAttack) {
                triggerAttackUI(key, key, keyAttack);
                attackFound = true;
                break;
            }
        }
    </script>
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
