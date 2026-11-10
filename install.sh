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
#   - README.md is linked into $HOME; install.sh and flake.nix are repo
#     metadata and are not linked there.
#   - Parent directories are created as real directories, so applications can
#     keep writing their generated state next to the linked files.
#   - Real (non-symlink) targets are never overwritten.
#   - Re-running the script is safe (idempotent).

set -euo pipefail

# Repository location and clone target. This is the single source of truth:
# the installer always works on $DOTFILES_DIR, regardless of where it was
# invoked from.
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
  echo "   Use 'make switch' or 'home-manager switch' instead." >&2
  echo "   Set DOTFILES_FORCE=1 to override." >&2
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
# exists and is not already a symlink is left untouched, so user data is never
# clobbered. Safe to call repeatedly.
link() {
  local src="$1" dst="$2"

  # Never create a symlink that points to itself. This is the safety net that
  # prevents the "too many levels of symbolic links" failure.
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
# Tracked top-level files go to $HOME, except repo metadata (install.sh and
# flake.nix). README.md is intentionally linked. Hidden entries (.gitignore)
# and directories (.config, Pictures) are skipped here.
if git -C "$repo" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  while IFS= read -r -d '' rel; do
    case "$rel" in
      */* | .* | flake.nix | install.sh) continue ;;
    esac
    link "$repo/$rel" "$HOME/$rel"
  done < <(git -C "$repo" ls-files -z -- .)
else
  while IFS= read -r -d '' path; do
    base="${path##*/}"
    case "$base" in
      flake.nix | install.sh) continue ;;
    esac
    link "$path" "$HOME/$base"
  done < <(find "$repo" -maxdepth 1 -type f ! -name '.*' -print0)
fi

echo ">> Done."
