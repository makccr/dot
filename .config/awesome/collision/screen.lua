local capi = {screen=screen,client=client,mouse=mouse, keygrabber = keygrabber}
local math = math
local wibox        = require( "wibox"           )
local awful        = require( "awful"           )
local beautiful    = require( "beautiful"       )
local surface      = require( "gears.surface"   )
local pango        = require( "lgi"             ).Pango
local pangocairo   = require( "lgi"             ).PangoCairo
local mouse        = require( "collision.mouse" )
local util         = require( "collision.util"  )
local shape        = require( "gears.shape"     )
local scale        = pango.SCALE

local module = {}

local wiboxes = {}
local wiboxes_s = setmetatable({},{__mode="k"})
local bgs = {}
local size  = 75
local pss   = capi.mouse.screen

-- Keep an index of the last selection client for each screen
local last_clients = setmetatable({},{__mode="kv"})
local last_clients_coords = {}

local screens,screens_inv = util.get_ordered_screens()

local function current_screen(focus)
  return (not focus) and capi.mouse.screen or (capi.client.focus and capi.client.focus.screen or capi.mouse.screen)
end

local function fit(self,_,width,height)
    -- Compute the optimal font size
    local padding   = self._private.padding or 10
    local tm        = self._private.top_margin or 0
    height          = math.max(0, height - tm)
    local min       = math.min(width, height)
    local font_size = math.max(0, min - 2*padding)

    self._private.desc:set_size( font_size * scale )
    self._private.layout:set_font_description(self._private.desc)

    local _, geo = self._private.layout:get_pixel_extents()

    -- The extra "min" is in case a font "lie" and is too big.
    return math.min(geo.x+geo.width, min), math.min(geo.y+geo.height, min) + tm
end

local function draw(self, _, cr, width, height)
    -- Some layouts never call fit()...
    fit(self, context, width, height)

    local _, geo = self._private.layout:get_pixel_extents()
    local tm     = self._private.top_margin or 0
    local sz     = math.min(width, height - tm)

    -- Translate the canvas to center the text
    local dy = ( sz - geo.height  )/2 - geo.y + tm
    local dx = ( sz - geo.width   )/2 - geo.x
    cr:move_to(dx, dy)

    -- Show the text
    cr:show_layout(self._private.layout)
end

local function set_screen(self, s)
    self._private.layout.text = tostring(s.index)
    self:emit_signal("widget::layout_changed")
end

local function set_padding(self, padding)
    self._private.padding = padding
    self:emit_signal("widget::layout_changed")
end

local function set_top_margin(margin)
    self._private.top_margin = margin or 0
    self:emit_signal("widget::layout_changed")
end

local function new_constrained_text(s)
    local wdg = wibox.widget.base.empty_widget()

    -- Add the basic functions
    rawset(wdg, "draw"           , draw           )
    rawset(wdg, "fit"            , fit            )
    rawset(wdg, "set_screen"     , set_screen     )
    rawset(wdg, "set_padding"    , set_padding    )
    rawset(wdg, "set_top_margin" , set_top_margin )

    -- Create the pango objects
    local pango_crx = pangocairo.font_map_get_default():create_context()
    local pango_l   = pango.Layout.new(pango_crx)
    local desc      = pango.FontDescription()
    desc:set_family( "Verdana"         )
    desc:set_weight( pango.Weight.BOLD )

    wdg._private.layout = pango_l
    wdg._private.desc   = desc
    wdg:emit_signal("widget::layout_changed")

    if s then set_screen(wdg, s) end

    return wdg
end

local function create_wibox(s)
    s = capi.screen[s]

    if wiboxes_s[s] then return wiboxes_s[s] end

    local wa = s.workarea

    -- Create a round wibox
    local w = wibox {
        width  = size,
        height = size,
        x      = math.floor(wa.x+wa.width /2-size/2),
        y      = math.floor(wa.y+wa.height/2-size/2),
        ontop  = true
    }

    -- Theme options
    local sh       = beautiful.collision_screen_shape or shape.circle
    local bw       = beautiful.collision_screen_border_width
    local bc       = beautiful.collision_screen_border_color
    local padding  = beautiful.collision_screen_padding or 10
    local bg       = beautiful.collision_screen_bg or beautiful.bg_alternate or "#ff0000"
    local fg       = beautiful.collision_screen_fg or beautiful.fg_normal    or "#0000ff"
    local bg_focus = beautiful.collision_screen_bg_focus or beautiful.bg_urgent or "#ff0000"
    local fg_focus = beautiful.collision_screen_fg_focus or beautiful.fg_urgent or "#ff0000"

    -- Setup the widgets
    w:setup {
        {
            nil,
            {
                nil,
                {
                    screen  = s,
                    padding = padding,
                    widget  = new_constrained_text
                },
                nil,
                layout = wibox.layout.align.vertical
            },
            nil,
            layout = wibox.layout.align.horizontal
        },
        bg                 = bg,
        shape              = sh or shape.circle,
        shape_border_width = bw,
        shape_border_color = bc,
        id                 = "main_background",
        widget             = wibox.container.background
    }

    -- Set the wibox shape
    surface.apply_shape_bounding(w, sh)

    wiboxes_s[s] = w
    wiboxes[s.index] = w --DEPRECATED
    bgs[s] = w:get_children_by_id("main_background")[1]

    return w
end

-- Hopefully, the wiboxes will be gargabe collected
local init = false
local function init_wiboxes()
    if init then return end

    awful.screen.connect_for_each_screen(function(s)
        create_wibox(s)
    end)

    init = true

    return true
end

local function select_screen(scr_index,move,old_screen)
  if capi.screen[scr_index] ~= capi.screen[old_screen or 1] then
    local c = last_clients[capi.screen[scr_index]]

    -- If the client is leaked elsewhere, prevent an error message
    if c and not pcall(function() return c.valid end) and not c.valid then
      last_clients[capi.screen[scr_index]] = nil
      c = nil
    end

    if c and c.valid and c:isvisible() then
      local geom = c:geometry()
      if last_clients_coords[scr_index] and last_clients_coords[scr_index].client == c then
        capi.mouse.coords(last_clients_coords[scr_index])
      else
        capi.mouse.coords({x=geom.x+geom.width/2,y=geom.y+geom.height/2+55})
      end
    else
      local geom = capi.screen[scr_index].geometry
      capi.mouse.coords({x=geom.x+geom.width/2,y=geom.y+geom.height/2+55})
    end
    mouse.highlight()
  end

  if move then
    local t = capi.screen[scr_index].selected_tag
    if t then
      t.screen = old_screen
      awful.tag.viewonly(t)
    end
  else
    local c = capi.mouse.current_client
    if c then
      capi.client.focus = c
    end
  end

  return capi.screen[scr_index]
end

local function in_rect(c,point)
  if not c then return true end
  local geo = c:geometry()
  return (
    geo.x < point.x             and geo.y < point.y              and
    geo.x + geo.width > point.x and geo.y + geo.height > point.y
  )
end

local function save_cursor_position()
  local coords = capi.mouse.coords()
  local c = capi.client.focus
  -- Be sure that that mouse in inside of the selected client before doing that
  if c and in_rect(c,coords) then
    last_clients_coords[c.screen] = {
      client = c,
      x      = coords.x,
      y      = coords.y,
    }
  else
    last_clients_coords[capi.mouse.screen] = nil
  end
end

local function next_screen(ss,dir,move)
  if capi.screen.count() == 1 then return 1 end

  local scr_index = capi.screen[screens_inv[ss]].index

  if type(scr_index) == "screen" then
    scr_index = scr_index.index
  end
  if dir == "left" then
    scr_index = scr_index == 1 and #screens or scr_index - 1
  elseif dir == "right" then
    scr_index = scr_index == #screens and 1 or scr_index+1
  end

  return select_screen(screens_inv[capi.screen[scr_index]],move,ss)
end

function module.display(_,dir,move)
  if #wiboxes == 0 then
    init_wiboxes()
  end
  save_cursor_position()
  module.reload(nil,dir)
  local ss = current_screen(move)
  next_screen(ss,dir,move)
  module.reload(nil,dir)
end

local function highlight_screen(ss)
  ss = capi.screen[ss]
  if pss ~= ss then

    local bg       = beautiful.collision_screen_bg or beautiful.bg_alternate or "#ff0000"
    local fg       = beautiful.collision_screen_fg or beautiful.fg_normal    or "#0000ff"
    local bg_focus = beautiful.collision_screen_bg_focus or beautiful.bg_urgent or "#ff0000"
    local fg_focus = beautiful.collision_screen_fg_focus or beautiful.fg_urgent or "#ff0000"

    if pss then
        bgs[pss].bg = bg
        bgs[pss].fg = fg
    end

    pss = ss

    bgs[ss].bg = bg_focus
    bgs[ss].fg = fg_focus
  end
end

function module.hide()
  if #wiboxes == 0 then return end

  for s=1, capi.screen.count() do
    wiboxes[s].visible = false
  end
  mouse.hide()
end

local function show()
  for s=1, capi.screen.count() do
    wiboxes[s].visible = true
  end
end

function module.reload(mod,dir,_,_,move)
  local ss = current_screen(move)
  if dir then
    ss = next_screen(ss,dir:lower(),move or (mod and #mod == 4))
  end

  highlight_screen(ss)

  show()

  return true
end

function module.select_screen(idx)
    save_cursor_position()
    select_screen(screens_inv[idx],false)
    if #wiboxes == 0 then
        init_wiboxes()
    end

    highlight_screen(screens_inv[idx])

    show()

    capi.keygrabber.run(function(_, _, event)
        if event == "release" then
            module.hide()
            mouse.hide()
            capi.keygrabber.stop()
            return false
        end
        return true
    end)
end

-- Make sure this keeps working when a new screen is added
awful.screen.connect_for_each_screen(function(s)
    if next(wiboxes) then
        create_wibox(s)
    end
end)

capi.client.connect_signal("focus",function(c)
    last_clients[c.screen] = c
end)

return module
-- kate: space-indent on; indent-width 4; replace-tabs on;
