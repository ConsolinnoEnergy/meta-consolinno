## 'nativesdk-' prefix is expected by naming scheme
PN := "nativesdk-${PN}"

inherit packagegroup nativesdk

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"

RDEPENDS:${PN} += "\
    nativesdk-barebox-passwd \
"
