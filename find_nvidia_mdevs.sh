#!/bin/bash
# qemu OpenStack VMs definitions folder
VM_CONFIG_FOLDER=/etc/libvirt/qemu

# all nvidia mdevs
ALL_MDEVS=($(mdevctl list | grep -i "nvidia" | cut -f 1 -d " "))
echo "+++++++++++++++++++++++++++++++++++++++++ Virsh VMs with nvidia mdevs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
for i in ${ALL_MDEVS[@]}; do
    FOUND=`grep $i $VM_CONFIG_FOLDER/*.xml`
    if [ ! -z "$FOUND" ]; then
        VM_CONFIG_FILE=`echo $FOUND | grep -oE '.*.xml'`
        OPENSTACK_ID=`awk '/<uuid>/,/<\/uuid>/p' $VM_CONFIG_FILE | sed -e 's/.*<uuid>//' -e 's/<\/uuid>//'`
        VM_NAME=`awk '/<name>/,/<\/name>/p' $VM_CONFIG_FILE  | sed -e 's/.*<name>//' -e 's/<\/name>//'`
        echo "Virsh VM Name: $VM_NAME, OpenStack ID: $OPENSTACK_ID, mdev in use $i"
    else
        UNUSED+=("$i")	    
    fi
done
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "----------------------------------------- mdevs with no associated VMs ---------------------------------------------------------------"
for i in ${UNUSED[@]}; do
    echo $i
done
echo "--------------------------------------------------------------------------------------------------------------------------------------"
