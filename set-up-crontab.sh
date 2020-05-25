#!/usr/bin/env bash
__this="${BASH_SOURCE[0]:-$0}"
__here="$(dirname "$(realpath "$__this")")"

usage() {
  echo "USAGE: $__this [--background|--appearance|--both]"
  echo "establishes a crontab"
}

(
  echo "17 * * * * $__here/change-gnome-appearance.sh && $__here/rotate-desktop-background.sh 2>&1 >> /tmp/crontab.log || echo 'failed' >> /tmp/crontab.log";
  echo "@reboot $__here/change-gnome-appearance.sh || echo 'failed' >> /tmp/crontab.log" 
) | crontab -u "$(whoami)" -