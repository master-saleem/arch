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

############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
#### START ### START ######## +++FUNKTION+++ ##### START ### START #######
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( archlinux-keyring )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_archlinux-keyring() {
tput sgr0
echo "*******************************************************************"
echo "Install archlinux-keyring on " $HOSTNAME
echo "*******************************************************************"
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy --noconfirm --needed archlinux-keyring
    sudo pacman -Su
}
func_install_archlinux-keyring
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Function ( Backup package_list )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_backup_package_list() {
tput sgr0
echo "*******************************************************************"
echo "Backup package_list from "$HOSTNAME
echo "*******************************************************************"
   sudo pacman -Qe | awk '{print $1}' > $HOME/$(date +%d-%m-%Y_%H_%M_%S)-package-list.txt
}
func_backup_package_list
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
# Function ( install aus dem AUR )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_install_aur() {
tput sgr0
echo "*******************************************************************"
echo "Install aus dem AUR "${1}
echo "*******************************************************************"
  cd /tmp
  sudo rm -rf "${1}"
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
# Function ( CleanUP )
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
func_cleanup() {
tput sgr0
echo "*******************************************************************"
echo "CleanUP on " $HOSTNAME
echo "*******************************************************************"
    sudo pacman -Rns $(pacman -Qtdq)

    # Flatpak unbenutzte Runtimes löschen
    sudo flatpak uninstall --unused -y

    # Removes old revisions of snaps
    # CLOSE ALL SNAPS BEFORE RUNNING THIS
    LANG=C snap list --all | while read snapname ver rev trk pub notes; do if [[ $notes = *disabled* ]]; then sudo snap remove "$snapname" --revision="$rev"; fi; done

    # Starting from snap 2.34 and later, you can set the maximum number of a snap’s revisions stored by the system by setting a refresh.retain option
    sudo snap set system refresh.retain=2

    sudo du -sh /var/lib/snapd/cache/         # Get used space
    sudo rm  --force /var/lib/snapd/cache/*   # Remove cache

    sudo rm -R /home/admin/.cache/*
    sudo rm -R /tmp/*
    sudo du -sh ~/.cache/
    sudo rm -rf ~/.cache/*

    sudo pacman -Scc --noconfirm
    sudo yaourt -Scc --noconfirm
    sudo yay -Scc --noconfirm
}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

############ +++++++ ######## ++++++++++++++ ############ +++++++ ########
##### END ###### END ######## +++FUNKTION+++ ##### END ###### END ########
############ +++++++ ######## ++++++++++++++ ############ +++++++ ########



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
make
)

count=0

for name in "${list_pacman[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_pacman
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
)

count=0

for name in "${list_yay[@]}" ; do
	count=$[count+1]
	func_install_or_not $name func_install_yay
done
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

tput sgr0

func_cleanup

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
