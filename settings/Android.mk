LOCAL_PATH:= $(call my-dir)


include $(CLEAR_VARS)

LOCAL_MODULE := LIBSSettings
LOCAL_SRC_FILES := LIBSSettings.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

THE_APK := $(LOCAL_PATH)/$(LOCAL_SRC_FILES)

include $(BUILD_PREBUILT)


$(THE_APK):
	curl -o $@ http://jenkins.sciaps.local/job/LIBSSettingsApp/lastSuccessfulBuild/artifact/mainSettingsApp/build/apk/mainSettingsApp-debug-unaligned.apk

