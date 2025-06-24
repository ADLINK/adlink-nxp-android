#!/bin/bash

IMG_NAME="android_emmc_disk_SP2SM.img"
PARTITION_TABLE="partition-table-28GB.img"
LOOP_DEV=""

function create_loop_device_file {
    echo "Creating $IMG_NAME..."
    truncate -s 29G "$IMG_NAME"

    echo "Attaching loop device..."
    LOOP_DEV=$(sudo losetup --show -fP "$IMG_NAME")
    echo "Loop device: $LOOP_DEV"

    echo "Flashing partition table..."
    sudo dd if="$PARTITION_TABLE" of="$LOOP_DEV" bs=1k count=17 conv=fsync

    echo "Re-reading partition table..."
    sudo partprobe "$LOOP_DEV"
    sleep 1  # Give kernel time to create partitions
}

function flash_bootloader {
    echo "Flashing bootloader to $LOOP_DEV at offset 32k..."
    sudo dd if=u-boot-imx8mp.imx of="$LOOP_DEV" bs=1k seek=32 conv=fsync
    sudo dd if=imx8mp_mcu_demo.img of="$LOOP_DEV" bs=1 seek=$((0x500000)) conv=fsync
}

function flash_partitions {
    echo "Flashing partitions..."
    sudo dd if=dtbo-imx8mp.img     of=${LOOP_DEV}p1  bs=10M conv=fsync,nocreat
    sudo dd if=dtbo-imx8mp.img     of=${LOOP_DEV}p2  bs=10M conv=fsync,nocreat
    sudo dd if=boot.img            of=${LOOP_DEV}p3  bs=10M conv=fsync,nocreat
    sudo dd if=boot.img            of=${LOOP_DEV}p4  bs=10M conv=fsync,nocreat
    sudo dd if=init_boot.img       of=${LOOP_DEV}p5  bs=10M conv=fsync,nocreat
    sudo dd if=init_boot.img       of=${LOOP_DEV}p6  bs=10M conv=fsync,nocreat
    sudo dd if=vendor_boot.img     of=${LOOP_DEV}p7  bs=10M conv=fsync,nocreat
    sudo dd if=vendor_boot.img     of=${LOOP_DEV}p8  bs=10M conv=fsync,nocreat
    sudo dd if=super_raw.img       of=${LOOP_DEV}p12 bs=10M conv=fsync,nocreat status=progress
    sudo dd if=adlink-imx8mp.img   of=${LOOP_DEV}p14 bs=10M conv=fsync,nocreat
    sudo dd if=vbmeta-imx8mp.img   of=${LOOP_DEV}p16 bs=10M conv=fsync,nocreat
    sudo dd if=vbmeta-imx8mp.img   of=${LOOP_DEV}p17 bs=10M conv=fsync,nocreat
}

function erase_partitions {
    echo "Zeroing misc, metadata, persistdata, and fbmisc partitions..."
    sudo dd if=/dev/zero of=${LOOP_DEV}p9  bs=1M   # misc
    sudo dd if=/dev/zero of=${LOOP_DEV}p10 bs=1M   # metadata
    sudo dd if=/dev/zero of=${LOOP_DEV}p11 bs=1M   # persistdata
    sudo dd if=/dev/zero of=${LOOP_DEV}p13 bs=1M status=progress #userpart
    sudo dd if=/dev/zero of=${LOOP_DEV}p15 bs=1M   # fbmisc
}

# ---- Script execution ----
create_loop_device_file
simg2img super.img super_raw.img
flash_bootloader
flash_partitions
erase_partitions
sudo losetup -d $LOOP_DEV
echo "Image creation complete."

