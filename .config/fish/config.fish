if status is-interactive
    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Zoxide
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

    # Git abbrs
    abbr gs 'git status'
    abbr ga 'git add .'
    abbr gc 'git commit -m'
    abbr gd 'git diff'
    abbr gr 'git restore'
    abbr grs 'git restore --staged'
    abbr gl 'git log'
    abbr glo 'git log --oneline'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gb 'git branch'
    abbr gco 'git checkout'
    abbr grb 'git rebase'
    abbr gcl 'git clone'
    abbr grv 'git remote -v'

    # Short commands
    abbr p 'phix'
    abbr d 'dotfiles'
    abbr f 'fastfetch'
    abbr v 'nvim'
    abbr vim 'nvim'
    abbr cls 'clear'
    abbr q 'exit'
    abbr shutdown 'shutdown -h now'

    abbr cat 'bat'
    abbr grep 'rg'
    abbr find 'fd'
    abbr top 'btop'

    abbr rm 'rm -i'
    abbr cp 'cp -i'
    abbr mv 'mv -i'

    abbr .. 'cd ..'
    abbr ... 'cd ../..'
    abbr .... 'cd ../../..'

    abbr l 'ls'
    abbr ll 'ls -l'
    abbr la 'ls -a'
    abbr lla 'ls -la'

    set -gx EDITOR nvim
    set -gx VISUAL nvim

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2> /dev/null
end
