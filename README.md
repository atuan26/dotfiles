
## Windows

## Linux

### KDE

- [config](https://github.com/shalva97/kde-configuration-files)

- Install [konsave](https://github.com/Prayag2/konsave): `python -m pip install konsave`
- Save profile: `konsave --save <profile name>`
- Apply profile: `konsave --apply <profile name>`


### Ubuntu

- apt-clone:
  -Install: `sudo apt install apt-clone`
  - Backup installed packages: `sudo apt-clone clone --with-dpkg-repack backup-$(date '+%Y-%m-%d-%H-%M-%S')`
  - View backup file details:`apt-clone info <apt-clone.tar.gz>`
  - Show diff: `apt-clone show-diff <apt-clone.tar.gz>`
  - Restore installed packages: `sudo apt-clone restore <apt-clone-state.tar.gz>`
- Gnome
  - Backup: `dconf dump / > gnome-settings.dconf`
  - Restore: `dconf load -f / < gnome-settings.dconf`


## MacOS

```
brew bundle dump
```


## VSCode

- Install Code sync: `code --install-extension golf1052.code-sync`
