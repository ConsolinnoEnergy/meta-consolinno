## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

BASE_PV = "5.4"

require kernel-common.inc

# 5.4.267
#SRCREV_kernel_vanilla_5.4.267 ?= "9153fc9664959aa6bb35915b2bbd8fbc4c762962"
# 5.4.288
#SRCREV_kernel_vanilla_5.4.288 ?= "b783bf0ebfecc8d5a5fd0cd5441e5a9d330e8992"
# 5.4.289 (9.01.25)
SRCREV_kernel_vanilla_5.4.289 ?= "7dda48bae35812dd7e852cc09cce410c15e3d7db"
# 5.4.293 (2.06.25)
SRCREV_kernel_vanilla_5.4.293 ?= "2c8115e4757809ffd537ed9108da115026d3581f"
# 5.4.294 (6.06.25)
SRCREV_kernel_vanilla_5.4.294 ?= "44613a259decccddd2bd4520f73cc4d5107546c6"
# 5.4.296 (17.07.25)
SRCREV_kernel_vanilla_5.4.296 ?= "bc4f0eb3c5ecee4a80a333b912ed29c225703b27"
# 5.4.297 (28.08.25)
SRCREV_kernel_vanilla_5.4.297 ?= "c25f780e491e4734eb27d65aa58e0909fd78ad9f"
# 5.4.299 (09.09.25)
SRCREV_kernel_vanilla_5.4.299 ?= "08c21a7a8d77131bb79b4611d19d9f45844053a8"


SRCREV_kernel_5.4         ?= "${SRCREV_kernel_vanilla_5.4.299}"
SRCREV_kernel_uapihdr_5.4 ?= "2ab1b7ad50466422ac8966f67a92452718865ac2"

#set full version to clarify cve-check output
PV = "5.4.299+git${SRCPV}"
