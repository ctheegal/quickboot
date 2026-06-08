# This bitbake recipe that packages and installs the quickboot
# audio optimizations. It ensures the custom 'modules-load.d'
# configuration, udev rules, early systemd services and the
# chime wav file are deployed to the rootfs.

SUMMARY = "Early Audio Boot Optimizations"
LICENSE = "CLOSED"
inherit systemd

FILESPATH = "${THISDIR}/files"
RDEPENDS:${PN} += "bash"

SRC_URI = " \
    file://audio-modules.conf \
    file://01-pipewire-audio.rules \
    file://pipewire.service \
    file://early_audio_play_app.service \
    file://audio_play_app.sh \
    file://sample-3s.wav \
"

SYSTEMD_SERVICE:${PN} = "early_audio_play_app.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}${sysconfdir}/modules-load.d/
    install -m 0644 ${UNPACKDIR}/audio-modules.conf ${D}${sysconfdir}/modules-load.d/

    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${UNPACKDIR}/01-pipewire-audio.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/pipewire.service ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/early_audio_play_app.service ${D}${sysconfdir}/systemd/system/

    install -d ${D}${bindir}/
    install -m 0755 ${UNPACKDIR}/audio_play_app.sh ${D}${bindir}/

    install -d ${D}/usr/share/sounds/
    install -m 0644 ${UNPACKDIR}/sample-3s.wav ${D}/usr/share/sounds/
}

FILES:${PN} += "${sysconfdir}/modules-load.d/* ${sysconfdir}/systemd/system/* ${bindir}/* /usr/share/sounds/*"
