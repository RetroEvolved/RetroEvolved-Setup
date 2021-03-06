# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is a derivative reworking of The RetroPie Project. The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="golang"
rp_module_desc="Golang binary install"
rp_module_section=""
rp_module_flags="noinstclean"

function _get_goroot_golang() {
    echo "$rootdir/supplementary/golang"
}

function install_bin_golang() {
    local version
    if [[ -e "$md_inst/bin/go" ]]; then
        local version=$(GOROOT="$md_inst" "$md_inst/bin/go" version | sed 's/.*\(go1[^ ]*\).*/\1/')
    fi
    printMsgs "console" "Current Go version: $version"
    if [[ ! "${version}" < "go1.8" ]]; then
        return 0
    fi

    rm -rf "$md_inst"
    mkdir -p "$md_inst"
    local arch="armv6l"
    if isPlatform "x86"; then
        if isPlatform "64bit"; then
            arch="amd64"
        else
            arch="386"
        fi
    fi
    printMsgs "console" "Downloading go1.8.linux-$arch.tar.gz"
    downloadAndExtract "https://storage.googleapis.com/golang/go1.8.linux-$arch.tar.gz" "$md_inst" 1
}
