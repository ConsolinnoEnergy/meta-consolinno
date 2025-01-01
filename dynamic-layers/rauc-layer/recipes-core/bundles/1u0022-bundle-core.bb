#

L1U0022_BASE_IMG = "1u0022-image-core"
L1U0022_INITRD_RECIPE = "fitimage-1u0022-system"
L1U0022_INITRD_IMG = "fitimage-1u0022-system.fit"

require ${@bb.utils.contains('DISTRO_FEATURES', 'rauc_bb', 'bundle_bb.inc', 'bundle.inc', d)}

