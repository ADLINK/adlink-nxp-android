# Android 16 for ADLINK LEC-iMX95

## Contents

```
1. Hardware Details
2. Software Details
3. Package structure
4. Flashing the image and booting
   4.1.  SD boot
   4.2.  eMMC boot
5. Peripheral testing
   5.1.  USB type A ports
   5.2.  Micro USB (Device mode)
   5.3.  HDMI
   5.4.  SER1 - Console
   5.5.  SER3 - RS232
   5.5.  SER0 - TTL
   5.7.  GPIO on expansion connector
   5.8.  Audio codec tvl320
   5.9.  SPI on expansion connector
   5.10. CAN interface
   5.11. RTC
   5.12. TPM
   5.13. PCIE
   5.14. Ethernet
   5.15. WiFi/BT
   5.16. LVDS display
   5.17. MIPI display
```

## 1 Hardware Details

| Base | I-Pi SMARC Plus |
|:----------------|:-----------|
| **Module** | **LEC-iMX95** |

## 2 Software Details
|   Android   |   Ver  15   |
|:-----------:|:-----------:|
| **Kernel**  | **6.18.21** |
| **U-Boot**  | **2026.04** |
| **Host OS** | **Ubuntu 22.04.4** |


## 3 Package structure

 ```
  |---adlink-lec-imx95-android-baklava_V2_R1_260928
     |--- android images
     |--- README.md
 ```
- Download Android release (adlink-lec-imx95-android-baklava_V2_R1_260928.zip) and extract it.


## 4 Flashing the Image and Booting

### 4.1 SD Boot

#### Host preparation

1. On a linux host machine, insert the micro SD card (through an USB adapter).

2. Check the device node of the micro SD card using dmesg command.

3. Move into android release directory ```adlink-lec-imx95-android-baklava_V2_R1_260928```

   ```
   $ sudo cp tools/lib64/libc++.so /lib/x86_64-linux-gnu
   $ sudo chmod +x /lib/x86_64-linux-gnu/libc++.so
   ```

   ```
   $ sudo apt-get install android-sdk-libsparse-utils
   $ sudo cp tools/bin/make_f2fs /usr/bin
   $ sudo chmod +x /usr/bin/make_f2fs /usr/bin/simg2img
   ```

#### Flash image to SD card

* Execute the following command for a 32 GB Micro-SD card.
   ```
   $ sudo ./imx-sdcard-partition.sh -f imx95 /dev/sdX
   ```
* /dev/sdX need to be changed to actual device node of the micro SD card

* For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pd

  Note: First boot from SD card can be slow,subsequent boot will be faster


### 4.2 eMMC Boot

#### Download uuu utility

 - Download uuu utility and copy to /usr/bin

 - https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.243/uuu

   ```
   $ sudo cp ~/Downloads/uuu /usr/bin
   $ sudo chmod +x /usr/bin/uuu
   ```

#### Boot into Recovery Mode

 * Set the boot switch into recovery mode.
 * Connect USB OTG cable to host.
 * Power on the board.

#### Flash image to eMMC

* Execute the following command to start flashing Android image to eMMC.

   ```
   $ sudo ./uuu_imx_android_flash.sh -f imx95 -e 
   ```

* Once flashing completed, power off the board and change boot settings to eMMC mode.
* Power on the board to boot Android from eMMC.


## 5 Peripheral testing
### 5.1 USB Type A

* All USB type A ports are validated.
* Any storage device connected on these ports will be mounted at "/mnt/media_rw" location.
* Device can also be accessed from Android GUI.


### 5.2 Micro USB (Device mode)

 * Not supported due to Hardware Limitation.

### 5.3 HDMI

HDMI function is enabled by default.

### 5.4 SER1 - Console

* Connect RS232 compatible UART cable to CN1609 expansion connector.
* Connect UART cable to CN1609 expansion connector to get android boot logs.

 Pin connection:

| Pin  | Function |
|:----:|:--------:|
| 1 | UART RX |
| 3 | UART TX |
| 5 | GND     |

### 5.5 SER3 - RS232
* Connect RS232 compatible UART cable to CN1609 expansion connector.

| Pin  | Function |
| :--: | :------: |
|  2   | UART RX  |
|  4   | UART TX  |
|  6   |   GND    |


#### UART Tx Test
* Open minicom, 115200 baudrate with no hardware flow control setting.
* Run the below commands from adb shell to transmit data to Minicom.
   ```
   $ stty -F /dev/ttyLP1 115200 cs8 -cstopb -parenb
   $ echo 'ADLINK' > /dev/ttyLP1
   ```
   'ADLINK' string will be displayed in minicom

#### UART Rx Test
* Run below command in adb shell
   ```
   $ cat /dev/ttyLP1
   ```
   Type some data and press enter in Minicom.
   The data will be received in serial console.

### 5.6 SER0 - TTL

* Console UART works at TTL level. Use TTL compatible USB Serial adapter to get logs.

Pin connection CN1001:

| Pin  | Function |
|:----:|:--------:|
| 10 | UART RX |
| 8  | UART TX |
| 6  | GND     |


#### UART Tx Test
* Open minicom, 115200 baudrate with no hardware flow control setting.
* Run the below commands from adb shell to transmit data to Minicom.
   ```
   $ stty -F /dev/ttyLP6 115200 cs8 -cstopb -parenb
   $ echo 'ADLINK' > /dev/ttyLP6
   ```
   'ADLINK' string will be displayed in minicom

#### UART Rx Test
* Run below command in adb shell
   ```
   $ cat /dev/ttyLP6
   ```
   Type some data and press enter in Minicom.
   The data will be received in serial console.

### 5.7 GPIO on Expansion Connector

 GPIO on expansion connector (CN1001) can be accessed using following commands:

```
$ gpioset <gpio chip> <gpio num>=<0|1>
```

 The GPIO_NUM mentioned above are mapped to following pin numbers:

| Pin on expansion | Gpio Chip    | Gpio number |
|:----------------:|:------------------:|:---------------:|
|      29       |    gpiochip4    |    0    |
|      31       |    gpiochip4    |    1    |
|      32       |    gpiochip4    |    2    |
|      33       |    gpiochip4    |    3    |
|      35       |    gpiochip4    |    4    |
|      36       |    gpiochip4    |    5    |
|      37       |    gpiochip4    |    6    |
|      38       |    gpiochip4    |    7    |
|      40       |    gpiochip4    |    8    |

### 5.8 Audio codec tvl320
 Increase the volume on settings
 To record and play recorded audio, connect a microphone and utilise the Sound Recorder App from Android UI.


### 5.9 SPI on expansion connector
 Two instances of SPI are available for user.

 Follow below procedure to perform loop-back test:

#### SPI1 Loopback test
* Connect Pin 19 and 21 in CN1001 connector
* Run below command to send and receive data over SPI1
    ```
    $ spidevtest -D /dev/spidev1.0 -v
    ```

### 5.10 CAN interface (CN1602)

Setup CAN0 & CAN1 Loopback: Connect Pins (13 - 14) and (15 - 16) in CN1602 connector.

Sender should execute below commands:

1. Configure the CAN0 ports as
   ```
   $ ip link set can0 type can bitrate 500000
   $ ip link set can0 up
   ```
2. Configure the CAN1 ports as
   ```
   $ ip link set can1 type can bitrate 500000
   $ ip link set can1 up 
   ```

3. Dump CAN data on can0:
   ```
   $ candump can0 &
   ```

4. Send data over can0:
   ```
   $ cansend can1 01a#11223344AABBCCDD
   ```

    Now, data sent from CAN0 will be dumped on CAN Analyzer.


### 5.11 RTC

While connected to network on Android we can  update date/time from UI by using below steps :

* Using Android UI Go -> Setting > System> Date & time -> Region
* Under Time zone , Select Time Zone -> Region.
* Time would updated , Disconnect from network (Ethernet )
* Now power off the target for some time
* Power on and check the time,Time would be updated.

### 5.12 TPM
  ```
  # su
  # eltt2 -cgv
  ```
### 5.13 PCIE
  ```
  # su
  # lspci
  ```

### 5.14 Ethernet

#### 5.14.1 Ethernet in u-boot
 * Press any key to break into U-Boot command prompt.
 * Execute the below commands to configure u-boot network (The following are provided as an example, please change appropriately)
##### ETH0 
   ```
   u-boot=> usb start
   u-boot=> net list
   eth0 : enetc-0 00:30:64:7e:57:54 active
   eth1 : enetc-1 00:30:64:7e:57:57 
   # initate Dhcp eth0
   u-boot=> dhcp eth0
   BOOTP broadcast 1
   BOOTP broadcast 2
   BOOTP broadcast 3
   *** Unhandled DHCP Option in OFFER/ACK: 224
   *** Unhandled DHCP Option in OFFER/ACK: 224
   DHCP client bound to address 192.168.1.74 (1024 ms)
   *** ERROR: `serverip' not set
   Cannot autoload with TFTPGET
   # Ping test
   u-boot=> ping 192.168.1.1
   Using enetc-0 device
   host 192.168.1.1 is alive
   ```
##### ETH1 
```
# initiate Dhcp eth1
  u-boot=> dhcp eth1 
  BOOTP broadcast 1
  BOOTP broadcast 2
  BOOTP broadcast 3
  *** Unhandled DHCP Option in OFFER/ACK: 224
  *** Unhandled DHCP Option in OFFER/ACK: 224
  DHCP client bound to address 192.168.1.82 (1266 ms)
  *** ERROR: `serverip' not set
  Cannot autoload with TFTPGET
  u-boot=> ping 192.168.1.1
  Using enetc-1 device
  host 192.168.1.1 is alive
```

#### 5.14.2 Ethernet in Android

  Android supports both Ethernet
  Open Settings -> Network & internet -> Internet -> Ethernet to view details of ETH0/ETH1 port
  Ethernet configuration can be obtained by running ifconfig command from adb shell

#### 5.15. Wifi/BT
  SDIO(Wi-Fi) AW-CM276NF
  WiFi/BT supported in Android and functionalities can be realised by using Android Settings.

### 5.16. LVDS display

* LVDS feature can be enabled by adding '-d lvds-panel' to flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx95 -d lvds-panel /dev/sdX```
to prepare SD card with LVDS feature enabled

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx95 -e -d lvds-panel```
to flash image to eMMC with LVDS feature enabled

### 5.17. MIPI display

* MIPI Display feature can be enabled by adding '-d mipi-panel' to flash command.

Example:

* Run ```$ sudo ./imx-sdcard-partition.sh -f imx95 -d mipi-panel /dev/sdX```
to prepare SD card with MIPI Display feature enabled

* Run ```$ sudo ./uuu_imx_android_flash.sh -f imx95 -e -d mipi-panel```
to flash image to eMMC with MIPI Display feature enabled
