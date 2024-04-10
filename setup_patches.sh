#!/bin/sh

PATCHROOTDIR=$(dirname $0)
BUILDDIR=${1:-android_build}
CURDIR=$(pwd)

usage () {
        echo "Syntex:"
        echo "  setup_patches.sh [android build directory]"
        echo "  please run the setup_patches.sh script from android's build directory"
}

check_work_dir () {
	case "$CURDIR" in
	*/$BUILDDIR)
		WORKDIR=$CURDIR
		;;
	*)
		usage
		exit 1
		;;
	esac
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
	fi
	if [ -z "$PATCHFILES" ]; then
		echo "No patch files found"
		usage
		exit 1
	fi
}

apply_patch_file () {
	# crop the directory where patch is applying
	TARGET_FILE=${1#*android_build/}
	TARGET_DIR=$(dirname $TARGET_FILE)
	# apply patch
	if [ -d $TARGET_DIR ]; then
		echo "[PATCH] Apply $1 to $TARGET_DIR..."
		patch -p1 -t -d $TARGET_DIR < $1
	else
		echo "No sub-directory: $TARGET_DIR found, cannot patch $1"
	fi
}

check_work_dir
get_patch_files
for pf in $PATCHFILES; do
        apply_patch_file $pf
done

