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

# Force docker to build for linux/amd64 (There is a bug with M1 Macs)
export DOCKER_DEFAULT_PLATFORM=linux/amd64
#############
# Variables #
#############
# Need to be before sourcing oh-my-zsh.sh
ZSH_THEME="powerlevel10k/powerlevel10k"

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
alias vimconfig="vi /Users/elmoctarebnou/.config/lvim/lua/elmoctarebnou"
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


# Requires eza to be installed
alias ls='eza -al --color=always --group-directories-first' 
alias ll='eza -l --color=always --group-directories-first'  
alias la='eza -a --color=always --group-directories-first'  
alias lt='eza -aT --color=always --group-directories-first' 

alias av="aws-vault"
alias "av-management"="aws-vault exec management --duration=12h"
alias "av-dev"="aws-vault exec development --duration=12h"
alias "av-prod"="aws-vault exec production --duration=12h"
alias "av-test"="aws-vault exec test --duration=12h"
alias "av-india-dev"="aws-vault exec india-development --duration=12h"
alias "av-non-prod"="aws-vault exec non-prod --duration=12h"
alias "av-list"="avlist"

# Requires bat to be installed
alias cat='bat --style=plain --paging=never' 
alias gsb='git_search_branch'

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
  echo "Checking out a branch..."
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi
  branch=$(git branch --format='%(refname:short)' | fzf --height 40% --border --prompt="Select a branch: ")
  if [[ -n $branch ]]; then
    git checkout "$branch"
  else
    echo "No branch selected."
  fi
}

# Git search branches without checking out
git_search_branch() {
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi
  branch=$(git branch --format='%(refname:short)' | fzf --height 40% --border --prompt="Select a branch: ")
  if [[ -n $branch ]]; then
    echo "Branch selected: $branch"
  else
    echo "No branch selected."
  fi
}

# Git revert with fzf (improved with automatic parent selection for merge commits)
grevert() {
  echo "Selecting a commit to revert..."
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi
  
  # Get the current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  
  # Use fzf to select a commit
  selected=$(git log --oneline --format="%h %p %s" |
             fzf --height 40% --border --prompt="Select a commit to revert: " --preview "echo {} | cut -d' ' -f1 | xargs -I% git show --color=always % | head -n 50")
  
  if [[ -n $selected ]]; then
    # Extract the commit hash, parent hashes, and commit message
    commit_hash=$(echo $selected | cut -d' ' -f1)
    parent_hashes=(${(z)$(echo $selected | cut -d' ' -f2- | cut -d' ' -f1-2)})
    commit_message=$(echo $selected | cut -d' ' -f4-)
    
    # Ask for confirmation
    echo "You are about to revert this commit:"
    echo "$selected"
    echo "on branch: $current_branch"
    
    # Handle merge commits
    if [[ ${#parent_hashes} -gt 1 ]]; then
      echo "This is a merge commit. Automatically selecting the first parent (main line of development)."
      parent_number=1
      revert_command="git revert --no-edit -m $parent_number $commit_hash"
    else
      revert_command="git revert --no-edit $commit_hash"
    fi
    
    # Generate automatic commit message
    auto_message="Revert \"$commit_message\"\n\nThis reverts commit $commit_hash."
    if [[ ${#parent_hashes} -gt 1 ]]; then
      auto_message+="\nAutomatically reverted to parent ${parent_number} (${parent_hashes[$parent_number]})."
    fi
    
    echo "Revert command: $revert_command"
    echo "Automatic commit message:"
    echo -e "$auto_message"
    echo -n "Do you want to proceed? [y/N] "
    read response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      # Perform the revert
      echo -e "$auto_message" | eval $revert_command
      if [[ $? -eq 0 ]]; then
        echo "Commit reverted successfully."
      else
        echo "Revert failed. Please check the output above for details."
      fi
    else
      echo "Revert cancelled."
    fi
  else
    echo "No commit selected."
  fi
}

gitclean() {
  echo "Selecting branches to delete..."
  if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install it first."
    return 1
  fi

  # Get current branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  
  # List all branches except the current one and main/master
  branches=$(git branch --format='%(refname:short)' | grep -vE "^(main|master|$current_branch)$" | 
             fzf --multi --height 40% --border --prompt="Select branches to delete (TAB to multi-select): " --preview "git log --color=always {} -n 50")
  
  if [[ -n $branches ]]; then
    echo "You're about to delete these branches:"
    echo "$branches"
    echo -n "Are you sure you want to proceed? [y/N] "
    read response
    
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      echo "$branches" | while read branch; do
        if git branch -D "$branch"; then
          echo "Deleted branch: $branch"
        else
          echo "Failed to delete branch: $branch"
        fi
      done
    else
      echo "Branch cleanup cancelled."
    fi
  else
    echo "No branches selected."
  fi}
# AWS VAULT List of Profiles
function avlist() {
  echo "av-management"
  echo "av-dev"
  echo "av-prod"
  echo "av-test"
  echo "av-india-dev"
  echo "av-non-prod"
}

# Fuzzy Finder for Files
function sd() {
  local dir="${1:-.}"
  local file
  file=$(fd --type f --type d --hidden --follow --exclude .git 2>/dev/null | fzf --height 60% --border --preview 'bat --style=numbers --color=always {} 2>/dev/null || ls -alh {}')
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

# Function to SSH using fzf
ssh_fzf() {
  local selected_host=$(grep "Host " ~/.ssh/config | grep -v '\*' | cut -d ' ' -f 2 | fzf --height 40% --reverse)
  
  if [ -n "$selected_host" ]; then
    local identity_file=$(sed -n "/Host $selected_host/,/Host /p" ~/.ssh/config | grep IdentityFile | awk '{print $2}')
    if [ -n "$identity_file" ]; then
      echo "Connecting to $selected_host using identity file: $identity_file"
    else
      echo "Connecting to $selected_host..."
    fi
    ssh "$selected_host"
  fi
}
# Alias for the function
alias ssf='ssh_fzf'

# Function to initialize work environment
init-work() {
  if tmux has-session -t ct 2>/dev/null; then
    echo "Tmux session 'ct' already exists. Attaching..."
  else
    echo "Creating new tmux session 'ct'..."
    tmux new-session -d -s ct -n 'config'

    # Create tmux windows
    tmux new-window -t ct -n 'logs'
    tmux new-window -t ct -n 'client' -c ~/cachetech/awm_frontend
    tmux new-window -t ct -n 'ssh'
  fi


  # Attach to the tmux session
  tmux attach -t ct
}

# Tmux attach to session with fzf
tat() {
  local session=$(tmux list-sessions -F "#{session_name}" | fzf --height 40% --reverse)
  if [[ -n $session ]]; then
    tmux attach -t "$session"
  fi
}

# Close all vscode instances
close-vscode() {
  pkill -f "Visual Studio Code"
}

# Extract various compressed file types
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Find and kill process
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Weather forecast
weather() {
    curl -s "wttr.in/$1?m"
}

###################
# Command History #
###################
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS='--height 40% --border'
bindkey '^R' fzf-command-history
zle -N fzf-command-history 

######################
# Oh My Zsh Plugins #
######################
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  docker
  docker-compose
  kubectl
  npm
  yarn
  nvm
  rust
)

# Load zsh-completions
autoload -U compinit && compinit

# Use starship to init zsh instead of oh-my-zsh
eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Rust cargo
source $HOME/.cargo/env
