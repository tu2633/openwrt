# OpenWrt Configuration Scripts

This repository contains a collection of scripts designed to simplify and automate common tasks when setting up a fresh installation of OpenWrt. These scripts are tailored for my personal use, and your experience may vary based on your specific setup. You will likely need to modify elements such as interface names, SD card mount points, or other configuration details to suit your environment.

## 💾 expand-sd-card.sh
This script automates the process of expanding an SD card to utilize its full capacity. It handles the entire procedure from start to finish, making it easy to maximize storage on your OpenWrt device.


## 🔌 create-pppoe-wan.sh
This bash script simplifies the creation of a PPPoE WAN interface. It makes certain assumptions about the OpenWrt interface configuration, but during execution, it prompts the user to input their PPPoE `username` and `password` for the WAN connection.

Once the credentials are provided, the script creates the interface and assigns it to the pre-existing `wan` firewall zone.


**Assumption:** The script assumes `eth1` is the WAN interface. You may need to adjust this based on your hardware setup.


## Note:
To ensure all script's are executable, run the following command:
```bash
chmod +x SCRIPT_FILE_PATH
```


## 🌐 tailscale-throughput-fix.sh
This script addresses throughput limitations caused by the default Linux configuration of the WAN interface (e.g., `pppoe-wan`). It applies specific network optimizations by running the following command as a hotplug script when the WAN interface comes up, with a 2-second delay:

```bash
ethtool -K pppoe-wan rx-udp-gro-forwarding on rx-gro-list off
```
**Note:** Create the file `/etc/hotplug.d/iface/99-ethtool-pppoe` and paste the contents of `tailscale-throughput-fix`
