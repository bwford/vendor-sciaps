LOCAL_PATH := $(call my-dir)

include $(LOCAL_PATH)/kernel.mk
include $(LOCAL_PATH)/mkfs.mk
include $(LOCAL_PATH)/prebuiltapks.mk

include $(call all-makefiles-under,$(LOCAL_PATH))
