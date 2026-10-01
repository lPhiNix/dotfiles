# PhiNix Dotfiles

My personal Linux dotfiles: a Hyprland + Caelestia desktop, a Fish shell and the
terminal and editor setup I use every day.

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/lPhiNix/dotfiles/main/install.sh | bash
```

### Manual

```sh
git clone https://github.com/lPhiNix/dotfiles.git "$HOME/.dotfiles"
"$HOME/.dotfiles/install.sh"
```

The installer symlinks each top-level. It never overwrites real files or
directories that are not symlinks, and it is safe to run again.

### Home Manager (Nix)

This repository is also a flake exposing a Home Manager module:

```nix
{
  inputs.dotfiles.url = "github:lPhiNix/dotfiles";

  # in your home configuration:
  imports = [inputs.dotfiles.homeManagerModules.default];
  dotfiles.enable = true;
}
```

## Screenshots

![screenshot](Pictures/Screenshots/noir.png)
