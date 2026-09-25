# Android 16 for ADLINK LEC-iMX95

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
Download GCC from [AARCH64 here](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz) [AARCH32 here](https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz?rev=dccb66bb394240a98b87f0f24e70e87d&hash=B788763BE143D9396B59AA91DBA056B6) and copy into ${HOME} directory
```

$ sudo tar -xvJf ${HOME}/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz -C /opt
$ export AARCH32_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi/bin/arm-none-eabi-
$ sudo tar -xvJf ${HOME}/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt
$ export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```

## Download Android source from NXP and patches from Adlink GitHub
Download "imx-android-16.0.0_2.0.0.tar.gz" from NXP site available [here](https://www.nxp.com/webapp/sps/download/license.jsp?colCode=16.0.0_2.0.0_ANDROID_SOURCE&appType=file1&DOWNLOAD_ID=null) and copy into ${HOME} directory
```
$ mkdir ${HOME}/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
$ chmod a+x ${HOME}/bin/repo
$ export PATH=${PATH}:${HOME}/bin
$ cd ${HOME}
$ git clone https://github.com/ADLINK/adlink-nxp-android.git -b Android-16
$ tar xzvf imx-android-16.0.0_2.0.0.tar.gz
$ source ${HOME}/imx-android-16.0.0_2.0.0/imx_android_setup.sh
```

### Follow the steps below to set the external Clang, Kernel-build-tools, Rust, and Clang-tools for kernel building

```
$ cd ${HOME}/android_build/
$ sudo ./device/nxp/common/tools/setup_android_kernel_prebuilts.sh
$ export KERNEL_PREBUILTS_PATH=/opt/android-kernel-prebuilts-6.18

```


## Apply LEC-iMX8MP patches
### 1. Android Device
```
$ cd ${HOME}/android_build/device/nxp
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/device/nxp/0001-lec-imx95-device-support.patch
```

### 2. Kernel
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/kernel_imx
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/kernel-imx/0001-lec-imx95-add-initial-board-support.patch
```

### 3. U-boot
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/uboot-imx
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/uboot-imx/0001-lec-imx95-add-initial-board-support.patch
```

### 4. imx-mkimage
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/imx-mkimage
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/imx-mkimage/0001-lec-imx95-Add-timing-data-configurations.patch
```

### 5. imx-oei
```
$ cd ${HOME}/android_build/vendor/nxp-opensource/imx-oei
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/imx-oei/0001-lec-imx95-Added-DDR-timing-support.patch
```

### 6. imx-sm

   ```
   $ cd ${HOME}/android_build/vendor/nxp-opensource/imx-sm
   $ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/imx-sm/0001-lec-imx95-add-SM-support.patch
   ```

### 7. nxp-mwifiex

```
$ cd ${HOME}/android_build/vendor/nxp-opensource/nxp-mwifiex
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/vendor/nxp-opensource/nxp-mwifiex/0001-lec-imx95-adding-nxp-mwifiex-SD8997.patch
```



### 8. libbt

```
$ cd ${HOME}/android_build/hardware/nxp/libbt
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/hardware/nxp/libbt/0001-lec-imx95-addling-bt-config.patch
```

### 9. External Libraries
```
$ cd ${HOME}/android_build/external
$ cp -rf ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/external/* ./
```

### 10 .Build

```
$ cd ${HOME}/android_build/build/make
$ git am ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/lec-imx95/build/make/0001-lec-imx95-added-release-build-tag.patch
```

Compile Android 15 BSP
------------------------------

```
$ cd ${HOME}/android_build
$ source build/envsetup.sh
$ lunch lec_imx95-nxp_stable-userdebug
$ ./imx-make.sh -j4 2>&1 | tee build-log.txt
```


Flash Dependency (One-Time)

```
$ cp -r ${HOME}/adlink-nxp-android/patches/imx-android-16.0.0_2.0.0/android_build/tools/ ${HOME}/android_build/out/target/product/lec_imx95/
```

