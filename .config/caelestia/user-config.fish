#  _____ _     _        ____             __ _
# |  ___(_)___| |__    / ___|___  _ __  / _(_) __ _
# | |_  | / __| '_ \  | |   / _ \| '_ \| |_| |/ _` |
# |  _| | \__ \ | | | | |__| (_) | | | |  _| | (_| |
# |_|   |_|___/_| |_|  \____\___/|_| |_|_| |_|\__, |
#                                             |___/
# --------------------------------------------------
# User fish configuration by lPhiNix

abbr f        'fastfetch'
abbr d        'dotfiles'
abbr v        'nvim'
abbr vim      'nvim'
abbr cls      'clear'
abbr q        'exit'
abbr shutdown 'shutdown -h now'

abbr cat   'bat'
abbr grep  'rg'
abbr find  'fd'
abbr top   'btop'

abbr rm 'rm -i'
abbr cp 'cp -i'
abbr mv 'mv -i'


abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

abbr g 'git'
abbr gr 'git rebase'
abbr grc 'git rebase --continue'
abbr gcp 'git cherry-pick'
abbr gcl 'git clone'
abbr grv 'git remote -v'
abbr gpsu 'git push -u origin HEAD'

set -gx EDITOR nvim
set -gx VISUAL nvim
