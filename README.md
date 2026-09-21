# PhiNix Dotfiles

My personal Linux setup: a NixOS system configuration bundled with the dotfiles
and a portable Home Manager layer, all versioned in a single repository.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/lPhiNix/dotfiles/main/bootstrap.sh | bash
```

### Manual

```sh
git clone --bare git@github.com:lPhiNix/dotfiles.git "$HOME/.dotfiles"
d() { git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" "$@"; }
d config status.showUntrackedFiles no
d checkout -f
d submodule update --init --recursive
```

Then apply the configuration:

```sh
# NixOS
sudo nixos-rebuild switch --flake ~/.nix#$(hostname -s)

# other Linux (Home Manager)
home-manager switch --flake ~/.nix#phinix@$(hostname -s)
```

## Screenshots

![screenshot](Pictures/Screenshots/noir.png)
