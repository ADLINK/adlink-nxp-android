#!/bin/sh -e

CWD=$(pwd)
PATCHROOTDIR=$(cd "$(dirname "$0")" && pwd)
MACHINE=${1:-lec_imx95}

usage () {
	echo "Syntax:"
	echo "  gen_release.sh <machine>"
	echo "  e.g. gen_release.sh lec_imx95   (uses imx95_filelist.txt)"
#	echo "       gen_release.sh lec_imx8mp  (uses imx8mp_filelist.txt)"
	echo "  please run the gen_release.sh script from android's build directory"
}

# Derive the SoC name from the machine name by stripping everything up to
# the first underscore: lec_imx95 -> imx95, lec_imx8mp -> imx8mp
SOC=${MACHINE#*_}
FILELIST=${PATCHROOTDIR}/${SOC}_filelist.txt

if [ ! -f "${FILELIST}" ]; then
	echo "Error: file list not found: ${FILELIST}"
	usage
	exit 1
fi

PRODUCT_DIR=${CWD}/out/target/product/${MACHINE}
if [ ! -d "${PRODUCT_DIR}" ]; then
	echo "Error: product directory not found: ${PRODUCT_DIR}"
	usage
	exit 1
fi

RELEASE_FILES=$(xargs < "${FILELIST}")
# lec_imx95 -> adlink-lec-imx95-android-baklava.zip
MACHINE_NAME=$(echo "${MACHINE}" | tr '_' '-')
OUT_ZIP=${CWD}/adlink-${MACHINE_NAME}-android-baklava.zip

echo "Machine   : ${MACHINE}"
echo "File list : ${FILELIST}"
echo "Output    : ${OUT_ZIP}"

rm -f "${OUT_ZIP}"

cd "${PRODUCT_DIR}"
if [ -f "${PATCHROOTDIR}/Android.zip" ]; then
	rm -rf Android/
	unzip "${PATCHROOTDIR}/Android.zip"
	zip -r "${OUT_ZIP}" ${RELEASE_FILES} Android/
else
	zip -r "${OUT_ZIP}" ${RELEASE_FILES}
fi
cd "${CWD}"
