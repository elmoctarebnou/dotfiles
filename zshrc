################
# Path exports #
################
export PATH=$HOME/bin:/usr/local/bin:$PATH
# Home brew alias
export PATH=/opt/homebrew/bin:$PATH
# Rust Cargo
export PATH="$HOME/.cargo/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Lvim
export PATH="$HOME/.local/bin:$PATH"
# Vscode to enable code command
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# Added by Amplify CLI binary installer
export PATH="$HOME/.amplify/bin:$PATH"
export PATH="/Library/PostgreSQL/14/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# Psycopg2 settup for max arm
export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
export PATH="/opt/homebrew/bin/npm:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
############
# Sourcing #
############
source $ZSH/oh-my-zsh.sh
alias zshsource="source ~/.zshrc"
alias tmuxsource='tmux source-file ~/.tmux.conf'
#####################
# Oh my zsh plugins #
#####################
plugins=(
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)
# Lvim alias
alias vi=lvim
# get machine's ip address
alias ip="ipconfig getifaddr en0"
# edit global zsh configuration
alias zshconfig="vi ~/.zshrc"
# reload zsh configuration
alias ohmyzsh="cd ~/.oh-my-zsh"
# navigate to global ssh directory
alias sshhome="cd ~/.ssh"
# edit global ssh configuration
alias sshconfig="vi ~/.ssh/config"
# edit global git configuration
alias gitconfig="vi ~/.gitconfig"
# edit tmux config
alias tmuxconfig="vi ~/.tmux.conf"
# Alias aws configure
alias awsconfig="vi ~/.aws/config"
alias awscreds="vi ~/.aws/credentials"
# git aliases
alias gs="git status"
alias gd="git diff"
alias gl="git lg"
alias ga="git add ."
gcmt() {
  git commit -m "$*"
}
# Create a git branch function that prompts the user to select a branch from a list of branches by index starting from 1
gcout() {
   echo "Creating a new branch..."
  # Check if fzf is installed
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi

  # Get the list of branches and use fzf to select one
  branch=$(git branch --format='%(refname:short)' | fzf --height 10 --border --prompt="Select a branch: ")

  # Check if a branch was selected
  if [[ -n $branch ]]; then
    git checkout "$branch"
  else
    echo "No branch selected."
  fi
}
######################
# AWS Authentication #
######################
# Alias aws-vault switch user
alias av="aws-vault"
# Alias switch to different aws profile
alias "av-management"="aws-vault exec management --duration=12h"
alias "av-dev"="aws-vault exec development --duration=12h"
alias "av-prod"="aws-vault exec production --duration=12h"
alias "av-test"="aws-vault exec test --duration=12h"
alias "av-india-dev"="aws-vault exec india-development --duration=12h"
# List my av aliases that I have created
function avlist() {
  echo "av-management"
  echo "av-dev"
  echo "av-prod"
  echo "av-test"
  echo "av-india-dev"
}
alias "av-list"="avlist"
# python alias
alias python=python3
alias pip=pip3
# Alias list objects
alias ls='ls -al'
# tmux alias
function tat {
  cd ~/
  sh tmux-session-setup.sh
  default_name="EBNOU"
  name=${1:-$default_name}
  tmux attach -t $name
}

###################################
# Fuzy finder for command history # 
###################################
# Use fzf for command history search
export FZF_DEFAULT_COMMAND='history -n'
export FZF_CTRL_R_OPTS='--height 40% --border'
# Bind Ctrl+R to fzf history search
bindkey '^R' fzf-history-widget
# Define the fzf-history-widget function
fzf-history-widget() {
  local selected
  selected=$(history -n 1 | fzf --tac +s --tiebreak=index --preview="echo {}" --preview-window=up:1:wrap)
  if [[ -n $selected ]]; then
    LBUFFER="$selected"
  fi
  zle redisplay
}
zle -N fzf-history-widget

# Enhanced find function using fzf
function ffind() {
  local dir="${1:-.}"  # Default to current directory if no argument is given
  local file

  # Use find to list files and directories, then pipe to fzf for interactive selection
  file=$(find "$dir" -type f -o -type d 2>/dev/null | fzf --height 40% --border --preview '[[ -f {} ]] && bat --style=numbers --color=always {} || ls -alh {}')

  # Check if a file was selected
  if [[ -n $file ]]; then
    # Open the selected file or directory
    if [[ -f $file ]]; then
      # Open file with default editor
      ${EDITOR:-vi} "$file"
    else
      # Change directory if a directory was selected
      cd "$file" || return
    fi
  else
    echo "No file selected."
  fi
}

# load zsh-completions
autoload -U compinit && compinit

# Use starship theme (needs to be at the end)
eval "$(starship init zsh)"

