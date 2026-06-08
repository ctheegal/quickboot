# Recipe for early camera boot optimizations and preview application.
# Installs systemd services, udev rules, kernel module load lists,
# and helper scripts to achieve fast time-to-first-frame on boot.

SUMMARY = "Early Camera Boot Optimizations"
LICENSE = "CLOSED"
inherit systemd

FILESPATH = "${THISDIR}/files"
RDEPENDS:${PN} += "bash"

SRC_URI = " \
    file://camera-modules.conf \
    file://02-cam-server.rules \
    file://cam-server.service \
    file://early_cam_preview_app.service \
    file://cam_preview_app.sh \
    file://iq9075-first-boot-cam-setup.sh \
"

SYSTEMD_SERVICE:${PN} = "early_cam_preview_app.service"
SYSTEMD_AUTO_ENABLE = "enable"

do_install() {
    install -d ${D}${sysconfdir}/modules-load.d/
    install -m 0644 ${UNPACKDIR}/camera-modules.conf ${D}${sysconfdir}/modules-load.d/

    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${UNPACKDIR}/02-cam-server.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/cam-server.service ${D}${sysconfdir}/systemd/system/
    install -m 0644 ${UNPACKDIR}/early_cam_preview_app.service ${D}${sysconfdir}/systemd/system/

    install -d ${D}${bindir}/
    install -m 0755 ${UNPACKDIR}/cam_preview_app.sh ${D}${bindir}/
    install -m 0755 ${UNPACKDIR}/iq9075-first-boot-cam-setup.sh ${D}${bindir}/
}

FILES:${PN} += "${sysconfdir}/modules-load.d/* ${sysconfdir}/udev/rules.d/* ${sysconfdir}/systemd/system/* ${bindir}/*"
