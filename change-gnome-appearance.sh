#!/usr/bin/env bash
set -euo pipefail
# https://stackoverflow.com/a/19666729/6571327
PID=""; PID="$(pgrep gnome-session | head -1)"
export DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/"$PID"/environ|cut -d= -f2-)"

usage() {
  echo "USAGE: $0 [dark|standard|light]"
  echo "changes the system color theme"
}


look_up_appearance_by_hour() {
  local hour
  hour="$(date +%H)"
  if ((hour <= 6 || hour >= 20)); then
    echo "dark"
  elif ((hour <= 10 || hour >= 17)); then
    echo "standard"
  else
    echo "light"
  fi
}

change_appearance() {
  local appearance_name=""
  appearance_name="$(get_desired_appearance_name "$1")"
  # echo "about to set $appearance_name"
  gsettings set org.gnome.desktop.interface gtk-theme "$appearance_name"
}

get_desired_appearance_name() {
  case $1 in
  standard) echo "Yaru" ;;
  dark) echo "Yaru-dark" ;;
  light) echo "Yaru-light" ;;
  *)
    echo "invalid appearance $1" >&2
    usage
    return 1
    ;;
  esac
}

if [[ "$0" = "${BASH_SOURCE[0]}" ]]; then
  {
    echo
    echo "$PID $DBUS_SESSION_BUS_ADDRESS"
    echo "running as $(whoami)"
    echo "starting right on up"
  } >> /tmp/crontab.log
  desired_appearance="${1:-"$(look_up_appearance_by_hour)"}"
  # echo "desired=$desired_appearance"
  change_appearance "$desired_appearance"
fi