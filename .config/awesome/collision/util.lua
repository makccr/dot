local capi      = {screen = screen}
local math      = math
local color     = require( "gears.color" )
local beautiful = require( "beautiful"   )
local glib      = require("lgi").GLib
local cairo        = require( "lgi"            ).cairo

local module = {settings={}}


local rr,rg,rb
function module.get_rgb(col)
  if not rr then
    local pat = color(col or beautiful.fg_normal)
    local s,r,g,b,a = pat:get_rgba()
    rr,rg,rb = r,g,b
  end
  return rr,rg,rb
end

--- Draw an arrow path. The current context position is the center of the arrow
-- By default, the arrow is pointing up, use context rotation to get other directions
--
-- To get an arrow pointing down:
-- @usage cr:move_to(width/2, height/2)
-- cr:rotate(math.pi)
--
--
function module.arrow_path(cr, width, sidesize)
  cr:rel_move_to( 0                   , -width/2 )
  cr:rel_line_to( width/2             , width/2  )
  cr:rel_line_to( -sidesize           , 0        )
  cr:rel_line_to( 0                   , width/2  )
  cr:rel_line_to( (-width)+2*sidesize , 0        )
  cr:rel_line_to( 0                   , -width/2 )
  cr:rel_line_to( -sidesize           , 0        )
  cr:rel_line_to( width/2             , -width/2 )
  cr:close_path()
end

function module.arrow_path2(cr, width, height, head_width, shaft_width, shaft_length)
  local shaft_length = shaft_length or height / 2
  local shaft_width  = shaft_width  or width  / 2
  local head_width   = head_width   or width
  local head_length  = height - shaft_length

  cr:move_to( width/2                     , 0 )
  cr:rel_line_to( head_width/2                , head_length )
  cr:rel_line_to( -(head_width-shaft_width)/2 , 0  )
  cr:rel_line_to( 0                           , shaft_length        )
  cr:rel_line_to( -shaft_width                , 0 )
  cr:rel_line_to( 0           , -shaft_length )
  cr:rel_line_to( -(head_width-shaft_width)/2             , 0 )
  cr:close_path()
end

function module.arrow(width, sidesize, margin, bg_color, fg_color)
  local img = cairo.ImageSurface(cairo.Format.ARGB32, width+2*margin, width+2*margin)
  local cr = cairo.Context(img)
  cr:set_source(color(bg_color))
  cr:paint()
  cr:set_source(color(fg_color))
  cr:set_antialias(cairo.Antialias.NONE)
  cr:move_to(margin+width/2, margin+width/2)
  module.arrow_path(cr, width, sidesize)
  cr:fill()
  return cairo.Pattern.create_for_surface(img)
end

function module.draw_round_rect(cr,x,y,w,h,radius)
  cr:save()
  cr:translate(x,y)
  cr:move_to(0,radius)
  cr:arc(radius,radius,radius,math.pi,3*(math.pi/2))
  cr:arc(w-radius,radius,radius,3*(math.pi/2),math.pi*2)
  cr:arc(w-radius,h-radius,radius,math.pi*2,math.pi/2)
  cr:arc(radius,h-radius,radius,math.pi/2,math.pi)
  cr:close_path()
  cr:restore()
end

local function refresh_dt(last_sec,last_usec,callback,delay)
  local tv = glib.TimeVal()
  glib.get_current_time(tv)
  local dt = (tv.tv_sec*1000000+tv.tv_usec)-(last_sec*1000000+last_usec)
  if dt < delay then
    callback()
  end
  return tv.tv_sec,tv.tv_usec
end

function module.double_click(callback,delay)
  delay = delay or 250000
  local ds,du = 0,0
  return function()
    ds,du = refresh_dt(ds,du,callback,delay)
  end
end

-- Screen order is not always geometrical, sort them
local screens,screens_inv
function module.get_ordered_screens()
  if screens then return screens,screens_inv end

  screens = {}
  for i=1,capi.screen.count() do
    local geom = capi.screen[i].geometry
    if #screens == 0 then
      screens[1] = capi.screen[i]
    elseif geom.x < capi.screen[screens[1]].geometry.x then
      table.insert(screens,1,capi.screen[i])
    else
      for j=#screens,1,-1 do
        if geom.x > capi.screen[screens[j]].geometry.x then
          table.insert(screens,j+1,capi.screen[i])
          break
        end
      end
    end
  end

  screens_inv = {}
  for k,v in ipairs(screens) do
    screens_inv[v] = k
  end

  return screens,screens_inv
end

capi.screen.connect_signal("added", function()
  screens,screens_inv = nil, nil
end)
capi.screen.connect_signal("removed", function()
  screens,screens_inv = nil, nil
end)

--- Setup the whole thing and call fct(cr, width, height) then apply the shape
-- fct should not set the source or color
function module.apply_shape_bounding(c_or_w, fct)
  local geo = c_or_w:geometry()

  local img = cairo.ImageSurface(cairo.Format.A1, geo.width, geo.height)
  local cr = cairo.Context(img)

  cr:set_source_rgba(0,0,0,0)
  cr:paint()
  cr:set_operator(cairo.Operator.SOURCE)
  cr:set_source_rgba(1,1,1,1)

  fct(cr, geo.width, geo.height)

  cr:fill()

  c_or_w.shape_bounding = img._native
end

return module
-- kate: space-indent on; indent-width 2; replace-tabs on;
