red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`

echo "${green}Downloading Google system/core tools...${reset}"
git clone https://android.googlesource.com/platform/system/core
cp core/mkbootimg/mkbootimg .
cp $1/zImage .
echo "${green}Making boot.img using Moto G4 ramdisk...${reset}"
./mkbootimg --kernel zImage --ramdisk ramdisk.cpio.gz --kernel_offset 0x70000000 --ramdisk_offset 0x71000000 --second_offset 0x70f00000 --tags_offset 0x70000100 --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk" -o $2
