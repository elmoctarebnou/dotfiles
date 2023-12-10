######## Path exports ########
export PATH=$HOME/bin:/usr/local/bin:$PATH
# Home brew alias
export PATH=/opt/homebrew/bin:$PATH
# Rust Cargo
export PATH="$HOME/.cargo/bin:$PATH"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Lvim
export PATH="$HOME/.local/bin:$PATH"
# Vs code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

######## Sourcing ############
source $ZSH/oh-my-zsh.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
##############################
# Oh my zsh plugins
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

####### Alias ############
# get machine's ip address
alias ip="ipconfig getifaddr en0"
# edit global zsh configuration
alias zshconfig="code ~/.zshrc"
# reload zsh configuration
alias zshsource="source ~/.zshrc"
# reload zsh configuration
alias ohmyzsh="cd ~/.oh-my-zsh"
# navigate to global ssh directory
alias sshhome="cd ~/.ssh"
# edit global ssh configuration
alias sshconfig="code ~/.ssh/config"
# edit global git configuration
alias gitconfig="code ~/.gitconfig"
# git aliases
alias gits="git status"
alias gitd="git diff"
alias gitl="git lg"
alias gita="git add ."
alias gitc="cz commit"
# python alias
alias python=python3
# Lvim alias
alias vi=lvim

# tmux alias
function tat {
  cd ~/
  sh tmux-session-setup.sh
  tmux attach -t "$name"
}



# load zsh-completions
autoload -U compinit && compinit

# Use starship theme (needs to be at the end)
eval "$(starship init zsh)"
