# config.mk
#
# Product-specific compile-time definitions
#

TARGET_BOARD_PLATFORM := msm8996
TARGET_BOOTLOADER_BOARD_NAME := msm8996

BOARD_USES_QCOM_HARDWARE := true

TARGET_CUSTOM_DTBTOOL := dtbTool
TARGET_KERNEL_CONFIG := msm_defconfig
TARGET_KERNEL_SOURCE := kernel

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo

BOARD_SEPOLICY_DIRS := \
       $(BOARD_SEPOLICY_DIRS) \
       device/qcom/sepolicy \
       device/qcom/sepolicy/common \
       device/qcom/sepolicy/test \
       device/qcom/sepolicy/$(TARGET_BOARD_PLATFORM)

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
ifneq ($(TARGET_USES_AOSP), true)
TARGET_2ND_CPU_VARIANT := cortex-a53
else
TARGET_2ND_CPU_VARIANT := cortex-a9
endif

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
BOOTLOADER_GCC_VERSION := arm-eabi-4.8
BOOTLOADER_PLATFORM := msm8996 # use msm8996 LK configuration

TARGET_USES_OVERLAY := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
MAX_VIRTUAL_DISPLAY_DIMENSION := 4096

BOARD_USES_GENERIC_AUDIO := true
USE_CAMERA_STUB := true
-include $(QCPATH)/common/msm8996/BoardConfigVendor.mk

# Some framework code requires this to enable BT
BOARD_HAVE_BLUETOOTH := true
BOARD_USES_WIPOWER := false
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/qcom/common

USE_OPENGL_RENDERER := true
BOARD_USE_LEGACY_UI := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x04000000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x04000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3221225472
BOARD_USERDATAIMAGE_PARTITION_SIZE := 10737418240
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_PARTITION_SIZE := 33554432
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)

TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
ifneq ($(TARGET_USES_AOSP),true)
TARGET_USES_QCOM_BSP := true
endif

BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff

BOARD_EGL_CFG := device/qcom/$(TARGET_BOARD_PLATFORM)/egl.cfg

BOARD_KERNEL_BASE        := 0x80000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x02000000
BOARD_RAMDISK_OFFSET     := 0x02200000

BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_USES_UNCOMPRESSED_KERNEL := false

ifneq ($(QCPATH),)
CORE_CTL_ROOT := $(QCPATH)/android-perf/core-ctl
CORE_CTL_MODULE:
	$(hide) mkdir -p $(KERNEL_OUT)/$(CORE_CTL_ROOT)
	$(hide) cp -f $(CORE_CTL_ROOT)/Kbuild $(KERNEL_OUT)/$(CORE_CTL_ROOT)/Makefile
	$(hide) cp -f $(CORE_CTL_ROOT)/core_ctl.c $(KERNEL_OUT)/$(CORE_CTL_ROOT)/core_ctl.c
	$(hide) $(MAKE) $(MAKE_FLAGS) -C $(KERNEL_OUT) M=$(KERNEL_OUT)/$(CORE_CTL_ROOT) ARCH=$(TARGET_ARCH) $(KERNEL_CROSS_COMPILE) modules
	$(hide) $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)strip --strip-debug $(KERNEL_OUT)/$(CORE_CTL_ROOT)/core_ctl.ko
	$(hide) mkdir -p $(KERNEL_MODULES_OUT)
	$(hide) cp -f $(KERNEL_OUT)/$(CORE_CTL_ROOT)/core_ctl.ko $(KERNEL_MODULES_OUT)
TARGET_KERNEL_MODULES += CORE_CTL_MODULE
endif

QCA_CLD_ROOT := vendor/qcom/opensource/wlan/qcacld-2.0
QCA_CLD_MODULE:
	$(hide) mkdir -p $(KERNEL_OUT)/$(QCA_CLD_ROOT)
	$(hide) cp -f $(QCA_CLD_ROOT)/Kbuild $(KERNEL_OUT)/$(QCA_CLD_ROOT)/Makefile
	$(hide) cp -rf $(QCA_CLD_ROOT)/CORE $(KERNEL_OUT)/$(QCA_CLD_ROOT)/CORE
	$(hide) cp -rf $(QCA_CLD_ROOT)/wcnss $(KERNEL_OUT)/$(QCA_CLD_ROOT)/wcnss
	$(hide) $(MAKE) $(MAKE_FLAGS) -C $(KERNEL_OUT) M=$(KERNEL_OUT)/$(QCA_CLD_ROOT) ARCH=$(TARGET_ARCH) $(KERNEL_CROSS_COMPILE) MODNAME=wlan WLAN_OPEN_SOURCE=1 CONFIG_QCA_CLD_WLAN=m WLAN_ROOT=$(QCA_CLD_ROOT) BOARD_PLATFORM=$(TARGET_BOARD_PLATFORM) modules
	$(hide) $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)strip --strip-debug $(KERNEL_OUT)/$(QCA_CLD_ROOT)/wlan.ko
	$(hide) mkdir -p $(KERNEL_MODULES_OUT)/qca_cld
	$(hide) cp -f $(KERNEL_OUT)/$(QCA_CLD_ROOT)/wlan.ko $(KERNEL_MODULES_OUT)/qca_cld/qca_cld_wlan.ko
	$(hide) ln -sf /system/lib/modules/qca_cld/qca_cld_wlan.ko $(KERNEL_MODULES_OUT)/wlan.ko

TARGET_KERNEL_MODULES += QCA_CLD_MODULE

MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024

TARGET_NO_RPC := true

TARGET_PLATFORM_DEVICE_BASE := /devices/soc/

#Enable Peripheral Manager
TARGET_PER_MGR_ENABLED := true

#Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

#Enable SW based full disk encryption
TARGET_SWV8_DISK_ENCRYPTION := false

#Enable PD locater/notifier
TARGET_PD_SERVICE_ENABLED := true

BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_BOOTIMG_SIGNED := true

# Enable dex pre-opt to speed up initial boot
ifeq ($(HOST_OS),linux)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
      WITH_DEXPREOPT_PIC := true
      ifneq ($(TARGET_BUILD_VARIANT),user)
        # Retain classes.dex in APK's for non-user builds
        DEX_PREOPT_DEFAULT := nostripping
      endif
    endif
endif

# Enable sensor multi HAL
USE_SENSOR_MULTI_HAL := true

TARGET_LDPRELOAD := libNimsWrap.so

TARGET_COMPILE_WITH_MSM_KERNEL := true

TARGET_KERNEL_APPEND_DTB := true
# Added to indicate that protobuf-c is supported in this build
PROTOBUF_SUPPORTED := false

#Add NON-HLOS files for ota upgrade
ADD_RADIO_FILES := true
TARGET_RECOVERY_UPDATER_LIBS := librecovery_updater_msm
TARGET_RECOVERY_UI_LIB := librecovery_ui_msm

TARGET_CRYPTFS_HW_PATH := device/qcom/common/cryptfs_hw

#Add support for firmare upgrade on 8996
HAVE_SYNAPTICS_DSX_FW_UPGRADE := true

# Enable MDTP (Mobile Device Theft Protection)
TARGET_USE_MDTP := true
