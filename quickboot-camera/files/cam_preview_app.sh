#!/bin/bash
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# DESCRIPTION:
# Previews Camera using the GStreamer (gst-launch-1.0) utility.
# This script is designed to be executed by early_cam_preview_app.service
# once Weston and the camera server are fully initialized.
#
# Logs to both systemd journalctl and kernel log (dmesg).

# Function to log to both journalctl and kernel log
log_message() {
    local level="$1"
    local message="$2"

    # Log to systemd journal
    echo "[$level] $message"

    # Log to kernel log (dmesg) via /dev/kmsg
    case "$level" in
        INFO)    kmsg_level=6 ;;
        WARNING) kmsg_level=4 ;;
        ERROR)   kmsg_level=3 ;;
        *)       kmsg_level=6 ;;
    esac

    echo "<${kmsg_level}>$SERVICE_NAME: $message" > /dev/kmsg 2>/dev/null || true
}

# Start logging
log_message "INFO" "=========================================="
log_message "INFO" "Camera Preview App Started"
log_message "INFO" "=========================================="
log_message "INFO" "Command: gst-launch-1.0 -e qtiqmmfsrc name=camsrc video_0::type=preview ! video/x-raw,format=NV12_Q08C,width=1920,height=1080,framerate=30/1 ! waylandsink fullscreen=true"

#export XDG_RUNTIME_DIR=/dev/socket/weston && export WAYLAND_DISPLAY=wayland-1
GST_REGISTRY_UPDATE=no gst-launch-1.0 -e qtiqmmfsrc name=camsrc video_0::type=preview ! video/x-raw,format=NV12_Q08C,width=1920,height=1080,framerate=30/1 ! waylandsink fullscreen=true
