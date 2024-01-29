## --*- bitbake -*--
FILESEXTRAPATHS:prepend := "${THISDIR}/barebox-1u0022-${BASE_PV}:${THISDIR}/features:"

BAREBOX_DEFCONFIG = "${S}/arch/arm/configs/imx_v7_defconfig"

IMGBASE:consolinno-leaflet-1u0022-1 = "imx6ull-consolinno-1u0022"

DEPENDS += "openssl-native"

inherit barebox-environment-3
require barebox-passwd.inc

CFGSET = "\
    file://optimize.cfg \
    file://cpu.cfg \
    ${@bb.utils.contains('MACHINE_FEATURES', 'fitimage', 'file://fitimage.cfg', '', d)} \
\
    file://hw.cfg \
    file://hardening.cfg \
    file://features.cfg \
"

ENVSET += "\
    file://bin-fitimage-boot;subdir=_env \
    file://boot-self;subdir=_env \
    file://boot-factory;subdir=_env \
    file://boot-recovery;subdir=_env \
    file://boot-system-A;subdir=_env \
    file://boot-system-B;subdir=_env \
    file://init-automounts;subdir=_env \
"

PATCHSET += "\
"

kernel_generate_dynamic_cfg:append() {
    ## prevent definition of BOOTM_FITIMAGE_PUBKEY which triggers #include in some dtrees
    printf 'CONFIG_BOOTM_FITIMAGE_PUBKEY_ENV=y\n' >> ${CFG_DYNAMIC}
    printf 'CONFIG_CRYPTO_RSA_KEY="%s"\n'           '${L1U0022_IMAGE_CRT_FILE}' >> ${CFG_DYNAMIC}
    printf 'CONFIG_CRYPTO_RSA_KEY_NAME_HINT="%s"\n' '${L1U0022_IMAGE_KEY_HINT}' >> ${CFG_DYNAMIC}

    if ${@bb.utils.contains('DISTRO_FEATURES', 'release', 'true', 'false', d)}; then
        printf 'CONFIG_BOOTM_FORCE_SIGNED_IMAGES=y\n'
    fi >> ${CFG_DYNAMIC}
}

BAREBOX_BOOTSRC	??= "bootchooser"
BAREBOX_NETPATH ??= "/mnt/tftp"

do_env[vardeps] += "BAREBOX_BOOTSRC BAREBOX_NETPATH"
python do_env:append() {
    distro_features = set((d.getVar('DISTRO_FEATURES', True) or '').split())

    env_add (d, "nv/bootchooser.reset_attempts",           "all-zero")
    env_add (d, "nv/bootchooser.targets",                  "system0 system1 system2")
    env_add (d, "nv/bootchooser.retry",                    "1")
    env_add (d, "nv/bootchooser.system0.boot",             "system-A")
    env_add (d, "nv/bootchooser.system0.default_attempts", "3")
    env_add (d, "nv/bootchooser.system0.default_priority", "21")
    env_add (d, "nv/bootchooser.system1.boot",             "system-B")
    env_add (d, "nv/bootchooser.system1.default_attempts", "3")
    env_add (d, "nv/bootchooser.system1.default_priority", "20")
    env_add (d, "nv/bootchooser.system2.boot",             "factory")
    env_add (d, "nv/bootchooser.system2.default_attempts", "1")
    env_add (d, "nv/bootchooser.system2.default_priority", "5")
    env_add (d, "nv/bootchooser.state_prefix",             "state.bootstate")

    env_add (d, "nv/tftp.windowsize",     "8")
    env_add (d, "nv/dhcp.vendor_id",      "consolinno:1u0022:bootloader")
    env_add (d, "nv/boot.default",        d.getVar('BAREBOX_BOOTSRC', True))
    env_add (d, "nv/machine",             d.getVar('MACHINE',         True))
    env_add (d, "nv/netpath",             d.getVar('BAREBOX_NETPATH', True))

    env_file(d, "bin/fitimage-boot",      "_env/bin-fitimage-boot")
    env_file(d, "boot/self",              "_env/boot-self")
    env_file(d, "boot/factory",           "_env/boot-factory")
    env_file(d, "boot/recovery",          "_env/boot-recovery")
    env_file(d, "boot/system-A",          "_env/boot-system-A")
    env_file(d, "boot/system-B",          "_env/boot-system-B")
    env_file(d, "init/1u0022-automounts", "_env/init-automounts")

    if 'release' in distro_features:
        env_add (d, "nv/linux.bootargs.logging", "quiet")
        env_add (d, "nv/boot.watchdog_timeout",  "60")
}
