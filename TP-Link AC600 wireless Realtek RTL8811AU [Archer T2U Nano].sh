#!/bin/bash
# TP-Link AC600 wireless Realtek RTL8811AU [Archer T2U Nano]
sudo pacman -Su git dkms
cd /tmp
git clone https://github.com/aircrack-ng/rtl8812au.git
cd rtl8812au
sudo make dkms_install