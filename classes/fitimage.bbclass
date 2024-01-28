FITIMAGE_KERNELS ??= ""
FITIMAGE_KERNELS[type] = "list"

FITIMAGE_DTBS ??= ""
FITIMAGE_DTBS[type] = "list"

FITIMAGE_OVERLAYS ??= ""
FITIMAGE_OVERLAYS[type] = "list"

FITIMAGE_RAMDISKS ??= ""
FITIMAGE_RAMDISKS[type] = "list"

FITIMAGE_TEMPLATE ?= "fitimage.its"
FITIMAGE_ITSFILE  ?= "fitimage-gen.its"

FITIMAGE_SEARCH_PATH ?= "\
    ${DEPLOY_DIR_IMAGE} \
"
FITIMAGE_SEARCH_PATH[type] = "list"

FITIMAGE_COMPONENTS ?= "\
    virtual/dtb:do_deploy \
    virtual/kernel:do_deploy \
"
FITIMAGE_COMPONENTS[type] = "list"

FITIMAGE_BOOT_NAME ??= "${IMAGE_BASENAME}"

FITIMAGE_ATTR_ID ??= "device-id"
FITIMAGE_ATTR_DESC ??= "device-description"

DEPENDS += "dtc-native"

PACKAGE_ARCH = "${MACHINE_ARCH}"

## do not create -dev + -dbg packages; their deps on ${PN} break SDK build else
ALLOW_EMPTY:${PN}-dev = ""
ALLOW_EMPTY:${PN}-dbg = ""

inherit image_types deploy

## we do not want the '.rootfs' suffix
IMAGE_NAME_SUFFIX:forcevariable = ""

def fitimage_expand_filenames(d, varname):
    res = []
    raw = oe.data.typed_value(varname, d)
    search_path = oe.data.typed_value("FITIMAGE_SEARCH_PATH",d)
    for r in raw:
        resolved = None

        for p in search_path:
            full_name = os.path.join(p, r)
            if os.path.exists(full_name):
                resolved = full_name
                break

            ## when raw path is absolute, abort after the first
            ## search path item
            if r.startswith('/'):
                break

        if resolved is None:
            bb.fatal("file %s not found" % (r,))
        else:
            res += [resolved,]

    return res

def fitimage_generate_fragment(d):
    from fitimage import FitImage

    images = FitImage.from_desc(kernels  = fitimage_expand_filenames(d, 'FITIMAGE_KERNELS'),
                                dtbs     = fitimage_expand_filenames(d, 'FITIMAGE_DTBS'),
                                overlays = fitimage_expand_filenames(d, 'FITIMAGE_OVERLAYS'),
                                ramdisks = fitimage_expand_filenames(d, 'FITIMAGE_RAMDISKS'),
                                id_attr  = d.getVar('FITIMAGE_ATTR_ID'),
                                desc_attr = d.getVar('FITIMAGE_ATTR_DESC'))

    return images

def fitimage_generate_its(d, template, output):
    frag = fitimage_generate_fragment(d).finish()
    ## normalize paths; when relative us WORKDIR resp. B as parent directory
    template = os.path.join(d.getVar("WORKDIR"), d.expand(template))
    output   = os.path.join(d.getVar("B"), d.expand(output))
    with open(output, "w") as out_file:
        with open(template, "r") as in_file:
            out_file.write(d.expand(in_file.read()))

        out_file.write('\n'.join(frag.emit(d)))
        out_file.write('\n')

do_fitimage_prepare_its[vardeps] += "FITIMAGE_KERNELS FITIMAGE_DTBS FITIMAGE_OVERLAYS FITIMAGE_RAMDISKS"
do_fitimage_prepare_its[vardeps] += "FITIMAGE_ATTR_ID FITIMAGE_ATTR_DESC"
do_fitimage_prepare_its[vardeps] += "FITIMAGE_SEARCH_PATH FITIMAGE_TEMPLATE FITIMAGE_ITSFILE"
do_fitimage_prepare_its[depends] += "${FITIMAGE_COMPONENTS}"
python do_fitimage_prepare_its() {
    fitimage_generate_its(d, d.getVar('FITIMAGE_TEMPLATE'), d.getVar('FITIMAGE_ITSFILE'))
}
addtask do_fitimage_prepare_its after do_configure before do_image_fit

IMAGE_CMD:fit[vardepsexclude] = "DATETIME"
IMAGE_CMD:fit = "mkimage ${EXTRA_IMAGECMD} -f '${FITIMAGE_ITSFILE}' ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.fit"

## TODO: make gzip/xz-native depending on conversion
do_image_fit[depends] += "\
    u-boot-tools-native:do_populate_sysroot \
    ${PN}:do_fitimage_prepare_its \
    gzip-native:do_populate_sysroot \
    xz-native:do_populate_sysroot \
"

do_image_fit[dirs] = "${B}"
fitimage_do_image_fit() {
    # used by CONVERSION_CMD:xxx
    type=fit

    rm -f ${IMAGE_BASENAME}.fit* ${IMAGE_NAME}.fit

    # first pass; generate the fit image
    for t in ${IMAGE_TYPES}; do
	case $t in
	  fit|fit.*)
		${IMAGE_CMD:fit}
		break
		;;
	esac
    done

    # second pass; apply conversions
    for t in ${IMAGE_TYPES}; do
	case $t in
	  fit.gz)
		${CONVERSION_CMD:gz}
		;;
	  fit.xz)
		${CONVERSION_CMD:xz}
		;;
	esac
    done

    # third pass; rename to base name
    for t in ${IMAGE_TYPES}; do
	case $t in
	  fit|fit.*)
		mv ${IMAGE_NAME}.$t ${IMAGE_BASENAME}.$t
		;;
	esac
    done
}
addtask do_image_fit before do_deploy

do_install[dirs] = "${B}"
fitimage_do_install() {
    for t in ${IMAGE_TYPES}; do
	case $t in
	  fit|fit.*)
		install -D -p -m 0644 ${IMAGE_BASENAME}.$t ${D}/boot/${FITIMAGE_BOOT_NAME}.$t
		;;
	esac
    done
}
addtask do_install before do_build after do_image_fit

do_deploy[cleandirs] = "${DEPLOYDIR}"
do_deploy[dirs] = "${B}"
fitimage_do_deploy() {
    for t in ${IMAGE_TYPES}; do
	case $t in
	  fit|fit.*)
		install -D -p -m 0644 '${IMAGE_BASENAME}'.$t '${DEPLOYDIR}/${IMAGE_NAME}'.$t
		ln -s '${IMAGE_NAME}'.$t '${DEPLOYDIR}/${IMAGE_BASENAME}'.$t
		ln -s '${IMAGE_NAME}'.$t '${DEPLOYDIR}/${IMAGE_BASENAME}-${MACHINE}'.$t
		;;
	esac
    done
}
addtask do_deploy before do_build after do_image_fit

EXPORT_FUNCTIONS do_image_fit do_install do_deploy
