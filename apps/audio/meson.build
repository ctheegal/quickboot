# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# ── Configuration: substitute @VARIABLE@ placeholders in service template ─────
# @BINDIR@  → e.g. /usr/bin   (where quickboot-audio-demo is installed)
# @DATADIR@ → e.g. /usr/share (where sounds/sample-3s.wav is expected)
audio_conf = configuration_data()
audio_conf.set('BINDIR',  get_option('prefix') / get_option('bindir'))
audio_conf.set('DATADIR', get_option('prefix') / get_option('datadir'))

# ── Generate service file from template ───────────────────────────────────────
# quickboot-audio-demo.service.in → quickboot-audio-demo.service
audio_service = configure_file(
  input         : 'quickboot-audio-demo.service.in',
  output        : 'quickboot-audio-demo.service',
  configuration : audio_conf,
)

# ── Install demo script ────────────────────────────────────────────────────────
# Installs quickboot-audio-demo to /usr/bin/ as an executable (no .sh extension)
install_data(
  'quickboot-audio-demo',
  install_dir  : get_option('prefix') / get_option('bindir'),
  install_mode : 'rwxr-xr-x',
)

# ── Install generated service file ────────────────────────────────────────────
# Installs quickboot-audio-demo.service to the systemd unit directory.
# Service is disabled by default; enabled only when 'quickboot' DISTRO_FEATURE
# is set (or manually via: systemctl enable quickboot-audio-demo.service)
unitdir = get_option('prefix') / 'lib' / 'systemd' / 'system'

install_data(
  audio_service,
  install_dir  : unitdir,
  install_mode : 'rw-r--r--',
)

# ── Post-install: reload systemd daemon only ──────────────────────────────────
# Service is NOT auto-enabled here — it must be explicitly enabled via
# DISTRO_FEATURE=quickboot or manually with systemctl enable.
# Skipped automatically on Yocto cross-builds where DESTDIR=${D} is set.
meson.add_install_script(
  'sh', '-c',
  '''
  if [ -z "$DESTDIR" ] && command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload
    echo "quickboot-audio-demo: service installed but NOT enabled by default."
    echo "  To enable: systemctl enable quickboot-audio-demo.service"
  fi
  '''
)
