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

- The Linux host must be Ubuntu 20.04 or later,

-  RAM: Minimum of 16 GB RAM.

-  Storage : 300GB 
  (Recommended storage medium SSD ,Encountered unexpected build error in HDD)

Host Machine Setup
==================================================================
Installing Dependency Packages
------------------------------------

Use the following commands to install the dependency packages.

```Shell
sudo apt-get install uuid uuid-dev zlib1g-dev liblz-dev liblzo2-2 liblzo2-dev lzop 
sudo apt-get install git curl u-boot-tools mtd-utils android-sdk-libsparse-utils android-sdk-ext4-utils 
sudo apt-get install device-tree-compiler gdisk m4 zlib1g-dev bison flex make libssl-dev gcc-multilib 
sudo apt-get install libghc-gnutls-dev swig liblz4-tool liblz4-tool libdw-dev dwarves bc cpio tar 
sudo apt-get install lz4 rsync ninja-build clang libelf-dev


sudo apt-get install android-sdk-libsparse-utils
sudo apt install linux-generic dkms git
sudo apt install simh

```

Git Setup
---------
Use the following commands for git configuration.

```Shell
git config --global user.name "First Last"
git config --global user.email "first.last@company.com
```

Repo Setup
---------
Use the following commands for setting up repo .


```Shell
mkdir ~/bin

PATH=~/bin:$PATH

curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo

chmod a+x ~/bin/repo
```


## To setup GCC Compiler

Download the gcc from : https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

```Shell
sudo tar -xvJf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz -C /opt

export AARCH64_GCC_CROSS_COMPILE=/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
```



## To setup CLANG compiler

```Shell
sudo git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86  /opt/prebuilt-android-clang

cd /opt/prebuilt-android-clang

sudo git checkout d20e409261d6ad80a0c29ac2055bf5c3bb996ef4

export CLANG_PATH=/opt/prebuilt-android-clang
```



Download the source from NXP 
==================================================================

- Create a new project folder and initiate the repository using below commands 

  Note : for illustration of step we have used project folder : ~/android_bsp 
  
  ```shell
  mkdir ~/android_bsp/
  cd ~/android_bsp
  ```
  
  Download the bsp soruce from below url and place ~/android_bsp
  
  URL : https://www.nxp.com/design/design-center/software/embedded-software/i-mx-software/android-os-for-i-mx-applications-processors:IMXANDROID
  Under Downloads select  13.0.0_1.2.0_ANDROID_SOURCE  
  
  
  
  Extract the source to project folder :
  
  ```shell
  tar xzvf imx-android-13.0.0_1.2.0.tar.gz -C ~/android_bsp/
  cd ~/android_bsp
  source imx-android-13.0.0_1.2.0/imx_android_setup.sh
  ```
  
  

Build Instructions
==================================================================



## To apply the patches



- Git clone the patches from git to the android project folder 

  ```shell
  cd ~/android_bsp
  git clone --branch SP2-IMX8MP https://github.com/ADLINK/imx8mp_android.git 
  ```

  

- ```Shell
  Apply device patches  
  
  cd ~/android_bsp/android_build/device/nxp/
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0001-SP2-IMX8MP-Android_Devices.patch 
  
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0002-SP2-IMX8MP-Android_Device_files.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0003-SP2-IMX8MP-Device_changes_2g_hdmi_cma_fix.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0004-SP2-IMX8MP-Device_changes_touch.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/device/nxp/0005-SP2-IMX8MP-Device_WIFI_BT_support.patch
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-nodpi/default_wallpaper.png
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw600dp-nodpi/default_wallpaper.png
  
  cp imx8m/evk_8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png imx8m/sp2_imx8mp/overlay/frameworks/base/core/res/res/drawable-sw720dp-nodpi/default_wallpaper.png
  ```
  
- Apply kernel_imx patches  

  ```Shell
  cd ~/android_bsp/android_build/vendor/nxp-opensource/kernel_imx
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0001-Andorid_gki_dts.patch 
  
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0002-sp2-imx8mp-patch-drm-panel-enhancement-to-take-addit.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0003-sp2-imx8mp-patch-pcie_phy-modify-nxp-pcie-phy-to-tun.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0004-sp2-imx8mp-patch-sgtl5000-switch-to-highest-voltage-.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0005-sp2-imx8mp-patch-core.c-allow-dual-role-for-imx8mp-w.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0006-sp2-imx8mp-patch-panel-simple-move-ampire-am1024600d.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0007-sp2-imx8mp-patch-snd-fsl-sai-provide-mclk-TODO.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0008-sp2-imx8mp-patch-snd-fsl-sai-enable-transmitter-when.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0009-sp2-imx8mp-patch-snd-sgtl5000-enable-mclk-only-when-.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0010-sp2-imx8mp-patch-snd-sgtl5000-fixup-enable-mclk-only.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0011-sp2-imx8mp-patch-panel-simple-parse-additional-delay.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0012-sp2-imx8mp-patch-pwm-backlight-add-pre-pwm-on-delay-.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0013-sp2-imx8mp-patch-panel-lvds-introduce-delays-to-tune.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0014-sp2-imx8mp-patch-pwm-bl-and-panel-lvds-move-power-of.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0015-sp2-imx8mp-patch-realtek-phy-modify-driver-to-config.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0016-sp2-imx8mp-patch-ili9881c-mipi-dsi-panel-add-support.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0017-sp2-imx8mp-panel_fix.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0018-sp2-imx8mp-Kernel-touch-support.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/kernel_imx/0019-sp2-imx8mp-Kernel-WIFI-BT.patch
  
  
  ```

- Apply uboot-imx patches  

  ```Shell
  cd ~/android_bsp/android_build/vendor/nxp-opensource/uboot-imx
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0001-sp2-imx8mp-patch-add-source-for-sp2imx8mp-board.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0002-sp2-imx8mp-patch-msgpack-add-c-6.0.0-msgpack-source.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0003-sp2-imx8mp-patch-msgpack-fix-build-float-point-relat.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0004-sp2-imx8mp-patch-handoff-redirect-handoff.h-to-asm-a.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0005-sp2-imx8mp-patch-lvds-Add-i.MX8MP-LVDS-support-in-ub.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0006-sp2-imx8mp-patch-lvds-fix-build-warnings-after-patch.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0007-sp2-imx8mp-patch-dsi-panel-ilitek-ili9881c-cherry-pi.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0008-sp2-imx8mp-patch-lvds-add-panel-generic-lvds-support.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0009-sp2-imx8mp-patch-pwm_backlight-work-around-to-fix-lv.patch
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0010-sp2-imx8mp-patch-ldb-fix-wrong-color-display-by-enab.patch 
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0011-sp2-imx8mp-patch-u-boot-add-fn_key-gpio-input-for-um.patch 
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/vendor/nxp-opensource/uboot-imx/0012-sp2-imx8mp-uboot_android_defconfigs.patch
  ```

- Apply build patches

  ```Shell
  cd  ~/android_bsp/android_build/build  
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/build/0001-Build_can_spi.patch
  
  ```

- Apply external patches 

  ```shell
  cd ~/android_bsp/android_build/external/
  
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/external/0001-external_can_spi_utils.patch 
  ```

  

- Apply  Bionic patches

  ```shell
  cd ~/android_bsp/android_build/bionic/ 
  patch -p1 < ~/android_bsp/imx8mp_android/patches/imx-android-13.0.0_1.2.0./android_build/bionic/0001-Bionic_spi_fix.patch 
  
  ```

  ## To Compile the Android 13 BSP

- After applying all patches, build the source
  
  ```shell
  cd ~/android_bsp/android_build
  source build/envsetup.sh
  lunch sp2_imx8mp-userdebug
  ./imx-make.sh -j3 2>&1 | tee build-log.txt
   
  ```

 

Output Image Path
--------------------------------------

Image will be generate in the  path :  android_build/out/target/product/sp2_imx8mp/



Flash Procedure for Android 13 SP2-IMX8MP
==================================================================


==================================================================

- SP2-IMX8MP Boot setting for SD card boot 1100 

- Connect the 32-GB SD card to the SD card reader on the host machine.

- Find the SD card mounted under /dev/sdx.

  ```shell
  ls /dev/sdx 
  ```

  

- Use the below command to flash the image on SD card.

  ```Shell
  cd ~/android_bsp/android_build/out/target/product/sp2_imx8mp/
  sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 /dev/sdx
  ```

Note: if you come across the make_f2fs error while flashing using imx-sdcard-partition.sh on the SD card 

```
Missing make_f2fs, fallback to erase the metadata partition 
```

- Edit the  imx-sdcard-partion.sh 

  ​               replace mafe_f2fs  with   ../../../host/linux-x86/bin/make_f2fs as shown below
  
  ```shell
  function format_partition
  {
      num=`gdisk -l ${node} | grep -w $1 | awk '{print $1}'`
      if [ ${num} -gt 0 ] 2>/dev/null; then
          get_current_device_base_name
  
          echo "format_partition: $1:${current_device_base_name}${num} ${2:-ext4}"
          if [ "$2" != "f2fs" ]; then
              mkfs.ext4 -F ${current_device_base_name}${num} -L$1
          else
              # check whether make_f2fs exists
              command -v  ../../../host/linux-x86/bin/make_f2fs >/dev/null 2>&1 || { echo -e >&2 "${RED}Missing make_f2fs, fallback to erase the $1 partition ${STD}" ; erase_partition $1 ; return ; }
      
              get_partition_size $1
              randome_part=$RANDOM
              # generate a sparse filesystem image with f2fs type and the size of the partition
              ../../../host/linux-x86/bin/make_f2fs -S $(( g_sizes*1024*1024 )) -g android /tmp/TemporaryFile_${randome_part}
              simg2img /tmp/TemporaryFile_${randome_part} ${current_device_base_name}${num}
              rm /tmp/TemporaryFile_${randome_part}
          fi
      fi
  
  }
  ```
  
  

