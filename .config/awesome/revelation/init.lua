-- revelation.lua
--
-- Library that implements Expose like behavior.
--
-- @author Perry Hargrave resixian@gmail.com
-- @author Espen Wiborg espenhw@grumblesmurf.org
-- @author Julien Danjou julien@danjou.info
-- @auther Quan Guo guotsuan@gmail.com
--
-- @copyright 2008 Espen Wiborg, Julien Danjou
-- @copyright 2015 Quan Guo
--


local beautiful    = require("beautiful")
local wibox        = require("wibox")
local awful        = require('awful')
local aw_rules     = require('awful.rules')
local pairs        = pairs
local setmetatable = setmetatable
local naughty      = require("naughty")
local table        = table
local clock        = os.clock
local tostring     = tostring
local capi         = {
    awesome        = awesome,
    tag            = tag,
    client         = client,
    keygrabber     = keygrabber,
    mousegrabber   = mousegrabber,
    mouse          = mouse,
    screen         = screen
}

-- disable for now. 
-- It seems there is not way to pass err handling function into the delayed_call()

local function debuginfo(message)
    message = message or "No information available"
    nid = naughty.notify({ text = tostring(message), timeout = 10 })
end

local delayed_call = (type(timer) ~= 'table' and  require("gears.timer").delayed_call)

local view_only_func
local toggle_tag_func
local jump_to_func


if type(awful.client.object) == 'table' then
    view_only_func = function (tag) tag:view_only() end
    toggle_tag_func = function (t, c) c:toggle_tag(t) end
    jump_to_func = function(c) c:jump_to() end
else
    view_only_func = function (tag) awful.tag.viewonly(tag) end
    toggle_tag_func = function (t, c) awful.client.toggletag(t, c) end
    jump_to_func = function(c) awful.client.jumpto(c) end
end


local hintbox = {} -- Table of letter wiboxes with characters as the keys
local hintindex = {} -- Table of visible clients with the hint letter as the keys

local clients = {} --Table of clients to be exposed after fitlering
local clientData = {} -- table that holds the positions and sizes of floating clients

local revelation = {
    -- Name of expose tag.
    tag_name = "Revelation",

    charorder = "jkluiopyhnmfdsatgvcewqzx1234567890",

    -- Match function can be defined by user.
    -- Must accept a `rule` and `client` and return `boolean`.
    -- The rule forms follow `awful.rules` syntax except we also check the
    -- special `rule.any` key. If its true, then we use the `match.any` function
    -- for comparison.
    match = {
        exact = aw_rules.match,
        any   = aw_rules.match_any
    },
    property_to_watch={
        maximized            = false,
        minimized            = false,
        fullscreen           = false,
        maximized_horizontal = false,
        maximized_vertical   = false,
        sticky               = false,
        ontop                = false,
        above                = false,
        below                = false,
    },
    tags_status = {},
    is_excluded = false,
    curr_tag_only = false,
    font = beautiful.revelation_font or "monospace 20",
    fg = beautiful.revelation_fg_normal or beautiful.fg_normal or "#DCDCCC",
    bg = beautiful.revelation_bg_normal or beautiful.bg_normal or "#000000",
    border_color = beautiful.revelation_border_color or beautiful.border_focus or "#DCDCCC",
    border_width = beautiful.revelation_border_width or beautiful.border_width or 2,
    hintsize = (type(beautiful.xresources) == 'table' and beautiful.xresources.apply_dpi(beautiful.revelation_hintsize or 50) or 60)
}



-- Executed when user selects a client from expose view.
--
-- @param restore Function to reset the current tags view.
local function selectfn(_, t, zt)
    return function(c)
        revelation.restore(t, zt)
        -- Focus and raise
        --
        if type(delayed_call) == 'function' then
            capi.awesome.emit_signal("refresh")
        end

        if awful.util.table.hasitem(hintindex, c) then
            if c.minimized then
                c.minimized = false
            end

            jump_to_func(c)
        end
    end
end

-- Tags all matching clients with tag t
-- @param rule The rule. Conforms to awful.rules syntax.
-- @param clients A table of clients to check.
-- @param t The tag to give matching clients.
local function match_clients(rule, _clients, t, is_excluded)

    local mfc = rule.any and revelation.match.any or revelation.match.exact
    local mf = is_excluded and function(c,_rule) return not mfc(c,_rule) end or mfc
    local flt

    for _, c in pairs(_clients) do
        if mf(c, rule) then
            -- Store geometry before setting their tags
            clientData[c] = {}
            clientData[c]["geometry"] = c:geometry()
            flt = awful.client.property.get(c, "floating")
            if flt ~= nil then
                clientData[c]["floating"] = flt
                awful.client.property.set(c, "floating", false)
            end


            for k,v in pairs(revelation.property_to_watch) do
                clientData[c][k] = c[k]
                c[k] = v

            end
            toggle_tag_func(t, c)
            if c:isvisible() then 
                table.insert(clients, c)
            end
        end
    end

end


-- Implement Exposé (ala Mac OS X).
--
-- @param rule A table with key and value to match. [{class=""}]
function revelation.expose(args)
    args = args or {}
    local rule = args.rule or {}
    local is_excluded = args.is_excluded or revelation.is_excluded
    local curr_tag_only = args.curr_tag_only or revelation.curr_tag_only

    local t={}
    local zt={}

    clients = {}
    clientData = {}

    for scr=1,capi.screen.count() do
        t[scr] = awful.tag.new({revelation.tag_name},
            scr, awful.layout.suit.fair)[1]
        zt[scr] = awful.tag.new({revelation.tag_name.."_zoom"},
            scr, awful.layout.suit.fair)[1]

        if curr_tag_only then
            match_clients(rule, awful.client.visible(scr), t[scr], is_excluded)
        else
            match_clients(rule, capi.client.get(scr), t[scr], is_excluded)
        end

        view_only_func(t[scr])
    end

    if type(delayed_call) == 'function' then
        capi.awesome.emit_signal("refresh")
    end
    -- No need for awesome WM 3.5.6: capi.awesome.emit_signal("refresh")
    --
    local status, err=pcall(revelation.expose_callback, t, zt, clients) 

    --revelation.expose_callback(t, zt)
    if not status then
        debuginfo('Oops!, something is wrong in revelation.expose_callback!')

        if err.msg then 
            debuginfo(err.msg) 
        end

        if err.code then 
            debuginfo('error code is '.. tostring(err.code)) 
        end

        revelation.restore(t, zt)

    end
end


function revelation.restore(t, zt)
    for scr=1, capi.screen.count() do
        awful.tag.history.restore(scr)
        t[scr].screen = nil
    end

    capi.keygrabber.stop()
    capi.mousegrabber.stop()
    
     for _, c in pairs(clients) do
            if clientData[c] then
                for k,v in pairs(clientData[c]) do
                    if v ~= nil then
                        if k== "geometry" then
                            c:geometry(v)
                        elseif k == "floating" then
                            awful.client.property.set(c, "floating", v)
                        else
                            c[k]=v
                        end
                    end
                end
            end
      end
    
    for scr=1, capi.screen.count() do
        t[scr].activated = false
        zt[scr].activated = false
    end

    for i,j in pairs(hintindex) do
        hintbox[i].visible = false
    end
end

local function hintbox_display_toggle(c, show)
    for char, thisclient in pairs(hintindex) do
        if char and char ~= c then
            hintindex[char] = thisclient
            if show then
                hintbox[char].visible = true
            else
                hintbox[char].visible = false
            end

        end
    end
end

local function hintbox_pos(char)
    local client = hintindex[char]
    local geom = client:geometry()
    hintbox[char].x = math.floor(geom.x + geom.width/2 - revelation.hintsize/2)
    hintbox[char].y = math.floor(geom.y + geom.height/2 - revelation.hintsize/2)
end


function revelation.expose_callback(t, zt, clientlist)

    hintindex = {}
    for i,thisclient in pairs(clientlist) do
        -- Move wiboxes to center of visible windows and populate hintindex
        local char = revelation.charorder:sub(i,i)
        if char and char ~= '' then
            hintindex[char] = thisclient
            hintbox_pos(char)
            hintbox[char].visible = true
            hintbox[char].screen = thisclient.screen
        end
    end

    local zoomed = false
    local zoomedClient = nil
    local key_char_zoomed = nil

    capi.keygrabber.run(function (mod, key, event) 
        local c
        if event == "release" then return true end

        if awful.util.table.hasitem(mod, "Shift") then
            key_char = string.lower(key)
            c = hintindex[key_char]
            if not zoomed and c ~= nil then
                --debuginfo(c.screen)
                view_only_func(zt[c.screen.index or c.screen])
                toggle_tag_func(zt[c.screen.index or c.screen], c)
                zoomedClient = c
                key_char_zoomed = key_char
                zoomed = true
                -- update the position of this hintbox, since it is zoomed
                if type(delayed_call) == 'function' then 
                    capi.awesome.emit_signal("refresh")
                end
                hintbox_pos(key_char)
                hintbox_display_toggle(key_char, false)


            elseif zoomedClient ~= nil then
                awful.tag.history.restore(zoomedClient.screen.index or zoomedClient.screen)
                toggle_tag_func(zt[zoomedClient.screen.index or zoomedClient.screen], zoomedClient)
                hintbox_display_toggle(key_char_zoomed,  true)
                if type(delayed_call) == 'function' then 
                    capi.awesome.emit_signal("refresh")
                end
                hintbox_pos(key_char_zoomed) 

                zoomedClient = nil
                zoomed = false
                key_char_zoomed = nil
            end
        end

        if hintindex[key] then
            --client.focus = hintindex[key]
            --hintindex[key]:raise()

            selectfn(restore,t, zt)(hintindex[key])

            for i,j in pairs(hintindex) do
                hintbox[i].visible = false
            end

            return false
        end

        if key == "Escape" then
            if zoomedClient ~= nil then 
                awful.tag.history.restore(zoomedClient.screen)
                toggle_tag_func(zt[zoomedClient.screen.index or zoomedClient.screen], zoomedClient)
                hintbox_display_toggle(string.lower(key),  true)
                if type(delayed_call) == 'function' then 
                    capi.awesome.emit_signal("refresh")
                end
                hintbox_pos(key_char_zoomed) 

                zoomedClient = nil
                zoomed = false
            else
                for i,j in pairs(hintindex) do
                    hintbox[i].visible = false
                end
                revelation.restore(t, zt)
                return false
            end
        end

        return true
    end) 

    local pressedMiddle = false

    local lastClient = nil
    capi.mousegrabber.run(function(mouse)
        local c

        if type(awful.client.object) == 'table' then
            c = capi.mouse.current_client
        else
            c = awful.mouse.client_under_pointer()
        end
        if c then
          lastClient = c
        else
          local current_wibox = capi.mouse.current_wibox
          if current_wibox then
            for i = 1, #revelation.charorder do
              local char = revelation.charorder:sub(i,i)
              if hintbox[char] == current_wibox then
                c = lastClient
                break
              end
            end
          end
        end
        local key_char = awful.util.table.hasitem(hintindex, c) 
        if mouse.buttons[1] == true then
            if c ~= nil then
                selectfn(restore, t, zt)(c)

                for i,j in pairs(hintindex) do
                    hintbox[i].visible = false
                end
                return false
            else
                return true
            end
        elseif mouse.buttons[2] == true and pressedMiddle == false and c ~= nil then
            -- is true whenever the button is down.
            pressedMiddle = true
            -- extra variable needed to prevent script from spam-closing windows
            --
            if zoomed == true and zoomedClient ~=nil then 
                awful.tag.history.restore(zoomedClient.screen.index or zoomedClient.screen)
                toggle_tag_func(zt[zoomedClient.screen.index or zoomedClient.screen], zoomedClient)
            end
            c:kill()
            hintbox[key_char].visible = false
            hintindex[key_char] = nil
            local pos = awful.util.table.hasitem(clients, c)
            table.remove(clients, pos)


            if zoomed == true and zoomedClient ~=nil then 
                hintbox_display_toggle(key_char_zoomed, true)
                zoomedClient = nil
                zoomed = false
                key_char_zoomed = nil
            end
            
            return true

        elseif mouse.buttons[2] == false and pressedMiddle == true then
            pressedMiddle = false
            for key, _ in pairs(hintindex) do
                hintbox_pos(key) 
            end
        elseif mouse.buttons[3] == true then
            if not zoomed and c ~= nil then
                view_only_func(zt[c.screen.index or c.screen])
                toggle_tag_func(zt[c.screen.index or c.screen], c)
                if key_char ~= nil then 
                    hintbox_display_toggle(key_char, false)
                    if type(delayed_call) == 'function' then 
                        capi.awesome.emit_signal("refresh")
                    end
                    hintbox_pos(key_char) 
                end
                zoomedClient = c
                zoomed = true
                key_char_zoomed = key_char
            elseif zoomedClient ~= nil then
                awful.tag.history.restore(zoomedClient.screen.index or zoomedClient.screen)
                toggle_tag_func(zt[zoomedClient.screen.index or zoomedClient.screen], zoomedClient)
                hintbox_display_toggle(key_char_zoomed, true)
                if type(delayed_call) == 'function' then 
                    capi.awesome.emit_signal("refresh")
                end
                hintbox_pos(key_char_zoomed) 

                zoomedClient = nil
                zoomed = false
                key_char_zoomed = nil
            end
        end

        return true
        --Strange but on my machine only fleur worked as a string.
        --stole it from
        --https://github.com/Elv13/awesome-configs/blob/master/widgets/layout/desktopLayout.lua#L175
    end,"fleur")

end

-- Create the wiboxes, but don't show them
--
function revelation.init(args)
    local letterbox = {}

    args = args or {}

    revelation.tag_name = args.tag_name or revelation.tag_name
    if args.match then
        revelation.match.exact = args.match.exact or revelation.match.exact
        revelation.match.any = args.match.any or revelation.match.any
    end

    revelation.charorder = args.charorder or revelation.charorder

    for i = 1, #revelation.charorder do
        local char = revelation.charorder:sub(i,i)
        hintbox[char] = wibox({
          fg=revelation.fg,
          bg=revelation.bg,
          border_color=revelation.border_color,
          border_width=revelation.border_width
        })
        hintbox[char].ontop = true
        hintbox[char].width = revelation.hintsize
        hintbox[char].height = revelation.hintsize
        letterbox[char] = wibox.widget.textbox()
        letterbox[char]:set_markup(char.upper(char))
        letterbox[char]:set_font(revelation.font)
        letterbox[char]:set_align("center")
        hintbox[char]:set_widget(letterbox[char])
    end
end

setmetatable(revelation, { __call = function(_, ...) return revelation.expose(...) end })

return revelation
