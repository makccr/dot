![Header SVG](https://makccr.github.io/images/github-header.svg)

These are my dot files. I'm primarily a [MacOS](https://www.apple.com/macos/) user, but I occasionally use [Manjaro](https://manjaro.org/), or another Arch based Linux distribution; so that's where I take my cue. The main things here are: 

1. My [Neovim](https://neovim.io/) configuration. 
2. [My Bash](https://www.gnu.org/software/bash/) configuration.
3. My [Alacritty](https://github.com/alacritty/alacritty) configuration.
4. My [Qutebroswer](https://qutebrowser.org/) configuration.
5. Snippets for [Auto Hot Key](https://www.autohotkey.com/) & [Keyboard Maestro](https://www.keyboardmaestro.com/main/). 
6. Miscellaneous other things: [BitBar Plug-ins](https://getbitbar.com/) and Apple Scripts. 

I mainly use these apps: Vim & the Shell for standard writing; normally in the [Markdown](https://www.markdownguide.org/) or [Fountain](https://fountain.io/) format. I'm not a programmer, so I haven't customized these apps to make those kinds of tasks easier, the way that many users do. 

### Config Guide
App Configs| Other stuff
 :-- | :---------- 
[Alacritty](https://github.com/makccr/dot/blob/master/.config/alacritty/alacritty.yml) | [Alfred Preferences](https://github.com/makccr/dot/tree/master/misc/alfred-workflows/Alfred.alfredpreferences) & [Alfred Work-flows](https://github.com/makccr/dot/tree/master/misc/alfred-workflows) 
[Bash Settings](https://github.com/makccr/dot/tree/master/.bashrc) | [Apple Scripts](https://github.com/makccr/dot/tree/master/misc/apple-scripts) 
[Bash Scripts](https://github.com/makccr/dot/tree/master/.bin) | [Auto Hot Key](https://github.com/makccr/dot/blob/master/misc/snippets/ahk/ahk.ahk) 
[Git](https://github.com/makccr/dot/blob/master/.gitconfig) | [Bitbar Plug-ins](https://github.com/makccr/dot/tree/master/misc/bitbar) 
[Htop](https://github.com/makccr/dot/blob/master/.config/htop/htoprc) | [Fortune Database](https://github.com/makccr/dot/blob/master/quotes) 
[Neovim](https://github.com/makccr/dot/blob/master/.config/nvim/init.vim) | [Keyboard Maestro](https://github.com/makccr/dot/blob/master/misc/snippets/keyboardMaestro.kmsync) 
[Profile](https://github.com/makccr/dot/tree/master/.profile) | [Screen-savers](https://github.com/makccr/dot/tree/master/misc/macOS/screensavers) 
[Qutebroswer](https://github.com/makccr/dot/tree/master/.qutebrowser) |  
 [Tmux](https://github.com/makccr/dot/tree/master/.tmux.conf) |  
 [Vifm](https://github.com/makccr/dot/tree/master/.config/vifm) | 

###### My Shell (Yes it is running tmux in the screenshot, I just hate the statusbar)
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/profile.jpg)

```bash
#Profile settings                               #Bash prompt settings
if [ -f ~/.bashrc ]; then                       PS1="\e[0;34m";
    . ~/.bashrc                                 PS1+="\W ";
fi                                              PS1+="\e[0;32m";
                                                PS1+="> ";
#neofetch                                       PS1+="\e[0m";
#transmission-remote -l                         export PS1;
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
