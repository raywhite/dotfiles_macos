if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Editors
if test -z "$EDITOR"
    set -gx EDITOR 'nvim'
end
if test -z "$VISUAL"
    set -gx VISUAL 'nvim'
end
if test -z "$PAGER"
    set -gx PAGER 'less'
end

# Initialize Utilities
# Setup brew
eval "$(/opt/homebrew/bin/brew shellenv)"
## Starship
starship init fish | source
## direnv
#direnv hook fish | source
## Zoxide
#zoxide init --cmd cd fish | source
## fzf
#fzf --fish | source

# PATH
#fish_add_path "/opt/homebrew/opt/uutils-coreutils/libexec/uubin"

# Aliases
# alias nv='neovide --fork'
# alias nvn='neovide --frame none --fork'
# alias nvb='neovide --frame transparent --fork'

# Abbreviations
## `cat` → `bat` abbreviation
## Requires `brew install bat`
if type -q bat
  abbr --add -g cat 'bat'
end
## neovide
if type -q neovide
  abbr --add -g nv 'neovide --fork'
  abbr --add -g nvn 'neovide --frame none --fork'
  abbr --add -g nvb 'neovide --frame transparent --fork'
end

# Fish Cursor Style
set fish_cursor_default underscore

# eza
set -Ux EZA_STANDARD_OPTIONS --icons

# fisher plugins
# fisher install catppuccin/fish
# fisher instrll plttn/fish-eza
# fisher install jorgebucaran/autopair.fish
# fisher install patrickf1/fzf.fish
