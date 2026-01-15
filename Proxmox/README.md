# Table of Contents
-  [Proxmox Auto Update](#proxmox-auto-update)
# Proxmox Auto Update
### Allows you to quickly update your Proxmox VE version.
- The script edits Debian APT config as well as the Proxmox repository config based on your provided debian release code name.
- Written based on 8.x -> 9.x update, but will also work on 7.x -> 8.x.
- You will be asked to provide debian release code name ([it can be found here](https://www.debian.org/releases/) (all lowercases are expected) or in the official Proxmox VE update guide).
- Make sure to read the official guide before running the script as well as look over the script before using it to make sure that it meets all necessary criteria.
- Made only for non enterprise versions.
# 