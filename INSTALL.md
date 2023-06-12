ADLINK LEC-IMX8MP 2GB Module with iPI SMARC plus Android 11 BSP
==================================================================

Preparation
===========

Installing Dependency Packagages
--------------------------------

- sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop 
- sudo apt-get install git curl u-boot-tools mtd-utils android-sdk-libsparse-utils android-sdk-ext4-utils 
- sudo apt-get install device-tree-compiler gdisk m4 zlib1g-dev bison flex make libssl-dev gcc-multilib

Git Setup
---------

- git config --global user.name "First Last"
- git config --global user.email "first.last@company.com"

To setup GCC Compiler
---------------------

- sudo tar -xvJf gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz -C /opt
- export AARCH64_GCC_CROSS_COMPILE=/opt/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu/bin/aarch64-linux-gnu-


To setup CLANG compiler
-----------------------

- sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opt/prebuilt-android-clang -b master-kernel-build-2021
- cd /opt/prebuilt-android-clang
- sudo git checkout bceb7274dda5bb587a5473058bd9f52e678dde98
- export CLANG_PATH=/opt/prebuilt-android-clang

To download the source from NXP
-------------------------------

- $ mkdir ~/bin
- $ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
- $ chmod a+x ~/bin/repo
- $ export PATH=${PATH}:~/bin
- $ tar -zxvf imx-android-11.0.0_2.6.0.tar.gz
- $ source ~/imx-android-11.0.0_2.6.0/imx_android_setup.sh

Now Android 11 source will be downloaded into android_build directory


To apply the patches
--------------------

- cd ~/android_build/device/nxp
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/device/nxp/0001-LEC-IMX8MP-Android_Devices.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/device/nxp/0002-LEC-IMX8MP-Android_Device_files.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/device/nxp/0003-bluetooth-driver-config.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/device/nxp/0004-pcie-ssd-automount.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/device/nxp/0005-emmc-uboot-uuu-config.patch
- cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png imx8m/lec_imx8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png
- cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png imx8m/lec_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png
- cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png imx8m/lec_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png

- cd ~/android_build/vendor/nxp-opensource/kernel_imx
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0001-LEC-IMX8MP-Kernel_Config_Device_Tree.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0002-88W8997-Bluetooth_Driver_Support.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0003-four-uart-support.patch 
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0004-Ethernet-DWMAC-FEC-support.patch 
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0005-pcie-uart-console-pins-conflict.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0006-bludroid-driver.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0007-nvme-support.patch
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/kernel_imx/0008-mipi-dsi-panel-support.patch

- cd ~/android_build/vendor/nxp-opensource/
- rm -rf uboot-imx
- cp -rf ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp-opensource/uboot-imx ./

- cd ~/android_build/external
- cp -rf ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/external/* ./

- cd ~/android_build/build/make
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/build/make/0001-packages-add.patch

- cd ~/android_build/vendor/nxp/imx-firmware
- patch -p1 < ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp/imx-firmware/0001-88W8997-Firmware-Config.patch

- cd ~/android_build/vendor/nxp/linux-firmware-imx/firmware
- cp -rf ~/LEC-iMX8MP-ANDROID_11/patches/imx-android-11.0.0_2.6.0/android_build/vendor/nxp/linux-firmware-imx/firmware/mrvl/ ./

To Compile the Android 11 BSP
------------------------------
- $ cd android_build
- $ source build/envsetup.sh
- $ lunch lec_imx8mp-userdebug
- $ ./imx-make.sh -j4 2>&1 | tee build-log.txt

