#!/bin/bash

# Local Variables
#	liveuser="live"
#	liveuserpass="${liveuser}"

# Arch Config
	set -e -u
	sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
	locale-gen
	ln -sf /usr/share/zoneinfo/UTC /etc/localtime
	usermod -s /usr/bin/zsh root
	cp -aT /etc/skel/ /root/
	chmod 700 /root

# Setup Pacman
#	pacman-key --init archlinux
#	pacman-key --populate archlinux
#	pacman-key --init
#	pacman-key --init calamaros
#	pacman-key --populate calamaros
#	pacman-key --populate
#	pacman -Syy
#	pacman-key --refresh-keys


#Edit Mirrorlist
	sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
	sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

#Distro Name
	sed -i.bak 's/Arch Linux/CalamarOS/g' /usr/lib/os-release
	sed -i.bak 's/arch/calamaros/g' /usr/lib/os-release
	sed -i.bak 's/www.archlinux.org/www.calamaros.com/g' /usr/lib/os-release
	sed -i.bak 's/bbs.archlinux.org/www.calamaros.com/g' /usr/lib/os-release
	sed -i.bak 's/bugs.archlinux.org/www.calamaros.com/g' /usr/lib/os-release
	#cp /usr/lib/os-release /etc/os-release
	echo "Generated os-release file"

#Set Nano Editor
	export _EDITOR=nano
	echo "EDITOR=${_EDITOR}" >> /etc/environment
	echo "EDITOR=${_EDITOR}" >> /etc/skel/.bashrc
	echo "EDITOR=${_EDITOR}" >> /etc/profile
	echo "Editor by default: ${_EDITOR}"
 
#Enable Sudo
	chmod 750 /etc/sudoers.d
	#chmod 440 /etc/sudoers.d/g_wheel
	chown -R root /etc/sudoers.d
	echo "live ALL=(ALL) ALL" >> /etc/sudoers
	echo "Enabled Sudo"


#sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
#sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
#sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

	sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
	sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
	sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf



# config autologin user
	#sed -i '$a AutomaticLogin="live"' /etc/gdm/custom.conf
	#groupadd -r autologin
	#groupadd -r nopasswdlogin
	#echo "Autologin activated"

#Create Liveuser
	id -u live &>/dev/null || useradd -m live -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel"
	passwd -d live
	#rm /home/${liveuser}/.config/autostart/firstrun.desktop
	echo 'Created User livecd: live'
	echo 'Password user livecd: live'

# Gnome settings
	
	echo "Setting Icon theme"	
	#gsettings set org.gnome.desktop.interface icon-theme "Numix-Square"

#	echo "Setting GTK Theme"	
	#gsettings set org.gnome.desktop.interface theme-theme ""
	echo "Setting Favorites app dash dock"	
	#gsettings set org.gnome.shell favorite-apps "['chromium.desktop', 'org.gnome.Nautilus.desktop', 'gnome-tweak-tool.desktop', 'gnome-control-center.desktop']"

	echo "Setting Wallpaper"
	#gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/CalamarOS/wallpapers/Calamaros-wallpaper.png"

# Activate system stuff
	glib-compile-schemas /usr/share/glib-2.0/schemas/
	systemctl enable NetworkManager.service
	systemctl start NetworkManager.service
	systemctl enable pacman-init.service choose-mirror.service
	systemctl set-default graphical.target

