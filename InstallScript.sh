#!/bin/bash
set -e
ROOT=$(pwd)

# Install pacman packages
pacman_packages="./packages.txt"
yay_dir_name="yay"
sudo pacman -S --needed --noconfirm - < "$pacman_packages"

# Install yay per pacman
sudo pacman -S --needed --noconfirm base-devel git && git clone https://aur.archlinux.org/yay.git && cd $yay_dir_name && makepkg -si --noconfirm
cd $ROOT
rm -rf $yay_dir_name

# Install aur packages per yay
yay_packages="./aur-packages.txt"
yay -S --needed --noconfirm \
    --answerclean All \
    --answerdiff None \
    - < "$yay_packages"

# Clone dotfiles
projects_directory="$HOME/projects"
dotfiles_directory="$projects_directory/dotfiles"
cd $projects_directory
git clone https://github.com/orkansama/dotfiles
cd $dotfiles_directory
./automatic-symlink-creator.sh

chsh -s $(which zsh)
sudo ln -s "$dotfiles_directory/keyd" "/etc/keyd"

systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable keyd --now
sudo systemctl enable sddm.service
sudo systemctl enable bluetooth.service

printf "dont forget to change git auth to ssh!"
echo "Installation completed"
