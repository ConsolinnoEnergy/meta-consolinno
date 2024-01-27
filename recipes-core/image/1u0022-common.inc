LICENSE = "CLOSED"

_IMAGE_FEATURES_RELEASE ??= ""
## TODO: replace this by ssh authkey or so
_IMAGE_FEATURES_RELEASE += "empty-root-password"

_IMAGE_FEATURES_DEBUG ??= "debug-tweaks"

IMAGE_FEATURES += "${@bb.utils.contains('DISTRO_FEATURES', 'release', \
    '${_IMAGE_FEATURES_RELEASE}', '${_IMAGE_FEATURES_DEBUG}', d)}"

FEATURE_PACKAGES_debug-tweaks += "\
    packagegroup-1u0022-debug \
"

FEATURE_PACKAGES_tpm2 ="\
    tpm2-tools \
    tpm2-tss \
"

FEATURE_PACKAGES_tpm2-device = "\
    libtss2-tcti-device \
"