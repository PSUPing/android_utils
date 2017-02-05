# $1 = path_to_boot.img
# $2 = path_to_extract_to

cd ../boot_tools
boot_extract_dir=$(pwd)

echo $1
echo $2

./boot-extract -i $1
cd $2
./boot-extract $1

mkdir ramdisk
mv ramdisk.cpio.gz ramdisk
cd ramdisk
gunzip -c ramdisk.cpio.gz | cpio -i
mv ramdisk.cpio.gz ../
