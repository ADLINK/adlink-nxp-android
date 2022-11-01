LOCAL_PATH := $(call my-dir)

PRIVATE_LOCAL_CFLAGS := -O2 -g -W -Wall		\
			-Wno-error=unused-parameter

#
# spidev_test
#

include $(CLEAR_VARS)

LOCAL_SRC_FILES := adlink_pwm.c \
		   gpiopwm_routines.c
LOCAL_MODULE := adlink_pwm
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := $(LOCAL_PATH)
LOCAL_CFLAGS := $(PRIVATE_LOCAL_CFLAGS)
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)
