## --*- bitbake -*--
LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"
BASE_PV = "6.6"

require kernel-common.inc

# 6.6.12
SRCREV_kernel_vanilla_6.6 ?= "47345b4264bc394a8d16bb16e8e7744965fa3934"
SRCREV_kernel_uapihdr_6.6 ?= "c17cda15cc86e65e9725641daddcd7a63cc9ad01"

SRCREV_kernel_6.6         ?= "${SRCREV_kernel_vanilla_6.6}"
