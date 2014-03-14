LOCAL_PATH := $(call my-dir)
TARGET_OUT_WLAN_FW := $(TARGET_OUT_ETC)/firmware/ti-connectivity

FIRMWARE_FILES := $(notdir $(shell find $(LOCAL_PATH) -iname *.bin))

define prebuilt-firmware
include $(CLEAR_VARS)
LOCAL_MODULE := $(1)
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $$(TARGET_OUT_WLAN_FW)
LOCAL_SRC_FILES := $$(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)
endef

$(foreach d,$(FIRMWARE_FILES),$(eval $(call prebuilt-firmware,$d)))


WIRELESS_DIR := hardware/ti/wlan/mac80211/compat_wl12xx
#WIRELESS_DIR := $(KERNEL_DIR)


include $(CLEAR_VARS)
LOCAL_MODULE := mac80211.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(WIRELESS_DIR)/net/mac80211/mac80211.ko
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_MODULE := cfg80211.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(WIRELESS_DIR)/net/wireless/cfg80211.ko
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_MODULE := wl12xx.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(WIRELESS_DIR)/drivers/net/wireless/wl12xx/wl12xx.ko
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_MODULE := wl12xx_sdio.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(WIRELESS_DIR)/drivers/net/wireless/wl12xx/wl12xx_sdio.ko
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)



