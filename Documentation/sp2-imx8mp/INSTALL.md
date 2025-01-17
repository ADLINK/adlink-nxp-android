# Android 14 for ADLINK LEC-iMX8MP

## Preparation

### Installing Dependency Packages
```shell
$ sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl u-boot-tools mtd-utils android-sdk-libsparse-utils
$ sudo apt-get install device-tree-compiler gdisk m4 bison flex make libssl-dev gcc-multilib libgnutls28-dev swig liblz4-tool libdw-dev
$ sudo apt-get install dwarves bc cpio tar lz4 rsync ninja-build clang libelf-dev build-essential libncurses5
```

### Setup GIT
```shell
$ git config --global user.name "First Last"
$ git config --global user.email "first.last@company.com"
```

Compilers ,rust and tools related to Android 14 are placed in the directory  /opta14 

### Setup GCC Compiler

Download GCC from [here](https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz) and copy into ${HOME} directory
```shell
$ sudo tar -xvJf ${HOME}/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opta14
$ export AARCH64_GCC_CROSS_COMPILE=/opta14/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```

### Setup CLANG Compiler

```shell
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 /opta14/prebuilt-android-clang
$ cd /opta14/prebuilt-android-clang
$ sudo git fetch origin 7061673283909f372f4938e45149d23bd10cbd40
$ sudo git checkout 7061673283909f372f4938e45149d23bd10cbd40
$ export CLANG_PATH=/opta14/prebuilt-android-clang
$ export LIBCLANG_PATH=/opta14/prebuilt-android-clang/clang-r510928/lib
```
### Setup Kernel Build Tools

```shell
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/kernel/prebuilts/build-tools /opta14/prebuilt-android-kernel-build-tools
$ cd /opta14/prebuilt-android-kernel-build-tools
$ sudo git fetch origin b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
$ sudo git checkout b46264b70e3cdf70d08c9ae2df6ea3002b242ebc
$ export PATH=/opta14/prebuilt-android-kernel-build-tools/linux-x86/bin:$PATH
```
### Setup RUST

```shell
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/rust /opta14/prebuilt-android-rust
$ cd /opta14/prebuilt-android-rust
$ sudo git fetch origin 442511af884f074018466f85b4daadd4b0ac0050
$ sudo git checkout 442511af884f074018466f85b4daadd4b0ac0050
$ export PATH=/opta14/prebuilt-android-rust/linux-x86/1.73.0b/bin:$PATH
```
### Setup CLANG Tools

```shell
$ sudo git clone -b main-kernel-build-2024 --single-branch --depth 1 https://android.googlesource.com/platform/prebuilts/clang-tools /opta14/prebuilt-android-clang-tools
$ cd /opta14/prebuilt-android-clang-tools
$ sudo git fetch origin 1634c6a556d1f2c24897bf74156c6449486e8941
$ sudo git checkout 1634c6a556d1f2c24897bf74156c6449486e8941
$ export PATH=/opta14/prebuilt-android-clang-tools/linux-x86/bin:$PATH
```
## Download Android source from NXP and patches from Adlink GitHub
Download "imx-android-14.0.0_2.2.0.tar.gz" from NXP site available [here](https://www.nxp.com/webapp/Download?colCode=14.0.0_2.2.0_ANDROID_SOURCE&appType=license) and copy into ${HOME} directory
```shell
$ mkdir ${HOME}/bin
$ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
$ chmod a+x ${HOME}/bin/repo
$ export PATH=${PATH}:${HOME}/bin
$ cd ${HOME}
$ git clone https://github.com/ADLINK/imx8mp_android.git -b Android-14
$ tar xzvf imx-android-14.0.0_2.2.0.tar.gz
$ source ${HOME}/imx-android-14.0.0_2.2.0/imx_android_setup.sh
```


## Apply LEC-iMX8MP patches
### 1. Android Device
```shell
$ cd ${HOME}/android_build/device/nxp
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/device/nxp/0001-sp2-imx8mp-Android-Devices.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/device/nxp/0002-sp2-imx8mp-Android-adding-Device-files.patch
```

### 2. Kernel
```shell
$ cd ${HOME}/android_build/vendor/nxp-opensource/kernel_imx
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0001-sp2-imx8mp-patch-sgtl5000-switch-to-highest-voltage-.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0002-sp2-imx8mp-patch-core.c-allow-dual-role-for-imx8mp-w.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0003-sp2-imx8mp-patch-realtek-phy-modify-driver-to-config.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0004-sp2-imx8mp-tpm-use-default-guard-time-from-dts-to-us.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0005-sp2-imx8mp-patch-drm-panel-enhancement-to-take-addit.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0006-sp2-imx8mp-patch-panel-simple-parse-additional-delay.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0007-sp2-imx8mp-patch-pwm-backlight-add-pre-pwm-on-delay-.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0008-sp2-imx8mp-patch-panel-lvds-introduce-delays-to-tune.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0009-sp2-imx8mp-patch-pwm-bl-and-panel-lvds-move-power-of.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0010-sp2-imx8mp-patch-mipi-dsi-ili9881c-override-mode_fla.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0011-sp2-imx8mp-patch-mipi-dsi-ili9881c-add-hannstar-p071.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/kernel_imx/0012-sp2-imx8mp-Android-Kernel-support.patch
```

### 3. U-boot
```shell
$ cd ${HOME}/android_build/vendor/nxp-opensource/uboot-imx
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/uboot-imx/0001-lib-string-Add-memmem-library-function.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/uboot-imx/0002-sp2imx8mp-patch-msgpack-add-c-6.0.0-msgpack-source.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/uboot-imx/0003-sp2imx8mp-patch-msgpack-fix-build-float-point-relate.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/uboot-imx/0004-sp2imx8mp-copy-from-imx8mp_evk-and-modify-lpddr4-tra.patch
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/uboot-imx/0005-sp2-imx8mp-u-boot-support-dtbo-based-android-boot.patch
```

### 4. imx-mkimage
```shell
$ cd ${HOME}/android_build/vendor/nxp-opensource/imx-mkimage
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/vendor/nxp-opensource/imx-mkimage/0001-sp2-imx8mp-add-support-to-compile-sp2-dtb.patch
```

### 5. Build
```shell
$ cd ${HOME}/android_build/build/make
$ git am ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/build/make/0001-sp2-imx8mp-Updated-build-id-and-removed-camera.patch
```

### 6. External Libraries
```shell
$ cd ${HOME}/android_build/external
$ git apply ${HOME}/imx8mp_android/patches/imx-android-14.0.0_2.2.0/android_build/sp2-imx8mp/external/0001-external_can_spi_beep_utils.patch
```

Compile Android 14 BSP
------------------------------
```shell
$ cd ${HOME}/android_build
$ source build/envsetup.sh
$ lunch sp2_imx8mp-trunk_staging-userdebug
$ ./imx-make.sh -j4 2>&1 | tee build-log.txt
```

on successful compilation image would be generated in ~/android_build/out/target/product/sp2_imx8mp/
