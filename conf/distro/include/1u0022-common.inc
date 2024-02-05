## --*- bitbake -*--

TCLIBCAPPEND = ""
DISTRO_VERSION = "0.0"
DISTRO_NAME = "consolinno leaflet distro"

### core distro settings

INIT_MANAGER = "systemd"

DISTRO_FEATURES_DEFAULT:append = " usrmerge tpm2 virtualization"
DISTRO_FEATURES_DEFAULT:remove = "alsa bluetooth irda nfc pcmcia pci zeroconf 3g x11 ext2 nfs vfat"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "pulseaudio bluez5 sysvinit"

### static uid/gid

USERADD_GID_TABLES += "files/groups-static A"
USERADD_UID_TABLES += "files/passwd-static"
USERADD_ERROR_DYNAMIC = "skip"

USERADDEXTENSION = "useradd-staticids"

### security/ca setup

L1U0022_CA_PATH       ??= "~/.local/share/1u0022-ca"

## NOTE: this variable must not be expanded within "fakeroot" python fragments!
_L1U0022_CA_PATH_EXPANDED = "${@os.path.expanduser(d.getVar('L1U0022_CA_PATH'))}"

#### rauc

L1U0022_RAUC_CA_PATH  ??= "${_L1U0022_CA_PATH_EXPANDED}/rauc"
L1U0022_RAUC_KEY_FILE ??= "${L1U0022_RAUC_CA_PATH}/rauc.key"
L1U0022_RAUC_CRT_FILE ??= "${L1U0022_RAUC_CA_PATH}/rauc.crt"

## overrides the weak default in rauc-target.inc
RAUC_KEYRING_URI   ?= "file://${L1U0022_RAUC_CRT_FILE}"

#### image

L1U0022_IMAGE_CA_PATH  ??= "${_L1U0022_CA_PATH_EXPANDED}/image"
L1U0022_IMAGE_KEY_FILE ??= "${L1U0022_IMAGE_CA_PATH}/image.key"
L1U0022_IMAGE_CRT_FILE ??= "${L1U0022_IMAGE_CA_PATH}/image.crt"

L1U0022_IMAGE_KEY_HINT ??= "l1u0022-signing-key"

#### HAB

L1U0022_HAB_CA_PATH    ??= "${_L1U0022_CA_PATH_EXPANDED}/hab"
L1U0022_HAB_CA_PATH[doc] = "\
    Base directory of HAB CA; beside the entries listed below a file \
    with an hardcoded name 'key_pass.txt' is expected there. \
"

L1U0022_HAB_SRK_INDEX  ??= "0"
L1U0022_HAB_TABLE_BIN  ??= "${L1U0022_HAB_CA_PATH}/SRK.table.bin"

L1U0022_HAB_CSF_BASE   ??= "${L1U0022_HAB_CA_PATH}/CSF.pem"
L1U0022_HAB_CSF_BASE[doc] = "\
    CSF certificate; when ending in '_crt.pem' another file with a \
    '_key.pem' suffix is expected which contains the corresponding \
    private key\
"

L1U0022_HAB_IMG_BASE   ??= "${L1U0022_HAB_CA_PATH}/IMG.pem"
L1U0022_HAB_IMG_BASE[doc] = "\
    IMG certificate; when ending in '_crt.pem' another file with a \
    '_key.pem' suffix is expected which contains the corresponding \
    private key\
"

### misc settings
ROOT_HOME = "/root"
