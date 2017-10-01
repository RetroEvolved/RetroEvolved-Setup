RetroEvolved-Setup
==============

General Usage
-------------

This is a Shell script originally based off "RetroPie" designed to setup the Raspberry Pi, ODroid-C1 or a PC running Ubuntu with many emulators and games using EmulationStation as the graphical front end. Bootable pre-made images for the Raspberry Pi are available for those that want a ready to go system, downloadable via our website at https://RetroGame.Club/pages/RetroEvolved

This script is designed for use on Raspbian on the Rasperry Pi, or Ubuntu on the ODroid-C1 or a PC.

To run the RetroEvolved Setup Script make sure that your APT repositories are up-to-date and that Git is installed:

```shell
sudo apt-get update
<!--sudo apt-get dist-upgrade (DO NOT UPGRADE TO RASPBIAN STRETCH AS IT IS NOT YET SUPPORTED)-->
sudo apt-get install git
```

Then you can download the latest RetroEvolved setup script with

```shell
cd
git clone --depth=1 https://github.com/RetroEvolved/RetroEvolved-Setup.git
```

The script is executed with 

```shell
cd RetroEvolved-Setup
sudo ./retroevolved_setup.sh
```

When you first run the script it may install some additional packages that are needed.

Binaries and Sources
--------------------

On the Raspberry Pi, RetroEvolved Setup offers the possibility to install from binaries or source. For other supported platforms only a source install is available. Installing from binary is recommended on a Raspberry Pi as building everything from source can take a long time.

For more information visit the blog at https://RetroGame.Club/blogs/Tutorials or the repository at https://github.com/RetroEvolved/RetroEvolved-Setup.


Thanks
------

This script is entirely based off the hard work of the RetroPie team and many thanks go out to them for creating such a powerful script! Please note that our aim with the RetroEvolved project is not to take any due credit away from the RetroPie team, but rather make their script accessable to developers who desire to sell hardware preinstalled with this code as this is one of the great joys of the GNU GPL!
