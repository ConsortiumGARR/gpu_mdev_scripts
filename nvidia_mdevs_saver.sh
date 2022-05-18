#!/bin/bash

SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

# if alternative saving dir is specified as argument..use it
if [ ! -z "$1" ]; then
	SAVED_MDEVS=$1
fi

# save mdevs (if any) into a variable..
MDEVS=`mdevctl list | sort`
# on a gpu machine we should always have some mdevs in use..
# if there are errors on reboot or if something goes wrong
# don't update the mdevs file, we just keep the last non-empty list..
if [ -n "$MDEVS" ]; then
    echo "$MDEVS" > $SAVED_MDEVS
else
    logger -p syslog.info "No mdevs found, something bad happened, check your configuration :("
fi 

exit 0