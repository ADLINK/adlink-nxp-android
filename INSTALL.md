ADLINK SP2IMX8MP Android 13 BSP 
==================================================================

```
This document outlines the procedures for Build and Flash Android BSP for SP2IX8MP

1.Prerequisite
2.Host Machine Setup
3.Download the source from NXP 
4.Build Instructions
5.Flash Procedure for Android 13 SP2-IMX8MP
```

Prerequisite
===========

### Host machine :

- Machine: x86

- The Linux host must be Ubuntu 20.04 

- RAM: Minimum of 16 GB RAM.

- Storage : 300GB 
  (Recommended storage medium SSD ,Encountered unexpected build error in HDD)

Host Machine Setup
==================================================================
Installing Dependency Packages
------------------------------------

Use the following commands to install the dependency packages.

```Shell
$ sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop git curl u-boot-tools mtd-utils android-sdk-libsparse-utils
$ sudo apt-get install device-tree-compiler gdisk m4 bison flex make libssl-dev gcc-multilib libgnutls28-dev swig liblz4-tool libdw-dev
$ sudo apt-get install dwarves bc cpio tar lz4 rsync ninja-build clang libelf-dev build-essential libncurses5

```

Setup GIT
---------
Use the following commands for git configuration.

```Shell
git config --global user.name "First Last"
git config --global user.email "first.last@company.com
```




## Setup GCC Compiler

Download the gcc from : https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

```Shell
sudo tar -xvJf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt

export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```



## Setup CLANG Compiler

```Shell
sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86  /opt/prebuilt-android-clang

cd /opt/prebuilt-android-clang

sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4

export CLANG_PATH=/opt/prebuilt-android-clang
```



## Download Android source from NXP and patches from Adlink GitHub

- Download the "imx-android-13.0.0_1.2.0.tar.gz" from NXP site [Click here](https://www.nxp.com/webapp/Download?colCode=13.0.0_1.2.0_ANDROID_SOURCE&appType=license) and copy into ${HOME} directory

  ```shell
  $ mkdir ${HOME}/bin
  $ curl https://storage.googleapis.com/git-repo-downloads/repo > ${HOME}/bin/repo
  $ chmod a+x ${HOME}/bin/repo
  $ export PATH=${PATH}:${HOME}/bin
  $ cd ${HOME}
  $ git clone --branch SP2-IMX8MP https://github.com/ADLINK/imx8mp_android.git 
  $ tar -zxvf imx-android-13.0.0_1.2.0.tar.gz
  $ source ${HOME}/imx-android-13.0.0_1.2.0/imx_android_setup.sh
  ```
  
  

## Apply SP2-IMX8MP patches



### 1. Android Device

  ```Shell
cd ${HOME}/android_build/device/nxp

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0001-SP2-IMX8MP-Android_Devices.patch
  
git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0002-SP2-IMX8MP-Android_Device_files.patch
  
git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0003-SP2-IMX8MP-Device_changes_2g_hdmi_cma_fix.patch
  
git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0004-SP2-IMX8MP-Device_changes_touch.patch
  
git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0005-SP2-IMX8MP-Device_WIFI_BT_support.patch
  
git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0006-Device-singel_image-sgtl5000-SD-card.patch
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png
  ```

### 2. Kernel

```Shell
cd ${HOME}/android_build/vendor/nxp-opensource/kernel_imx

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0001-Andorid_gki_dts.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0002-sp2-imx8mp-patch-drm-panel-enhancement-to-take-addit.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0003-sp2-imx8mp-patch-pcie_phy-modify-nxp-pcie-phy-to-tun.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0004-sp2-imx8mp-patch-sgtl5000-switch-to-highest-voltage-.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0005-sp2-imx8mp-patch-core.c-allow-dual-role-for-imx8mp-w.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0006-sp2-imx8mp-patch-panel-simple-move-ampire-am1024600d.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0007-sp2-imx8mp-patch-snd-fsl-sai-provide-mclk-TODO.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0008-sp2-imx8mp-patch-snd-fsl-sai-enable-transmitter-when.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0009-sp2-imx8mp-patch-snd-sgtl5000-enable-mclk-only-when-.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0010-sp2-imx8mp-patch-snd-sgtl5000-fixup-enable-mclk-only.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0011-sp2-imx8mp-patch-panel-simple-parse-additional-delay.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0012-sp2-imx8mp-patch-pwm-backlight-add-pre-pwm-on-delay-.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0013-sp2-imx8mp-patch-panel-lvds-introduce-delays-to-tune.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0014-sp2-imx8mp-patch-pwm-bl-and-panel-lvds-move-power-of.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0015-sp2-imx8mp-patch-realtek-phy-modify-driver-to-config.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0016-sp2-imx8mp-patch-ili9881c-mipi-dsi-panel-add-support.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0017-sp2-imx8mp-panel_fix.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0018-sp2-imx8mp-Kernel-touch-support.patch

git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0019-sp2-imx8mp-Kernel-WIFI-BT.patch
```

### 3. U-boot 

  ```Shell
  cd ${HOME}/android_build/vendor/nxp-opensource/uboot-imx
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0001-sp2-imx8mp-patch-add-source-for-sp2imx8mp-board.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0002-sp2-imx8mp-patch-msgpack-add-c-6.0.0-msgpack-source.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0003-sp2-imx8mp-patch-msgpack-fix-build-float-point-relat.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0004-sp2-imx8mp-patch-handoff-redirect-handoff.h-to-asm-a.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0005-sp2-imx8mp-patch-lvds-Add-i.MX8MP-LVDS-support-in-ub.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0006-sp2-imx8mp-patch-lvds-fix-build-warnings-after-patch.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0007-sp2-imx8mp-patch-dsi-panel-ilitek-ili9881c-cherry-pi.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0008-sp2-imx8mp-patch-lvds-add-panel-generic-lvds-support.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0009-sp2-imx8mp-patch-pwm_backlight-work-around-to-fix-lv.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0010-sp2-imx8mp-patch-ldb-fix-wrong-color-display-by-enab.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0011-sp2-imx8mp-patch-u-boot-add-fn_key-gpio-input-for-um.patch
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0012-sp2-imx8mp-uboot_android_defconfigs.patch
  ```

### 4. Build

  ```Shell
  cd ${HOME}/android_build/build 
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/build/0001-Build_can_spi.patch
  
  ```

### 5.  External Libraries

  ```shell
  cd ${HOME}/android_build/external/
  
  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/external/0001-can-spi-utils.patch
  ```

### 

### 6. imx-mkimage

  ```shell
  cd ${HOME}/android_build/vendor/nxp-opensource/imx-mkimage/

  git apply ${HOME}/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/imx-mkimage/0001-sp2-imx8mp-add-support-to-compile-sp2-dtb.patch
  
  
  ```


  ## To Compile the Android 13 BSP

- After applying all patches, build the source
  
  ```shell
  cd ${HOME}/android_build
  source build/envsetup.sh
  lunch sp2_imx8mp-userdebug
  ./imx-make.sh -j3 2>&1 | tee build-log.txt
   
  ```

 

Output Image Path
--------------------------------------

Image will be generate in the  path :  ${HOME}/android_build/out/target/product/sp2_imx8mp/

Refer Readme.md for Flash Procedure.
