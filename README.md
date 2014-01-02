core-prep
=========

Ubuntu Core Preparation Scripts


prereq
----------------

- i386 {real/virtual} hardware
- 20GB+ storages

1. setup
----------------

$ cd setup
and read readme.txt
(Note: This operation will erase your storage).

2. customize your own Ubuntu Core (skippable)
----------------------------------------------------

prereq:
- setup completed
- (If you want armhf Ubuntu Core, exec: sudo apt-get install qemu-user-static)

 # ./cutomize-core.sh

3. get tarballs
-----------------------------------

 $ cd helper
 $ get_ubuntu-core-12.04.3-core-i386_current.tar.gz.sh
 $ get_kernel.tar.sh

4. install cutomized Ubuntu Core
-----------------------------------

prereq:
- none.

 $ cd ../update
 # ./update-core.sh
   or 
 # ./update-core.sh (tarball)

Notes: "update" is not not strictly accurate, you can clean-install with this command.


