# Android Compile Utilities for Motorola G4

I needed to have at least a semi-automated way to recompile the kernel and build a boot.img file. These utilites help with that 

### get_moto.sh 

This will download the Marshmallow kernel code from Motroloa's GitHub repos (<https://github.com/MotorolaMobilityLLC>) into a specified directory. Since the repo directory is attached to the repo, it goes up a level and then creates the directory. 

Usage: 

    ./get_moto.sh <name of dir>

### get_boot_tools.sh

This will download the Motorola system-core, download a boot-extract tool from <https://github.com/csimmonds/boot-extract> and compile them. It assumes it will create a directory called `boot_tools`.

Usage: 

    ./get_boot_tools.sh

### split_bootimg.sh

Split apart a given boot.img file into the kernel (`zImage`), the ramdisk, and the second stage if present. It also shows the console command and offsets in the event they are needed to create the image later. 

Usage: 

    ./split_bootimg.sh <path to boot image> <where to extract it to>

###  mkramdisk.sh

Create the ramdisk file system as a cpio.gz file that can be used to create a boot.img

Usage: 

    ./mkramdisk.sh <name of the ramdisk dir> <where to output the .cipo.gz file to>

### mkboot.sh 

Create a boot image file that can be loaded onto Motorola G4 firmware. **Note:** This assumes the following offsets: Kernel - 0x70000000, Ramdisk - 0x71000000, Second stage - 0x70f00000

Usage: 

    ./mkboot.sh <location of zImage> <location of ramdisk.cpio.gz> <where to output the boot.img file>

### recompile.sh

Do a `make clean` for the code in the specified directory, copy the traceconfig from this repo, and recompile the kernel. 

    ./recompile <location of kernel source>
