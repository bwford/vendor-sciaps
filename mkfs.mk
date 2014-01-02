.PHONY: mkrootfs cleanrootfs mkubifs

mkrootfs:
	mkdir -p myfs
	mkdir -p myfs/system/lib/modules
	cp -r out/target/product/pcm049/root/* myfs
	cp -r out/target/product/pcm049/system myfs
	cp -r out/target/product/pcm049/data myfs
	cp out/target/product/pcm049/target/kbuild/pvrsrvkm_sgx540_120.ko myfs/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/compat/compat.ko myfs/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/net/wireless/cfg80211.ko myfs/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/net/mac80211/mac80211.ko myfs/system/lib/modules
	cp hardware/ti/wlan/mac80211/compat_wl12xx/drivers/net/wireless/wl12xx/wl12xx.ko myfs/system/lib/modules
	cp myfs/system/etc/firmware/ti-connectivity/wl1271-nvs_127x.bin myfs/system/etc/firmware/ti-connectivity/wl1271-nvs.bin

cleanrootfs:
	rm -rf myfs

mkubifs: mkrootfs
	mkfs.ubifs -r myfs -m 2048 -c 3888 -e 126976 -o root.ubifs
	ubinize -s 2048 -O 2048 -p 131072 -m 2048 -o root-pcm049.ubi vendor/sciaps/ini-file
	mv -f root.ubifs root-pcm049.ubifs