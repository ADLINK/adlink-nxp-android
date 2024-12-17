#!/bin/sh -e

CWD=$(pwd)
PATCHROOTDIR=$(dirname $0)
MACHINE=${1:-sp2_imx8mp}
RELEASE_FILES=$(cat ${CWD}/${PATCHROOTDIR}/filelist.txt | xargs)

usage () {
        echo "Syntax:"
        echo "  gen_release.sh <machine>"
        echo "  please run the gen_release.sh script from android's build directory"
}

if [ -d ${CWD}/out/target/product/${1} ]; then
	cd ${CWD}/out/target/product/${1}
	if [ -f ${CWD}/${PATCHROOTDIR}/Android.zip ]; then
		if [ -d Android ]; then
			rm -rf Android/
		fi
		unzip ${CWD}/${PATCHROOTDIR}/Android.zip
		tar zcvf ../../../../android-13-${1}.tgz ${RELEASE_FILES} Android/
	else
		tar zcvf ../../../../android-13-${1}.tgz ${RELEASE_FILES}
	fi
	cd -
else
	usage
fi

