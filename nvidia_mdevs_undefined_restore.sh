#!/bin/bash

# Default saved mdevs file (from save_nvidia_mdevs.service)
DEFAULT_SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

# Before clean reboot/shutdown nvidia mdevs are seved to this file..
SHUTDOWN_REBOOT_SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs.reboot
SAVED_MDEVS=""

# You may need to adjust this variable..
SYSPATH="/sys/devices/pci*"
CREATE_PATH="/mdev_supported_types/nvidia-315/create"

# Restore after a clean reboot/shutdown
if [ -s "$SHUTDOWN_REBOOT_SAVED_MDEVS" ]; then
    # restore from it
    SAVED_MDEVS=$SHUTDOWN_REBOOT_SAVED_MDEVS
else
    SAVED_MDEVS=$DEFAULT_SAVED_MDEVS
fi


sleep 30
# check if mdev_supported_types exist, if not then something bad happened..
# and there is no restore to do, just exit and leave untouched existing SAVED_MDEV file(s)
CHECK_CREATE_PATH=$(find $SYSPATH -wholename *$CREATE_PATH | wc -l)
if [ $CHECK_CREATE_PATH -eq 0 ]; then
    echo "Error: $SYSPATH...$CREATE_PATH does not exist. Can't restore mdevs. Exiting."
    exit 13
fi
#check if SAVED_MDEVS exists and is not empty..
if [  -s "$SAVED_MDEVS" ]; then
    echo "Current saved mdevs file: $SAVED_MDEVS"
    while IFS= read -r line; do
        # restore not defined mdevs..
        if [[ ! $line =~ defined ]]; then
            UUID=`echo $line | cut -f1 -d " "`
            DEV=`echo $line | cut -f2 -d " "`
            GPU_PATH=`find $SYSPATH -wholename "*/$DEV"`
            echo $UUID > $GPU_PATH/$CREATE_PATH
        fi
    done < "$SAVED_MDEVS"
    if [ -f "$SHUTDOWN_REBOOT_SAVED_MDEVS" ]; then
        # delete clean reboot/shutdown mdevs file if it exists..
        rm $SHUTDOWN_REBOOT_SAVED_MDEVS
    fi
else # no SAVED_MDEV file or empty..
    logger -p syslog.info "File $SAVED_MDEVS does not exist or is empty. Nothing to restore."
    exit 17
fi
exit 0