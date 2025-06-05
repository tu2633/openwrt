#!/bin/bash

set -e

DEVICE="/dev/mmcblk0"
PART="${DEVICE}p2"

# --- 1. Ensure required packages are installed ---
echo "==== [1/6] Installing Required Packages ===="
for pkg in parted tune2fs resize2fs blkid; do
    if ! opkg list-installed | grep -q "^$pkg "; then
        echo "  -> Installing $pkg..."
        opkg update
        opkg install $pkg
    else
        echo "  -> $pkg is already installed."
    fi
done

# --- 2. Resize partition 2 to 100% ---
echo
echo "==== [2/6] Resizing Partition 2 to 100% ===="
echo "  -> Expanding partition 2 to fill available space..."
parted -s $DEVICE resizepart 2 100%
echo "  -> Partition 2 resized."

# --- 3. Remount root as read-only and repair filesystem ---
echo
echo "==== [3/6] Remounting root as read-only ===="
mount -o remount,ro /
echo "  -> Root filesystem remounted read-only."

echo
echo "==== [4/6] Removing reserved GDT blocks with tune2fs ===="
tune2fs -O^resize_inode $PART
echo "  -> Reserved GDT blocks removed."

echo
echo "==== [5/6] Running fsck.ext4 with automatic yes to all prompts ===="
fsck.ext4 -y $PART
echo "  -> Filesystem checked and repaired."

echo
echo "==== [6/6] Resizing filesystem to fill partition ===="
resize2fs $PART
echo "  -> Filesystem resized."

# --- 4. Update PARTUUID in boot files ---
echo
echo "==== Updating PARTUUID in boot files ===="
PARTUUID=$(blkid -s PARTUUID -o value $PART)
echo "  -> Detected PARTUUID: $PARTUUID"

if [ -f /boot/cmdline.txt ]; then
    echo "  -> Updating /boot/cmdline.txt..."
    sed -i -r "s|PARTUUID=[a-fA-F0-9\-]+|PARTUUID=$PARTUUID|g" /boot/cmdline.txt
else
    echo "  -> Warning: /boot/cmdline.txt not found."
fi

if [ -f /boot/partuuid.txt ]; then
    echo "  -> Updating /boot/partuuid.txt..."
    echo "$PARTUUID" > /boot/partuuid.txt
else
    echo "  -> Warning: /boot/partuuid.txt not found."
fi

echo
echo "==== All done! ===="
echo "Partition 2 has been resized, filesystem repaired and grown, and PARTUUIDs updated."
echo "System will reboot automatically in 5 seconds..."
sleep 5
reboot
