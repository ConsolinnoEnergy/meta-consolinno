# SPDX-License-Identifier: GPL-2.0-or-later
#
# Author: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>

inherit barebox-environment-2

kconfig_set() {
    bbnote "Setting $1 in .config to $2"
    if [ "$2" = "n" ]; then
        line="# CONFIG_$1 is not set"
    else
        line="CONFIG_$1=$2"
    fi

    if [ "$(grep -E CONFIG_$1[=\ ] ${B}/.config)" ]; then
        sed -i "/CONFIG_$1[= ]/c\\$line" ${B}/.config
    else
        echo "$line" >> ${B}/.config
    fi
}

def env_file(d, opt, fname = None):
    if not fname:
        fname = opt

    fname = os.path.join(d.getVar("WORKDIR", True), fname)

    with open(fname) as f:
        data = f.read()
        env_add(d, opt, data)
