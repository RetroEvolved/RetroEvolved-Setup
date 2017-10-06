#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is a derivative reworking of The RetroPie Project. The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="scummvm"
rp_module_desc="ScummVM"
rp_module_help="Copy your ScummVM games to $romdir/scummvm"
rp_module_licence="GPL2 https://raw.githubusercontent.com/scummvm/scummvm/master/COPYING"
rp_module_section="opt"
rp_module_flags="!mali"

function depends_scummvm() {
    local depends=(libmpeg2-4-dev libogg-dev libvorbis-dev libflac-dev libmad0-dev libpng12-dev libtheora-dev libfaad-dev libfluidsynth-dev libfreetype6-dev zlib1g-dev libjpeg-dev)
    if [[ "$md_id" == "scummvm-sdl1" ]]; then
        depends+=(libsdl1.2-dev)
    else
        depends+=(libsdl2-dev)
    fi
    getDepends "${depends[@]}"
}

function sources_scummvm() {
    gitPullOrClone "$md_build" https://github.com/scummvm/scummvm.git "branch-1-9"
    if isPlatform "rpi"; then
        applyPatch rpi_enable_scalers.diff <<\_EOF_
diff --git a/configure b/configure
index 31dbf5a..58e9563 100755
--- a/configure
+++ b/configure
@@ -2651,10 +2651,6 @@ if test -n "$_host"; then
 			append_var LDFLAGS "-L$RPI_ROOT/opt/vc/lib"
 			# This is so optional OpenGL ES includes are found.
 			append_var CXXFLAGS "-I$RPI_ROOT/opt/vc/include"
-			_savegame_timestamp=no
-			_eventrec=no
-			_build_scalers=no
-			_build_hq_scalers=no
 			# We prefer SDL2 on the Raspberry Pi: acceleration now depends on it
 			# since SDL2 manages dispmanx/GLES2 very well internally.
 			# SDL1 is bit-rotten on this platform.
_EOF_
    fi
}

function build_scummvm() {
    local params=(--enable-all-engines --enable-vkeybd --enable-release --disable-debug --enable-keymapper --disable-eventrecorder --prefix="$md_inst")
    isPlatform "rpi" && params+=(--host=raspberrypi)
    # stop scummvm using arm-linux-gnueabihf-g++ which is v4.6 on wheezy and doesn't like rpi2 cpu flags
    if isPlatform "rpi"; then
        CC="gcc" CXX="g++" ./configure "${params[@]}"
    else
        ./configure "${params[@]}"
    fi
    make clean
    make
    strip "$md_build/scummvm"
    md_ret_require="$md_build/scummvm"
}

function install_scummvm() {
    make install
    mkdir -p "$md_inst/extra"
    cp -v backends/vkeybd/packs/vkeybd_*.zip "$md_inst/extra"
}

function configure_scummvm() {
    mkRomDir "scummvm"

    local dir
    mkUserDir "$home/.local"
    for dir in .config .local/share .cache; do
        mkUserDir "$home/$dir"
        moveConfigDir "$home/$dir/scummvm" "$md_conf_root/scummvm"
    done

    # Create startup script
    rm -f "$romdir/scummvm/+Launch GUI.sh"
    local name="ScummVM"
    [[ "$md_id" == "scummvm-sdl1" ]] && name="ScummVM-SDL1"
    cat > "$romdir/scummvm/+Start $name.sh" << _EOF_
#!/bin/bash
game="\$1"
pushd "$romdir/scummvm" >/dev/null
$md_inst/bin/scummvm --fullscreen --joystick=0 --extrapath="$md_inst/extra" \$game
while read line; do
    id=(\$line);
    touch "$romdir/scummvm/\$id.svm"
done < <($md_inst/bin/scummvm --list-targets | tail -n +3)
popd >/dev/null
_EOF_
    chown $user:$user "$romdir/scummvm/+Start $name.sh"
    chmod u+x "$romdir/scummvm/+Start $name.sh"

    addEmulator 1 "$md_id" "scummvm" "bash $romdir/scummvm/+Start\ $name.sh %BASENAME%"
    addSystem "scummvm"
}
