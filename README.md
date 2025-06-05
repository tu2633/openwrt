# OpenWRT Configuration Scripts

This repository contains scripts that are useful for my peronal usage when creating a fresh install of OpenWRT. Your experience using these scripts may vary, depending on your individual configuration. It is highly likely that you will have to make modifiations to any included scripts such as interface names, sd card mount names etc.,

## 💾 expand_sd_card.sh
This script is used to expand the sd card to it's full capacity and automating the entire process from A-Z.

## 🌐 tailscale_throughput_fix.sh
This script is used to resolve any throughput limitations due to the initial linux configuration of the WAN interface e.g, `ppoe-wan`

**IMPORTANT:** To ensure the script is executable, ensure that the following command is ran:
```bash
chmod +x /etc/hotplug.d/iface/99-ethtool-pppoe
```
