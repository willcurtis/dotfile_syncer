#!/bin/bash

# CONFIGURATION
WATCHED_FILES=(
  "$HOME/.zshrc"
  "$HOME/.cloginrc"
  "$HOME/.gitconfig"
  "$HOME/.bash_profile"
  "$HOME/.ssh/"
)
REPO_DIR="$HOME/Documents/GitHub/dotfiles"
LOG_FILE="$REPO_DIR/dotfile_syncer.log"
DEBOUNCE_SECONDS=10

# Setup
mkdir -p "$REPO_DIR"
cd "$REPO_DIR" || exit 1

# Initialize Git repo if missing
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "Initializing Git repo..."
  git init
  git remote add origin git@github.com:willcurtis/dotfiles.git
  # Optional: git pull origin main
fi

# Utility: logger
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Utility: check if content has changed
content_changed() {
  local src="$1"
  local dest="$REPO_DIR/$(basename "$src")"

  if [ -d "$src" ]; then
    rsync -rni "$src/" "$dest/" | grep -q '^>f'
    return $?
  elif [ -f "$src" ]; then
    if [ ! -f "$dest" ] || ! cmp -s "$src" "$dest"; then
      return 0
    fi
  fi

  return 1
}

# Sync file or directory
sync_path() {
  local src="$1"
  local dest="$REPO_DIR/$(basename "$src")"

  if [ -d "$src" ]; then
    rsync -a --delete "$src/" "$dest/"
  elif [ -f "$src" ]; then
    cp "$src" "$dest"
  fi
}

# Monitor and sync changes
fswatch -o "${WATCHED_FILES[@]}" | while read -r; do
  sleep "$DEBOUNCE_SECONDS" # debounce

  changes_detected=false
  changed_items=()

  for path in "${WATCHED_FILES[@]}"; do
    if content_changed "$path"; then
      log "Detected change in $(basename "$path")"
      sync_path "$path"
      git add "$(basename "$path")"
      changed_items+=("$(basename "$path")")
      changes_detected=true
    fi
  done

  if [ "$changes_detected" = true ]; then
    COMMIT_MESSAGE="Auto-sync: updated ${changed_items[*]} on $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MESSAGE"
    if git push; then
      log "Successfully pushed changes."
    else
      log "ERROR: Failed to push changes."
    fi
  else
    log "No actual changes detected."
  fi
done
