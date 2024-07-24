#!/bin/bash

# Because how else are you going to stack your ergo keyboard on top of your laptop keyboard?

keyboard_ids=$(xinput list \
        | grep -i "asus keyboard" \
        | awk -F'=' '{print $2}' \
        | awk '{print $1}' \
    )

echo "Current status:"
for id in $keyboard_ids; do

    if xinput list-props "$id" \
        | grep -i "device enabled" \
        | awk -F':' '{print $2}' \
        | grep '1' >/dev/null 2>&1;
    then
        echo "      Asus Keyboard $id: Enabled"
    else
        echo "      Asus Keyboard $id: Disabled"
    fi
done
echo ""

echo "0 to disable"
echo "1 to enable"
read -rp "Enable or disable?: " enable_or_disable

if [[ "$enable_or_disable" != "0" && "$enable_or_disable" != "1" ]]; then
    echo "Invalid answer: $enable_or_disable";
    exit 1;
fi


for id in $keyboard_ids; do
    xinput set-prop "$id" "Device Enabled" "$enable_or_disable"
done

t1="enabled"
t2="enable"
if [ "$enable_or_disable" == "0" ]; then
    t1="disabled"
    t2="disable"
fi

if [ "$?" -eq 0 ]; then
    echo "Successfully $t1 laptop keyboard!" && exit 0;
else
    echo "Error occured while attempting to $t2 laptop keyboard"
fi


