#!/bin/bash

# NOOBS partition setup script for Arch Linux ARM
#  - part1 == boot partition (FAT), part2 == root partitions (ext4)
#  - example usage:
#    ./partition_setup.sh part1=/dev/mmcblk0p7 id1=LABEL=root part2=/dev/mmcblk0p8 id2=UUID=550e8400-e29b-41d4-a716-446655440000

# extract and set part1 and part2 variables
part1=
part2=
while [[ $# > 0 ]]; do
  part=`expr "$1" : '\(^part[1-2]\)'`
  if [[ "${part}" != '' ]]; then
    eval ${part}=`expr "$1" : '.*=\(.*\)'`
  fi
  shift
done

if [[ ${part1} == '' || ${part2} == '' ]]; then
  echo "error: part1 and part2 not specified"
  exit 1
fi

# create mount points
mkdir /tmp/1
mkdir /tmp/2

# mount partitions
mount ${part1} /tmp/1
mount ${part2} /tmp/2

# adjust files
sed -ie "s|@ROOT@|${part2}|" /tmp/1/cmdline.txt
sed -ie "s|@BOOT@|${part1}|" /tmp/2/etc/fstab

# clean up
umount /tmp/1
umount /tmp/2
