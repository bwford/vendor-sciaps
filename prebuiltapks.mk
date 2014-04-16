
.PHONY: cleanPrebuiltApks

LOCAL_PATH := $(call my-dir)

PREBUILT_APKS := $(addprefix $(LOCAL_PATH)/, settings/LIBSSettings.apk)

cleanPrebuiltApks:
	rm -f $(PREBUILT_APKS)
