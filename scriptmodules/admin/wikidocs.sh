#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is a derivative reworking of The RetroPie Project. The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

rp_module_id="wikidocs"
rp_module_desc="Generate mkdocs documentation from wiki"
rp_module_section=""

function depends_wikidocs() {
    getDepends python3 python3-pip libyaml-dev
    pip3 install --upgrade mkdocs mkdocs-material
}

function sources_wikidocs() {
    gitPullOrClone "$md_build" https://github.com/RetroEvolved/RetroEvolved-Docs.git
    gitPullOrClone "$md_build/docs" https://github.com/RetroEvolved/retroevolved-setup.wiki.git

    cp -v "docs/Home.md" "docs/index.md"
    cp -R "$md_build/"{images,stylesheets} "docs/"
}

function build_wikidocs() {
    mkdocs build
}

function install_wikidocs() {
    rsync -a --delete "$md_build/site/" "$__tmpdir/wikidocs/"
    chown -R $user:$user "$__tmpdir/wikidocs"
}

function upload_wikidocs() {
    rsync -av --delete "$__tmpdir/wikidocs/" "retroevolved@$__binary_host:docs/"
}
