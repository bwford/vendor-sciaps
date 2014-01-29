.PHONY: cleanrootfs mkrootfs

STAGING_DIR := out/target/product/pcm049/rootfs_staging
STAGING_DIR_TS := out/target/product/pcm049/stagingts
ROOTFS_TAR := rootfs.tar.bz2
ROOT_UBI_IMG := root.ubi

$(STAGING_DIR_TS):
	mkdir -p $(STAGING_DIR)
	mkdir -p $(STAGING_DIR)/system/lib/modules
	cp -r out/target/product/pcm049/root/* $(STAGING_DIR)
	cp -r out/target/product/pcm049/system $(STAGING_DIR)
	cp -r out/target/product/pcm049/data $(STAGING_DIR)
	cp out/target/product/pcm049/target/kbuild/pvrsrvkm_sgx540_120.ko $(STAGING_DIR)/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/compat/compat.ko $(STAGING_DIR)/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko $(STAGING_DIR)/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/net/mac80211/mac80211.ko $(STAGING_DIR)/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx.ko $(STAGING_DIR)/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx_sdio.ko $(STAGING_DIR)/system/lib/modules
	cp $(STAGING_DIR)/system/etc/firmware/ti-connectivity/wl1271-nvs_127x.bin $(STAGING_DIR)/system/etc/firmware/ti-connectivity/wl1271-nvs.bin
	touch $(STAGING_DIR_TS)

$(ROOTFS_TAR): $(STAGING_DIR_TS)
	build/tools/mktarball.sh out/host/linux-x86/bin/fs_get_stats $(STAGING_DIR) . rootfs.tar $(ROOTFS_TAR)

mkrootfs: $(STAGING_DIR_TS)

cleanrootfs:
	rm -rf $(STAGING_DIR)
	rm -f $(STAGING_DIR_TS)


$(ROOT_UBI_IMG) root.ubifs: $(ROOTFS_TAR)
	$(eval TMP := $(shell mktemp -d))
	cd $(TMP) && tar -xpf $(abspath $(ROOTFS_TAR))
	mkfs.ubifs -r $(TMP) -m 2048 -c 3888 -e 126976 -o root.ubifs
	ubinize -s 2048 -O 2048 -p 131072 -m 2048 -o $(ROOT_UBI_IMG) vendor/sciaps/ini-file
	rm -rf $(TMP)
