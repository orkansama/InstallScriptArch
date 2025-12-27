#!/bin/bash
set -e  # Skript bricht bei Fehlern ab

# Variablen
PACKAGES_FILE="./packages.txt"
REPO_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

# Prüfe ob packages.txt da ist 
if [[ ! -f "$PACKAGES_FILE" ]]; then
    echo "Datei $PACKAGES_FILE nicht gefunden!"
    exit 1
fi

# Installiere alle Pakete
sudo pacman -S --needed - < "$PACKAGES_FILE"

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
cp -r "$REPO_DIR/zsh" "$CONFIG_DIR/"

# Erstelle ein symlink von .config/zsh/.zshenv nach ~/ (.zshenv MUSS dort sein)
ln -sf ~/.config/dotfiles/zsh/.zshenv ~/.zshenv

# curl ohmyzsh
export RUNZSH=no  # verhindert dass der Installer exec zsh aufruft damit er nicht nach dem install.sh beendet
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# .git und .gitignore kopieren 
cp -r "$REPO_DIR/.git" "$CONFIG_DIR/"
cp "$REPO_DIR/.gitignore" "$CONFIG_DIR/"

# Wenn alles erfolgreich war, temporären Ordner löschen
rm -rf "$REPO_DIR"

echo "Installation abgeschlossen, dotfiles kopiert und Repo gelöscht!"
