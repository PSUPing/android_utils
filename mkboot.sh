# $1 = location of zImage
# $2 = location of ramdisk.cipo.gz
# $3 = name of boot image

red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`

cd ../boot_tools/

echo "${green}Making boot.img...${reset}"
./mkbootimg --kernel $1 --ramdisk $2 --kernel_offset 0x70000000 --ramdisk_offset 0x71000000 --second_offset 0x70f00000 --tags_offset 0x70000100 --cmdline "console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlyprintk" -o $3
