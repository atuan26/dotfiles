
## Windows

## Linux

### Ubuntu
1. Requirement
- Install `apt-clone`:
    ```bash
    sudo apt install apt-clone
    ```
2. Backup:
   - Backup installed packages:
     ```
     sudo apt-clone clone --with-dpkg-repack backup-$(date '+%Y-%m-%d-%H-%M-%S')
     ```
   - View backup file details:
     ```
     apt-clone info <apt-clone.tar.gz> 
     ```
3. Restore:
    - Show diff: `apt-clone show-diff <apt-clone.tar.gz>`
    - Restore installed packages:
        ```
        sudo apt-clone restore <apt-clone-state.tar.gz>
        ```


## MacOS

```
brew bundle dump
```


## VSCode

```
code --install-extension golf1052.code-sync
```
