LOCAL_PATH:= $(call my-dir)

PRIVATE_LOCAL_CFLAGS := -O2 -g -W -Wall         \
                        -Wno-error=unused-parameter

#
# hciconfig
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	csr.c \
	csr_h4.c \
	hci.c \
	textfile.c \
	hciconfig.c

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/libs/ \
	$(LOCAL_PATH)/libs/include/ \
	$(LOCAL_PATH)/common/

LOCAL_CFLAGS:= \
	-DSTORAGEDIR=\"/tmp\" \
	-DVERSION=\"3.36\" \
	-Wno-error=unused-parameter \
	-Wno-error=missing-field-initializers

LOCAL_SHARED_LIBRARIES := \
	libbluetooth

#LOCAL_STATIC_LIBRARIES := \
#	libbluez-utils-common-static

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE:=hciconfig

include $(BUILD_EXECUTABLE)

#
# hcitool
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	hci.c \
	oui.c \
	textfile.c \
	hcitool.c

LOCAL_C_INCLUDES:= \
	$(LOCAL_PATH)/libs/ \
	$(LOCAL_PATH)/libs/include/ \
	$(LOCAL_PATH)/common/

LOCAL_CFLAGS:= \
	-DSTORAGEDIR=\"/tmp\" \
	-DVERSION=\"3.36\" \
	-Wno-error=unused-parameter \
	-Wno-error=missing-field-initializers

LOCAL_SHARED_LIBRARIES := \
	libbluetooth

#LOCAL_STATIC_LIBRARIES := \
#	libbluez-utils-common-static

LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
LOCAL_MODULE:=hcitool

include $(BUILD_EXECUTABLE)
