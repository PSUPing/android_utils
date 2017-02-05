red=`tput setaf 1`
green=`tput setaf 2`
cyan=`tput setaf 6`
reset=`tput sgr0`
cd ..
mkdir boot_tools
cd boot_tools

top_dir=$(pwd)

echo "${green}Downloading Motorola system/core...${reset}"
git clone https://github.com/MotorolaMobilityLLC/system-core
echo "${green}Compiling libmincrypt...${reset}"
cd $top_dir/system-core/libmincrypt
gcc -c *.c -I../include
ar rcs libmincrypt.a  *.o
echo "${green}Compiling mkbootimg...${reset}"
cd ../mkbootimg
gcc mkbootimg.c -o mkbootimg -I../include ../libmincrypt/libmincrypt.a
cp mkbootimg $top_dir
echo "${green}Compiling mkbootfs...${reset}"
cd ../cpio
gcc mkbootfs.c  -o mkbootfs -I../include
cp mkbootfs $top_dir

cd $top_dir

echo "${green}Getting boot-extract tool${reset}"
git clone https://github.com/csimmonds/boot-extract.git
cd boot-extract
make
mv boot-extract boot-ext
cp boot-ext $top_dir

cd $top_dir

rm -rf boot-extract
mv boot-ext boot-extract
