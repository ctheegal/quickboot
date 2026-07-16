# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

project('quickboot-apps',
  version       : '1.0.0',
  license       : 'BSD-3-Clause-Clear',
  meson_version : '>= 0.56.0',
)

# ── Subdirectories ─────────────────────────────────────────────────────────────
# Each subdirectory installs its own demo script and systemd service.
# Both services are disabled by default and must be explicitly enabled
# via DISTRO_FEATURE=quickboot or: systemctl enable <service>

subdir('audio')   # quickboot-audio-demo  + quickboot-audio-demo.service
subdir('camera')  # quickboot-camera-demo + quickboot-camera-demo.service
