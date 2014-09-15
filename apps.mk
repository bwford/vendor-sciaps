
define gradlebuild
#make it phony so its always built
.PHONY: $(1)

$(1):
	cd $(2) && \
	git submodule init && \
	git submodule update && \
	./gradlew clean assemble

include $$(CLEAR_VARS)
LOCAL_MODULE := $(3)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_SRC_FILES := $(1)
include $(BUILD_SYSTEM)/base_rules.mk
$$(LOCAL_BUILT_MODULE) : $$(LOCAL_SRC_FILES) | $$(ACP)
	$$(transform-prebuilt-to-target)

endef


LOCAL_PATH := $(call my-dir)

$(eval $(call gradlebuild,\
	$(LOCAL_PATH)/LIBZAlloyMatch/SciapsLIBS/build/outputs/apk/SciapsLIBS-libz500-hardware-release.apk, \
	$(LOCAL_PATH)/LIBZAlloyMatch, \
	LIBSAlloyMatch \
	))

