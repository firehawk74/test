#!/bin/bash

sed -i 's|#Color|Color|' /etc/pacman.conf
sed -i 's|#ParallelDownloads = 5|ParallelDownloads = 25|' /etc/pacman.conf

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

hwclock --systohc --utc

sed -i 's|#en_US.UTF-8 UTF-8|en_US.UTF-8 UTF-8|' /etc/locale.gen
sed -i 's|#pl_PL.UTF-8 UTF-8|pl_PL.UTF-8 UTF-8|' /etc/locale.gen

locale-gen

echo LANG=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_ADDRESS=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_COLLATE=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_CTYPE=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_IDENTIFICATION=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_MONETARY=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_MESSAGES=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_MEASUREMENT=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_NAME=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_NUMERIC=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_PAPER=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_TELEPHONE=pl_PL.UTF-8 >> /etc/locale.conf
echo LC_TIME=pl_PL.UTF-8 >> /etc/locale.conf

echo KEYMAP=pl >> /etc/vconsole.conf
echo FONT=Lat2-Terminus16.psfu.gz >> /etc/vconsole.conf
echo FONT_MAP=8859-2 >> /etc/vconsole.conf

echo Please, Enter a hostname
read -p 'hostname: ' HostNamevar
echo $HostNamevar >> /etc/hostname

echo 127.0.0.1   localhost >> /etc/hosts
echo ::1         localhost >> /etc/hosts
echo 127.0.1.1   archlinux.localdomain  archlinux >> /etc/hosts

systemctl enable dhcpcd

pacman -S --needed --noconfirm networkmanager

systemctl enable NetworkManager

pacman -S --needed --noconfirm iw iwd dialog net-tools wireless_tools

mkinitcpio -P linux-zen


echo Please, Enter a Root Password
read -sp 'Password: ' RootPasswordvar
echo root:$RootPasswordvar | chpasswd


echo Please, Enter a UserName
read -p 'Username: ' UserNamevar
echo Please, Enter a Password for $UserNamevar

read -sp 'Password: ' UserPasswordvar
useradd -m $UserNamevar

echo $UserNamevar:$UserPasswordvar | chpasswd

EDITOR=nano visudo

pacman -S --needed --noconfirm grub efibootmgr

pacman -S --needed --noconfirm intel-ucode

mkdir /boot/efi/

mount /dev/sda1 /boot/efi

grub-install --target=x86_64-efi --bootloader-id=uefi --efi-directory=/boot/efi --removable --recheck

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable fstrim.timer


# pacman -S --needed --noconfirm firefox firefox-i18n-pl dolphin kwrite konsole xdg-user-dirs git wget qbittorrent qnapi vlc

pacman -S --needed --nocofirm xorg xorg-xinit xorg-xrandr arandr
#pacman -S --needed --noconfirm pavucontrol-qt pulseaudio 
pacman -S --noconfirm xf86-video-intel mesa
pacman -S --needed --noconfirm i3 lightdm lightdm-gtk-greeter
#pacman -S --needed --nocofirm virtualbox-guest-utils xf86-video-vmware

echo "i3" > ~/.xinitrc

#systemctl enable vboxservice.service

systemctl enable lightdm

nmtui










