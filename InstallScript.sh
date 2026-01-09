#!/bin/bash
set -e  # Skript bricht bei Fehlern ab

# Variablen
REPO_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"
ZSH_DIR="$HOME/.config/zsh"

# Array mit allen Package-Dateien
PACKAGE_FILES=(
    "./packages.txt"
    "./zsh_packages.txt"
)

# Prüfen, ob das Array leer ist
if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    echo "Keine Paket-Dateien gefunden. Abbruch."
    exit 1
fi

# Installiere alle pakete
for FILE in "${PACKAGE_FILES[@]}"; do
    if [[ -f "$FILE" ]]; then
        echo "Installing packages from $FILE..."
        sudo pacman -S --needed --noconfirm - < "$FILE"
    else
        echo "File $FILE not found, skipping."
    fi
done

# Repo klonen in einen Temporären Ordner "~/dotfiles"
if [[ ! -d "$REPO_DIR" ]]; then
    git clone https://github.com/orkansama/dotfiles.git "$REPO_DIR"
fi

# Zielordner .config erstellen falls noch nicht vorhanden
mkdir -p "$CONFIG_DIR"

# Kopiere Daten aus temp dotfiles-Ordner nach .config mit allen unterverzeichnissen (-r)
cp -r "$REPO_DIR/hypr" "$CONFIG_DIR/"
cp -r "$REPO_DIR/waybar" "$CONFIG_DIR/"
cp -r "$REPO_DIR/wofi" "$CONFIG_DIR/"

# Schiebe keyd files nach etc
sudo cp -r "$REPO_DIR/keyd" "/etc"

# Erstelle ein symlink von .config/zsh/.zshenv nach ~/ (.zshenv MUSS in Home sein)
ln -sf ~/.config/zsh/.zshenv ~/.zshenv

git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.config/zsh"
cp -r "$REPO_DIR/zsh/" "$HOME/.config/zsh/" # Erst danach weil git sonst nicht möchte :C

# .git und .gitignore kopieren nach .config
cp -r "$REPO_DIR/.git" "$CONFIG_DIR/"
sudo cp "$REPO_DIR/.gitignore" "/etc"

# Wenn alles erfolgreich war, temporären Ordner löschen
rm -rf "$REPO_DIR"

# Ändere die shell manuell
chsh -s $(which zsh)

# Installiere yay und die packete
sudo pacman -S --needed --noconfirm base-devel git && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm

if [[ -f aur-packages.txt ]]; then
    echo "Installing AUR packages..."
    yay -S --needed --noconfirm \
        --answerclean All \
        --answerdiff None \
        - < aur-packages.txt
fi

rm -rf yay

# Aktiviere Audio Permanent
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Aktiviere keyd Service Permanent
sudo systemctl enable keyd --now

echo "Installation abgeschlossen, dotfiles kopiert und Repo gelöscht!"
