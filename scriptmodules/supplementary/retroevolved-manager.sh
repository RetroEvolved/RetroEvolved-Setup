#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is a derivative reworking of The RetroPie Project. The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="retroevolved-manager"
rp_module_desc="Web Based Manager originally designed for RetroPie files and configs based on the Recalbox Manager"
rp_module_help="Open your browser and go to http://your_retroevolved_ip:8000/"
rp_module_licence="MIT https://raw.githubusercontent.com/botolo78/RetroPie-Manager/retropie/ORIGINAL%20LICENCE.txt"
rp_module_section="exp"
rp_module_flags="noinstclean"

function depends_retroevolved-manager() {
    local depends=(python-dev virtualenv)
    getDepends "${depends[@]}"
}

function sources_retroevolved-manager() {
    gitPullOrClone "$md_inst" "https://github.com/botolo78/RetroPie-Manager.git"
}

function install_retroevolved-manager() {
    cd "$md_inst"
    chown -R $user:$user "$md_inst"
    sudo -u $user make install
}

function _is_enabled_retroevolved-manager() {
    grep -q 'rpmanager\.sh.*--start' /etc/rc.local
    return $?
}

function enable_retroevolved-manager() {
    local config="\"$md_inst/rpmanager.sh\" --start --user $user 2>\&1 > /dev/shm/rpmanager.log \&"

    if _is_enabled_retroevolved-manager; then
        dialog \
          --yesno "RetroEvolved-Manager is already enabled in /etc/rc.local with the following config.\n\n$(grep "rpmanager\.sh" /etc/rc.local)\n\nDo you want to update it?" \
          22 76 2>&1 >/dev/tty || return
    fi

    sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
    sed -i "s|^exit 0$|${config}\\nexit 0|" /etc/rc.local
    printMsgs "dialog" "RetroEvolved-Manager enabled in /etc/rc.local\n\nIt will be started on next boot."
}

function disable_retroevolved-manager() {
    if _is_enabled_retroevolved-manager; then
        dialog \
          --yesno "Are you sure you want to disable RetroEvolved-Manager on boot?" \
          22 76 2>&1 >/dev/tty || return

        sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
        printMsgs "dialog" "RetroEvolved-Manager configuration in /etc/rc.local has been removed."
    else
        printMsgs "dialog" "RetroEvolved-Manager was already disabled in /etc/rc.local."
    fi
}

function remove_retroevolved-manager() {
    sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
}

function gui_retroevolved-manager() {
    local cmd=()
    local options=(
        1 "Start RetroEvolved-Manager now"
        2 "Stop RetroEvolved-Manager now"
        3 "Enable RetroEvolved-Manager on Boot"
        4 "Disable RetroEvolved-Manager on Boot"
    )
    local choice
    local rpmanager_status
    local error_msg

    while true; do
        if [[ -f "$md_inst/rpmanager.sh" ]]; then
            rpmanager_status="$($md_inst/rpmanager.sh --isrunning)\n\n"
        fi
        if _is_enabled_retroevolved-manager; then
            rpmanager_status+="RetroEvolved-Manager is currently enabled on boot"
        else
            rpmanager_status+="RetroEvolved-Manager is currently disabled on boot"
        fi
        cmd=(dialog --backtitle "$__backtitle" --menu "$rpmanager_status\n\nChoose an option." 22 86 16)
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1)
                    dialog --infobox "Starting RetroEvolved-Manager" 4 30 2>&1 >/dev/tty
                    error_msg="$("$md_inst/rpmanager.sh" --start 2>&1 >/dev/null)" \
                    || printMsgs "dialog" "$error_msg"
                    ;;

                2)
                    dialog --infobox "Stopping RetroEvolved-Manager" 4 30 2>&1 >/dev/tty
                    error_msg="$("$md_inst/rpmanager.sh" --stop 2>&1 >/dev/null)" \
                    || printMsgs "dialog" "$error_msg"
                    ;;

                3)  enable_retroevolved-manager
                    ;;

                4)  disable_retroevolved-manager
                    ;;
            esac
        else
            break
        fi
    done
}
