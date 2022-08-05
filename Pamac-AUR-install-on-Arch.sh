#!/bin/bash
#set -e
clear
tput sgr0
tput setaf 1
echo ''
echo '                  -`'
echo '                 .o+`'
echo '                `ooo/'
echo '               `+oooo:'
echo '              `+oooooo:'
echo '              -+oooooo+:'
echo '            `/:-:++oooo+:'
echo '           `/++++/+++++++:'
echo '          `/++++++++++++++:'
echo '        `/+++ooooooooooooo/`'
echo '        ./ooosssso++osssssso+`'
echo '       .oossssso-````/ossssss+`'
echo '      -osssssso.      :ssssssso.'
echo '     :osssssss/        osssso+++.'
echo '    /ossssssss/        +ssssooo/-'
echo '  `/ossssso+/:-        -:/+osssso+-'
echo ' `+sso+:-`     ArchLinux   `.-/+oso:'
echo '`++:.                           `-/+/'
echo '.`                                 ` '
echo ''
tput sgr0

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( archlinux-keyring )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

func_install_archlinux-keyring() {
tput sgr0
echo "*******************************************************************"
echo "Install archlinux-keyring"
echo "*******************************************************************"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy --noconfirm --needed archlinux-keyring
    sudo pacman -Su
}
func_install_archlinux-keyring
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( PAUSE )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function pause() {
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install or not )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_or_not() {
 if pacman -Qi $1 &> /dev/null; then
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 2
     echo " The package "$1" is already installed"
   # tput sgr0
 else
     tput sgr0
     tput setaf 1
     echo "--------------------------------------------------------------"
     tput setaf 3
     echo " Installing "$2" package "$1
    tput sgr0
     $2 $1
 fi
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit pacman )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

func_install_pacman() {
tput sgr0
echo "*******************************************************************"
echo "Install mit pacman "${1}
echo "*******************************************************************"
   sudo pacman -S --noconfirm --needed $1
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install aus dem git )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_git() {
tput sgr0
echo "*******************************************************************"
echo "Install aus dem git "${1}
echo "*******************************************************************"
  cd /tmp
  rm -rf "${1}"
  # Скачивание исходников.
  git clone https://github.com/"${1}".git
  # Переход в "${1}".
  cd "${1}"
  makepkg -s --noconfirm
  sudo pacman -U --noconfirm --needed ./*.pkg.tar.*
  cd ..
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install aus dem AUR )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_aur() {
tput sgr0
echo "*******************************************************************"
echo "Install aus dem AUR "${1}
echo "*******************************************************************"
  cd /tmp
  rm -rf "${1}"
  # Скачивание исходников.
  git clone https://aur.archlinux.org/"${1}".git
  # Переход в "${1}".
  cd "${1}"
  makepkg -s --noconfirm
  sudo pacman -U --noconfirm --needed ./*.pkg.tar.*
  cd ..
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( install mit YAY )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_yay() {
tput sgr0
echo "*******************************************************************"
echo "Install mit YAY "${1}
echo "*******************************************************************"
  yay -S --noconfirm --needed ${1}
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( uninstall ) wenn pamac-aur installiert ist dann ( uninstall )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_uninstall() {
tput sgr0
if pacman -Qi ${1} &> /dev/null; then
 tput setaf 7
  echo "-----------------------------------------------------------------"
  echo "  The package "${1}" is installed, Uninstall"
  
  sudo pacman -Rdd --noconfirm ${1}
  #tput sgr0
 else
  tput setaf 6
  echo "-----------------------------------------------------------------"
  echo " The package "${1}" is not installed"
 
fi
 echo "-----------------------------------------------------------------"
 echo
 tput sgr0
}
echo "*******************************************************************"
echo " Uninstall " ${1}
echo "*******************************************************************"

list_uninstall=(
pamac-all
libpamac-full
)

count=0

for name in "${list_uninstall[@]}" ; do
	count=$[count+1]
	func_uninstall $name
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of pacman software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of pacman software "
echo "*******************************************************************"
list_pacman=(
wget
git
)

count=0

for name in "${list_pacman[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_pacman
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0



# atareao/nautilus-document-converter.git
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of git software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of git software "
echo "*******************************************************************"
list_git=(
)

count=0

for name in "${list_git[@]}" ; do
    count=$[count+1]
    func_install_or_not $name func_install_git
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0




# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of AUR software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of AUR software "
echo "*******************************************************************"
list_aur=(
yay
)

count=0

for name in "${list_aur[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_aur
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Liste of YAY software
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0
echo "*******************************************************************"
echo " Liste of YAY software "
echo "*******************************************************************"
list_yay=(
pamac-aur
)

count=0

for name in "${list_yay[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_yay
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tput sgr0


tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0
tput setaf 8
echo " All packages installed"

tput setaf 11
echo " Reboot your system"
tput sgr0
tput setaf 1
echo "*******************************************************************"
tput sgr0

