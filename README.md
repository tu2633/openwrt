# OpenWRT Configuration Scripts

This repository contains scripts that are useful for my peronal usage when creating a fresh install of OpenWRT. Your experience using these scripts may vary, depending on your individual configuration. It is highly likely that you will have to make modifiations to any included scripts such as interface names, sd card mount names etc.,

## 💾 expand-sd-card.sh
This script is used to expand the sd card to it's full capacity and automating the entire process from A-Z.

## 🌐 tailscale-throughput-fix.sh
This script is used to resolve any throughput limitations due to the initial linux configuration of the WAN interface e.g, `ppoe-wan`

Runs `ethtool -K ppoe-wan rx-udp-gro-forwarding on rx-gro-list off` as a hotplug on the wan interface coming up with a delay of 2 seconds.

**IMPORTANT:** To ensure the script is executable, ensure that the following command is ran:
```bash
chmod +x /etc/hotplug.d/iface/99-ethtool-pppoe
```
## 🔌create-ppoe-wan.sh
This bash script makes alot of assumptions on the openwrt interface configuration. However, on execution the user will be presented with the option to enter their PPOE `username` and `password` credentials for the WAN interface.

Upon submission the interface will be created and assigned to the already-existent `wan` firewall.

`eth1`: assumed to be the WAN interface
