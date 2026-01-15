#!/usr/bin/env bash
set -euo pipefail


# Get the current debian release of your system
current_debian_release="$(grep "VERSION_CODENAME" /etc/os-release | cut -d = -f2)"

target_debian_release=""
cont=""

# Files that need to be modified
apt_config_location="/etc/apt/sources.list"
proxmox_source_list_location="/etc/apt/sources.list.d/pve-no-subscription.list"
proxmox_license_source_location="/etc/apt/sources.list.d/pve-enterprise.list"

echo "This script automates the update to a newer version of Proxmox VE."
echo "However you will still be prompted for apt updates and certain config choices."

read -p "Please enter the desired debian code name (Can be found in https://www.debian.org/releases/)." target_debian_release
# Force the name to lowercase
target_debian_release="${target_debian_release,,}"


echo "Current detected debian release: $current_debian_release"

read -p "Do you want to continue? (y/n)" cont

if [ "$cont" != "y" ] ; then
        echo "Exiting..."
        exit 0
fi

# Updates base debian repositories
if [ -f "$apt_config_location" ] ; then
        echo "Updating APT config"
        sed -i s/"$current_debian_release"/"$target_debian_release"/g "$apt_config_location"
else 
        echo "APT config file seems to be missing please create this file accordingly."
        echo "$apt_config_location"
        exit 0
fi

# Updates proxmox repositories
if [ -f "$proxmox_source_list_location" ] ; then
        echo "Updating proxmox no subscription file."
        sed -i s/"$current_debian_release"/"$target_debian_release"/g "$proxmox_source_list_location"
else 
        echo "No subscription file does not exits... Creating now..."
        touch "$proxmox_source_list_location"
        echo "deb http://download.proxmox.com/debian/pve $target_debian_release pve-no-subscription" > "$proxmox_source_list_location"
fi

# Removes the enterprise version repository
if [ -f "$proxmox_license_source_location" ] ; then
        rm -f "$proxmox_license_source_location"
fi

echo "Performing apt update."
apt update

if [ "$target_debian_release" == "trixie" ] ; then
        apt install proxmox-archive-keyring
fi

echo "Performing full upgrade (should be attended)."
apt full-upgrade
