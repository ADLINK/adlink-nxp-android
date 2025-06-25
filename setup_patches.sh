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
			git reset --hard HEAD^
			cd -
		fi
	done
}

apply_patch_file () {
	WORKDIR=$(pwd)
	for pf in $PATCHFILES; do
		# crop the directory where patch is applying
		TARGET_FILE=${pf#*android_build/}
		TARGET_DIR=$(dirname $TARGET_FILE)
		# apply patch
		if [ -d $TARGET_DIR ]; then
			cd $WORKDIR/$TARGET_DIR
			echo "[PATCH] Apply $WORKDIR/$pf to $TARGET_DIR..."
			git am -3 --ignore-whitespace $WORKDIR/$pf
			cd -
		else
			echo "No sub-directory: $TARGET_DIR found, cannot patch $WORKDIR/$pf"
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

