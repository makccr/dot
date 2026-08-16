<a href="https://makc.co">
    <img src="https://makc.co/images/github-header.svg" alt="MAKC lgoo" title="MAKC" align="right" height="50" />
</a>

# Dotfiles
These are my dot files. I primarily use [Arch](https://www.archlinux.org), or, if I'm feeling lazy some flavor of Arch like [Manjaro](https://manjaro.org) or [Cachy OS](https://cachyos.org/)_(Cachy OS is pictured below)_. But I do also run [Ubuntu LTS](https://ubuntu.com/) andior [Fedora Workstation](https://fedoraproject.org/workstation/) from time to time, so I also try to make sure my dotfiles work there as well. The same thing is also true of [FreeBSD](https://www.freebsd.org/), which I also have been known to daily drive for brief periods, but in no way do I put a ton of effort into ensuring my configs work there as well. My primary use case is writing, some light web design and the general scripting and hacking that comes with using Window Managers and light-weight systems, so I do tend to keep things as minimal and performant as possible.

**Note**: *There are some [OSX](https://www.apple.com/os/macos/) and [Windows](https://support.microsoft.com/en-us/welcometowindows) specific configs here as as well, but I use something other than Linux or BSD about once a year when I absolutely have to. These configs, only get updated on the rare occasion that I happen to use them, and find an issue that needs to be fixed.*

**The main things here are:**
1. My [Neovim](https://neovim.io/) configuration. 
2. My [Zsh](https://www.zsh.org/) configuration.
3. My window manager configuration, primarily [Hyprland](https://hypr.land/) these days; but I have used [BSPWM](https://github.com/baskerville/bspwm), [DWM](https://dwm.suckless.org/) and [Awesome WM](https://awesomewm.org/) extensively in the past, and those configurations are also contained here.
4. My [Alacritty](https://github.com/alacritty/alacritty) configuration, as well as a few back up terminals. 
5. My status bar configuration. With the switch to [Wayalnd](https://wayland.freedesktop.org/), my status bar of choice has become [Waybar](https://github.com/Alexays/Waybar), but I also have an extensive amount of [Polybar](https://polybar.github.io/) configuration available in these files as well.

![Screenshot](images/desktop.jpg)
![Screenshot](images/desktop-b.jpg)

### Usage 
Typically I use a `git clone` to pull down my dot files into the `~/Documents` folder, or some other convenient location and then use symbolic links to have things end up in the right place: 

#### Step by step guide
1. Change directory into a convenient location
```bash
cd ~/Documents
```
2. Clone the repo
```bash
git clone --depth 1 https://codeberg.org/makccr/dot
```
3. Move back into home directory
```bash
cd 
```
4. Set up symbolic links 
```bash
ln -sf ~/Documents/dot/.config .
ln -sf ~/Documents/dot/.scripts .
ln -sf ~/Documents/dot/.gitconfig .
ln -sf ~/Documents/dot/.zshenv .
ln -sf ~/Documents/dot/.tmux.conf .
ln -sf ~/Documents/dot/.Xresources .
ln -sf ~/Documents/dot/.xbindkeysrc .
```
**Note**: I've also built a script to automate this process. `setup.sh` can be founnd in the `.scripts` folder & makes the symbolic link process take about 0.36 seconds: 
```bash
./~/Documents/.scripts/setup.sh
```
