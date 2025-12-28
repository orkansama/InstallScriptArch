#!/bin/bash
set -e  # Skript bricht bei Fehlern ab

# Variablen
REPO_DIR="$HOME/dotfiles"
CONFIG_DIR="$HOME/.config"

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
        sudo pacman -S --needed - < "$FILE"
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
cp -r "$REPO_DIR/zsh" "$CONFIG_DIR/"

# Erstelle ein symlink von .config/zsh/.zshenv nach ~/ (.zshenv MUSS in Home sein)
ln -sf ~/.config/zsh/.zshenv ~/.zshenv

# curl ohmyzsh
export RUNZSH=no  # verhindert dass der Installer exec zsh aufruft damit er nicht nach dem install.sh beendet
export CHSH=no    # verhindert die Abfrage ob zsh nun die standart shell sein soll
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# .git und .gitignore kopieren nach .config
cp -r "$REPO_DIR/.git" "$CONFIG_DIR/"
cp "$REPO_DIR/.gitignore" "$CONFIG_DIR/"

# Wenn alles erfolgreich war, temporären Ordner löschen
rm -rf "$REPO_DIR"

# Ändere die shell manuell
chsh -s $(which zsh)

echo "Installation abgeschlossen, dotfiles kopiert und Repo gelöscht!"
