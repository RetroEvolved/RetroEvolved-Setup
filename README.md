RetroEvolved-Setup
==============

Disclaimer
------------

The RetroEvolved Setup Script is a derivitave reworking of the "RetroPie" setup script (Found Here: https://github.com/RetroPie/RetroPie-Setup) with minor changes made to remove all non-commercial licensed code, trademarked images and provide a medium for developers and resellers to sell their hardware preinstalled with this code without fear of legal repercussion. All references to "RetroPie" have thus been replaced with "RetroEvolved" to distinguish this project from it's original source. This code is licensed under the same licenses as the original source "RetroPie" which is the GNU GPL version stated below in the License section. "RetroEvolved" was created to distinguish itself completely from RetroPie but in no way is attempting to take credit for the hard work of the RetroPie team! Only commercially usable emulators, etc. are allowed to be pre-built onto a distributable image, but all non-commercial emulators can be downloaded by the end-user by utilizing this setup script.

License
-------------

GNU GENERAL PUBLIC LICENSE, Version 3, 29 June 2007

General Usage
-------------

This is a shell script designed to setup the Raspberry Pi, ODroid-C1 or a PC running Ubuntu with many emulators and games using EmulationStation as the graphical front end. Bootable pre-made images for the Raspberry Pi are available for those that want a ready to go system, downloadable via our website at https://RetroGame.Club/pages/RetroEvolved

This script is designed for use on Raspbian on the Rasperry Pi, or Ubuntu on the ODroid-C1 or a PC.

To run the RetroEvolved Setup Script make sure that your APT repositories are up-to-date and that Git is installed:

```shell
sudo apt-get update
sudo apt-get dist-upgrade
sudo apt-get install git
```

Then you can download the latest RetroEvolved setup script with

```shell
cd
git clone --depth=1 https://github.com/RetroEvolved/RetroEvolved-Setup.git
```

The script is executed with 

```shell
chmod u+x **/*.sh
cd RetroEvolved-Setup
sudo ./retroevolved_setup.sh
```

When you first run the script it may install some additional packages that are needed.

Binaries and Sources
--------------------

On the Raspberry Pi, the RetroEvolved Setup script offers the possibility to install from binaries or source. For other supported platforms only a source install is available. Installing from binary is recommended on a Raspberry Pi as building everything from source can take a long time.

For more information visit the blog at https://RetroGame.Club/blogs/Tutorials or the repository at https://github.com/RetroEvolved/RetroEvolved-Setup. If you would like to see more information about "RetroPie" please go to https://retropie.org.uk/


Thanks
------

Without Retro Game Emulators and EmulationStation culminating from the hard work of hundreds of developers, this project would not be possible. EmulationStation is the incredible front-end to this project which allows us to use custom themes and integrate the emulator packages mentioned above.

Again we would like to mention that this script is entirely based off the hard work of the RetroPie team and many thanks go out to them for creating such a powerful script! Please note that our aim with the RetroEvolved project is not to take any due credit away from the RetroPie team, but rather make their script accessable to developers who desire to sell hardware preinstalled with this code as this is one of the great joys of the GNU GPL!
