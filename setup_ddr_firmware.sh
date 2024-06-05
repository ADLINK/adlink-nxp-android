#!/bin/bash

SOC=${1:-imx8mp}
DDR_FW_VER="8.12" #refer to the name of 'firmware-imx-8.10.inc'
FSL_MIRROR="https://www.nxp.com/lgfiles/NMG/MAD/YOCTO"
MKIMAGE_DIR="imx-mkimage"

setup_platform()
{
	case "${SOC}" in
	imx8mn)
		PLATFORM="imx8mn"
		SOC_DIR="iMX8M"
		;;
	imx8mm)
		PLATFORM="imx8mm"
		SOC_DIR="iMX8M"
		;;
	imx8mp)
		PLATFORM="imx8mp"
		SOC_DIR="iMX8M"
		;;
	imx8mq)
		PLATFORM="imx8mq"
		SOC_DIR="iMX8M"
		;;
	imx8m)
		PLATFORM="imx8mq"
		SOC_DIR="iMX8M"
		;;
	default)
		printf "Targest SOC isn't supported by this script\n"
		exit 1
		;;
	esac
	printf "SOC: ${SOC}, PLATFORM: ${PLATFORM} SOC_DIR: ${SOC_DIR}\n"
}

setup_patform

if [ ! -d firmware-imx-${DDR_FW_VER} ] ; then
	wget ${FSL_MIRROR}/firmware-imx-${DDR_FW_VER}.bin && \
	chmod +x firmware-imx-${DDR_FW_VER}.bin && \
	./firmware-imx-${DDR_FW_VER}.bin || \
	printf "Fails to fetch DDR firmware \n"
fi

if [ -d firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys ] ; then
	if [ ${PLATFORM} = "imx8mp" ] ; then
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem_202006.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_imem_202006.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_dmem_202006.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_imem_202006.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
	else
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_imem.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_dmem.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
		cp firmware-imx-${DDR_FW_VER}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_imem.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
	fi
	cp firmware-imx-${DDR_FW_VER}/firmware/hdmi/cadence/signed_hdmi_imx8m.bin vendor/nxp-opensource/${MKIMAGE_DIR}/${SOC_DIR}
else
	printf "Cannot find DDR firmware \n"
fi

if [ -e firmware-imx-${DDR_FW_VER}.bin ]; then
  rm -rf ./firmware-imx-${DDR_FW_VER}.bin
fi
if [ -d firmware-imx-${DDR_FW_VER} ]; then
  rm -rf ./firmware-imx-${DDR_FW_VER}
fi

