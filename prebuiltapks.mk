
.PHONY: cleanPrebuiltApks

LOCAL_PATH := $(call my-dir)

PREBUILT_APKS := $(addprefix $(LOCAL_PATH)/, alloymatch/LIBSAlloyMatch.apk home/LIBSHome.apk, settings/LIBSSettings.apk)

cleanPrebuiltApks:
	rm -f $(PREBUILT_APKS)
