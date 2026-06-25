if status is-interactive
# Commands to run in interactive sessions can go here
end

set -g fish_greeting ""

fastfetch -c config_promt.jsonc
oh-my-posh init fish --config ~/.config/ohmyposh/promt.omp.jsonc | source

alias f="fastfetch"

alias d="dotfiles"

alias sp="sudo pacman"
alias p="pacman"
alias y="yay"

alias v="nvim"
alias vim="nvim"

alias ls="lsd"
alias la="lsd -a"
alias ll="lsd -l"
alias lla="lsd -la"

alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --graph --decorate"
alias gb="git branch"
alias gcl="git clone"
alias gr="git remote"
alias grv="git remote -v"

alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

alias top="htop"
alias cat="bat"

alias cls="clear"
alias q="exit"
alias shutdown="shutdown -h now"

alias clear="command clear; fastfetch -c config_promt.jsonc"

alias cmatrix="cmatrix -C blue"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/phinix/.lmstudio/bin
# End of LM Studio CLI section

