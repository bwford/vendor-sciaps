LOCAL_PATH:= $(call my-dir)


include $(CLEAR_VARS)

LOCAL_MODULE := LIBSHome
LOCAL_SRC_FILES := LIBSHome.apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)

LOCAL_OVERRIDES_PACKAGES := Home Launcher2

LIBSHOME_APK := $(LOCAL_PATH)/$(LOCAL_SRC_FILES)

include $(BUILD_PREBUILT)


$(warning $(LIBSHOME_APK))
$(LIBSHOME_APK):
	curl -o $@ http://jenkins.sciaps.local/job/LIBSHomeApp/lastSuccessfulBuild/artifact/app/build/apk/app-release-unsigned.apk


