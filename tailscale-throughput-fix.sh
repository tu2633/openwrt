#!/bin/sh
[ "$ACTION" = "ifup" ] && [ "$INTERFACE" = "wan" ] && {
    # Wait a bit for pppoe-wan to be fully created
    sleep 2
    /usr/sbin/ethtool -K pppoe-wan rx-udp-gro-forwarding on rx-gro-list off
}
