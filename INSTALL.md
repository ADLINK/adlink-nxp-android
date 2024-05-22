# Android 13 for ADLINK LEC-iMX8MP

## Preparation

### Installing Dependency Packages
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
Download GCC [Click here](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz) and copy into ${HOME} directory
```

$ sudo tar -xvJf ${HOME}/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf.tar.xz -C /opt
$ export AARCH64_GCC_CROSS_COMPILE=/opt/gcc-arm-9.2-2019.12-x86_64-aarch64-none-elf/bin/aarch64-none-elf-
```

### Setup CLANG Compiler

```
$ sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opt/prebuilt-android-clang
$ cd /opt/prebuilt-android-clang
$ sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4
$ export CLANG_PATH=/opt/prebuilt-android-clang
```

## Download Android source from NXP and patches from Adlink GitHub
Download the "imx-android-13.0.0_1.2.0.tar.gz" from NXP site [Click here](https://www.nxp.com/webapp/Download?colCode=13.0.0_1.2.0_ANDROID_SOURCE&appType=license) and copy into ${HOME} directory
```
$ mkdir ${HOME}/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
$ chmod a+x ${HOME}/bin/repo
$ export PATH=${PATH}:${HOME}/bin
$ cd ${HOME}
$ git clone https://github.com/ADLINK/imx8mp_android.git -b Android-13
$ tar -zxvf imx-android-13.0.0_1.2.0.tar.gz
$ source ${HOME}/imx-android-13.0.0_1.2.0/imx_android_setup.sh
```


## Apply LEC-iMX8MP patches 
### 1. Android Device
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/device/nxp
$ git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/device/nxp/0001-lec-imx8mp-Add-device-support.patch
```

### 2. Kernel
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/kernel_imx
$ git am ${HOME}/imx8mp_android/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/kernel_imx/0001-lec-imx8mp-Add-initial-board-support.patch
```

### 3. U-boot
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/uboot-imx
$ git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/kernel_imx/0001-lec-imx8mp-Add-initial-board-support.patch
```

### 4. imx-mkimage
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/imx-mkimage
$ git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/vendor/nxp-opensource/imx-mkimage/0001-lec-imx8mp-add-support-to-compile-lec-dtb.patch
```

### 5. Libbt
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/hardware/nxp/libbt
$ git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/hardware/nxp/libbt/0001-lec-imx8mp-Add-bt-uart-support.patch
```

### 6. External Libraries
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/external
$ git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/external/0001-can-spi-pwm-utils.patch
```
```
$ cd ${HOME}/imx-android-13.0.0_1.2.0/android_build/external/toybox
$ git am ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0/android_build/external/toybox/0001-lec-imx8mp-fix-lspci-listing-issue.patch
```

Compile Android 13 BSP
------------------------------
```
$ cd {HOME}/imx-android-13.0.0_1.2.0/android_build
$ source build/envsetup.sh
$ lunch lec_imx8mp-userdebug
$ ./imx-make.sh -j4 2>&1 | tee build-log.txt
```
