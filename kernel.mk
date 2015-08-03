.PHONY: kernel cleankernel kernelconfig kernelmodules

KERNEL_UIMAGE := $(KERNEL_DIR)/arch/arm/boot/uImage

$(info kerneldir: $(KERNEL_DIR))

WIFI_DRIVERS := \
	/net/wireless/cfg80211.ko \
	/net/mac80211/mac80211.ko \
	/drivers/net/wireless/wl12xx/wl12xx.ko \
	/drivers/net/wireless/wl12xx/wl12xx_sdio.ko

KERNEL_WIRELESS_MODULES := $(addprefix $(KERNEL_DIR),$(WIFI_DRIVERS))

KERNEL_MODULES := $(PVRSGX_MODULE)

kernelconfig:
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm menuconfig

$(KERNEL_DIR)/.config:
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5014_defconfig

$(KERNEL_UIMAGE): $(KERNEL_DIR)/.config
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm uImage -j8

kernelmodules: $(KERNEL_DIR)/.config
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm modules -j8


kernel: $(KERNEL_UIMAGE) $(KERNEL_MODULES)

cleankernel:
	rm -f $(KERNEL_UIMAGE) $(KERNEL_MODULES)
	cd $(KERNEL_DIR) && make CROSS_COMPILE=arm-eabi- ARCH=arm clean


############### KSP5014 version check ########################################################

KSP5014_VERSIONCHECK_MODULE := kernel/arch/arm/mach-omap2/board-44xx-ksp5014-version.ko

$(KSP5014_VERSIONCHECK_MODULE): kernelmodules


include $(CLEAR_VARS)
LOCAL_MODULE := board-44xx-ksp5014-version.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(KSP5014_VERSIONCHECK_MODULE)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)

############### Wifi Driver ###################################################################

EXTERNAL_WIRELESS_DIR := hardware/ti/wlan/mac80211/compat_wl12xx
EXTERNAL_WIRELESS_MODULES := $(addprefix $(EXTERNAL_WIRELESS_DIR),$(WIFI_DRIVERS))

EXTERN_WIFI_MAKE := out/target/product/$(TARGET_DEVICE)/_externwifi

$(EXTERN_WIFI_MAKE): $(KERNEL_UIMAGE)
	export KERNEL_DIR=$(abspath $(KERNEL_DIR)) && \
	export KLIB=$(abspath $(KERNEL_DIR)) && \
	export KLIB_BUILD=$(abspath $(KERNEL_DIR)) && \
	$(MAKE) -C $(EXTERNAL_WIRELESS_DIR) ARCH=arm CROSS_COMPILE=arm-eabi- && \
	mkdir -p $(dir $(EXTERN_WIFI_MAKE)) && \
	touch $(EXTERN_WIFI_MAKE)

$(EXTERNAL_WIRELESS_MODULES): $(EXTERN_WIFI_MAKE)

WIRELESS_DIR := $(EXTERNAL_WIRELESS_DIR)
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




############### Graphics Driver ###############################################################

PVRSGX_MODULE := out/target/product/$(TARGET_DEVICE)/target/kbuild/pvrsrvkm_sgx540_120.ko

sgx/eurasia_km/INSTALL:
	mkdir -p sgx
	cd sgx && tar xzf ../device/ti/proprietary-open/omap4/sgx_src/eurasia_km.tgz
	touch sgx/eurasia_km/INSTALL


$(PVRSGX_MODULE): $(KERNEL_UIMAGE) sgx/eurasia_km/INSTALL
	cd sgx/eurasia_km/eurasiacon/build/linux2/omap4430_android && \
	export KERNELDIR=$(abspath $(KERNEL_DIR)) && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1 clean && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1

include $(CLEAR_VARS)
LOCAL_MODULE := pvrsrvkm_sgx540_120.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(PVRSGX_MODULE)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)


############### BareBox MLO ##################################################################################
BAREBOX_MLO_CONFIG := barebox/barebox_mlo-2013.06.0/.config

$(BAREBOX_MLO_CONFIG):
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5014_mlo_defconfig

barebox/barebox_mlo-2013.06.0/MLO: $(BAREBOX_MLO_CONFIG)
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm

.PHONY: barebox_mloclean

barebox_mloclean:
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm clean && \
	rm -f MLO && \
	rm -f .config


############### BareBox #####################################################################################
BAREBOX_CONFIG := barebox/barebox-2013.06.0/.config

$(BAREBOX_CONFIG):
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5014_defconfig

barebox/barebox-2013.06.0/barebox.bin: $(BAREBOX_CONFIG)
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm

.PHONY: bareboxclean

bareboxclean:
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm clean && \
	rm -f barebox.bin && \
	rm -f .config
