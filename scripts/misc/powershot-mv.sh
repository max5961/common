#!/usr/bin/env bash

if [[ -z "$1" || -z "$2" ]]; then
    printf "USAGE: powershot-mv [BLOCK_DEVICE] [TARGET]\n" && exit 1
fi

BLOCK_DEVICE=/dev/"${1}"
TARGET="${2}"
MOUNT_POINT="/mnt/powershot"
DCIM="$MOUNT_POINT/DCIM"

main() {
    # Mount device
    mkdir -p "$MOUNT_POINT"
    mkdir -p "$TARGET"
    sudo mount "$BLOCK_DEVICE" "$MOUNT_POINT" || echo "mount $BLOCK_DEVICE failed" && exit 1

    # Move files
    for dir in $DCIM/*; do
        path=$dir
        echo "${path}"
        for file in "${path}"/*; do
            if [[ -f "$file" ]]; then
                sudo mv "${file}" "${TARGET}"/. \
                    && echo -e "\t\e[32m✔\e[0m $(basename $file)"
            fi
        done
    done

    # Clean files
    echo -e "removing CTG files"
    for ctg in $TARGET/*.CTG; do
        if [[ -f "$ctg" ]]; then
            rm "$ctg"
        fi
    done

    # Unmount
    echo -e "unmounting $MOUNT_POINT"
    sudo umount "$MOUNT_POINT"
}

main
