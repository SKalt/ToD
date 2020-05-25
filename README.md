# ToD
Time of Day: rotate GNOME dark/light mode and themed wallpapers on Ubuntu 20.04 / Focal Fossa 

## Install
```sh
INSTALL_LOCATION="${INSTALL_LOCATION:-$PWD/ToD}"
git clone https://github.com/SKalt/ToD.git $INSTALL_LOCATION && cd $INSTALL_LOCATION;
# blows away other user-specific crontabs
./set-up-crontab.sh
```

## License

BSD-0

## TODOs and parts that might break

- [./setup-crontab.sh](./setup-crontab.sh)
  - [ ] should only register/deregister the wallpaper and theme-changing jobs, not nuking other crontabs
  - [ ] could register/deregister wallpaper and theme-changing jobs separately

- [./rotate-desktop-background.sh](./rotate-desktop-background.sh)
  - [ ] configuration file needs testing

- [./rotate-desktop-background.sh](./rotate-desktop-background.sh), [./change-gnome-appearance.sh](./change-gnome-appearance.sh)
  - [ ] consolidate shared functions: time-of-day lookup, theme-argument validation
  - [ ] time-of-day lookup should respect sun{rize,set}
  - [ ] `DBUS_SESSION_BUS_ADDRESS` lookup address should be more robust 

- use shellcheck
- port this to golang :)
