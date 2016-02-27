#!/bin/bash

#TODO insert module
#need to compile ?

#make -s -C ../.. all
#insmod driver/razermouse.ko


RAZER_BLACKWIDOW_CHROMA_DEVICES=`ls /sys/bus/hid/devices/ | grep "1532:0046"`
echo $RAZER_BLACKWIDOW_CHROMA_DEVICES
for DEV in $RAZER_BLACKWIDOW_CHROMA_DEVICES
do
    if [ -d "/sys/bus/hid/devices/$DEV/input" ]; then
        INPUT_DEVS=`ls /sys/bus/hid/devices/$DEV/input`
        echo "looping $DEV $INPUT_DEVS"
	for INPUT_DEV in $INPUT_DEVS
	do
            echo "Activating $DEV $INPUT_DEV"
	    MOUSE=`ls /sys/bus/hid/devices/$DEV/input/$INPUT_DEV/ | grep "mouse"`
	    if [ $MOUSE ]; then
		echo "Found Razer LED Device : $DEV"
		echo -n "$DEV" > /sys/bus/hid/drivers/hid-generic/unbind 2> /dev/null
		echo $?
		echo -n "$DEV" > /sys/bus/hid/drivers/razermouse/bind 2> /dev/null
		echo $?
	    fi
	done
    else
	#no input directories ? use .0003 as default and try that
	if [[ "$DEV" == *.0003 ]]; then
	    echo "Found Razer LED Device : $DEV"
	    echo -n "$DEV" > /sys/bus/hid/drivers/hid-generic/unbind 2> /dev/null
	    echo $?
	    echo -n "$DEV" > /sys/bus/hid/drivers/razermouse/bind 2> /dev/null
	    echo $?
	fi
    fi
done
