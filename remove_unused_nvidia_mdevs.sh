#!/bin/bash
# qemu OpenStack VMs definitions folder
VM_CONFIG_FOLDER=/etc/libvirt/qemu

# all nvidia mdsvs
ALL_MDEVS=($(mdevctl list | grep -i "nvidia" | cut -f 1 -d " "))
for i in ${ALL_MDEVS[@]}; do
    FOUND=`grep $i $VM_CONFIG_FOLDER/*.xml`
    if [ -z "$FOUND" ]; then
        echo "Unused mdev $i"
        mdevctl stop --uuid $i
        mdevctl undefine --uuid $i   
    fi
done
