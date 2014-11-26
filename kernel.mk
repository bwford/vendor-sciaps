.PHONY: kernel cleankernel kernelconfig kernelmodules

KERNEL_UIMAGE := $(KERNEL_DIR)/arch/arm/boot/uImage
PVRSGX_MODULE := out/target/product/$(TARGET_DEVICE)/target/kbuild/pvrsrvkm_sgx540_120.ko
KSP5012_VERSIONCHECK_MODULE := kernel/arch/arm/mach-omap2/board-omap4ksp5012-version.ko

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
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5012_defconfig

$(KERNEL_UIMAGE): $(KERNEL_DIR)/.config
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm uImage -j8

kernelmodules: $(KERNEL_DIR)/.config
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm modules -j8

$(KERNEL_WIRELESS_MODULES): kernelmodules

$(KSP5012_VERSIONCHECK_MODULE): kernelmodules

sgx/eurasia_km/INSTALL:
	mkdir -p sgx
	cd sgx && tar xzf ../device/ti/proprietary-open/omap4/sgx_src/eurasia_km.tgz
	touch sgx/eurasia_km/INSTALL


$(PVRSGX_MODULE): $(KERNEL_UIMAGE) sgx/eurasia_km/INSTALL
	cd sgx/eurasia_km/eurasiacon/build/linux2/omap4430_android && \
	export KERNELDIR=$(abspath $(KERNEL_DIR)) && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1 clean && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.1 -j8

include $(CLEAR_VARS)
LOCAL_MODULE := pvrsrvkm_sgx540_120.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(PVRSGX_MODULE)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_MODULE := board-omap4ksp5012-version.ko
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/modules
LOCAL_SRC_FILES := $(KSP5012_VERSIONCHECK_MODULE)
include $(BUILD_SYSTEM)/base_rules.mk
$(LOCAL_BUILT_MODULE) : $(LOCAL_SRC_FILES) | $(ACP)
	$(transform-prebuilt-to-target)


.PHONY: wirelesskm
EXTERNAL_WIRELESS_DIR := hardware/ti/wlan/mac80211/compat_wl12xx
EXTERNAL_WIRELESS_MODULES := $(addprefix $(EXTERNAL_WIRELESS_DIR),$(WIFI_DRIVERS))

wirelesskm: $(KERNEL_UIMAGE)
	cd $(EXTERNAL_WIRELESS_DIR) && \
	export KERNEL_DIR=$(abspath $(KERNEL_DIR)) && \
	export KLIB=$(abspath $(KERNEL_DIR)) && \
	export KLIB_BUILD=$(abspath $(KERNEL_DIR)) && \
	make ARCH=arm CROSS_COMPILE=arm-eabi-

$(EXTERNAL_WIRELESS_MODULES): wirelesskm

kernel: $(KERNEL_UIMAGE) $(KERNEL_MODULES)

cleankernel:
	rm -f $(KERNEL_UIMAGE) $(KERNEL_MODULES)
	cd $(KERNEL_DIR) && make CROSS_COMPILE=arm-eabi- ARCH=arm clean


############### BareBox MLO ###############
BAREBOX_MLO_CONFIG := barebox/barebox_mlo-2013.06.0/.config

$(BAREBOX_MLO_CONFIG):
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5012_mlo_defconfig

barebox/barebox_mlo-2013.06.0/MLO: $(BAREBOX_MLO_CONFIG)
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm

.PHONY: barebox_mloclean

barebox_mloclean:
	cd barebox/barebox_mlo-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm clean


############### BareBox ####################
BAREBOX_CONFIG := barebox/barebox-2013.06.0/.config

$(BAREBOX_CONFIG):
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm ksp5012_defconfig

barebox/barebox-2013.06.0/barebox.bin: $(BAREBOX_CONFIG)
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm

.PHONY: bareboxclean

bareboxclean:
	cd barebox/barebox-2013.06.0 && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm clean