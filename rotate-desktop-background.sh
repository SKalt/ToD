#!/usr/bin/env bash
set -euo pipefail

# https://stackoverflow.com/a/19666729/6571327
PID=""; PID="$(pgrep gnome-session | head -1)"
export DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/"$PID"/environ|cut -d= -f2-)"

__this="${BASH_SOURCE[0]:-$0}"
__here="$(dirname "$(realpath "$__this")")"
cfg_file="$__here/background.cfg"

usage() {
  echo "USAGE: $__this dark|standard|light
  sets the background image in conjunction with the system theme
  configure a background file in $cfg_file or use random images from
  ~/Pitures/Wallpapers/ whose names contain the theme name (dark|light|standard)
  "
}

get_random_background_file() {
  local appearance="$1"
  find ~/Pictures/Wallpapers -type f | grep "$appearance" | sort -R | head -1
}

get_configured_background_for_appearance() {
  # expects a key=value ini/cfg/.env style doc
  local appearance="$1"
  local result=""
  if [ -e "$cfg_file" ]; then
    result="$(
      grep -e "$appearance" "$cfg_file" |
        tail -1 |
        awk -F "=" '{ print $2 }'
    )"
    if [ -n "$result" ] && [ -e "$result" ]; then
      echo "$result"
    else
      return 1
    fi
  else
    return 1
  fi
}

get_file_uri() {
  echo "file://$1"
}

get_wallpaper() {
  local file=""
  file="$(
    get_configured_background_for_appearance "$1" || get_random_background_file "$1"
  )"
  get_file_uri "$file"
}

validate_appearance() {
  if [ -n "$1" ]; then
    case "$1" in
    light | standard | dark) echo "$1" ;;
    *) usage && return 1 ;;
    esac
  else
    return 1
  fi
}

get_current_appearance() {
  validate_appearance "$1" && return 0

  case "$(gsettings get org.gnome.desktop.interface gtk-theme)" in
  "'Yaru-dark'") echo "dark" ;; # for reasons unknown, the theme names include single-quotes
  "'Yaru-light'") echo "light" ;;
  "'Yaru'") echo "standard";;
  *) echo "standard" ;;
  esac
}

change_background() {
  local appearance=""
  appearance="$(get_current_appearance "$1")"
  # echo "curent appearance=$appearance"
  local wallpaper=""
  wallpaper="$(get_wallpaper "$appearance")"
  # echo "wallpaper=$wallpaper"
  gsettings set org.gnome.desktop.background picture-uri "$wallpaper"
}

if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
  change_background "${1:-}"
fi