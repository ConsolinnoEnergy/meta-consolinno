## --*- bitbake -*--

TCLIBCAPPEND = ""
DISTRO_VERSION = "0.0"
DISTRO_NAME = "consolinno leaflet distro"

### core distro settings

INIT_MANAGER = "systemd"

DISTRO_FEATURES_DEFAULT:append = " usrmerge"
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

### misc settings
ROOT_HOME = "/root"
