#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

#
# macOS Bootstrap Script
#
# This script installs Homebrew, then installs and sets up the Fish shell as the default.
#

# --- Functions ---

# @description Check if a command exists.
# @param $1 The command to check.
# @return 0 if the command exists, 1 otherwise.
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# @description Print a message to the console.
# @param $1 The message to print.
log() {
  echo "=> $1"
}

# --- Main Execution ---

# --- Install Homebrew ---
if ! command_exists brew; then
  log "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  log "Homebrew installed successfully."
else
  log "Homebrew is already installed."
fi

# --- Configure Homebrew Shell Environment ---
# This ensures that `brew` command is available in the shell.
# The script will add the Homebrew path to your .zprofile (for zsh) or .bash_profile (for bash).
# For Apple Silicon Macs (arm64)
if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  if ! grep -q '/opt/homebrew/bin/brew shellenv' ~/.zprofile 2>/dev/null; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  fi
# For Intel Macs (x86_64)
else
  eval "$(/usr/local/bin/brew shellenv)"
  if ! grep -q '/usr/local/bin/brew shellenv' ~/.bash_profile 2>/dev/null; then
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
  fi
fi

# --- Install Fish Shell ---
if ! command_exists fish; then
  log "Installing Fish shell..."
  brew install fish
  log "Fish shell installed successfully."
else
  log "Fish shell is already installed."
fi

# --- Set Fish as the Default Shell ---
FISH_PATH_ARM="/opt/homebrew/bin/fish"
FISH_PATH_INTEL="/usr/local/bin/fish"
CURRENT_SHELL=$(dscl . -read ~/ UserShell | sed 's/UserShell: //')
TARGET_FISH_PATH=""

if [[ "$(uname -m)" == "arm64" ]]; then
  TARGET_FISH_PATH="$FISH_PATH_ARM"
else
  TARGET_FISH_PATH="$FISH_PATH_INTEL"
fi

if [[ "$CURRENT_SHELL" != "$TARGET_FISH_PATH" ]]; then
  log "Setting Fish as the default shell..."

  # Add Fish to the list of acceptable shells if it's not already there
  if ! grep -Fxq "$TARGET_FISH_PATH" /etc/shells; then
    log "Adding Fish to /etc/shells..."
    echo "$TARGET_FISH_PATH" | sudo tee -a /etc/shells > /dev/null
  fi

  # Change the default shell
  chsh -s "$TARGET_FISH_PATH"
  log "Default shell changed to Fish. Please restart your terminal for the changes to take effect."
else
  log "Fish is already the default shell."
fi

# --- Install Fisher and Fish Shell Plugins ---
log "Checking Fisher plugin manager and plugins..."
# We use fish -c "..." to run these commands within a fish shell,
# which is required for fisher to work correctly.
if ! command_exists fisher; then
  log "Installing Fisher..."
  brew install fisher
  log "Fisher installed successfully."
else
  log "Fisher is already installed."
fi
log "Installing Fisher plugins..."
fish -c "fisher install PatrickF1/fzf.fish"
fish -c "fisher install givensuman/fish-eza"
log "Fisher and plugins installed."

# --- Install Chezmoi ---
if ! command_exists chezmoi; then
    log "Installing chezmoi..."
    brew install chezmoi
    log "chezmoi installed successfully."
else
    log "chezmoi is already installed."
fi

# --- Initialize Chezmoi from dotfiles repository ---
log "Initializing chezmoi with dotfiles from https://github.com/raywhite/dotfiles_macos.git"
# Using 'chezmoi init --apply' will clone the repository and apply the dotfiles in one step.
chezmoi init --apply https://github.com/raywhite/dotfiles_macos.git

log "Bootstrap complete!"
