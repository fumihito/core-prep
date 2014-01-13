How to setup your Ubuntu Core development environments.

1) ./format.sh /dev/sda1 YESDOIT
2) cd ../update ; ./update-core.sh
3) sudo umount /mnt/root
4) sudo mount /dev/sda4 /mnt/root
5) bash _30extract-core.sh /tmp/_20get-tar.sh.*/ubuntu-core-12.04.3-core-i386_current.tar.gz
6) bash _40setup-kernel.sh
7) DEFAULTUSER=(yourname) DEfAULTPASS=(yourpassword) bash _60_configure_initialuser.sh
8) cp /etc/resolv.conf /mnt/root/etc; chroot /mnt/root; 
   apt-get install sudo less isc-dhcp-client ntp openssh-server
9) reboot and boot with "core" or "sub".
   "core" : Pure Ubuntu Core 
   "sub"  : Your work env with Ubuntu Core.

In "sub" lands, you may want to setup Ubuntu Desktop, exec:

    (edit /etc/network/interfaces [1])
    (edit /etc/apt/sources.list [2])
    sudo apt-get update 
    sudo apt-get install ubuntu-desktop 
    sudo apt-get install virtualbox-guest-utils

[1] sample of /etc/network/interfaces::

    # interfaces(5) file used by ifup(8) and ifdown(8)
    auto lo
    iface lo inet loopback
    auto eth0
    iface eth0 inet dhcp

[2] sample of /etc/apt/sources.list::

    deb http://jp.archive.ubuntu.com/ubuntu/ precise main restricted
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise main restricted
    deb http://jp.archive.ubuntu.com/ubuntu/ precise-updates main restricted
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise-updates main restricted
    deb http://jp.archive.ubuntu.com/ubuntu/ precise universe
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise universe
    deb http://jp.archive.ubuntu.com/ubuntu/ precise-updates universe
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise-updates universe
    deb http://jp.archive.ubuntu.com/ubuntu/ precise multiverse
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise multiverse
    deb http://jp.archive.ubuntu.com/ubuntu/ precise-updates multiverse
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise-updates multiverse
    deb http://jp.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
    deb-src http://jp.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
    deb http://security.ubuntu.com/ubuntu precise-security main restricted
    deb-src http://security.ubuntu.com/ubuntu precise-security main restricted
    deb http://security.ubuntu.com/ubuntu precise-security universe
    deb-src http://security.ubuntu.com/ubuntu precise-security universe
    deb http://security.ubuntu.com/ubuntu precise-security multiverse
    deb-src http://security.ubuntu.com/ubuntu precise-security multiverse
    deb http://archive.canonical.com/ubuntu precise partner
    deb-src http://archive.canonical.com/ubuntu precise partner
    deb http://extras.ubuntu.com/ubuntu precise main
    deb-src http://extras.ubuntu.com/ubuntu precise main
