## --*- bitbake -*--

LICENSE = "CLOSED"

SRC_URI = "\
    file://fitimage.its \
"

FITIMAGE_DTBS     = "${@get_dtbs(d, '.dtb',  'MACHINE_DTBS')}"
FITIMAGE_OVERLAYS = "${@get_dtbs(d, '.dtbo', 'MACHINE_DTBS')}"

FITIMAGE_SIGNED_NODES ??= "cfg0"
FITIMAGE_SIGNING_ALGO ??= "sha256,rsa4096"
FITIMAGE_SIGNING_KEY_NAME = "${L1U0022_IMAGE_KEY_HINT}"
FITIMAGE_SIGNING_KEY = "${L1U0022_IMAGE_KEY_FILE}"

def get_dtbs(d, suffix, var):
    all_dtbs = (d.getVar(var, True) or "").split()
    all_dtbs = filter(lambda x: x.endswith(suffix), all_dtbs)
    all_dtbs = map(lambda x: "devicetree/%s" % x, all_dtbs)
    return ' '.join(sorted(all_dtbs))

inherit fitimage

IMAGE_CMD:fit = "\
    mkimage ${EXTRA_IMAGECMD} \
    -f '${FITIMAGE_ITSFILE}' \
    -G ${FITIMAGE_SIGNING_KEY} \
    -r \
    ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.fit \
"

python do_fitimage_prepare_its:prepend() {
    from fitimage import FitImage

    FitImage.set_global_hash_algo('sha256')
}

do_fitimage_prepare_its[vardeps] += "FITIMAGE_SIGNED_NODES FITIMAGE_SIGNING_ALGO FITIMAGE_SIGNING_KEY_NAME"
python do_fitimage_prepare_its:append() {
    nodes = (d.getVar('FITIMAGE_SIGNED_NODES') or "").split()
    if nodes:
        fname = os.path.join(d.getVar("B"), d.getVar('FITIMAGE_ITSFILE'))
        algo  = d.getVar('FITIMAGE_SIGNING_ALGO')
        hint  = d.getVar('FITIMAGE_SIGNING_KEY_NAME')
        with open(fname, "a") as out_file:
            for n in nodes:
                out_file.write('&%s {\n' % n)
                out_file.write('\tsignature-1 {\n')
                out_file.write('\t\talgo = "%s";\n' % algo)
                if hint:
                    out_file.write('\t\tkey-name-hint = "%s";\n' % hint)
                out_file.write('\t};\n')
                out_file.write('};\n')
}

## must be after 'inherit fitimage' because image_types overrides this variable
IMAGE_TYPES = "fit"

PACKAGES += "${PN}-image"

FILES:${PN}-image = "/boot/${FITIMAGE_BOOT_NAME}.fit"
