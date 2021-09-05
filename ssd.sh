#!/bin/bash
loadkeys pl
setfont Lat2-Terminus16
timedatectl set-ntp true
wipefs -a /dev/sda
wipefs -a /dev/sdb
fdisk -l

echo Example: sda

read -p '/dev/' hardDrivevar

fdisk /dev/$hardDrivevar << EOF
g
n
1

+550M
n
2


t
1
83
t
2
82


w
EOF


echo Example: sdb

read -p '/dev/' hardDrivevar

fdisk /dev/$hardDrivevar << EOF
g
n
1


w
EOF


mkfs.vfat -F32 -n EFI /dev/sda1
mkfs.ext4 -L root /dev/sda2
#mkswap -L swap /dev/sda3
mkfs.ext4 -L dane /dev/sdb1

mount /dev/sda2 /mnt
#swapon /dev/sda3
mkdir /mnt/home
mount /dev/sdb1 /mnt/home

mv arch-chroot.sh /mnt

sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads = 5|ParallelDownloads = 25|' /etc/pacman.conf

pacstrap -i /mnt base base-devel bash-completion intel-ucode iucode-tool linux linux-firmware linux-headers nano dhcpcd neofetch


genfstab -U /mnt >> /mnt/etc/fstab



arch-chroot /mnt/
