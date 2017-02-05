cross=/lib/android/ndk-r13b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`

cd ..
root_dir=$(pwd)
cp android_utils/traceconfig $1/
cd $1
top_dir=$(pwd)
cd out/target/product/generic/obj/kernel
kernel_out_dir=$(pwd)

echo "${green}Cross compile dir : ${cyan}$cross${reset}"
echo "${green}Top directory     : ${cyan}$top_dir${reset}"
echo "${green}Kernel Out Dir    : ${cyan}$kernel_out_dir${reset}"
echo ""

cd $top_dir

echo "${green}make clean...${reset}"
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android clean
make -C kernel M=$top_dir/vendor/qcom/opensource/wlan/prima O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KCFLAGS=-mno-android modules WLAN_ROOT=$top_dir/vendor/qcom/opensource/wlan/prima MODNAME=wlan BOARD_PLATFORM=msm8952 CONFIG_PRONTO_WLAN=m clean

echo "${green}Copying new traceconfig...${reset}"
cd $top_dir
cp traceconfig $kernel_out_dir/mapphone_defconfig
cp $kernel_out_dir/mapphone_defconfig $kernel_out_dir/.config

echo "${green}Compiling Android kernel...${reset}"
make -C kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= defoldconfig
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android dtbs
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android modules
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir INSTALL_MOD_PATH=$top_dir/out/target/product/generic INSTALL_MOD_STRIP="--strip-debug --remove-section=.note.gnu.build-id" ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= modules_install

echo "${green}Compiling WLAN Driver...${reset}"
cd $top_dir/out/target/product/generic/obj
make -C kernel M=$top_dir/vendor/qcom/opensource/wlan/prima O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KCFLAGS=-mno-android modules WLAN_ROOT=$top_dir/vendor/qcom/opensource/wlan/prima MODNAME=wlan BOARD_PLATFORM=msm8952 CONFIG_PRONTO_WLAN=m
