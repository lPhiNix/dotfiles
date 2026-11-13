if status is-interactive
    # Starship custom prompt
    command -v starship &> /dev/null && starship init fish | source

    # Direnv + Zoxide
    command -v direnv &> /dev/null && direnv hook fish | source
    command -v zoxide &> /dev/null && zoxide init fish --cmd cd | source

    # Better ls
    command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

    # Git abbrs
    abbr lg 'lazygit'
    abbr gd 'git diff'
    abbr ga 'git add .'
    abbr gc 'git commit -m'
    abbr gl 'git log'
    abbr gs 'git status'
    abbr gst 'git stash'
    abbr gsp 'git stash pop'
    abbr gp 'git push'
    abbr gpl 'git pull'
    abbr gsw 'git switch'
    abbr gsm 'git switch main'
    abbr gb 'git branch'
    abbr gbd 'git branch -d'
    abbr gco 'git checkout'
    abbr gsh 'git show'
    abbr g 'git'
    abbr gr 'git rebase'
    abbr grc 'git rebase --continue'
    abbr gcp 'git cherry-pick'
    abbr gcl 'git clone'
    abbr grv 'git remote -v'
    abbr gpsu 'git push -u origin HEAD'

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

    # For jumping between prompts in the terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end
end
