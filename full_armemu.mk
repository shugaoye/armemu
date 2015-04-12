# Copyright (C) 2015 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#******************************************************************************
#
# Makefile - Makefile of virtual device armemu
#
# Copyright (c) 2015 Roger Ye.  All rights reserved.
#
# This is part of the build for virtual device armemu.
#
#******************************************************************************

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full.mk)

PRODUCT_NAME := full_armemu
PRODUCT_DEVICE := armemu
PRODUCT_BRAND := AOSP_ARMEMU
PRODUCT_MODEL := Full_Android_ARMEMU

# define U-Boot and Kernel path and configuration
TARGET_U_BOOT_SOURCE := u-boot
TARGET_U_BOOT_CONFIG := goldfish_config

TARGET_KERNEL_SOURCE := kernel
TARGET_KERNEL_CONFIG := goldfish_armv7_defconfig

PRODUCT_OUT ?= out/target/product/armemu

include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk
include $(TARGET_U_BOOT_SOURCE)/AndroidU-Boot.mk

# define U-Boot images
TARGET_KERNEL_UIMAGE := $(PRODUCT_OUT)/zImage.uimg
TARGET_RAMDISK_UIMAGE := $(PRODUCT_OUT)/ramdisk.uimg
TARGET_RECOVERY_UIMAGE := $(PRODUCT_OUT)/ramdisk-recovery.uimg

# define build targets for kernel, U-Boot and U-Boot images
.PHONY: $(TARGET_PREBUILT_KERNEL) $(TARGET_PREBUILT_U-BOOT) $(TARGET_KERNEL_UIMAGE) $(TARGET_RAMDISK_UIMAGE) $(TARGET_RECOVERY_UIMAGE)

$(TARGET_KERNEL_UIMAGE): $(TARGET_PREBUILT_KERNEL)
	mkimage -A arm -C none -O linux -T kernel -d $(TARGET_PREBUILT_INT_KERNEL) -a 0x00010000 -e 0x00010000 $(TARGET_KERNEL_UIMAGE)

$(TARGET_RAMDISK_UIMAGE): $(PRODUCT_OUT)/ramdisk.img
	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk.img -a 0x00800000 -e 0x00800000 $(TARGET_RAMDISK_UIMAGE)

#$(TARGET_RECOVERY_UIMAGE): $(PRODUCT_OUT)/ramdisk-recovery.img
#	mkimage -A arm -C none -O linux -T ramdisk -d $(PRODUCT_OUT)/ramdisk-recovery.img -a 0x00800000 -e 0x00800000 $(TARGET_RECOVERY_UIMAGE)

LOCAL_U_BOOT := $(TARGET_PREBUILT_U-BOOT)

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := prebuilts/qemu-kernel/arm/kernel-qemu-armv7
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

LOCAL_KERNEL_UIMAGE := $(TARGET_KERNEL_UIMAGE)
LOCAL_RAMDISK_UIMAGE := $(TARGET_RAMDISK_UIMAGE)
# LOCAL_RECOVERY_UIMAGE := $(TARGET_RECOVERY_UIMAGE)

PRODUCT_COPY_FILES += \
     $(LOCAL_U_BOOT):u-boot.bin \
     $(LOCAL_KERNEL):kernel \
     $(LOCAL_KERNEL_UIMAGE):system/zImage.uimg \
     $(LOCAL_RAMDISK_UIMAGE):system/ramdisk.uimg \
#     $(LOCAL_RECOVERY_UIMAGE):system/ramdisk-recovery.uimg \
     device/generic/armemu/init.recovery.armemu.rc:root/init.recovery.armemu.rc \
     device/generic/armemu/init.recovery.armemu.sh:root/init.recovery.armemu.sh

