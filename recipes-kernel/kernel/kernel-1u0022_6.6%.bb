## due to '?=' set the variables here before including other files!

#KERNEL_BASE_URI ?= "${@l1u0022_public_component_uri(d, 'kernel')}"
#KERNEL_REFSPEC  ?= ";branch=${BASE_PV}/1u0022"
#KERNEL_REVISION ?= "1da177e4c3f41524e886b7f1b8a0c1fc7321cac2"
#inherit 1u0022-public-component

INCPATH = "."

require ${INCPATH}/kernel-common_6.6.inc
require ${INCPATH}/kernel-target.inc

# DEPENDS += "openssl-native"
