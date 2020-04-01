![Header SVG](https://makccr.github.io/images/github-header.svg)

These are my dot files. I'm primarily a [MacOS](https://www.apple.com/macos/) user, but I occasionally use [Manjaro](https://manjaro.org/), or another Arch based Linux distribution; so that's where I take my cue. The main things here are: 

1. My [Vim](https://www.vim.org/) configuration. 
2. [Z-Shell](http://zsh.sourceforge.net/)
    * [Oh-my-zsh](https://ohmyz.sh/)
    * [Powerline 10k](https://github.com/romkatv/powerlevel10k) 
3. My [iTerm](https://www.iterm2.com/) configuration (MacOS)
4. My [Alacritty](https://github.com/alacritty/alacritty) configuration (Linux)
5. Snippets for [Auto Hot Key](https://www.autohotkey.com/) & [Keyboard Maestro](https://www.keyboardmaestro.com/main/). 
6. Miscellaneous other things, [BitBar Plug-ins](https://getbitbar.com/) and Apple Scripts. 

I mainly use these apps: Vim & the Shell for standard writing; normally in the [Markdown](https://www.markdownguide.org/) or [Fountain](https://fountain.io/) format. I'm not a programmer, so I haven't customized these apps to make those kinds of tasks easier, the way that many users do. 

I have also added configurations for [Atom](https://atom.io/), [hTop](https://hisham.hm/htop/), and a few other things. I also occasionally go through some pieces of these configurations on my [YouTube channel](https://www.youtube.com/c/makccr), most recently, my [.vimrc & .vim directory](https://www.youtube.com/watch?v=Igfm59WL3NE).

### Config Guide
Apps          | Path in Repository      
 ------------ | ----------------------- 
Alacritty     | [.config/alacritty/alacritty.yml](https://github.com/makccr/dot/blob/master/.config/alacritty/alacritty.yml)
Atom          | [.atom/](https://github.com/makccr/dot/tree/master/.atom)
Git           | [.gitconfig](https://github.com/makccr/dot/blob/master/.gitconfig) 
Htop          | [.config/htop/htoprc](https://github.com/makccr/dot/blob/master/.config/htop/htoprc)
iTerm         | [misc/macOS/terminals/com.googlecode.iterm2.plist](https://github.com/makccr/dot/blob/master/com.googlecode.iterm2.plist) & [/misc/macOS/terminals/gruvbox.iterm.json](https://github.com/makccr/dot/blob/master/gruvbox.iterm.json)
Neovim        | [.config/nvim/init.vim](https://github.com/makccr/dot/blob/master/.config/nvim/init.vim)
OhMyZsh       | [.zshrc](https://github.com/makccr/dot/blob/master/.zshrc)
Powerline 10K | [.p10k.zsh](https://github.com/makccr/dot/blob/master/.p10k.zsh) 
Vifm          | [.config/vifm/](https://github.com/makccr/dot/tree/master/.config/vifm)
Vim           | [.vim/](https://github.com/makccr/dot/blob/master/.vimrc) & [.vimrc](https://github.com/makccr/dot/tree/master/.vim)
zsh           | [.zshrc](https://github.com/makccr/dot/blob/master/.zshrc) & [.zprofile](https://github.com/makccr/dot/blob/master/.zprofile) 

Other Stuff        | Path in Repository      
 ----------------- | ----------------------- 
Alfred Preferences | [misc/alfred-worfklows/Alfred.alfredpreferences](https://github.com/makccr/dot/tree/master/misc/alfred-workflows/Alfred.alfredpreferences)
Alfred Work-flows  | [misc/alfred-workflows/](https://github.com/makccr/dot/tree/master/misc/alfred-workflows)
Apple Scripts      | [/misc/apple-scripts/](https://github.com/makccr/dot/tree/master/misc/apple-scripts)
Apple Terminal     | [misc/macOS/terminals/Gruvbox.terminal](https://github.com/makccr/dot/blob/master/misc/macOS/terminals/Gruvbox.terminal)
Auto Hot Key       | [misc/snippets/ahk/ahk.ahk](https://github.com/makccr/dot/blob/master/misc/snippets/ahk/ahk.ahk)
Bash Scripts       | [.bin/](https://github.com/makccr/dot/tree/master/.bin)
Bitbar Plug-ins    | [/misc/bitbar](https://github.com/makccr/dot/tree/master/misc/bitbar)
Fortune Database   | [quotes.dat](https://github.com/makccr/dot/blob/master/quotes)
Keyboard Maestro   | [/misc/snippets/keyboardMaestro.kmsync](https://github.com/makccr/dot/blob/master/misc/snippets/keyboardMaestro.kmsync)
Screen-savers      | [misc/macOS/screensavers/](https://github.com/makccr/dot/tree/master/misc/macOS/screensavers)

###### My Default Shell (It's usually running in Alacritty these days, you can't beat that GPU acceleration) 
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/profile.jpg)

```bash
#neofetch #Running a customized neofetch 
#covid #A script I built to keep my updated on COVID-19 effects
#echo ' ' #I keep most lines commented out, and uncomment when I want to see more
#transmission-remote -l #The command to display any currently downloading torrents
#echo ' ' #blank lines
fortune ~/repo/dot/quotes #Displaying a quote for me look at 
```

###### My Vim configuration (I've been using [Neovim](https://github.com/neovim/neovim), but I still just link to the original .vimrc).
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/vim.jpg)

###### My file browser. I use [VIFM](https://github.com/vifm/vifm), and highly recommend it for Vim or Neovim users because it just carries over most of the command we're already used to using. 
![Screenshot](https://raw.githubusercontent.com/makccr/dotProfiles/master/images/vifm.jpg)
