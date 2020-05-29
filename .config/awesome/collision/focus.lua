local capi = { client = client , mouse      = mouse     ,
               screen = screen , keygrabber = keygrabber,}

local setmetatable = setmetatable
local ipairs       = ipairs
local surface      = require( "gears.surface"  )
local shape        = require( "gears.shape"    )
local util         = require( "awful.util"     )
local client       = require( "awful.client"   )
local tag          = require( "awful.tag"      )
local alayout      = require( "awful.layout"   )
local wibox        = require( "wibox"          )
local cairo        = require( "lgi"            ).cairo
local beautiful    = require( "beautiful"      )
local color        = require( "gears.color"    )
local col_utils    = require( "collision.util" )
local grect        = require( "gears.geometry" ).rectangle
local placement    = require( "awful.placement")

local module = {}
local wiboxes,delta = nil,100
local edge = nil

---------------- Visual -----------------------
local function init()
    wiboxes = {}

    local s        = beautiful.collision_focus_shape or shape.rounded_rect
    local bw       = beautiful.collision_focus_border_width
    local bc       = beautiful.collision_focus_border_color
    local padding  = beautiful.collision_focus_padding or 7
    local bg       = beautiful.collision_focus_bg or beautiful.bg_alternate or "#ff0000"
    local fg       = beautiful.collision_focus_fg or beautiful.fg_normal    or "#0000ff"
    local bg_focus = beautiful.collision_focus_bg_center or beautiful.bg_urgent or "#ff0000"
    local sw       = beautiful.collision_shape_width or 75
    local sh       = beautiful.collision_shape_height or 75
    local cshape   = beautiful.collision_focus_shape_center or shape.circle

    for k,v in ipairs({"up","right","down","left","center"}) do
        wiboxes[v] = wibox {
            height = sh,
            width  = sw,
            ontop  = true
        }

        local r_shape = v == "center" and cshape or s
        local r_bg    = v == "center" and bg_focus    or bg
        local x = sw/2 - padding
        local y = sh/2 - padding

        wiboxes[v]:setup {
            v ~= "center" and {
                {
                    {
                        widget = wibox.widget.imagebox
                    },
                    shape  = shape.transform(col_utils.arrow_path2)
                                : rotate_at(x, y, (k-1)*(2*math.pi)/4),
                    bg     = fg,
                    widget = wibox.container.background
                },
                margins = padding,
                widget  = wibox.container.margin,
            } or {
                widget = wibox.widget.imagebox
            },
            bg                 = r_bg,
            shape              = r_shape,
            shape_border_width = bw,
            shape_border_color = bc,
            widget             = wibox.container.background
        }

        if awesome.version >= "v4.1" then
            wiboxes[v].shape = r_shape
        else
            surface.apply_shape_bounding(wiboxes[v], r_shape)
        end
    end
end

local function emulate_client(screen)
  return {is_screen = true, screen=screen, geometry=function() return capi.screen[screen].workarea end}
end

local function display_wiboxes(cltbl,geomtbl,float,swap,c)
  if not wiboxes then
    init()
  end
  local fc = capi.client.focus or emulate_client(capi.mouse.screen)
  for k,v in ipairs({"left","right","up","down","center"}) do
    local next_clients = (float and swap) and c or cltbl[grect.get_in_direction(v , geomtbl, fc:geometry())]
    if next_clients or k==5 then
      local parent = k==5 and fc or next_clients
      wiboxes[v].visible = true
      placement.centered(wiboxes[v], {parent = parent})
    else
      wiboxes[v].visible = false
    end
  end
end

---------------- Position -----------------------
local function float_move(dir,c)
  return ({left={x=c:geometry().x-delta},right={x=c:geometry().x+delta},up={y=c:geometry().y-delta},down={y=c:geometry().y+delta}})[dir]
end

local function float_move_max(dir,c)
  return ({left={x=capi.screen[c.screen].workarea.x},right={x=capi.screen[c.screen].workarea.width+capi.screen[c.screen].workarea.x-c:geometry().width}
      ,up={y=capi.screen[c.screen].workarea.y},down={y=capi.screen[c.screen].workarea.y+capi.screen[c.screen].workarea.height-c:geometry().height}})[dir]
end

local function floating_clients()
  local ret = {}
  for v in util.table.iterate(client.visible(),function(c) return c.floating end) do
    ret[#ret+1] = v
  end
  return ret
end

local function bydirection(dir, c, swap,max)
  if not c then
    c = emulate_client(capi.mouse.screen)
  end

  local float = nil

  if c.is_screen then
    float = false
  else
    float = (c.floating or alayout.get(c.screen) == alayout.suit.floating)
  end

  -- Move the client if floating, swaping wont work anyway
  if swap and float then
    c:geometry((max and float_move_max or float_move)(dir,c))
    display_wiboxes(nil,nil,float,swap,c)
  else

    if not edge then
      local scrs =col_utils.get_ordered_screens()
      local last_geo =capi.screen[scrs[#scrs]].geometry
      edge = last_geo.x + last_geo.width
    end

    -- Get all clients rectangle
    local cltbl,geomtbl,scrs,roundr,roundl = max and floating_clients() or client.tiled(),{},{},{},{}
    for i,cl in ipairs(cltbl) do
      local geo = cl:geometry()
      geomtbl[i] = geo
      scrs[capi.screen[cl.screen or 1]] = true
      if geo.x == 0 then
        roundr[#roundr+1] = cl
      elseif geo.x + geo.width >= edge -2 then
        roundl[#roundl+1] = cl
      end
    end

    --Add first client at the end to be able to rotate selection
    for k,c in ipairs(roundr) do
      local geo = c:geometry()
      geomtbl[#geomtbl+1] = {x=edge,width=geo.width,y=geo.y,height=geo.height}
      cltbl[#geomtbl] = c
    end
    for k,c in ipairs(roundl) do
      local geo = c:geometry()
      geomtbl[#geomtbl+1] = {x=-geo.width,width=geo.width,y=geo.y,height=geo.height}
      cltbl[#geomtbl] = c
    end

    -- Add rectangles for empty screens too
    for i = 1, capi.screen.count() do
      if not scrs[capi.screen[i]] then
        geomtbl[#geomtbl+1] = capi.screen[i].workarea
        cltbl[#geomtbl] = emulate_client(i)
      end
    end

    local target = grect.get_in_direction(dir, geomtbl, c:geometry())
    if swap ~= true then
      -- If we found a client to focus, then do it.
      if target then
        local cl = cltbl[target]
        if cl and cl.is_screen then
          capi.client.focus = nil --TODO Fix upstream fix
          capi.mouse.screen = capi.screen[cl.screen]
        else
          local old_src = capi.client.focus and capi.client.focus.screen
          capi.client.focus = cltbl[((not cl and #cltbl == 1) and 1 or target)]
          capi.client.focus:raise()
          if not old_src or capi.client.focus.screen ~= capi.screen[old_src] then
            capi.mouse.coords(capi.client.focus:geometry())
          end
        end
      end
    else
      if target then
        -- We found a client to swap
        local other = cltbl[((not cltbl[target] and #cltbl == 1) and 1 or target)]
        if capi.screen[other.screen] == capi.screen[c.screen] or col_utils.settings.swap_across_screen then
          --BUG swap doesn't work if the screen is not the same
          c:swap(other)
        else
          local t  = capi.screen[other.screen].selected_tag --TODO get index
          c.screen = capi.screen[ other.screen]
          c:tags({t})
        end
      else
        -- No client to swap, try to find a screen.
        local screen_geom = {}
        for i = 1, capi.screen.count() do
          screen_geom[i] = capi.screen[i].workarea
        end
        target = grect.get_in_direction(dir, screen_geom, c:geometry())
        if target and target ~= c.screen then
          local t = target.selected_tag
          c.screen = target
          c:tags({t})
          c:raise()
        end
      end
      if target then
        -- Geometries have changed by swapping, so refresh.
        cltbl,geomtbl = max and floating_clients() or client.tiled(),{}
        for i,cl in ipairs(cltbl) do
          geomtbl[i] = cl:geometry()
        end
      end
    end
    display_wiboxes(cltbl,geomtbl,float,swap,c)
  end
end

function module.global_bydirection(dir, c,swap,max)
  bydirection(dir, c or capi.client.focus, swap,max)
end

function module._global_bydirection_key(mod,key,event,direction,is_swap,is_max)
  bydirection(direction,capi.client.focus,is_swap,is_max)
  return true
end

function module.display(mod,key,event,direction,is_swap,is_max)
  local c = capi.client.focus
  local cltbl,geomtbl = max and floating_clients() or client.tiled(),{}
  for i,cl in ipairs(cltbl) do
    geomtbl[i] = cl:geometry()
  end

  -- Sometime, there is no focussed clients
  if not c then
    c = geomtbl[1] or cltbl[1]
  end

  -- If there is still no accessible clients, there is nothing to display
  if not c then return end

  display_wiboxes(cltbl,geomtbl,c.floating or alayout.get(c.screen) == alayout.suit.floating,is_swap,c)
end

function module._quit()
  if not wiboxes then return end
  for k,v in ipairs({"left","right","up","down","center"}) do
    wiboxes[v].visible = false
  end
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
-- kate: space-indent on; indent-width 4; replace-tabs on;
