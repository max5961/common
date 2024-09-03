#!/bin/bash

# Because how else are you going to stack your ergo keyboard on top of your laptop keyboard?
# Power button disable does not work unfortunately

keyboard_ids=$(xinput list \
        | grep -i "asus keyboard" \
        | awk -F'=' '{print $2}' \
        | awk '{print $1}' \
    )

# powerbutton_ids=$(xinput list \
    #         | grep -i "power button" \
    #         | awk -F'=' '{print $2}' \
    #         | awk '{print $1}' \
    #     )

function get_current_status() {
    if xinput list-props "$1" \
        | grep -i "device enabled" \
        | awk -F':' '{print $2}' \
        | grep '1' >/dev/null 2>&1;
    then
        echo "$2"
    else
        echo "$3"
    fi

}

echo "Current status:"
for id in $keyboard_ids; do
    get_current_status \
        "$id" \
        "       Asus Keyboard $id: Enabled" \
        "       Asus Keyboard $id: Disabled"

done
# for id in $powerbutton_ids; do
#     get_current_status \
    #         "$id" \
    #         "       Asus Powerbutton $id: Enabled" \
    #         "       Asus Powerbutton $id: Disabled"
#
# done
echo ""

echo "0 to disable"
echo "1 to enable"
read -rp "Enable or disable? [0/1]: " enable_or_disable

if [[ "$enable_or_disable" != "0" && "$enable_or_disable" != "1" ]]; then
    echo "Invalid answer: $enable_or_disable";
    exit 1;
fi

echo "Modifying xinput..."
for id in $keyboard_ids; do
    xinput set-prop "$id" "Device Enabled" "$enable_or_disable"
    get_current_status \
        "$id" \
        "Successfully enabled Asus Keyboard $id" \
        "Successfully disabled Asus Keyboard $id"
done

# for id in $powerbutton_ids; do
#     xinput set-prop "$id" "Device Enabled" "$enable_or_disable"
#     get_current_status \
    #         "$id" \
    #         "Successfully enabled Power Button $id" \
    #         "Successfully disabled Power Button $id"
# done

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
