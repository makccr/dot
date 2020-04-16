![Header SVG](https://makccr.github.io/images/github-header.svg)

These are my dot files. I'm primarily a [MacOS](https://www.apple.com/macos/) user, but I occasionally use [Manjaro](https://manjaro.org/), or another Arch based Linux distribution; so that's where I take my cue. The main things here are: 

1. My [Neovim](https://neovim.io/) configuration. 
2. [My Bash](https://www.gnu.org/software/bash/) configuration.
3. My [Alacritty](https://github.com/alacritty/alacritty) configuration.
4. My [Qutebroswer](https://qutebrowser.org/) configuration.
5. Snippets for [Auto Hot Key](https://www.autohotkey.com/) & [Keyboard Maestro](https://www.keyboardmaestro.com/main/). 
6. Miscellaneous other things: [BitBar Plug-ins](https://getbitbar.com/) and Apple Scripts. 

I mainly use these apps: Vim & the Shell for standard writing; normally in the [Markdown](https://www.markdownguide.org/) or [Fountain](https://fountain.io/) format. I'm not a programmer, so I haven't customized these apps to make those kinds of tasks easier, the way that many users do. 

I have also added configurations for [Atom](https://atom.io/), [hTop](https://hisham.hm/htop/), and a few other things. I also occasionally go through some pieces of these configurations on my [YouTube channel](https://www.youtube.com/c/makccr), most recently, my [.vimrc & .vim directory](https://www.youtube.com/watch?v=Igfm59WL3NE).

### Config Guide
Apps | Other stuff
 :-- | :---------- 
[Alacritty](https://github.com/makccr/dot/blob/master/.config/alacritty/alacritty.yml) | [Alfred Preferences](https://github.com/makccr/dot/tree/master/misc/alfred-workflows/Alfred.alfredpreferences)
[Bash Settings](https://github.com/makccr/dot/tree/master/.bashrc) | [Alfred Work-flows](https://github.com/makccr/dot/tree/master/misc/alfred-workflows)
[Bash Scripts](https://github.com/makccr/dot/tree/master/.bin) | [Apple Scripts](https://github.com/makccr/dot/tree/master/misc/apple-scripts)
[Git](https://github.com/makccr/dot/blob/master/.gitconfig) | [Apple Terminal](https://github.com/makccr/dot/blob/master/misc/macOS/terminals/Gruvbox.terminal)
[Htop](https://github.com/makccr/dot/blob/master/.config/htop/htoprc) | [Auto Hot Key](https://github.com/makccr/dot/blob/master/misc/snippets/ahk/ahk.ahk)
[Neovim](https://github.com/makccr/dot/blob/master/.config/nvim/init.vim) | [Bitbar Plug-ins](https://github.com/makccr/dot/tree/master/misc/bitbar)
[Profile](https://github.com/makccr/dot/tree/master/.profile) | [Fortune Database](https://github.com/makccr/dot/blob/master/quotes)
[Qutebroswer](https://github.com/makccr/dot/tree/master/.qutebrowser) | [Keyboard Maestro](https://github.com/makccr/dot/blob/master/misc/snippets/keyboardMaestro.kmsync)
 [Vifm](https://github.com/makccr/dot/tree/master/.config/vifm) | [Screen-savers](https://github.com/makccr/dot/tree/master/misc/macOS/screensavers)

###### My Shell
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/profile.jpg)

```bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

#neofetch
#transmission-remote -l
#echo ' '
fortune ~/repo/dot/quotes
#echo ' '
#cat ~/Dropbox/writing/notes/To-do.md
#echo ' '
#covid
```
**My [nvim](https://github.com/neovim/neovim) Configuration.** | **My [vifm](https://github.com/vifm/vifm) Configuration.**
---------- | -------------------
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/vim.jpg) | ![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/vifm.jpg)
