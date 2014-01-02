

KERNEL_DIR := kernel
KERNEL_UIMAGE := $(KERNEL_DIR)/arch/arm/boot/uImage

$(KERNEL_UIMAGE):
	cd $(KERNEL_DIR) && \
	make CROSS_COMPILE=arm-eabi- ARCH=arm pcm049_defconfig && \
    make CROSS_COMPILE=arm-eabi- ARCH=arm uImage -j8

sgx/eurasia_km/INSTALL:
	mkdir -p sgx
	cd sgx && tar xzf ../device/ti/proprietary-open/omap4/sgx_src/eurasia_km.tgz
	touch sgx/eurasia_km/INSTALL


out/target/product/pcm049/target/kbuild/pvrsrvkm_sgx540_120.ko: $(KERNEL_UIMAGE) sgx/eurasia_km/INSTALL
	cd sgx/eurasia_km/eurasiacon/build/linux2/omap4430_android && \
	export KERNELDIR=$(abspath $(KERNEL_DIR)) && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.0 clean && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.0

hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko: $(KERNEL_UIMAGE)
	cd hardware/ti/wlan/mac80211/compat_wl12xx && \
	export KERNEL_DIR=$(abspath $(KERNEL_DIR)) && \
	export KLIB=$(abspath $(KERNEL_DIR)) && \
	export KLIB_BUILD=$(abspath $(KERNEL_DIR)) && \
	make ARCH=arm CROSS_COMPILE=arm-eabi- clean && \
	make ARCH=arm CROSS_COMPILE=arm-eabi-


