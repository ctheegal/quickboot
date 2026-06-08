#!/bin/bash
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# ==============================================================================
# DESCRIPTION:
# This script must be executed manually by the user during the first boot.
# It is designed specifically for the IQ-9075 EVK device to optimize camera
# initialization and reduce boot time.
#
# Functions performed:
# 1. Initializes the required EFI variable settings for the camera
#    (VendorDtbOverlays).
# 2. Reduces camera server init time by relocating unnecessary camera sensor
#    module binaries that are not required for the IQ-9075 EVK to a backup folder.
#
# USAGE:
#  Run this script once on the device via the terminal:
#  /usr/bin/iq9075-first-boot-cam-setup.sh
# ==============================================================================

echo -n "camx" > /var/data
efivar -n 882f8c2b-9646-435f-8de5-f208ff80c1bd-VendorDtbOverlays -w -f /var/data
efivar -n 882f8c2b-9646-435f-8de5-f208ff80c1bd-VendorDtbOverlays -p

mkdir /data/sensors-to-remove
cd /usr/lib/camx/lemans/camera/
mv com.qti.sensormodule.cmk_imx577_rb4_csi0.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_imx577_rb4_csi1.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_imx577_rb4_csi2.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_imx577_rb8_csi0.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_imx577_rb8_csi2.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_imx577_rb8_csi3.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb4_cam0.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb4_cam1.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb4_cam2.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb8_cam0a.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb8_cam0b.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb8_cam1.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb8_cam2.bin /data/sensors-to-remove
mv com.qti.sensormodule.cmk_ov9282_rb8_cam3.bin /data/sensors-to-remove
mv com.qti.sensormodule.cust_ov13858_rb8_cam0.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl03.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl0f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl10.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_gmsl30.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_gmsl00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_gmsl01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_gmsl02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_gmsl03.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl10.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl11.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl12.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl13.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl20.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl21.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl22.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_monaco_yuv_gmsl23.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl03.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl_dphy00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl_dphy01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_gmsl_dphy02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl10.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl11.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl12.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl13.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl20.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl21.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl22.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb4_yuv_gmsl23.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl03.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl0f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl_dphy00.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl_dphy01.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl_dphy02.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_gmsl_dphy03.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl10.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl11.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl12.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl13.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl1f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl20.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl21.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl22.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl23.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl2f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl30.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl31.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl32.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl33.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_rb8_yuv_gmsl3f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl10.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl11.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl12.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl13.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl1f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl20.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl21.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl22.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl23.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl2f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl30.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl31.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl32.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl33.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox03f10_yuv_gmsl3f_bcast.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox08d10_gmsl.bin /data/sensors-to-remove
mv com.qti.sensormodule.leopard_max96724_ox08d10_monaco_gmsl.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg0_rb4.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg0_rb8.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg1_rb4.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg1_rb8.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg2_rb4.bin /data/sensors-to-remove
mv com.qti.sensormodule.qti_tpg2_rb8.bin /data/sensors-to-remove
mv com.qti.sensormodule.rhodes_ov13858_rb8_cam1.bin /data/sensors-to-remove
mv libmctf_cl_program.bin /data/sensors-to-remove
sync
