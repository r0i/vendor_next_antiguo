PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/bin/50-next.sh:system/addon.d/50-next.sh

# Next-OS-specific init file
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/etc/init.local.rc:root/init.next.rc

# Copy latinime for gesture typing
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/next/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/next/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/next/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    Development \
    SpareParts \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker

# Busybox
PRODUCT_PACKAGES += \
    Busybox

# CM Hardware Abstraction Framework
PRODUCT_PACKAGES += \
    org.cyanogenmod.hardware \
    org.cyanogenmod.hardware.xml

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME \
    BluetoothExt

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/next/overlay/common

# Bootanimation
PRODUCT_COPY_FILES += \
    vendor/next/prebuilt/common/bootanimation/bootanimation.zip:system/media/bootanimation.zip

# Layers Manager
PRODUCT_COPY_FILES += \
	vendor/next/prebuilt/common/apk/LayersManager.apk:system/priv-app/LayersManager/LayersManager.apk

# Nova Launcher
PRODUCT_COPY_FILES += \
	vendor/next/prebuilt/common/apk/NovaLauncher.apk:system/priv-app/NovaLauncher/NovaLauncher.apk

# SuperSU
PRODUCT_COPY_FILES += \
	vendor/next/prebuilt/common/UPDATE-SuperSU.zip:system/UPDATE-SuperSU.zip \
	vendor/next/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# Versioning System
# Next-OS first version.
PRODUCT_VERSION_MAJOR = 6.0.1
PRODUCT_VERSION_MINOR = Beta
PRODUCT_VERSION_MAINTENANCE = 0.1
ifdef NEXT_BUILD_EXTRA
    NEXT_POSTFIX := -$(NEXT_BUILD_EXTRA)
endif
ifndef NEXT_BUILD_TYPE
    NEXT_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif

ifeq ($(NEXT_BUILD_TYPE),DM)
    NEXT_POSTFIX := -$(shell date +"%Y%m%d")
endif

ifndef NEXT_POSTFIX
    NEXT_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
endif

PLATFORM_VERSION_CODENAME := $(NEXT_BUILD_TYPE)

# Set all versions
NEXT_VERSION := Next-OS_$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(NEXT_BUILD_TYPE)$(NEXT_POSTFIX)
NEXT_MOD_VERSION := Next-OS_$(NEXT_BUILD)-$(PRODUCT_VERSION_MAJOR)-$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_MAINTENANCE)-$(NEXT_BUILD_TYPE)$(NEXT_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    next.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.next.version=$(NEXT_VERSION) \
    ro.modversion=$(NEXT_MOD_VERSION) \
    ro.next.buildtype=$(NEXT_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/next/tools/next_process_props.py

