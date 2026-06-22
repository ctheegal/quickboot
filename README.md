# Qualcomm Early Services Initialization Framework

## Overview

This project introduces a set of yocto recipes (systemd service units, udev rules, and kernel module configurations) designed to dramatically reduce the time-to-first-perception for critical system services — 
* Display (Weston / DRM pipeline)
* Audio (PipeWire)
* Camera (GStreamer / cam-server pipelines)

It targets use cases such as **Action Cameras**, **Automotive IVI**, and **Industrial HMI** where a very fast boot experience is a hard product requirement.

## How It Works ?

QuickBoot achieves early boot of critical services through three complementary techniques applied consistently across all three subsystems:

### 1. Explicit Kernel Module Pre-loading
Rather than relying on `udev` coldplug (which is slow and non-deterministic), QuickBoot uses `modules-load.d` configuration files to pre-load kernel modules in a precise, dependency-ordered sequence during `systemd-modules-load.service` — one of the earliest systemd units to run.

### 2. Event-Driven Service Activation via udev
Custom udev rules watch for specific device node creation events (e.g., `controlC0` for ALSA, `video0` for camera, `card0` for DRM/display) and immediately trigger the corresponding service the moment the hardware is ready — eliminating polling delays.

### 3. Minimal systemd Dependencies (`DefaultDependencies=no`)
All early boot services are configured with `DefaultDependencies=no`, which removes the implicit ordering after `sysinit.target` and `basic.target`. This allows services to start in parallel with the rest of the boot sequence, as soon as their hardware dependency is satisfied.

## Subsystem Deep Dive

### 🔊 Audio — Early Chime

**Goal:** Play an audio chime as early as possible to signal boot completion.

**Mechanism:**
- `audio-modules.conf` pre-loads ALSA/audio kernel modules via `systemd-modules-load` before udev coldplug runs.
- A udev rule fires `pipewire.service` the instant `controlC0` (the ALSA control device) appears.
- `pipewire.service` runs with `DefaultDependencies=no`, bypassing `sysinit.target` ordering.
- `early_audio_play_app.service` plays a WAV file to the `pal_sink_speaker_ll` low-latency sink and logs precise timestamps to both `journald` and `/dev/kmsg` for boot-time measurement.

---

### 🖥️ Display — Early Weston Compositor

**Goal:** Show a splash screen or UI frame as early as possible (before `multi-user.target`).

**Mechanism:**
- `display-modules.conf` pre-loads DRM/GPU kernel modules early.
- A udev rule fires 'weston.service' whenever DRM is ready ( dev-dri-card0.device )
- 'weston.service runs with  `DefaultDependencies=no`, bypassing sysinit.target ordering.
- 'weston.service runs with --backend=drm-backend.so --shell=kiosk-shell.so --idle-time=0 

---

### 📷 Camera — Early Preview

**Goal:** Start camera preview (first frame) as fast as possible, targeting Action Camera use cases.

**Mechanism:**
- `camera-modules.conf` pre-loads camera and V4L2 kernel modules via `systemd-modules-load`.
- `02-cam-server.rules` triggers `cam-server.service` the moment `video0` is enumerated by udev.
- `early_cam_preview_app.service` is a real-time scheduled service that launches a GStreamer pipeline via `cam_preview_app.sh` on the Weston compositor.
- `iq9075-first-boot-cam-setup.sh` performs a one-time first-boot optimization: configures EFI settings and relocates unused sensor module binaries to reduce camera initialization latency on subsequent boots.

## Installation

### Prerequisites
- Target device running Qualcomm Linux (QLI 2.0+)
- Root access on the target
- Weston, PipeWire, GStreamer installed on the rootfs

### Deploy to Target

Clone the repository on the target device and run the installer:

```bash
git clone https://github.com/ctheegal/quickboot.git
cd quickboot
sudo ./quickboot-apps-installer.sh
````

The installer automatically:

1. Copies udev rules → `/etc/udev/rules.d/`
2. Copies `*-modules.conf` → `/etc/modules.d/` and other `.conf` → `/etc/modprobe.d/`
3. Copies systemd service/socket units → `/etc/systemd/system/`
4. Copies shell scripts → `/usr/bin/` (with execute permission)
5. Copies WAV audio assets → `/usr/share/sounds/`
6. Runs `systemctl daemon-reload`
7. Auto-discovers and enables all `early_*.service` units
8. Runs `udevadm control --reload-rules && udevadm trigger`

#### Reboot
```bash
sudo reboot
```

After reboot, the early boot services will activate automatically as their respective hardware devices are enumerated.

### Deploy to Source code and enable the Quickboot module at compile time

#### Fetch quickboot recipes 
* cd qcom-meta
* git clone https://github.com/ctheegal/quickboot

#### Add the recipe to `qcom-multimedia-image` (or any image) so it's baked in from first boot
* meta-qcom-distro/recipes-products/images/qcom-multimedia-image.bb
* IMAGE_INSTALL:append = " quickboot_audio quickboot_camera quickboot_display"

## Authors

* __Chitti Babu Theegala__ — `ctheegal@qti.qualcomm.com, Qualcomm Technologies, Inc.
* __Vaibhav Jindal__ — `vaibjind@qti.qualcomm.com`, Qualcomm Technologies, Inc.
* __Tarun Balaji Nidiganti__ — `tnidiganti@qti.qualcomm.com`, Qualcomm Technologies, Inc.

## License

*Quickboot* is licensed under the [BSD-3-clause License](https://spdx.org/licenses/BSD-3-Clause.html). See [LICENSE.txt](LICENSE.txt) for the full license text.
