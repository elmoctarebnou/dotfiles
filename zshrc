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

git_search_branch() {
  # deps
  command -v fzf >/dev/null 2>&1 || { echo "fzf is not installed."; return 1; }
  git rev-parse --git-dir >/dev/null 2>&1 || { echo "Not a git repository."; return 1; }

  local sel branch

  sel=$(
    # list local + remote branches; drop the remotes/*/HEAD ref
    git for-each-ref --format='%(refname:short)' refs/heads refs/remotes \
      | grep -v '/HEAD$' \
      | sort -u \
      | fzf --height=40% --layout=reverse --border --ansi \
            --prompt="Select a branch: " \
            --preview '
              p={}
              printf "Commits on %s\n\n" "$p"

              # Resolve to a concrete ref that git log will accept
              if git show-ref --verify --quiet "refs/heads/$p"; then
                ref="refs/heads/$p"
              elif git show-ref --verify --quiet "refs/remotes/$p"; then
                ref="refs/remotes/$p"
              elif git show-ref --verify --quiet "refs/remotes/origin/$p"; then
                ref="refs/remotes/origin/$p"
              else
                echo "Branch not found locally or remotely."
                exit 0
              fi

              git log --oneline --graph --decorate --color=always -n 20 "$ref" --
            ' \
            --preview-window=up,60%,wrap
  ) || return

  [[ -z $sel ]] && { echo "No branch selected."; return 0; }

  # normalize and switch
  branch=${sel#remotes/}  # turn remotes/origin/foo -> origin/foo

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git switch "$branch" && echo "Switched to: $branch" && return
  fi

  # origin/foo → create tracking branch "foo"
  if [[ $branch == origin/* ]]; then
    local local_name=${branch#origin/}
    git switch -c "$local_name" --track "origin/$local_name" \
      && echo "Created and switched to: $local_name (tracking origin/$local_name)" \
      || return 1
    return
  fi

  # other remote like upstream/foo
  if [[ $branch == */* ]]; then
    local remote=${branch%%/*} name=${branch#*/}
    git switch -c "$name" --track "$remote/$name" \
      && echo "Created and switched to: $name (tracking $remote/$name)" \
      || return 1
    return
  fi

  # last try (unusual refnames)
  git switch "$branch" && echo "Switched to: $branch"
}

set-region() {
  if ! command -v fzf >/dev/null 2>&1; then
    echo "fzf not found. Please install fzf first."
    return 1
  fi

  local regions="
US East (Ohio)                us-east-2
US East (N. Virginia)         us-east-1
US West (N. California)       us-west-1
US West (Oregon)              us-west-2
Africa (Cape Town)            af-south-1
Asia Pacific (Hong Kong)      ap-east-1
Asia Pacific (Hyderabad)      ap-south-2
Asia Pacific (Jakarta)        ap-southeast-3
Asia Pacific (Malaysia)       ap-southeast-5
Asia Pacific (Melbourne)      ap-southeast-4
Asia Pacific (Mumbai)         ap-south-1
Asia Pacific (Osaka)          ap-northeast-3
Asia Pacific (Seoul)          ap-northeast-2
Asia Pacific (Singapore)      ap-southeast-1
Asia Pacific (Sydney)         ap-southeast-2
Asia Pacific (Taipei)         ap-east-2
Asia Pacific (Thailand)       ap-southeast-7
Asia Pacific (Tokyo)          ap-northeast-1
Canada (Central)              ca-central-1
Canada West (Calgary)         ca-west-1
Europe (Frankfurt)            eu-central-1
Europe (Ireland)              eu-west-1
Europe (London)               eu-west-2
Europe (Milan)                eu-south-1
Europe (Paris)                eu-west-3
Europe (Spain)                eu-south-2
Europe (Stockholm)            eu-north-1
Europe (Zurich)               eu-central-2
Israel (Tel Aviv)             il-central-1
Mexico (Central)              mx-central-1
Middle East (Bahrain)         me-south-1
Middle East (UAE)             me-central-1
South America (São Paulo)     sa-east-1
AWS GovCloud (US-East)        us-gov-east-1
AWS GovCloud (US-West)        us-gov-west-1
"

  # fzf selection
  local selection
  selection=$(echo "$regions" | fzf --prompt="Select AWS region > " --height=60% --reverse --border)

  # If nothing selected, exit
  [ -z "$selection" ] && return 1

  # Extract the region code (last column)
  local region_code
  region_code=$(echo "$selection" | awk '{print $NF}')

  export AWS_DEFAULT_REGION="$region_code"
  export AWS_REGION="$region_code"

  echo "✅ AWS region set to: $region_code"
}


fzf-command-history() {
  local selected
  selected=$(
    # list history newest→oldest, no numbers
    fc -l -n -r 1 |
    # de-duplicate, keeping the first (most recent) occurrence
    awk '!seen[$0]++' |
    # fuzzy-pick
    fzf -e +s --tiebreak=index --preview 'echo {}' --preview-window=up:1:wrap
  )
  if [[ -n $selected ]]; then
    LBUFFER="$selected"
  fi
  zle redisplay
}


sd() {
  local pick depth_flags

  # Parse flags: only -a is supported for now
  if [[ "$1" == "-a" ]]; then
    depth_flags=(-mindepth 1)            # recursive (show everything)
    shift
  else
    depth_flags=(-mindepth 1 -maxdepth 1)  # level 1 only
  fi

  pick=$(
    # Build the candidate list
    find . "${depth_flags[@]}" \
      \( -path '*/.*' -type d -o -path '*/node_modules' -o -path '*/build' -o -name '.*' -type f \) -prune -o \
      -print0 |
    FZF_DEFAULT_OPTS="" fzf --read0 --height=80% --layout=reverse --border \
      --preview '
        # IMPORTANT: {} is already shell-escaped; don’t wrap it in quotes.
        p={}
        printf "→ %s\n\n" "$p"

        if [ -d "$p" ]; then
          if command -v eza >/dev/null 2>&1; then
            eza -la --group-directories-first "$p" 2>/dev/null || ls -la "$p" 2>/dev/null
          else
            ls -la "$p" 2>/dev/null
          fi
        elif [ -f "$p" ] || [ -L "$p" ]; then
          if [ ! -r "$p" ]; then
            echo "(unreadable)"; exit 0
          fi
          if command -v bat >/dev/null 2>&1; then
            bat --paging=never --style=numbers --color=always --line-range=:200 "$p" 2>/dev/null \
            || head -n 200 "$p" 2>/dev/null || cat "$p" 2>/dev/null
          else
            head -n 200 "$p" 2>/dev/null || cat "$p" 2>/dev/null
          fi
        else
          # Helpful diagnostics if it’s something special
          ls -ld "$p" 2>/dev/null || true
          command -v file >/dev/null 2>&1 && file "$p" 2>/dev/null || echo "(unknown type)"
        fi
      ' \
      --preview-window=up,60%,wrap
  ) || return

  [[ -z $pick ]] && return
  if [[ -d $pick ]]; then
    cd -- "$pick"
  else
    "${EDITOR:-vim}" -- "$pick"
  fi
}

# Fuzzy Finder for Directories
fzf-command-history() {
  local selected
  selected=$(
    # list history newest→oldest, no numbers
    fc -l -n -r 1 |
    # de-duplicate, keeping the first (most recent) occurrence
    awk '!seen[$0]++' |
    # fuzzy-pick
    fzf -e +s --tiebreak=index --preview 'echo {}' --preview-window=up:1:wrap
  )
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
    tmux new-window -t ct -n 'client' -c ~/PATH_TO_PACKAGE
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


create_windows() {
  local session="$1"; shift
  local panes=("$@")

  for entry in "${panes[@]}"; do
    local name="${entry%%:*}"
    local dir="${entry#*:}"

    if ! tmux list-windows -t "$session" | grep -q "^${name}"; then
      tmux new-window -t "$session" -n "$name" -c "$dir"
    fi
  done
}

init-work() {
  if ! tmux has-session -t work 2>/dev/null; then
    tmux new-session -d -s work -n 'logs' -c ~/logs 
  fi

  local panes=(
    "PACKAGE_NAME:/PATH_TO_FOLDER"
  )

  create_windows work "${panes[@]}"

  tmux attach -t work
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

treemd() {
  # POSIX-sh: write a Markdown nested list of your directory tree
  # Usage: treemd [-o OUTPUT|-] [-i "dir1 dir2 ..."] [DIR]
  #   -o  output file (default: tree.md). Use "-" to write to stdout.
  #   -i  space-separated names to ignore (default below or $TREEMD_IGNORE)
  out="tree.md"
  dir="."
  ignore_default="build node_modules .git dist target .next out coverage venv .venv tests test test-common"
  ignore="${TREEMD_IGNORE:-$ignore_default}"

  while getopts "o:i:h" opt; do
    case "$opt" in
      o) out="$OPTARG" ;;
      i) ignore="$OPTARG" ;;
      h)
        printf "Usage: treemd [-o OUTPUT|-] [-i \"dir1 dir2 ...\"] [DIR]\n"
        return 0
        ;;
    esac
  done
  shift $((OPTIND-1))
  [ $# -gt 0 ] && dir="$1"

  command -v tree >/dev/null 2>&1 || { printf "treemd: 'tree' is not installed.\n" >&2; return 127; }

  # Build ignore pattern: name1|name2|...
  pattern=$(printf "%s" "$ignore" | awk '{for(i=1;i<=NF;i++){gsub(/\|/,"\\|",$i);printf "%s%s",(i>1?"|":""),$i}}')

  generate() {
    printf '## Directory tree for `%s`\n\n' "$dir"
    # Convert tree to Markdown bullets:
    tree -I "$pattern" -F --noreport "$dir" | awk '
      BEGIN { OFS=""; }
      NR==1 { print "- ", $0; next }  # root line
      {
        line=$0
        gsub(/\t/, "    ", line)              # tabs -> 4 spaces
        # Find branch token (Unicode or ASCII variants)
        pos = index(line, "├── "); if (!pos) pos = index(line, "└── ")
        if (!pos) pos = index(line, "|-- ");  if (!pos) pos = index(line, "`-- ")
        if (!pos) next

        indent_str = substr(line, 1, pos-1)
        gsub(/[^ ]/, " ", indent_str)         # make visible guides into spaces
        depth = int(length(indent_str) / 4)   # 4-space “cells” from tree

        rest = substr(line, pos)
        gsub(/├── |└── |\|-- |`-- /, "- ", rest)

        indent=""
        for (i=0; i<depth; i++) indent = indent "  "   # 2 spaces per level
        print indent, rest
      }'
    printf '\n'
  }

  if [ "$out" = "-" ]; then
    generate
  else
    tmp="${out}.tmp.$$"
    generate >"$tmp" && mv "$tmp" "$out"
    printf "Wrote Markdown list to %s (ignored: %s)\n" "$out" "$pattern"
  fi
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
