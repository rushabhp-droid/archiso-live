#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/Asia/Kolkata /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf


systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target
systemctl enable sddm.service
# NOTE THESE STEPS: THEY ARE VERY IMPORTANT
nano /etc/sudoers
useradd -m -G wheel liveuser
# Don't forget to add a password, otherwise you'll cannot access sudo later.
passwd liveuser
# This next step is the most important: it will permit us to "pause" the mkarchiso process and customize it regarding our needs.
su liveuser
pacman -Sy
pacman-key --init
pacman-key --populate archlinux
