#!/usr/bin/env bash

# This file is part of The RetroEvolved Project
#
# The RetroEvolved Project is a derivative reworking of the RetroPie setup script which is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroEvolved/RetroEvolved-Setup/master/LICENSE.md
#

scriptdir="$(dirname "$0")"
scriptdir="$(cd "$scriptdir" && pwd)"

"$scriptdir/retroevolved_packages.sh" setup gui

