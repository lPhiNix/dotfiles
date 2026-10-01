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
#   - Only the tracked files are linked, one symlink per file.
#   - ~/.config/<path> is symlinked to the matching file in the repository.
#   - ~/Pictures/<path> is symlinked the same way.
#   - Parent directories are created as real directories, so applications can
#     keep writing their generated state next to the linked files.
#   - Real (non-symlink) targets are never overwritten.
#   - Re-running the script is safe (idempotent).

set -euo pipefail

# Repository location and clone target.
REPO_URL="${DOTFILES_REPO:-https://github.com/lPhiNix/dotfiles.git}"
DEST="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Resolve the repository root. If this script is a real file living inside a
# checkout, use its directory; otherwise (piped through bash) clone the repo.
self="${BASH_SOURCE[0]:-}"
repo=""
if [ -n "$self" ]; then
  candidate="$(cd "$(dirname "$self")" 2>/dev/null && pwd || true)"
  if [ -n "$candidate" ] && [ -d "$candidate/.config" ]; then
    repo="$candidate"
  fi
fi

if [ -z "$repo" ]; then
  repo="$DEST"
  if [ ! -d "$repo/.git" ]; then
    command -v git >/dev/null 2>&1 || { echo "!! 'git' is required."; exit 1; }
    echo ">> Cloning $REPO_URL into $repo"
    git clone "$REPO_URL" "$repo"
  else
    echo ">> Using existing clone at $repo"
  fi
fi

# link SRC DST
#
# Symlink SRC at DST, creating the parent directory when needed. A target that
# exists and is not already a symlink is left untouched, so user data is never
# clobbered. Safe to call repeatedly.
link() {
  local src="$1" dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "!! $dst exists and is not a symlink; skipping"
    return
  fi

  ln -sfn "$src" "$dst"
  echo "$dst -> $src"
}

# list_files DIR
#
# Print every tracked file under DIR (repository-relative, NUL-separated).
# Uses git when available and falls back to find for plain-tarball installs.
list_files() {
  local dir="$1"
  if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git -C "$repo" ls-files -z -- "$dir"
  else
    (cd "$repo" && find "$dir" ! -type d -print0)
  fi
}

# --- config ----------------------------------------------------------------
# One symlink per tracked file (hypr, fish, kitty, btop, caelestia, Code, ...).
while IFS= read -r -d '' rel; do
  link "$repo/$rel" "$HOME/$rel"
done < <(list_files .config)

# --- pictures --------------------------------------------------------------
# One symlink per tracked image (Wallpapers, Screenshots).
while IFS= read -r -d '' rel; do
  link "$repo/$rel" "$HOME/$rel"
done < <(list_files Pictures)

# --- root files ------------------------------------------------------------
# Tracked top-level files (README.md, install.sh, ...) go to $HOME. Hidden
# entries (.gitignore) and directories (.config, Pictures) are skipped here.
if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  while IFS= read -r -d '' rel; do
    case "$rel" in
      */* | .*) continue ;;
    esac
    link "$repo/$rel" "$HOME/$rel"
  done < <(git -C "$repo" ls-files -z -- .)
else
  while IFS= read -r -d '' path; do
    link "$path" "$HOME/${path##*/}"
  done < <(find "$repo" -maxdepth 1 -type f ! -name '.*' -print0)
fi

echo ">> Done."
