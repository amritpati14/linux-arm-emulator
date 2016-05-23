#!/usr/bin/env bash

#####################################################
# LINUX/ARM EMULATOR FOR EVALUATING .NET CORE
# Author: Geunsik Lim (geunsik.lim@samsung.com)
# Major Goal: 
# 1) Run Exectuable ARM binary on a virtual device
# 2) Build a source for Linux/ARM on a virtual device
#

### Interrupt Setting
# To change the interrupt key form ^c to ctrl-}
# This function will be useful on Ubuntu and Centos.
stty intr ^]


### Color Setting
# Reset
NoColor='\e[0m'         # Color Off
 
# Regular Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White


### Configuration: Set the various build properties here

# Initialize default variables
__tap0='false'
__rootfs_linux_arm='rootfs-t30.ext4'
__rootfs_ubuntu_arm='rootfs-u1404.ext4'
__rootfs_default=''

# Set environment  of QEMU
function set_configuration {
__arch='-M vexpress-a9 -smp cores=2 -m 1024'
__kernel='-kernel ./kernel/kernel43-zImage-vexpress -dtb ./kernel/kernel43-vexpress-v2p-ca9.dtb'
__image='-drive file=./platform/'$__rootfs_default',if=sd,format=raw,cache=writeback' 
__kernelopt='console=ttyAMA0,115200 rw security=none single recovery data=writeback,nobh libata.force=noncq elevator=noop root=/dev/mmcblk0'
__graphic_no='-nographic'
__graphic_yes='-serail stdio'
__network='-net nic,model=lan9118 -net tap,ifname=tap0,script=no'
}

### Select menu between running environment and build environment
function select_guestos {
clear
echo -e ""
echo -e ""
echo -e ""
echo -e " =============== ${Blue}Linux/ARM Emulator (for .Net Core)${NoColor} ================= "
echo -e ""
echo -e " * ${Red}Notice${NoColor}: This emulator only supports ${Yellow}Ubuntu 14.04 x64${NoColor} LTS PC.           "
echo -e "           and does not support a GUI stack (e.g. window manager).    "
echo -e "           The emulator kernel is customized based on Linux kernel 4.3 "
echo -e ""
echo -e " ${Yellow}[User Mode]${NoColor}"
echo -e " ---------------------"
echo -e " 1. Starting Ubuntu/ARM OS(Hard-FP ABI) "
echo -e ""
echo -e " 2. Starting Linux/ARM  OS(Soft-FP ABI) "
echo -e ""
echo -e ""
echo -e " ${Yellow}[Developer Mode]${NoColor}"
echo -e " ---------------------"
echo -e " 3. Starting Ubuntu/ARM OS(Hard-FP ABI) with chroot "
echo -e ""
echo -e " 4. Starting Linux/ARM  OS(Soft-FP ABI) with chroot "
echo -e ""
echo -e " q. Exit"
echo -e ""
echo -e " ===================================================================== "
read -p " >> Enter Number (e.g. 1):" MENU_NO
}


### Start Emulator
function start_emulator {
MENU_NO=$1
if [[ "$MENU_NO" = "" ]]; then
    select_guestos
fi

if [[ "$MENU_NO" = "1" ]]; then
	# Ubuntu/ARM: arm v7 - cortex-a9 with linux 4.3 (up-to-date)
	echo -e ""
	__tap0=`ifconfig | grep tap0 | awk '{print $1}'`
        if [[ "$__tap0" != "tap0" ]]; then
	   display_network_guide
	   exit 1  
	fi
	echo -e ""
        __rootfs_default=$__rootfs_ubuntu_arm
        set_configuration
	qemu-system-arm $__arch $__kernel $__image -append "$__kernelopt" $__graphic_no $__network
	echo -e ""
	echo -e ""


elif [[ "$MENU_NO" = "2" ]]; then
	# Linux/ARM: arm v7 - cortex-a9 with linux 4.3 (up-to-date)
	echo -e ""
	__tap0=`ifconfig | grep tap0 | awk '{print $1}'`
        if [[ "$__tap0" != "tap0" ]]; then
	   display_network_guide
	   exit 1  
	fi
	echo -e ""
        __rootfs_default=$__rootfs_linux_arm
        set_configuration
	qemu-system-arm $__arch $__kernel $__image -append "$__kernelopt" $__graphic_no $__network
	echo -e ""
	echo -e ""

elif [[ "$MENU_NO" = "3" ]]; then
	# Ubuntu/ARM: arm v7 - cortex-a9 with linux 4.3 (up-to-date)
	echo -e ""
        __rootfs_default=$__rootfs_ubuntu_arm
	make_arm_build_env
	echo -e ""

elif [[ "$MENU_NO" = "4" ]]; then
	# Linux/ARM: arm v7 - cortex-a9 with linux 4.3 (up-to-date)
	echo -e ""
        __rootfs_default=$__rootfs_linux_arm
	make_arm_build_env
	echo -e ""


elif [[ "$MENU_NO" = "q" || "$MENU_NO" = "Q" ]]; then
	exit 1
else
	start_emulator
fi
}

# Enabling binary format support for ARM binaries through Qemu: 
# .https://www.kernel.org/doc/Documentation/binfmt_misc.txt
# .sudo cp /usr/bin/qemu-arm-static  ./platform/my/usr/bin/
# .How to force unmount (with a lazy unmount): umount -l ./platform/my/
# .Note: In case of /etc/init.d/rcS, mount -t tmpfs shm /dev/shm
#
QEMU=""
CHROOT_PS1="\[\e[1;35m\](chroot):\u\[\e[m\]\]"
function make_arm_build_env {
sudo mount platform/$__rootfs_default  ./platform/my/
sudo mount -t proc /proc    ./platform/my/proc
sudo mount -o bind /dev/    ./platform/my/dev
sudo mount -o bind /dev/pts ./platform/my/dev/pts
sudo mount -t tmpfs shm     ./platform/my/run/shm
sudo mount -o bind /sys     ./platform/my/sys
sudo mount -o bind /work/nfs     ./platform/my/nfs
if ! uname -m | grep -q arm;then QEMU=qemu-arm-static; fi
sudo chroot ./platform/my/ $QEMU /usr/bin/env PS1="${CHROOT_PS1}" /bin/bash
sudo umount ./platform/my/nfs
sudo umount ./platform/my/sys
sudo umount ./platform/my/proc
sudo umount ./platform/my/run/shm
sudo umount ./platform/my/dev/pts
sudo umount ./platform/my/dev
sudo umount ./platform/my/
}

# Enabling virtual network interface
#
function display_network_guide {
	echo -e ""
	echo -e ""
	echo -e "[${Red}Warning${NoColor}] You must run below commands before selecting Menu 2."
	echo -e " Please, read ${Red}'./doc/NETWORK.txt'${NoColor} file for more details."
	echo -e ""
	echo -e " ----------------------------------------------   "
	echo -e " ubuntu14.04$> sudo apt-get install uml-utilities "
	echo -e " ubuntu14.04$> sudo tunctl -u `whoami` -t tap0    "
	echo -e " ubuntu14.04$> sudo ifconfig tap0 192.168.100.1 up"
	echo -e " ubuntu14.04$> ./start.sh                         "
	echo -e " ----------------------------------------------   "
	echo -e ""
	echo -e ""
}

### Start Script: main function
set_configuration
start_emulator $1

# end of line
