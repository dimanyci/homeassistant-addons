#!/bin/sh

echo "Starting Masquerade NAT Setup..."

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "IP forwarding enabled."

# Check if MASQUERADE rule exists, add if missing
iptables -t nat -C POSTROUTING -j MASQUERADE 2>/dev/null
if [ $? -ne 0 ]; then
    iptables -t nat -A POSTROUTING -j MASQUERADE
    echo "MASQUERADE rule added."
else
    echo "MASQUERADE rule already exists."
fi

# Execute custom commands from /data/options.json if present
if [ -f /data/options.json ]; then
    for cmd in $(jq -r '.commands[]' /data/options.json); do
        echo "Executing custom command: $cmd"
        sh -c "$cmd"
    done
fi

# Keep container alive
tail -f /dev/null
