#!/usr/bin/env bash
set -euo pipefail


# Get the current debian release
current_debian_release="$(grep "VERSION_CODENAME" /etc/os-release | cut -d = -f2)"

target_debian_release=""
cont=""

apt_config_location="/etc/apt/sources.list"
proxmox_source_list_location="/etc/apt/sources.list.d/pve-no-subscription.list"
proxmox_license_source_location="/etc/apt/sources.list.d/pve-enterprise.list"

echo "This script updates the Debian APT config file as well as the Proxmox update config file."
echo "However you will still be prompted for apt updates."

read -p "Please enter the desired debian release name. " target_debian_release

echo "Current detected debian release: $current_debian_release"

read -p "Do you want to continue? (y/n)" cont

if [ "$cont" == "n" ] ; then
        echo "Exiting..."
        exit 0
fi

echo "Updating APT config"
sed -i s/"$current_debian_release"/"$target_debian_release" "$apt_config_location"

echo "Updating proxmox no subscription file"
sed -i s/"$current_debian_release"/"$target_debian_release" "$proxmox_source_list_location"

if [ -f "$proxmox_license_source_location" ] ; then
        rm -f "$proxmox_license_source_location"
fi

echo "Performing apt update."
apt update
echo "Performing full upgrade (should be attended)."
apt full-upgrade