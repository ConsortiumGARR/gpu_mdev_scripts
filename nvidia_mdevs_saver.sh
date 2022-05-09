#!/bin/bash

SAVED_MDEVS=/etc/saved_nvidia_mdevs/nvidia_mdevs

mdevctl list | sort > $SAVED_MDEVS
exit 0