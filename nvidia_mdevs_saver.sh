#!/bin/bash

SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

# You may need to adjust these variables..
SYSPATH="/sys/devices/pci*"
CREATE_PATH="/mdev_supported_types/nvidia-*/create"

# if alternative saving dir is specified as argument..use it
if [ ! -z "$1" ]; then
	SAVED_MDEVS=$1
fi

# save mdevs (if any) into a variable..
MDEVS=`mdevctl list | sort`
# on a gpu machine we should always have some mdevs in use..
# if there are errors on reboot or if something goes wrong
# don't update the mdevs file, we just keep the last non-empty list..

# check if mdev_supported_types exist, if not then something bad happened..
# and there is no restore to do, just exit and leave untouched existing SAVED_MDEV file(s)
CHECK_CREATE_PATH=$(find $SYSPATH -wholename *$CREATE_PATH | wc -l)
if [ $CHECK_CREATE_PATH -eq 0 ]; then
    echo "Error: $SYSPATH...$CREATE_PATH does not exist. Nothing to save. Exiting."
    exit 13
else
    echo "$MDEVS" > $SAVED_MDEVS
fi 

exit 0