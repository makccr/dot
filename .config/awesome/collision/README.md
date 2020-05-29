Collision window navigation module for AwesomeWM
================================================

**Warning:** The master branch is for Awesome 4.0+, use the `awesome3.5`
branch for older versions of Awesome.

This module add some visual indicators for common window management operations.
It is now easier to know the impact of a given command as a visual queue will
be printed on the screen. Collision has 3 modes:

* **Focus**: Move the focus from client to client
* **Move**: Move a client
* **Resize**: Change a client dimensions
* **Tag**: Move to the previous/next tag

# Installation

First, clone the repository

```lua
    mkdir -p ~/.config/awesome
    cd ~/.config/awesome
    git clone https://github.com/Elv13/collision
```

Now, open ~/.config/awesome/rc.lua (or copy /etc/xdg/awesome/rc.lua to 
~/.config/awesome/rc.lua fist if you never modified your Awesome config before)
 and add this line somewhere in your `rc.lua`:

```lua
    require("collision")()
```

It is a very good idea to also change the default <kbd>Mod4</kbd>+<kbd>arrow</kbd> shortcut to
something else:

```lua
    --Remove those lines:
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
     {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
     {description = "view next", group = "tag"}),
```

Your done!

# Usage

Using Collision is easy. You just have to hit the arrow keys (<kbd>➡</kbd> <kbd>⬆</kbd> <kbd>⬇</kbd> <kbd>⬅</kbd>)
with some modifiers keys. The <kbd>Shift</kbd> key is usually used for grabbing something
while the <kbd>Control</kbd> key is used to max out the effect.

| Modifier 1         | Modifier 2            | Modifier 3            | Effect                                                  |
| :----------:       | :----------:          | :----------:          | ------------------------------------------------------- |
| <kbd>Mod4</kbd>    |                       |                       | Move the focus on the tiled layer                       |
| <kbd>Mod4</kbd>    |                       | <kbd>Control</kbd>    | Move the focus on the floating layer                    |
| <kbd>Mod4</kbd>    | <kbd>Shift</kbd>      |                       | Move a client in the tiled or floating layer            |
| <kbd>Mod4</kbd>    | <kbd>Shift</kbd>      | <kbd>Control</kbd>    | Move a floating client to the far side of that screen   |
| <kbd>Mod4</kbd>    | <kbd>Mod1 (Alt)</kbd> |                       | Increase a floating client size                         |
| <kbd>Mod4</kbd>    | <kbd>Mod1 (Alt)</kbd> | <kbd>Shift</kbd>      | Reduce a floating client size                           |
| <kbd>Control</kbd> | <kbd>Mod1 (Alt)</kbd> |                       | Move to the next/previous tag                           |
| <kbd>Control</kbd> | <kbd>Mod4</kbd>       | <kbd>Mod1 (Alt)</kbd> | Move to the next/previous screen                        |
| <kbd>Control</kbd> | <kbd>Mod4</kbd>       | <kbd>Mod1 (Alt)</kbd> | + <kbd>Shift</kbd> Move tag to the next/previous screen |

# Using different keys

Due to the large ammount of keyboard shortcut Collision create, they are
auto-generated automatically. While this make installation simpler, it also
make Collision somewhat hard-coded magic. Some alternative keymaps can also
be ackward to use because of the reliance on mod keys such as <kbd>Alt</kbd> and <kbd>Control</kbd>.

That being said, Collision allow some basic remapping. Instead of:

```lua
    require("collision")()
```

This can be used:

```lua
    require("collision") {
        --        Normal    Xephyr       Vim      G510
        up    = { "Up"    , "&"        , "k"   , "F15" },
        down  = { "Down"  , "KP_Enter" , "j"   , "F14" },
        left  = { "Left"  , "#"        , "h"   , "F13" },
        right = { "Right" , "\""       , "l"   , "F17" },
    }
```

Of course, if the `Vim` keys are used, any other shortcut binded to them have to
be removed from rc.lua.

# Appearance

Collision appearance can be changed in yout theme using the `collision`
namespace

## Focus

| Variable                      | Description                                            |
| :---------------------------: | ------------------------------------------------------ |
| collision_bg_focus            | The background of the focus change arrow               |
| collision_fg_focus            | The foregroung filling color of the arrow              |
| collision_bg_center           | The focussed client circle background                  |
| collision_resize_width        | The size of the resize handles                         |
| collision_resize_shape        | The gears.shape used for the resize handle             |
| collision_resize_border_width | The resize handles border width                        |
| collision_resize_border_color | The resize handles border colors                       |
| collision_resize_padding      | The resize handles padding between the boder and arrow |
| collision_resize_bg           | The resize handles background color                    |
| collision_resize_fg           | The resize handles arrow color                         |
| collision_focus_shape         |                                                        |
| collision_focus_border_width  |                                                        |
| collision_focus_border_color  |                                                        |
| collision_focus_padding       |                                                        |
| collision_focus_bg            |                                                        |
| collision_focus_fg            |                                                        |
| collision_focus_bg_center     |                                                        |
| collision_screen_shape        |                                                        |
| collision_screen_border_width |                                                        |
| collision_screen_border_color |                                                        |
| collision_screen_padding      |                                                        |
| collision_screen_bg           |                                                        |
| collision_screen_fg           |                                                        |
| collision_screen_bg_focus     |                                                        |
| collision_screen_fg_focus     |                                                        |

# Settings

```lua
-- Swap clients across screen instead of adding them to the other tag
collision.settings.swap_across_screen = true
```

# Other

The `collision.select_screen(idx)` function allow to select a screen and can be
assigned to shortcuts.

The `collision.highlight_cursor(timeout)` method will highlight the current mouse
cursor position.

Use `collision.mouse.highlight()` and `collision.mouse.hide()`

# Notes

Using the focus arrows to select empty screens only work in Awesome 3.5.7+
