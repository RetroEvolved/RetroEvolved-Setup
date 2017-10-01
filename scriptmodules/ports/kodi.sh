#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="kodi"
rp_module_desc="Kodi - Open source home theatre software"
rp_module_licence="GPL2 https://raw.githubusercontent.com/xbmc/xbmc/master/LICENSE.GPL"
rp_module_section="opt"
rp_module_flags="!mali !osmc !xbian"

function _update_hook_kodi() {
    # to show as installed in retroevolved-setup 4.x
    hasPackage kodi && mkdir -p "$md_inst"
}

function depends_kodi() {
    if [[ "$md_mode" == "install" ]]; then
        if isPlatform "x86"; then
            apt-add-repository -y ppa:team-xbmc/ppa
        fi
    fi

    if isPlatform "rpi"; then
        # remove old repositories
        rm -f /etc/apt/sources.list.d/mene.list
        rm -f /etc/apt/sources.list.d/pipplware.list
        apt-key del 4096R/BAA567BB >/dev/null
    fi

    getDepends policykit-1

    addUdevInputRules
}

function install_bin_kodi() {
    # force aptInstall to get a fresh list before installing
    __apt_update=0
    aptInstall kodi kodi-peripheral-joystick kodi-inputstream-adaptive kodi-inputstream-rtmp
}

function remove_kodi() {
    aptRemove kodi
    rp_callModule kodi depends remove
}

function configure_kodi() {
    # remove old directLaunch entry
    delSystem "$md_id" "kodi"

    moveConfigDir "$home/.kodi" "$md_conf_root/kodi"

    addPort "$md_id" "kodi" "Kodi" "kodi"
}
