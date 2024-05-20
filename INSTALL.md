# Android 13 for ADLINK LEC-iMX8MP

## Preparation

### Installing Dependency Packagages
```
$ sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl u-boot-tools mtd-utils android-sdk-libsparse-utils
$ sudo apt-get install device-tree-compiler gdisk m4 bison flex make libssl-dev gcc-multilib libgnutls28-dev swig liblz4-tool libdw-dev
$ sudo apt-get install dwarves bc cpio tar lz4 rsync ninja-build clang libelf-dev build-essential libncurses5
```

### Setup GIT
```
$ git config --global user.name "First Last"
$ git config --global user.email "first.last@company.com"
```

### Setup GCC Compiler

```
$ sudo tar -xvJf gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz -C /opt
$ export AARCH64_GCC_CROSS_COMPILE=/opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```

### Setup CLANG compiler

```
$ sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opt/prebuilt-android-clang
$ cd /opt/prebuilt-android-clang
$ sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4
$ export CLANG_PATH=/opt/prebuilt-android-clang
```

## Download Android source from NXP

```
$ mkdir ~/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
$ chmod a+x ~/bin/repo
$ export PATH=${PATH}:~/bin
$ tar -zxvf imx-android-13.0.0_1.2.0.tar.gz
$ source ~/imx-android-13.0.0_1.2.0/imx_android_setup.sh
```
Now Android 13 source will be downloaded into android_build directory


## Apply LEC-iMX8MP patches for Android 13
### 1. Android Device
```
$ cd ~/android_build/device/nxp
$ git am ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/device/nxp/0001-lec-imx8mp-Add-device-support.patch
```

### 2. Kernel
```
$ cd ~/android_build/vendor/nxp-opensource/kernel_imx
$ git am < ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/kernel_imx/0001-lec-imx8mp-Add-initial-board-support.patch
```

### 3. U-boot
```
$ cd ~/android_build/vendor/nxp-opensource/uboot-imx
$ git am ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/kernel_imx/0001-lec-imx8mp-Add-initial-board-support.patch
```

### 4. imx-mkimage
```
$ cd ~/android_build/vendor/nxp-opensource/imx-mkimage
$ git am ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/imx-mkimage/0001-lec-imx8mp-add-support-to-compile-lec-dtb.patch
```

### 5. Libbt
```
$ cd ~/android_build/hardware/nxp/libbt
$ git am ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/hardware/nxp/libbt/0001-lec-imx8mp-Add-bt-uart-support.patch
```

### 6. External Libraries
```
$ cd ~/android_build/external
$ git apply ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/external/0001-can-spi-pwm-utils.patch
```
```
$ cd ~/android_build/external/toybox
$ git am ~/adlink-lec-imx8mp-android-tiramisu_V2_R1_240520/patches/imx-android-13.0.0_1.2.0/android_build/external/toybox/0001-lec-imx8mp-fix-lspci-listing-issue.patch
```

Compile Android 13 BSP
------------------------------
```
$ cd android_build
$ source build/envsetup.sh
$ lunch lec_imx8mp-userdebug
$ ./imx-make.sh -j4 2>&1 | tee build-log.txt
```