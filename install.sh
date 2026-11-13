#!/usr/bin/env bash
#    ___  __   _ _  ___        ___       __  ____ __
#   / _ \/ /  (_) |/ (_)_ __  / _ \___  / /_/ _(_) /__ ___
#  / ___/ _ \/ /    / /\ \ / / // / _ \/ __/ _/ / / -_|_-<
# /_/  /_//_/_/_/|_/_//_\_\ /____/\___/\__/_//_/_/\__/___/
#
# PhiNix dotfiles installer
#
#   curl -fsSL https://raw.githubusercontent.com/lPhiNix/dotfiles/main/install.sh | bash
#
# Links the tracked dotfiles into $HOME, so this repository can be used on any
# Linux machine. When run from a checkout the repository itself is used; when
# piped (curl | bash) it is cloned to $DOTFILES_DIR first.
#
# Conventions:
#   - Tracked files are linked one symlink per file, except the writable app
#     dirs (Caelestia and the OBS profile/scenes), which are linked as whole
#     directories so the apps can save through them.
#   - ~/.config/<path> and ~/Pictures/<path> mirror the repository.
#   - README.md is linked into $HOME; install.sh and flake.nix are metadata.
#   - Real (non-symlink) targets are never overwritten.
#   - Re-running the script is safe (idempotent).

set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/lPhiNix/dotfiles.git}"
DEST="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Make a relative DOTFILES_DIR absolute.
if [ "${DEST#/}" = "$DEST" ]; then
  DEST="$PWD/$DEST"
fi

# Never allow the home directory (or /) to be treated as the repository.
case "$DEST" in
  "$HOME" | "$HOME/" | "/")
    echo "!! Refusing to use '$DEST' as the dotfiles repository." >&2
    exit 1
    ;;
esac

# Do not mix install.sh with a Home Manager-managed configuration tree.
if [ "${DOTFILES_FORCE:-0}" != "1" ] &&
  find "$HOME/.config" -maxdepth 3 -type l -lname '/nix/store/*' -print -quit 2>/dev/null | grep -q .; then
  echo "!! Home Manager-managed files detected in $HOME/.config." >&2
  echo "   Use 'home-manager switch' instead (DOTFILES_FORCE=1 to override)." >&2
  exit 1
fi

repo="$DEST"

if [ -e "$repo" ] && [ ! -d "$repo" ]; then
  echo "!! $repo exists and is not a directory." >&2
  exit 1
fi

if [ -d "$repo/.git" ]; then
  echo ">> Using existing clone at $repo"
else
  if [ -d "$repo" ] && [ -n "$(ls -A "$repo" 2>/dev/null)" ]; then
    echo "!! $repo exists but is not a git checkout; refusing to touch it." >&2
    exit 1
  fi

  command -v git >/dev/null 2>&1 || { echo "!! 'git' is required." >&2; exit 1; }
  echo ">> Cloning $REPO_URL into $repo"
  git clone "$REPO_URL" "$repo"
fi

# link SRC DST
#
# Symlink SRC at DST, creating the parent directory when needed. A target that
# exists and is not a symlink is left untouched, so user data is never
# clobbered. Works for files and directories; safe to call repeatedly.
link() {
  local src="$1" dst="$2"

  if [ "$src" = "$dst" ]; then
    echo "!! refusing to link $dst to itself; skipping" >&2
    return
  fi

  mkdir -p -- "$(dirname -- "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "!! $dst exists and is not a symlink; skipping" >&2
    return
  fi

  ln -sfn -- "$src" "$dst"
  echo "$dst -> $src"
}

# --- config ----------------------------------------------------------------
# Static files are linked one by one. Caelestia and OBS are linked as whole
# directories below because their apps save with atomic renames.
while IFS= read -r -d '' rel; do
  case "$rel" in
    .config/caelestia/* | .config/obs-studio/*) continue ;;
  esac
  link "$repo/$rel" "$HOME/$rel"
done < <(git -C "$repo" ls-files -z -- .config)

link "$repo/.config/caelestia" "$HOME/.config/caelestia"
link "$repo/.config/obs-studio/basic/profiles/phone-vertical" \
  "$HOME/.config/obs-studio/basic/profiles/phone-vertical"
link "$repo/.config/obs-studio/basic/scenes" \
  "$HOME/.config/obs-studio/basic/scenes"

# --- pictures --------------------------------------------------------------
while IFS= read -r -d '' rel; do
  link "$repo/$rel" "$HOME/$rel"
done < <(git -C "$repo" ls-files -z -- Pictures)

# --- root files ------------------------------------------------------------
# README.md is linked; repo metadata and hidden entries are skipped.
while IFS= read -r -d '' rel; do
  case "$rel" in
    */* | .* | flake.nix | install.sh) continue ;;
  esac
  link "$repo/$rel" "$HOME/$rel"
done < <(git -C "$repo" ls-files -z -- .)

echo ">> Done."
