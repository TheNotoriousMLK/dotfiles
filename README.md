# MLK's dotfiles
![image of powerline go](https://camo.githubusercontent.com/60297a8d54249c0001ef67b63cba22dd7a73a1ff/68747470733a2f2f7261772e6769746875622e636f6d2f6a7573746a616e6e652f706f7765726c696e652d676f2f6d61737465722f707265766965772e706e67)

## Intro
These dotfiles are highly tailored for myself. They can be run on Linux, WSL and MacOS. If using Linux or WSL, a Debian install such as Ubuntu is required. On Linux (not WSL), GNOME is assumed to be the desktop environment. At the end, the default shell will be [Fish](https://fishshell.com). The [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) framework is also used.

These dotfiles can be used as is with slight adjustments to packages.txt files or by forking the repo and making edits to the code.

## Installation
This repo can be cloned anywhere, I prefer to keep it in `~/dotfiles`.

```bash
git clone https://github.com/thenotoriousmlk/dotfiles.git
```

Once the repo has been cloned, `cd` into the `dotfiles` directory and:
```bash
./install.sh
```

### Package management
Packages are managed using `apt`, `brew` and `snap`. The list of packages to be installed can be found under the `packages/` directory. These are merely text files with a list of packages to be installed. They are found in `packages.txt` under their respective directory.

#### Apt
The default packages installed are found under [packages.txt](packages/apt/packages.txt). For packages that are not WSL compatible, add them to [packages_not_wsl.txt](packages/apt/packages_not_wsl.txt). Packages under [packages_vbox.txt](packages/apt/packages_vbox.txt) are used for Linux installs on `VirtualBox`.

The list of PPAs can be updated using [repos.txt](packages/apt/repos.txt) and [repos_not_wsl.txt](packages/apt/repos_not_wsl.txt) for non WSL packages.

`Apt` is not run under MacOS.

#### Snap
[Snap](https://snapcraft.io) packages are only run under Linux and when not being run under WSL. They can be found in [packages.txt](packages/snap/packages.txt). Additional options can be set for a package install by using the format `package-name:--options`.

#### Homebrew
These dotfiles also uses [Homebrew](https://brew.sh) for package management. The default packages are found under [packages.txt](packages/brew/packages.txt) Packages under [packages_linux.txt](packages/brew/packages_linux.txt) are used for Linux (not MacOS) installs that are not under WSL. Packages under [packages_not_wsl.txt](packages/brew/packages_not_wsl.txt) are used by both Linux (not WSL) and MacOS. Packages under [packages_cask.txt](packages/brew/packages_cask.txt) are only used by MacOS. Additional options can be set for a package install by using the format `forumula:--options`.

When using MacOS, the `taps` for `Brew` can be confiured in [brew_sources.sh](packages/brew/brew_sources.sh).

To skip the installation of `Brew` run:
```bash
./install.sh --skip-brew
```

If you would also like Homebrew to be updated during install then:
```
./install.sh --update-brew
```

At any time, `packagees.txt` files can be updated and the `./install.sh` command run again. NB: This will not uninstall already installed packages.

## Configuration
These dotfiles will configure `git`, `vim`, `fish` and `GNOME`. It does so by symlinking files in the `$HOME` directory to the `dotfiles` directory. Any `.dotfile` in the root directory of the `dotfiles` directory except for `.gitignore` will be symlinked to `$HOME`. During the first run of configuration, you will be asked to supply your name and email for `git`.

To configure your machine, run:
```bash
./configure.sh
```
### Sudoers
These dotfiles edit `/etc/sudoers` file to enable software installation without entering a password. To prevent this behaviour, run:
```bash
./configure.sh --skip-sudoers
```

### Powerline Go
This repo uses [Powerline Go](https://github.com/justjanne/powerline-go) for its default prompt in Fish. You may change the prompt by updating the `fish_prompt` and `fish_right_prompt` functions in [init.fish](fish/omf/init.fish).

### GNOME Settings
Gnome settings are stored under [settings.txt](gnome/settings.txt). Each setting is separated into its parts via `|` character. All settings are set using the `gsettings` command. Edit as necessary.

## Inspiration
Some inspiration for these dotfiles was taken from:

* [Mathias Bynens](https://mathiasbynens.be/) and his dotfiles [repo](https://github.com/mathiasbynens/dotfiles)
