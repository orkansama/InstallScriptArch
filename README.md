# InstallScriptArch

A personal post-install script for setting up a fresh Arch Linux (Hyprland-based) desktop environment.

> **Warning**
> This script is meant to run **once, on a fresh Arch install**. It is not idempotent and has no safety checks for an already-configured system (it clones repos, creates symlinks, and will fail or misbehave if run twice). Reinstall Arch or use a VM/container if you need to test it again.

## What it does

1. Installs all pacman packages listed in [`packages.txt`](packages.txt).
2. Builds and installs [`yay`](https://github.com/Jguer/yay) (AUR helper) from the AUR, then removes the build directory.
3. Installs all AUR packages listed in [`aur-packages.txt`](aur-packages.txt) via `yay`.
4. Clones [orkansama/dotfiles](https://github.com/orkansama/dotfiles) into `~/projects/dotfiles` and runs its `automatic-symlink-creator.sh`.
5. Sets `zsh` as the default shell.
6. Symlinks the `keyd` config from the dotfiles repo to `/etc/keyd`.
7. Enables and starts user-level audio services (`pipewire`, `pipewire-pulse`, `wireplumber`).
8. Enables system services: `keyd`, `sddm`, `bluetooth`.

## Prerequisites

- A fresh Arch Linux installation with network access.
- A non-root user with `sudo` privileges.
- `git` available (or installed automatically as part of the `yay` build step).

## Usage

```bash
git clone <this-repo-url>
cd InstallScriptArch
./InstallScript.sh
```

The script uses `set -e`, so it stops on the first error.

## Package lists

- `packages.txt` — official repo packages, installed with `pacman`. One package name per line.
- `aur-packages.txt` — AUR packages, installed with `yay`. One package name per line.

To customize the install, edit these files before running the script.

## After installation

- The script reminds you at the end to switch Git authentication to SSH — do this manually (e.g. generate/add an SSH key and update your remotes) since it isn't automated.
- A reboot (or re-login) is recommended so the shell change, service enables, and `keyd` symlink take full effect.
