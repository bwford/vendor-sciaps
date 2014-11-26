LOCAL_PATH := $(call my-dir)


TARGET_OUT_WLAN_FW := $(TARGET_OUT_ETC)/firmware/ti-connectivity

FIRMWARE_FILES := $(notdir $(shell find $(LOCAL_PATH) -iname *.bin))

define prebuilt-firmware
include $$(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $$(TARGET_OUT_WLAN_FW)
LOCAL_SRC_FILES := $$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
include $$(BUILD_PREBUILT)

endef

$(foreach d,$(FIRMWARE_FILES),$(eval $(call prebuilt-firmware,$d)))



include $(call all-makefiles-under, $(LOCAL_PATH))