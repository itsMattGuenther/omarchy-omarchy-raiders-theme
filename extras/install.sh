#!/bin/bash
# Installs the Omarchy Raiders extras that an Omarchy theme cannot ship on its own:
#   - cliamp music player theme    -> ~/.config/cliamp/themes/omarchy-raiders.toml
#   - listening-station About logo -> ~/.config/omarchy-raiders/about.txt (swapped in by the hook)
#   - terminal greeting            -> ~/.config/omarchy-raiders/ + one block in ~/.bashrc
#   - theme-set hook               -> ~/.config/omarchy/hooks/theme-set.d/
# Safe to run more than once. Run with --uninstall to remove everything it added.
set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ROOT=$(cd "$HERE/.." && pwd)
OZ_DIR="$HOME/.config/omarchy-raiders"
BASHRC="$HOME/.bashrc"
MARK_START="# >>> omarchy-raiders greeting >>>"
MARK_END="# <<< omarchy-raiders greeting <<<"
HOOK="$HOME/.config/omarchy/hooks/theme-set.d/omarchy-raiders-theme-set.sh"

remove_bashrc_block() {
  [[ -f $BASHRC ]] && grep -qF "$MARK_START" "$BASHRC" || return 0
  cp "$BASHRC" "$BASHRC.bak.omarchy-raiders"
  sed -i "/^$MARK_START\$/,/^$MARK_END\$/d" "$BASHRC"
}

if [[ ${1:-} == --uninstall ]]; then
  remove_bashrc_block
  rm -f "$HOME/.config/cliamp/themes/omarchy-raiders.toml" "$HOOK"
  # give Omarchy its own About logo back
  bash "$ROOT/hooks/omarchy-raiders-theme-set.sh" "not-ours"
  rm -rf "$OZ_DIR"
  echo "Omarchy Raiders extras removed. Open a new terminal to see the change."
  exit 0
fi

mkdir -p "$OZ_DIR" "$HOME/.config/cliamp/themes"
cp "$HERE/cliamp/omarchy-raiders.toml" "$HOME/.config/cliamp/themes/omarchy-raiders.toml"

# Update the active copy before replacing our stored art. Otherwise the hook
# would mistake the previous version for the user's original About logo and
# overwrite the backup when extras are upgraded while this theme is active.
ABOUT="$HOME/.config/omarchy/branding/about.txt"
if [[ -f $OZ_DIR/about.txt && -f $ABOUT ]] && cmp -s "$OZ_DIR/about.txt" "$ABOUT"; then
  cp "$HERE/art/omarchy-raiders-ridge.txt" "$ABOUT"
fi
# Omarchy measures the raw About file with wc -L, including ANSI sequences.
# Keep this copy plain so the window fits; fastfetch supplies its logo colour.
cp "$HERE/art/omarchy-raiders-ridge.txt" "$OZ_DIR/about.txt"
cp "$HERE/greeting.sh" "$OZ_DIR/greeting.sh"
cp "$HERE/art/greeting-art.txt" "$OZ_DIR/greeting-art.txt"
cp "$HERE/art/greeting-art.ansi" "$OZ_DIR/greeting-art.ansi"

remove_bashrc_block
cat >> "$BASHRC" <<BLOCK
$MARK_START
[[ -r ~/.config/omarchy-raiders/greeting.sh ]] && source ~/.config/omarchy-raiders/greeting.sh
$MARK_END
BLOCK

omarchy hook install theme-set "$ROOT/hooks/omarchy-raiders-theme-set.sh" >/dev/null
# Apply the hook to whatever theme is active right now.
"$HOOK" "$(cat "$HOME/.local/state/omarchy/current/theme.name" 2>/dev/null || true)"

cat <<MSG
Installed:
  - cliamp theme        ~/.config/cliamp/themes/omarchy-raiders.toml
  - About-screen logo   $OZ_DIR/about.txt
  - greeting            one marked block at the end of ~/.bashrc
  - theme hook          $HOOK
Open a new terminal to see the greeting. Run with --uninstall to undo.
MSG
