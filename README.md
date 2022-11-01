ADLINK LEC-iMX8MP 2GB module with iPI SMARC plus Android 11
=========================================================================

Platform        : LEC-iMX8MP Android
================================================
Kernel version  : 5.10.72
================================================

Change log:
===========
2v0 (18 August 2022)
---------------------
 + USB Device Support is added
 + USB Debugging support is enabled
 + HDMI Audio / WM8960 Audio support is added
 + WiFi Hotspot is added
 + Bluetooth on Linux driver using hciconfig and hcitool
 + adlink_pwm command added.
 + PCIe host tested using lspci 
 + WiFi Driver functioning on Android.
 + Added WiFi Driver - Able to scan WiFi networks using iw utility
 + Added spitest
 + Enabled WM8960 Audio Interface
 + Enabled I2C Interface
 + Enabled CAN Interface
 + Enabled SPI Interface
 + Enabled PCIe
 + Added support for FEC Ethernet controller in U-Boot
 + Added support for USB adb in Android
 + RAM memory updated to 4 GB
 + imx-dwmac ethernet enabling issue fixed
 + Interfaces tested:
	- USB 2.0 and 3.0 ports
	- HDMI display
	- Ethernet (FEC and imx-DWMAC)
	- Micro SD interface
	- Onboard eMMC device


Supported interfaces:
=====================
 - Serial console
 - USB 2.0 and 3.0
 - HDMI display
 - Ethernet (FEC and imx-DWMAC)
 - Micro SD interface
 - OnBoard eMMC device
 - Android adb support on micro USB port
 - I2C interface
 - CAN interface
 - SPI interface
 - GPIO on expansion connector
 - GPIO PWM on expansion connector
 - WM8960 Audio codec
 - Wifi/BT
 - rtc 

Flashing the image and booting:
===============================
1. On a linux host machine, insert the micro SD card (through an USB adapter).
2. Ensure, the device node of the micro SD card using dmesg.
3. Change to the release and bin directory.
4. Execute the command for a 32 GB Micro-SD card:
  # sudo ./imx-sdcard-partition.sh -f imx8mp -c 28 /dev/sdX

</dev/sdX need to be changed to actual device node of the micro SD card>

For more details, please refer: https://www.nxp.com/docs/en/user-guide/ANDROID_USERS_GUIDE.pdf

Interface details:
==================
1. FEC in U-Boot:
 - Press any key to break into U-Boot command prompt.
 - Execute, the below commands (The following are provided as an example, please change appropriately)
       => setenv ipaddr 192.168.2.126
       => setenv serverip 192.168.2.5
       => setenv netmask 255.255.255.0
       => setenv ethaddr 00:a8:44:1f:1f:10

2. Running adb:
 - After the Board Booted up, connect the micro USB port on the ADLINK board with the Host system using a Micro USB cable.
 - On a Ubuntu machine, install adb
 - Execute the below command:
   # sudo adb usb
   # sudo adb shell ls <to list the current directory on the Android board>



Readme Contents
=================================================

   1. Hardware setup
   2. Package structure
   3. Steps to boot with prebuilts
   4. Peripheral testing
      4.1. USB type A ports
      4.2. Micro USB (Device mode)
      4.3. HDMI
      4.4. UART
      4.5. WM8960 Audio codec
      4.6. GPIO on expansion connector
      4.7. PWM GPIO
      4.8. SPI on expansion connector
      4.9. CAN interface
      4.10. RTC
      4.11. Wifi/BT

1) Hardware setup
=================================================

 Module		- LEC-iMX8MP
 Base		- ADLINK LEC-iMX8MP
 Host Machine 	- Linux Ubuntu


2) Package structure
=================================================

  |----- ADLINK_LEC_IMX8MP_2G_ANDROID_11_1V15
	  |----- bin           // android images
    	  |----- Readme.txt


3) Steps to boot with prebuilts
=================================================

------------------------------------------------------
3.1 Using SD card image
------------------------------------------------------

The SD card image packs bootloader, kernel and android file
system. Follow below steps:

  1. Unzip release package ADLINK_LEC_IMX8MP_4G_ANDROID_11_1V15
  2. Go to directory ADLINK_LEC_IMX8MP_4G_ANDROID_11_1V15/bin
  3. insert an sdcard
  4. Run the imx-sdcard-partition.sh

Note: First boot from SD card can be slow. Subsequent boots will
be faster


4) Peripheral testing
=================================================

-------------------------------------------------
4.1 USB Type A
-------------------------------------------------

 All USB type A ports are validated.

 Any storage device connected on these ports will be mounted at
 /mnt/media_rw/. Device can also be accessed from Android GUI.

---------------------------------------------------
4.2 Micro USB (Device mode)
---------------------------------------------------

 Connect micro USB cable to access device in client mode.
 Devices can be accessed using adb commands.

-------------------------------------------------
4.3 HDMI
-------------------------------------------------

  HDMI function is enabled by default.


-------------------------------------------------
4.4 UART
-------------------------------------------------

 Connect UART cable on expansion connector to get android boot logs.
 Pin connection:
     pin 8  - UART TX
     pin 10 - UART RX
     pin 9  - GND


-------------------------------------------------
4.5 WM8960 Audio Codec
-------------------------------------------------

Connect headphone on the jack, execute the following command to play on headphone
tinyplay <wav file> -D 1

To play the wav file on HDMI, execute the command below
tinyplay <wav file> -D 0

-------------------------------------------------
4.6 GPIO on Expansion Connector
-------------------------------------------------

 GPIO on Exapnsion connector (CN1001) can be used using following commands:
        => cd /sys/class/gpio/
        => echo GPIO_NUM > export
        => cd gpio<GPIO_NUM>
        => echo out > direction ("out" is to enable pin as ouput, "in" for input)
        => echo 1 > value ("1" to drive high, "0" to drive low)

 The GPIO_NUM mentioned above are mapped to following pin numbers:

 The GPIO_NUM mentioned above are mapped to following pin numbers:

 Pin on expansion  		   Gpio number
    pin7		     	-   	 497
    pin11			-	 499
    pin12			-   	 498
    pin13			-   	 500
    pin15			-   	 501
    pin16  		        -    	 502
    pin18   	 		-   	 503
    pin22 	   		-   	 504
    pin29			-   	 461
    pin31			-   	 462
    pin32			-   	 463
    pin33			-   	 464
    pin35			-   	 465
    pin36			-   	 466
    pin37			-   	 467
    pin38			-   	 468
    pin40			-   	 469


-------------------------------------------------
4.7 PWM GPIO's
-------------------------------------------------

Few gpio on expansion connector has additional PWM
feature via SX1509 I/O expander. Following pins support
pwm:
    29, 31, 32, 33, 35, 36, 37, 38, 40

adlink_pwm utility can be used to generate pwm
signal on above gpio. Use below command to turn
on pwm:
   adlink_pwm <pin> <state> <duty>

eg: for 30% duty cycle on pin 29:
       # adlink_pwm 29 ON 30
    to turn of pwm on pin 29:
       # adlink_pwm 29 OFF


-------------------------------------------------
4.8 SPI on expansion connector (CN1602)
-------------------------------------------------
 SPI on expansion connected is enabled. Follow below procedure:

 1. In connect CN1602, Connect pin27 (MOSI) and pin28 (MISO) on expansion connecter
 2. Run the below command to send a dummy message on spi line:
	# spidev_test -D /dev/spidev1.0 -v


-------------------------------------------------
4.9 CAN interface (CN1602)
-------------------------------------------------

Setup CAN0 & CAN1 Loop : Conn CN1602 => connect 13 & 14, 15 & 16

Sender should execute below commands:

1) Configure the CAN0 ports as
   # ip link set can0 type can bitrate 500000
   # ip link set can0 up

2) Configure the CAN1 ports as
   # ip link set can1 type can bitrate 500000
   # ip link set can1 up

3) Dump CAN data on can0:
   # candump can0 &

4) Send data over can1:
   # cansend can1 01a#11223344AABBCCDD

Now send data will be dump back on CAN0.

-------------------------------------------------
4.10 RTC
-------------------------------------------------

If connected to network android will update date/time from network
service. Date/time settings in android available under:
   Settings => system => Date&Time

To disable network update uncheck "Use network-provided time".

Now if date/time is manually set it can be stored to RTC using
below command:
     $ hwclock -w

Current data/time stored in RTC can be read as:
     $ hwclock

-------------------------------------------------
4.11 Wifi/BT 
-------------------------------------------------

AW-CM276NF Wifi/BT support. Wifi is working with Android UI.
BT works using bluez utils hciconfig & hcitool.



