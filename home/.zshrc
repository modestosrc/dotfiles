clear
pfetch

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

ENABLE_CORRECTION="false"

COMPLETION_WAITING_DOTS="true"

plugins=(
    git
    vi-mode
    zsh-autosuggestions
)

# vi-mode configs
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true 
MODE_INDICATOR="%F{white}󰞷%f"
INSERT_MODE_INDICATOR="%F{yellow}󰞷%f"
#RPROMPT="\$(vi_mode_prompt_info)$RPROMPT "

###############################################################################
# Meus comandos

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep extendedglob nomatch notify
bindkey -v
autoload -Uz compinit
compinit
set -o vi
eval "$(zoxide init zsh --cmd cd)"

export PATH="$HOME/bin:$PATH"
export PATH="$PATH:/opt/texlive/2023/tlpkg/TeXLive/"
export JAVA_HOME=/usr
export EDITOR=nvim

alias clr="clear"
alias update="sudo xbps-install -Su"
alias install="sudo xbps-install "
alias mixer="pulsemixer"
alias confnvim="cd /home/mateus/.config/nvim && nvim"
alias confkitty="nvim ~/.config/kitty/kitty.conf"
alias confawesome="nvim ~/.config/awesome/"
alias confbashrc="nvim ~/.bashrc"
alias confzsh="nvim ~/.zshrc"
alias minecraft="java -jar /home/mateus/bin/tlauncher.jar"
alias reload="cd ~ && source .zshrc"
alias starsector="cd /home/mateus/starsector/ && bash starsector.sh"
alias phide="polybar-msg cmd hide"
alias pshow="polybar-msg cmd show"
alias pquit="polybar-msg cmd quit"

setxkbmap -layout br
xmodmap ~/.Xmodmap

bindkey '^ ' autosuggest-accept

function lk {
    cd "$(walk "$@" --icons)"
}

###############################################################################

source $ZSH/oh-my-zsh.sh
PROMPT="$PROMPT\$(vi_mode_prompt_info) "

# opam configuration
[[ ! -r /home/mateus/.opam/opam-init/init.zsh ]] || source /home/mateus/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
