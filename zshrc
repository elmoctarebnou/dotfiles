###########################
# Required Packages/Tools #
###########################
# - Zsh: Mac OS default shell.
# - Homebrew: A package manager for macOS/Linux that simplifies the installation of software.
# - Oh My Zsh: A framework for managing your Zsh configuration with themes and plugins.
# - Neovim: Required for LunarVim.
# - LunarVim: An IDE layer for Neovim, providing enhanced editing features.
# - Starship Prompt: A customizable, fast prompt for your terminal.
# - Powerlevel10k: A Zsh theme.
# - fzf: A command-line fuzzy finder that helps quickly locate files, directories, and command history.
# - AWS CLI & AWS Vault: Tools for managing AWS services and securely handling AWS credentials.
# - Rust & Cargo
# - zsh-completions (Oh My Zsh plugin): Provides additional completion definitions for Zsh.
# - zsh-autosuggestions (Oh My Zsh plugin): Suggests commands as you type based on your command history.
# - zsh-syntax-highlighting (Oh My Zsh plugin): Highlights commands as you type to indicate syntax correctness.

#################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

################
# Path Exports #
################
export PATH=$HOME/bin:/usr/local/bin:$PATH
# Homebrew
export PATH=/opt/homebrew/bin:$PATH
export PATH=/opt/homebrew/opt/libpq/bin:$PATH
export PATH="/opt/homebrew/bin/npm:$PATH"
# Rust Cargo
export PATH="$HOME/.cargo/bin:$PATH"
# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
# Lvim
export PATH="$HOME/.local/bin:$PATH"
# VS Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# Amplify CLI
export PATH="$HOME/.amplify/bin:$PATH"
# PostgreSQL
export PATH="/Library/PostgreSQL/14/bin:$PATH"

#############
# Variables #
#############
ZSH_THEME="powerlevel10k/powerlevel10k" # Need to be before sourcing oh-my-zsh.sh

############
# Sourcing #
############
source $ZSH/oh-my-zsh.sh

###########
# Aliases #
###########
alias zshsource="source ~/.zshrc"
alias tmuxsource='tmux source-file ~/.tmux.conf'
alias vi=lvim
alias ip="ipconfig getifaddr en0"
alias zshconfig="vi ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"
alias sshhome="cd ~/.ssh"
alias sshconfig="vi ~/.ssh/config"
alias gitconfig="vi ~/.gitconfig"
alias tmuxconfig="vi ~/.tmux.conf"
alias awsconfig="vi ~/.aws/config"
alias awscreds="vi ~/.aws/credentials"
alias gs="git status"
alias gd="git diff"
alias gl="git lg"
alias ga="git add ."
alias python=python3
alias pip=pip3
alias ls='ls -al'
alias av="aws-vault"
alias "av-management"="aws-vault exec management --duration=12h"
alias "av-dev"="aws-vault exec development --duration=12h"
alias "av-prod"="aws-vault exec production --duration=12h"
alias "av-test"="aws-vault exec test --duration=12h"
alias "av-india-dev"="aws-vault exec india-development --duration=12h"
alias "av-list"="avlist"

##############
# Functions #
##############
# Git commit with message
gcmt() {
  if git diff-index --quiet HEAD --; then
    echo "No changes to commit."
  else
    git commit -m "$*"
  fi
}
# Git add and commit with message
gac() {
  git add .
  gcmt "$*"
}
# Git checkout with fzf
gcout() {
  echo "Creating a new branch..."
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi
  branch=$(git branch --format='%(refname:short)' | fzf --height 10 --border --prompt="Select a branch: ")
  if [[ -n $branch ]]; then
    git checkout "$branch"
  else
    echo "No branch selected."
  fi
}
# AWS Vault List
function avlist() {
  echo "av-management"
  echo "av-dev"
  echo "av-prod"
  echo "av-test"
  echo "av-india-dev"
}
# Tmux Attach
function tat {
  cd ~/
  sh tmux-session-setup.sh
  default_name="EBNOU"
  name=${1:-$default_name}
  tmux attach -t $name
}
# Fuzzy Finder for Files
function sd() {
  local dir="${1:-.}"
  local file
  file=$(find "$dir" -type f -o -type d 2>/dev/null | fzf --height 40% --border --preview '[[ -f {} ]] && bat --style=numbers --color=always {} || ls -alh {}')
  if [[ -n $file ]]; then
    if [[ -f $file ]]; then
      ${EDITOR:-lvim} "$file"
    else
      cd "$file" || return
    fi
  else
    echo "No file selected."
  fi
}
# Fuzzy Finder for Directories
fzf-command-history() {
  local selected
  selected=$(history -n 1 | fzf --tac +s --tiebreak=index --preview="echo {}" --preview-window=up:1:wrap)
  if [[ -n $selected ]]; then
    LBUFFER="$selected"
  fi
  zle redisplay
}

###################
# Command History #
###################
export FZF_DEFAULT_COMMAND='history -n'
export FZF_CTRL_R_OPTS='--height 40% --border'
bindkey '^R' fzf-command-history
zle -N fzf-command-history 

######################
# Oh My Zsh Plugins #
######################
plugins=(
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Load zsh-completions
autoload -U compinit && compinit

# Use starship to init zsh instead of oh-my-zsh
eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
