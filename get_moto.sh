kernel_tag=MMI-MPJ24.139
###### NOTE: Change this to be your cross compile toolchain (Android NDK) ######
cross=/lib/android/ndk-r13b/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`
mkdir $1
cd $1

top_dir=$(pwd)

echo "${green}Downloading MSM Kernel...${reset}"
git clone https://github.com/MotorolaMobilityLLC/kernel-msm/
echo "${green}Checking out $kernel_tag...${reset}"
cd kernel-msm
git checkout tags/$kernel_tag
cd ..
echo "${green}Downloading Motorola Kernel...${reset}"
git clone https://github.com/MotorolaMobilityLLC/motorola-kernel
echo "${green}Checking out $kernel_tag...${reset}"
cd motorola-kernel
git checkout tags/$kernel_tag
cd ..
echo "${green}Downloading Qualcomm WLAN Prima Driver...${reset}"
git clone https://github.com/MotorolaMobilityLLC/vendor-qcom-opensource-wlan-prima
echo "${green}Checking out $kernel_tag...${reset}"
cd vendor-qcom-opensource-wlan-prima
git checkout tags/$kernel_tag
cd ..

echo "${green}Renaming kernel dirs${reset}"
mv kernel-msm kernel
mkdir motorola
mv motorola-kernel motorola/kernel
mkdir -p vendor/qcom/opensource/wlan/
mv vendor-qcom-opensource-wlan-prima vendor/qcom/opensource/wlan/prima

if [ -d "$top_dir/kernel/fs/f2fs" ]; then
    echo "${green}Symlink between Motorola Kernel and MSM Kernel successful${reset}"
else
    echo "${red}Motorola kernel link does not exist, exiting.${reset}"
    exit 1
fi

echo "${green}Create output dirs${reset}"
mkdir -p out/target/product/generic/obj/kernel
cd out/target/product/generic/obj/kernel

kernel_out_dir=$(pwd)

echo "${green}Create .defconfig file${reset}"
cd $top_dir
( perl -le 'print "# This file was automatically generated from:\n#\t" . join("\n#\t", @ARGV) . "\n"' kernel/arch/arm/configs/msm8916-perf_defconfig kernel/arch/arm/configs/ext_config/moto-msm8916.config && cat kernel/arch/arm/configs/msm8916-perf_defconfig kernel/arch/arm/configs/ext_config/moto-msm8916.config ) > $kernel_out_dir/mapphone_defconfig || ( rm -f $kernel_out_dir/mapphone_defconfig && false )
cp $kernel_out_dir/mapphone_defconfig $kernel_out_dir/.config

echo "${green}Compile the kernel...${reset}"
echo "${green}Cross compile dir : ${cyan}$cross${reset}"
echo "${green}Top directory     : ${cyan}$top_dir${reset}"
echo "${green}Kernel Out Dir    : ${cyan}$kernel_out_dir${reset}"
echo ""

make -C kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= defoldconfig
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android dtbs
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= KCFLAGS=-mno-android modules
make -C kernel KBUILD_RELSRC=$top_dir/kernel O=$kernel_out_dir INSTALL_MOD_PATH=$top_dir/out/target/product/generic INSTALL_MOD_STRIP="--strip-debug --remove-section=.note.gnu.build-id" ARCH=arm CROSS_COMPILE=$cross KBUILD_BUILD_USER= KBUILD_BUILD_HOST= modules_install

echo "${green}Compiling WLAN Driver...${reset}"
cd $top_dir/out/target/product/generic/obj
make -C kernel M=$top_dir/vendor/qcom/opensource/wlan/prima O=$kernel_out_dir ARCH=arm CROSS_COMPILE=$cross KCFLAGS=-mno-android modules WLAN_ROOT=$top_dir/vendor/qcom/opensource/wlan/prima MODNAME=wlan BOARD_PLATFORM=msm8952 CONFIG_PRONTO_WLAN=m

echo "${green}Getting boot-extract tool${reset}"
git clone https://github.com/csimmonds/boot-extract.git
cd boot-extract
make
