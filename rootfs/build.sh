#!/bin/bash

# Rootfs definitions
ROOTFS_NAME="vanilla-pico"
REPO_URL=http://repo2.vanillaos.org
REPO_KEY=vanilla.key
CUSTOM_PACKAGE=""
CLEANUP_DIRS="/usr/share/doc/*
/usr/share/info/*
/usr/share/linda/*
/usr/share/lintian/overrides/*
/usr/share/locale/*
/usr/share/man/*
/usr/share/doc/kde/HTML/*/*
/usr/share/gnome/help/*/*
/usr/share/locale/*
/usr/share/omf/*/*-*.emf
/var/cache"

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
    --keyring=includes.rootfs/usr/share/keyrings/vanilla_keyring.gpg \
    sid \
    $ROOTFS_NAME \
    $REPO_URL

# Add the vanilla extra repository key
chroot $ROOTFS_NAME apt-key add /$REPO_KEY

# We need to remove the sources.list file since it is not needed
# after the debootstrap process. include.chroot already contains
# the correct sources.list file.
rm -rf $ROOTFS_NAME/etc/apt/sources.list

# Cleanup
chroot $ROOTFS_NAME apt update
chroot $ROOTFS_NAME apt upgrade -y
chroot $ROOTFS_NAME apt clean
chroot $ROOTFS_NAME apt autoremove -y

for dir in $CLEANUP_DIRS; do
    rm -rf $ROOTFS_NAME/$dir
done

# Restore apt cache directory
mkdir -p $ROOTFS_NAME/var/cache/apt/archives/partial

# Compression
tar -cvf $ROOTFS_NAME.tar -C $ROOTFS_NAME .
zstd -19 $ROOTFS_NAME.tar
rm $ROOTFS_NAME.tar
chmod 644 $ROOTFS_NAME.tar.zst
