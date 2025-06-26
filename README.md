# Dotfiles

This is a collection of dotfiles for bootstrapping a macos. I use a [chezmoi](https://github.com/twpayne/chezmoi) to manage them.

## Applications

* SHELL: fish and starship, fisher plugin manager
* IDE: Neovim and Neovide, Visual Studio Code
* Font: JetBrains Mono Nerd Font
* Terminal: ghostty 
* Password manager: 1password and 1password_cli
* Browser: Zen, Google Chrome

## Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install fish and set fish as default shell:

```sh
brew install fish

echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```

Install chezmoi with Homebrew:

```sh
brew install chezmoi
```

## chezmoi setup

Initialize chezmoi with dotfiles from this repository:

```sh
chezmoi init https://github.com/wohckcin/dotfiles.git
```

## Install Apps with Homebrew

Install all apps from the `Brewfile`, located in `private_dot_config/brewflie/Brewfile`.

```sh
brew bundle --file="~/.local/share/chezmoi/private_dot_config/brewflie/Brewfile"
```

## fish

### Install plugins

Install the fisher plugin manager:

```sh
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

Install fzf plugin

```sh
fisher install patrickf1/fzf.fish
```

Install eza plugin

```sh
fisher install plttn/fish-eza
```

### Create completition files

Parse manual pages installed on the system and attempt to create completion files in the fish configuration directory with the following command:

```sh
fish_update_completions
```

## chezmoi commands

### chezmoi apply

Check what changes will be applied:

```sh
chezmoi diff
```

Apply changes:

```sh
chezmoi apply -v
```

### chezmoi edit

```sh
chezmoi edit $FILE
```

### chezmoi merge

```sh
chezmoi merge $FILE
```

### chezmoi update

```sh
chezmoi update -v
```
