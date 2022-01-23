<a href="https://makc.co">
    <img src="https://makccr.github.io/images/github-header.svg" alt="MAKC lgoo" title="MAKC" align="right" height="50" />
</a>

# Dotfiles
These are my dot files. I've primarily been a [MacOS](https://apple.com/macos/) user for most of the time I've been collecting dotfiles, but I've recently switched to Linux. I primarily use [Arch](https://www.archlinux.org), but on occasion have been known to use [Arco](https://arcolinux.com/), [Manjaro](https://manjaro.org), or some other Arch based distro; but [Solus](https://getsol.us) is dope too, it just doesn't require much configuration. I also run Debian or Ubuntu on a few server type systems, so I also try to make sure my dotfiles work there as well (let me know if you have issues).

**The main things here are:**
1. My [Neovim](https://neovim.io/) configuration. 
2. My [Zsh](https://www.zsh.org/) configuration.
3. My window manager configuration.
4. My [Alacritty](https://github.com/alacritty/alacritty) configuration.
5. My [Polybar](https://polybar.github.io/) configuration.
6. My configs for [Ranger](https://github.com/ranger/ranger) & [Vifm](https://github.com/vifm/vifm).
7. Snippets for [Auto Hot Key](https://www.autohotkey.com/) & [Keyboard Maestro](https://www.keyboardmaestro.com/main/). 

I mainly use these apps: Vim & the Shell for standard writing; normally in the [Markdown](https://www.markdownguide.org/) or [Fountain](https://fountain.io/) format. I'm not a programmer, so I haven't customized these apps to make those kinds of tasks easier, the way that many users do.

## My Setup
Currently, my main system is Arch Linux running on a Ryzen 5 2600X (6-core) CPU & a GTX 1050Ti. I primarily use the [Awesome Window Manager](https://github.com/awesomeWM/awesome) as... well, the window manager; it's run, confoundedly, in tandem with [Polybar](https://github.com/polybar/polybar) to replace the standard wibar (I know it's dumb, but I don't want to hear it). I'm also a big fan of [DWM](https://dwm.suckless.org/) and [BSPWM](https://github.com/baskerville/bspwm). I use [Jonaburg's Picom Fork](https://github.com/jonaburg/picom) for transparency and whatnot, [Alacritty](https://github.com/alacritty/alacritty) as my main terminal ([kitty](https://github.com/kovidgoyal/kitty) or [st](https://st.suckless.org/) as a backup), and [Neovim](https://github.com/neovim/neovim) as my text editor. You can view all of my dotfiles here, or you can check out my [YouTube Channel](https://www.youtube.com/channel/UCWh6YtclgTAzReTASc4uSKw) for a more in-depth look at many of the configurations featured.

![Screenshot](images/desktop.jpg)
```sh

                   -`                    makc@vega-3
                  .o+`                   -----------
                 `ooo/                   OS: Arch Linux
                `+oooo:                  Kernel: Linux 5.16.1-arch1-1
               `+oooooo:                 Uptime: 3 days, 1 hour, 30 mins
               -+oooooo+:                Packages: 844 (pacman)
             `/:-:++oooo+:               Shell: zsh 5.8
            `/++++/+++++++:              Resolution: 1920x1080, 1920x1080
           `/++++++++++++++:             WM: awesome
          `/+++ooooooooooooo/`           Theme: Mojave-dark-solid [GTK3]
         ./ooosssso++osssssso+`          Icons: McMojave-circle-black-dark [GTK3]
        .oossssso-````/ossssss+`         Terminal: alacritty
       -osssssso.      :ssssssso.        Terminal Font: Hack Nerd Font Mono
      :osssssss/        osssso+++.       CPU: AMD Ryzen 5 2600X (6) @ 3.6GHz
     /ossssssss/        +ssssooo/-       GPU: NVIDIA GeForce GTX 1050 Ti
   `/ossssso+/:-        -:/+osssso+-     Memory: 4.74GiB / 31.28GiB (15%)
  `+sso+:-`                 `.-/+oso:
 `++:.                           `-/+/
 .`                                 `/
 ```
