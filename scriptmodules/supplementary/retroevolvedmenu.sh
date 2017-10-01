#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="retroevolvedmenu"
rp_module_desc="RetroEvolved configuration menu for EmulationStation"
rp_module_section="core"

function _update_hook_retroevolvedmenu() {
    # to show as installed when upgrading to retroevolved-setup 4.x
    if ! rp_isInstalled "$md_idx" && [[ -f "$home/.emulationstation/gamelists/retroevolved/gamelist.xml" ]]; then
        mkdir -p "$md_inst"
        # to stop older scripts removing when launching from retroevolved menu in ES due to not using exec or exiting after running retroevolved-setup from this module
        touch "$md_inst/.retroevolved"
    fi
}

function depends_retroevolvedmenu() {
    getDepends mc
}

function install_bin_retroevolvedmenu() {
    return
}

function configure_retroevolvedmenu()
{
    [[ "$md_mode" == "remove" ]] && return

    local rpdir="$home/RetroEvolved/retroevolvedmenu"
    mkdir -p "$rpdir"
    cp -Rv "$md_data/icons" "$rpdir/"
    chown -R $user:$user "$rpdir"

    isPlatform "rpi" && rm -f "$rpdir/dispmanx.rp"

    # add the gameslist / icons
    local files=(
        'audiosettings'
        'bluetooth'
        'configedit'
        'esthemes'
        'filemanager'
        'raspiconfig'
        'retroarch'
        'retronetplay'
        'rpsetup'
        'runcommand'
        'showip'
        'splashscreen'
        'wifi'
    )

    local names=(
        'Audio'
        'Bluetooth'
        'Configuration Editor'
        'ES Themes'
        'File Manager'
        'Raspi-Config'
        'Retroarch'
        'RetroArch Net Play'
        'RetroEvolved Setup'
        'Run Command Configuration'
        'Show IP'
        'Splash Screens'
        'WiFi'
    )

    local descs=(
        'Configure audio settings. Choose default of auto, 3.5mm jack, or HDMI. Mixer controls, and apply default settings.'
        'Register and connect to bluetooth devices. Unregister and remove devices, and display registered and connected devices.'
        'Change common RetroArch options, and manually edit RetroArch configs, global configs, and non-RetroArch configs.'
        'Install, uninstall, or update EmulationStation themes. Most themes can be previewed at https://github.com/retroevolved/ RetroEvolved-Setup/wiki/themes.'
        'Basic ascii file manager for linux allowing you to browse, copy, delete, and move files.'
        'Change user password, boot options, internationalization, camera, add your pi to Rastrack, overclock, overscan, memory split, SSH and more.'
        'Launches the RetroArch GUI so you can change RetroArch options. Note: Changes will not be saved unless you have enabled the "Save Configuration On Exit" option.'
        'Set up RetroArch Netplay options, choose host or client, port, host IP, delay frames, and your nickname.'
        'Install RetroEvolved from binary or source, install experimental packages, additional drivers, edit samba shares, custom scraper, as well as other RetroEvolved-related configurations.'
        'Change what appears on the runcommand screen. Enable or disable the menu, enable or disable box art, and change CPU configuration.'
        'Displays your current IP address, as well as other information provided by the command, "ip addr show."'
        'Enable or disable the splashscreen on RetroEvolved boot. Choose a splashscreen, download new splashscreens, and return splashscreen to default.'
        'Connect to or disconnect from a wifi network and configure wifi settings.'
    )

    setESSystem "RetroEvolved" "retroevolved" "$rpdir" ".rp .sh" "sudo $scriptdir/retroevolved_packages.sh retroevolvedmenu launch %ROM% </dev/tty >/dev/tty" "" "retroevolved"

    local file
    local name
    local desc
    local image
    local i
    for i in "${!files[@]}"; do
        case "${files[i]}" in
            audiosettings|raspiconfig|splashscreen)
                ! isPlatform "rpi" && continue
                ;;
            wifi)
                [[ "$__os_id" != "Raspbian" ]] && continue
        esac

        file="${files[i]}"
        name="${names[i]}"
        desc="${descs[i]}"
        image="$home/RetroEvolved/retroevolvedmenu/icons/${files[i]}.png"

        touch "$rpdir/$file.rp"

        local function
        for function in $(compgen -A function _add_rom_); do
            "$function" "retroevolved" "RetroEvolved" "$file.rp" "$name" "$desc" "$image"
        done
    done
}

function remove_retroevolvedmenu() {
    rm -rf "$home/RetroEvolved/retroevolvedmenu"
    delSystem "" retroevolved
}

function launch_retroevolvedmenu() {
    clear
    local command="$1"
    local basename="${command##*/}"
    local no_ext=${basename%.rp}
    case $basename in
        retroarch.rp)
            cp "$configdir/all/retroarch.cfg" "$configdir/all/retroarch.cfg.bak"
            chown $user:$user "$configdir/all/retroarch.cfg.bak"
            su $user -c "\"$emudir/retroarch/bin/retroarch\" --menu --config \"$configdir/all/retroarch.cfg\""
            iniConfig " = " '"' "$configdir/all/retroarch.cfg"
            iniSet "config_save_on_exit" "false"
            ;;
        rpsetup.rp)
            rp_callModule setup gui
            ;;
        raspiconfig.rp)
            raspi-config
            ;;
        filemanager.rp)
            mc
            ;;
        showip.rp)
            local ip="$(ip route get 8.8.8.8 2>/dev/null | head -1 | cut -d' ' -f8)"
            printMsgs "dialog" "Your IP is: $ip\n\nOutput of 'ip addr show':\n\n$(ip addr show)"
            ;;
        *.rp)
            rp_callModule $no_ext depends
            if fnExists gui_$no_ext; then
                rp_callModule $no_ext gui
            else
                rp_callModule $no_ext configure
            fi
            ;;
        *.sh)
            cd "$home/RetroEvolved/retroevolvedmenu"
            sudo -u "$user" bash "$command"
            ;;
    esac
    clear
}