#BAREBOX_BASE_URI ?= "${@l1u0022_public_component_uri(d, 'barebox')}"
#BAREBOX_REFSPEC  ?= ";branch=${BASE_PV}/1u0022"
#BAREBOX_REVISION ?= "0b666f81da14bf46cada222856762f7fd6641c26"
#inherit 1u0022-public-component

INCPATH := "."

require ${INCPATH}/barebox.inc
require ${INCPATH}/barebox-target.inc
require ${INCPATH}/barebox-common_2024.01.inc
