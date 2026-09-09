#!/bin/bash
# Omarchy Raiders terminal greeting. Sourced from ~/.bashrc by extras/install.sh.
# Prints the theme art and one line when a new interactive terminal opens,
# but only while the Omarchy Raiders theme is the active Omarchy theme.
# Reads two small files, starts no programs.
[[ $- == *i* ]] || return 0 2>/dev/null || exit 0
[[ -r "$HOME/.local/state/omarchy/current/theme.name" ]] || return 0
read -r _oz_theme < "$HOME/.local/state/omarchy/current/theme.name"
if [[ $_oz_theme != omarchy-raiders ]]; then unset _oz_theme; return 0; fi
unset _oz_theme
_oz_art="${BASH_SOURCE[0]%/*}/greeting-art.ansi"
[[ -r $_oz_art ]] || _oz_art="${BASH_SOURCE[0]%/*}/greeting-art.txt"
if [[ -r $_oz_art ]]; then
  mapfile -t _oz_lines < "$_oz_art"
  printf '\e[38;2;245;197;24m%s\e[0m\n' "${_oz_lines[@]}"
  printf '\e[38;2;154;143;168m%s\e[0m\n\n' "                   Still listening."
fi
unset _oz_art _oz_lines
