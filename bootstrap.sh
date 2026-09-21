#!/usr/bin/env bash
#    ___  __   _ _  ___        ___       __  ____ __
#   / _ \/ /  (_) |/ (_)_ __  / _ \___  / /_/ _(_) /__ ___
#  / ___/ _ \/ /    / /\ \ / / // / _ \/ __/ _/ / / -_|_-<
# /_/  /_//_/_/_/|_/_//_\_\ /____/\___/\__/_//_/_/\__/___/
#
# PhiNix dotfiles bootstrap
#
#   curl -fsSL https://raw.githubusercontent.com/lPhiNix/dotfiles/main/bootstrap.sh | bash
#
# Restores the dotfiles repo into $HOME as a bare repo (work-tree = $HOME),
# pulls its submodules (.nix, .config/nvim) and applies the configuration:
#
#   - NixOS        -> nixos-rebuild switch --flake ~/.nix#<host>
#   - other Linux  -> home-manager switch --flake ~/.nix#standalone
#
# The host defaults to `hostname -s`. Repos are public but cloned over SSH,
# so a working GitHub SSH key is required.

set -euo pipefail

REPO="git@github.com:lPhiNix/dotfiles.git"
FLAKE="$HOME/.nix"
GIT_DIR="$HOME/.dotfiles"
HOST="$(hostname -s)"
NIX=(nix --extra-experimental-features "nix-command flakes")

d() { git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"; }

echo ">> Host: $HOST"

# --- preflight -------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "!! 'git' is missing."; exit 1; }

if ! git ls-remote "$REPO" HEAD >/dev/null 2>&1; then
  echo "!! Cannot reach $REPO over SSH."
  echo "   Set up your GitHub SSH key (the repos are public, but they are"
  echo "   cloned over SSH) and try again."
  exit 1
fi

# Outside NixOS, Nix must already be installed. We warn, we do not install it.
if [ ! -e /etc/NIXOS ] && ! command -v nix >/dev/null 2>&1; then
  echo "!! Nix is not installed. Install it and run this script again:"
  echo "   sh <(curl -fsSL https://nixos.org/nix/install) --daemon"
  exit 1
fi

# --- backup + clone/update -------------------------------------------------
if [ -d "$GIT_DIR" ]; then
  echo ">> Repo already present: updating to origin/main"
  d fetch origin
  d reset --hard origin/main
else
  if [ -e "$HOME/.config" ]; then
    echo ">> Backing up ~/.config -> ~/.config.bak"
    rm -rf "$HOME/.config.bak"
    mv "$HOME/.config" "$HOME/.config.bak"
  fi
  echo ">> Cloning $REPO"
  git clone --bare "$REPO" "$GIT_DIR"
  d config status.showUntrackedFiles no
  d checkout -f
fi

echo ">> Submodules"
d submodule update --init --recursive

# --- apply -----------------------------------------------------------------
if [ -e /etc/NIXOS ]; then
  hosts="$("${NIX[@]}" eval --json "$FLAKE#nixosConfigurations" --apply 'builtins.attrNames' 2>/dev/null || echo '[]')"
  if ! printf '%s' "$hosts" | grep -q "\"$HOST\""; then
    echo "!! Host '$HOST' is not in nixosConfigurations. Available: $hosts"
    exit 1
  fi
  sudo nixos-rebuild switch --flake "$FLAKE#$HOST"
else
  target="standalone"
  cfgs="$("${NIX[@]}" eval --json "$FLAKE#homeConfigurations" --apply 'builtins.attrNames' 2>/dev/null || echo '[]')"
  if ! printf '%s' "$cfgs" | grep -q "\"$target\""; then
    echo "!! homeConfigurations.\"$target\" does not exist. Available: $cfgs"
    exit 1
  fi
  "${NIX[@]}" run github:nix-community/home-manager/release-26.05 -- \
    switch --flake "$FLAKE#$target"
fi

echo ">> Done."
