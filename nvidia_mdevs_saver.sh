#!/bin/bash

SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

if [ ! -z "$1" ]; then
	SAVED_MDEVS=$1
fi

mdevctl list | sort > $SAVED_MDEVS
exit 0