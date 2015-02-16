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

# KERNEL_DEFCONFIG := goldfish_armv7_defconfig
# KERNEL_DIR := kernel
TARGET_U_BOOT_SOURCE := u-boot
TARGET_U_BOOT_CONFIG := goldfish_config

# TARGET_PREBUILT_U_BOOT := device/generic/armemu/u-boot.bin
TARGET_KERNEL_SOURCE := kernel
TARGET_KERNEL_CONFIG := goldfish_armv7_defconfig
PRODUCT_OUT ?= out/target/product/armemu
include $(TARGET_KERNEL_SOURCE)/AndroidKernel.mk

# device.mk doesn't know about us, and we can't PRODUCT_COPY_FILES here.
# So cp will do.
.PHONY: $(PRODUCT_OUT)/kernel $(PRODUCT_OUT)/u-boot.bin
$(PRODUCT_OUT)/kernel: $(TARGET_PREBUILT_KERNEL)
	cp $(TARGET_PREBUILT_KERNEL) $(PRODUCT_OUT)/kernel

include $(TARGET_U_BOOT_SOURCE)/AndroidU-Boot.mk
$(PRODUCT_OUT)/u-boot.bin: $(TARGET_PREBUILT_U-BOOT)
	cp $(TARGET_PREBUILT_U-BOOT) $(PRODUCT_OUT)/u-boot.bin

LOCAL_U_BOOT := $(TARGET_PREBUILT_U-BOOT)

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := prebuilts/qemu-kernel/arm/kernel-qemu-armv7
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
     $(LOCAL_U_BOOT):u-boot.bin \
     $(LOCAL_KERNEL):kernel \
     $(LOCAL_KERNEL):system/kernel \
     out/target/product/armemu/ramdisk.img:system/ramdisk.img \
     device/generic/armemu/init.recovery.armemu.rc:root/init.recovery.armemu.rc \
     device/generic/armemu/init.recovery.armemu.sh:root/init.recovery.armemu.sh

