#!/bin/sh

PATCHROOTDIR=$(dirname $0)

usage () {
        echo "Syntax:"
        echo "  setup_patches.sh [clear]"
        echo "  please run the setup_patches.sh script from android's build directory"
}

get_patch_files () {
	if [ -d $PATCHROOTDIR/patches ]; then
		PATCHDIR=$(find $PATCHROOTDIR/patches -type d -name android_build)
	fi
	if [ -z "$PATCHDIR" ]; then
		echo "No directory containing the patches"
		usage
		exit 1
	fi
	if [ -d $PATCHDIR ]; then
		PATCHFILES=$(find $PATCHDIR -name "*.patch" | sort)
		PATCHREVERSE=$(find $PATCHDIR -name "*.patch" | sort -r)
	fi
	if [ -z "$PATCHFILES" ]; then
		echo "No patch files found"
		usage
		exit 1
	fi
}

clear_previous_patch () {
	echo $PATCHREVERSE
	for pf in $PATCHREVERSE; do
		# crop the directory where patch is applying
		TARGET_FILE=${pf#*android_build/}
		TARGET_DIR=$(dirname $TARGET_FILE)
		# un-patch
		if [ -d $TARGET_DIR ]; then
			cd $TARGET_DIR
			case "$TARGET_DIR" in
			*bionic)
				echo "git checkout -f 5630078b73dbd1ecce85868ca9766f64709f3354"
				git checkout -f 5630078b73dbd1ecce85868ca9766f64709f3354
				;;
			*external)
				echo "rm -rf spidevtest/ canutils/"
				rm -rf spidevtest/ canutils/
				;;
			*build)
				echo "patch -r -p1 < ../$pf"
				patch -r -p1 < ../$pf
				;;
			*device/nxp)
				rm -fr imx8m/sp2_imx8mp/
				echo "git checkout -f f0c720836e6526d305ad0afda0be6d825be8d07f"
				git checkout -f f0c720836e6526d305ad0afda0be6d825be8d07f
				;;
			*vendor/nxp-opensource/kernel_imx)
				rm -fr arch/arm64/boot/ arch/arm64/configs/
				echo "git checkout -f 1daca5e35461400d33b72e067cfd7d613cc5587b"
				git checkout -f 1daca5e35461400d33b72e067cfd7d613cc5587b
				;;
			*vendor/nxp-opensource/uboot-imx)
				rm -rf board/adlink include/msgpack/ lib/msgpack/
				rm -rf arch/arm/ cmd/ configs/ drivers/video/ include/
				echo "git checkout -f 20eaeb1407cc9c562fb549e51dfd0d4f7e180bba"
				git checkout -f 20eaeb1407cc9c562fb549e51dfd0d4f7e180bba
				;;
			esac
			cd -
		fi
	done
}

apply_patch_file () {
	for pf in $PATCHFILES; do
		# crop the directory where patch is applying
		TARGET_FILE=${pf#*android_build/}
		TARGET_DIR=$(dirname $TARGET_FILE)
		# apply patch
		if [ -d $TARGET_DIR ]; then
			echo "[PATCH] Apply $pf to $TARGET_DIR..."
			patch -p1 -t -d $TARGET_DIR < $pf
		else
			echo "No sub-directory: $TARGET_DIR found, cannot patch $pf"
		fi
	done
}

usage
get_patch_files
if [ "$1" = "clear" ]; then
	echo "clear patch"
	clear_previous_patch
else
	echo "apply patch"
	apply_patch_file
fi

