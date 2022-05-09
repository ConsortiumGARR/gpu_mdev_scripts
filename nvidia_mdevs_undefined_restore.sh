#!/bin/bash

SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

# You may need to adjust this variable..
SYSPATH="/sys/devices/pci*"
CREATE_PATH="/mdev_supported_types/nvidia-315/create"

sleep 30
#check if SAVED_MDEVS exists and is not empty..
if [  -s "$SAVED_MDEVS" ]; then
    while IFS= read -r line; do
        # restore not defined mdevs..
        if [[ ! $line =~ defined ]]; then
            UUID=`echo $line | cut -f1 -d " "`
            DEV=`echo $line | cut -f2 -d " "`
            GPU_PATH=`find $SYSPATH -wholename "*/$DEV"`
            echo $UUID > $GPU_PATH/$CREATE_PATH
        fi
    done < "$SAVED_MDEVS"
else # no SAVED_MDEV file or empty..
    logger -p syslog.info "File $SAVED_MDEVS does not exist or is empty. Nothing to restore."
    exit 17
fi
exit 0