# Recipe for early display boot optimizations.
#
# Installs custom Weston service configurations, udev rules for
# immediate triggering, and kernel module load lists to achieve
# early display availability.

SUMMARY = "Early Display Boot Optimizations"
LICENSE = "CLOSED"
inherit systemd

# Add this line to fix the do_unpack warning
S = "${UNPACKDIR}"

FILESPATH = "${THISDIR}/files"
RDEPENDS:${PN} += "bash"

SRC_URI = " \
    file://drm-modprobe.conf \
    file://display-modules.conf \
    file://03-drm.rules \
    file://weston.service \
    file://weston.socket \
"

do_install() {
    install -d ${D}${sysconfdir}/modules-load.d/
    install -m 0644 ${UNPACKDIR}/display-modules.conf ${D}${sysconfdir}/modules-load.d/

    install -d ${D}${sysconfdir}/modprobe.d/
    install -m 0644 ${UNPACKDIR}/drm-modprobe.conf ${D}${sysconfdir}/modprobe.d/

    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${UNPACKDIR}/03-drm.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/weston.service ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/weston.socket ${D}${sysconfdir}/systemd/system/
}

FILES:${PN} += "${sysconfdir}/modules-load.d/* ${sysconfdir}/modprobe.d/* ${sysconfdir}/udev/rules.d/*  ${sysconfdir}/systemd/system/*"
