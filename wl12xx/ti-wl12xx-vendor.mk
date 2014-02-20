#firmware
PRODUCT_PACKAGES += \
	wl127x-fw.bin \
	wl1271-fw-2.bin \
	wl1271-fw-ap.bin \
	wl127x-fw-3.bin \
	wl127x-fw-4-mr.bin \
	wl127x-fw-4-plt.bin \
	wl127x-fw-4-sr.bin \
	wl1271-nvs.bin \

#wifi drivers
PRODUCT_PACKAGES += \
	mac80211.ko \
	cfg80211.ko \
	wl12xx.ko \
	wl12xx_sdio.ko
