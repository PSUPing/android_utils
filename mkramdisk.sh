# This assumes the ramdisk is already in the boot_tools dir
# $1 = name of new ramdisk dir
# $2 = name of ramdisk output

red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`

cd ../boot_tools/

echo "${green}Creating new ramdisk...${reset}"
./mkbootfs $1 | gzip > $2
