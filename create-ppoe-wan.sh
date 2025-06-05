#!/bin/sh

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Prompt for PPPoE credentials
read -p "Enter PPPoE username: " username
read -p "Enter PPPoE password: " password

# Validate input
if [ -z "$username" ] || [ -z "$password" ]; then
    echo "Username and password cannot be empty." >&2
    exit 1
fi

# Configure eth1 as WAN PPPoE interface
uci set network.wan=interface
uci set network.wan.proto='pppoe'
uci set network.wan.device='eth1'
uci set network.wan.username="$username"
uci set network.wan.password="$password"
uci commit network

# Check that firewall.@zone[1] is named 'wan'
zone_name=$(uci get firewall.@zone[1].name 2>/dev/null)
if [ "$zone_name" != "wan" ]; then
    echo "Error: firewall.@zone[1] is not named 'wan' (found '$zone_name'). Aborting firewall assignment." >&2
    exit 1
fi

# Assign the WAN interface to the 'wan' firewall zone
uci add_list firewall.@zone[1].network='wan'
uci commit firewall

# Reload network and firewall to apply changes
service network reload
service firewall reload

echo "PPPoE WAN interface on eth1 configured and assigned to 'wan' firewall zone."
