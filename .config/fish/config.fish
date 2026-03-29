if status is-interactive
# Commands to run in interactive sessions can go here
end

set -g fish_greeting ""

alias ls="lsd"
alias ll="lsd -a"
alias lll="lsd -la"
alias cls="clear"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
thefuck --alias | source

