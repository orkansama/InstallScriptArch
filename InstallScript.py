from pathlib import Path
import subprocess

# Install Packages
subprocess.call("echo $EDITOR", shell=True)
subprocess.call("sudo pacman -S < packages.txt", shell=True)

# Setup Dotfiles

# Setup SystemD autostarts