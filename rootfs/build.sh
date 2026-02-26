#!/bin/bash

set -e

# Rootfs definitions
ROOTFS_NAME="vanilla-pico"
REPO_URL=https://repo3.vanillaos.org/20260224T144255Z
CUSTOM_PACKAGE=""
CLEANUPS=(
  "/usr/share/doc/*"
  "/usr/share/info/*"
  "/usr/share/lintian/overrides/*"
  "/usr/share/locale/*"
  "/usr/share/man/*"
  "/var/cache"
  "/var/log/*"
)

# Root check - debootstrap requires root privileges
if [ "$(id -u)" != "0" ];
  then echo "This script must be run as root"
  exit
fi

# Check if debootstrap is installed
if ! [ -x "$(command -v debootstrap)" ]; then
  echo 'Error: debootstrap is not installed.' >&2
  exit 1
fi

# Check if the includes.rootfs directory exists
if [ ! -d "includes.rootfs" ]; then
  echo "Error: includes.rootfs directory not found."
  exit 1
fi

mkdir -p $ROOTFS_NAME
cp -r includes.rootfs/* $ROOTFS_NAME

debootstrap \
    --variant=minbase \
    --include=$CUSTOM_PACKAGE,apt-utils,apt-transport-https,ca-certificates,gnupg2,bash,bzip2 \
    sid \
    $ROOTFS_NAME \
    $REPO_URL

# We need to remove the sources.list file since it is not needed
# after the debootstrap process. include.chroot already contains
# the correct sources.list file.
rm -rf $ROOTFS_NAME/etc/apt/sources.list

# Cleanup
chroot $ROOTFS_NAME apt update
chroot $ROOTFS_NAME apt upgrade -y
chroot $ROOTFS_NAME apt install -f -y
chroot $ROOTFS_NAME apt clean
chroot $ROOTFS_NAME apt autoremove -y

for path in "${CLEANUPS[@]}"; do
  rm -rf $ROOTFS_NAME$path
done

# Restore apt cache directory
mkdir -p $ROOTFS_NAME/var/cache/apt/archives/partial

# Compression
tar -cvf $ROOTFS_NAME.tar -C $ROOTFS_NAME .
tar -czvf $ROOTFS_NAME.tar.gz -C $ROOTFS_NAME .
zstd -19 $ROOTFS_NAME.tar
chmod 644 $ROOTFS_NAME.tar.zst
