local capi = {screen=screen,client=client,mouse=mouse}
local wibox = require("wibox")
local awful = require("awful")
local cairo        = require( "lgi"              ).cairo
local color        = require( "gears.color"      )
local beautiful    = require( "beautiful"        )
local surface      = require( "gears.surface"    )
local layout       = require( "collision.layout" )
local util         = require( "collision.util"   )
local shape        = require( "gears.shape"      )
local pango = require("lgi").Pango
local pangocairo = require("lgi").PangoCairo
local module = {}

local w = nil
local rad = 10
local border = 3

local function init()
  w = wibox{}
  w.ontop = true
  w.visible = true
end

local margin = 15

local function create_arrow(cr,x,y,width, height,direction)
  local r,g,b = util.get_rgb()
  cr:set_source_rgba(r,g,b,0.15)
  cr:set_antialias(1)

  local s = shape.transform(shape.arrow)
    : rotate_at(width/4, height/4, math.pi/2)

  if direction == 1 then
    s : rotate_at(width/4, height/4, math.pi)
  end

  s : translate(x, y)

  s(cr, width/2, height/2, nil)

  cr:fill()
end

local pango_l = nil
local function draw_shape(s,collection,current_idx,icon_f,y,text_height)
  local geo = capi.screen[s].geometry
  local wa  =capi.screen[s].workarea

  --Compute thumb dimensions
  local margins = 2*20 + (#collection-1)*20
  local width = (geo.width - margins) / #collection
  local ratio = geo.height/geo.width
  local height = width*ratio
  local dx = 20

  -- Do not let the thumb get too big
  if height > 150 then
    height = 150
    width = 150 * (1.0/ratio)
    dx = (wa.width-margins-(#collection*width))/2 + 20
  end

  -- Resize the wibox
  w.x,w.y,w.width,w.height = math.floor(geo.x),math.floor(y or (wa.y+wa.height) - margin - height),math.floor(geo.width),math.floor(height)

  local rshape = beautiful.collision_max_shape or shape.rounded_rect
  local img = cairo.ImageSurface(cairo.Format.ARGB32, geo.width,geo.height)
  local img3 = cairo.ImageSurface(cairo.Format.ARGB32, geo.width,geo.height)
  local cr = cairo.Context(img)
  local cr3 = cairo.Context(img3)
  cr:set_source_rgba(0,0,0,0)
  cr:paint()

  -- Get the colors
  local white,bg = color("#FFFFFF"),color(
    beautiful.collision_max_bg or beautiful.menu_bg_normal or beautiful.bg_normal
  )

  local normal, focus = color(beautiful.collision_max_fg or beautiful.fg_normal), color(beautiful.bg_urgent)

  -- Init the text properties
  if not pango_l then
    local pango_crx = pangocairo.font_map_get_default():create_context()
    pango_l = pango.Layout.new(pango_crx)
    pango_l:set_font_description(beautiful.get_font(font))
    pango_l:set_alignment("CENTER")
    pango_l:set_wrap("CHAR")
  end

  for k,v in ipairs(collection) do
    -- Shape bounding
    cr:set_source(white)

    local s = shape.transform(rshape) : translate(dx, 0)
    s(cr, width, height, 10)
    cr:fill()

    -- Borders and background
    cr3:set_source(k==current_idx and focus or normal)

    cr3:move_to(0,0)
    s = shape.transform(rshape) : translate(dx+border, border)
    s(cr3, width-2*border, height-2*border, rad)

    cr3:set_line_width(2*border + 4) -- The 4 is required to cover the non-antialiased region
    cr3:stroke_preserve()
    cr3:set_source(bg)
    cr3:fill()

    -- Print the icon
    local icon = icon_f(v,width-20,height-20-text_height)
    if icon then
      cr3:save()
      cr3:translate(dx+10,10)
      cr3:set_source_surface(icon)
      cr3:paint_with_alpha(0.7)
      cr3:restore()
    end

    -- Print a pretty line
    local r,g,b = util.get_rgb(normal)
    cr3:set_source_rgba(r,g,b,0.7)
    cr3:set_line_width(1)
    cr3:move_to(dx+margin,height - text_height-border)
    cr3:line_to(dx+margin+width-2*margin,height - text_height-border)
    cr3:stroke()

    -- Pring the text
    pango_l.text = v.name
    pango_l.width = pango.units_from_double(width-16)
    pango_l.height = pango.units_from_double(height-text_height-10)
    cr3:move_to(dx+8,height-text_height-0)
    cr3:show_layout(pango_l)

    -- Draw an arrow
    if current_idx and k == current_idx-1 then
      create_arrow(cr3,dx,0,width,height,1)
    else
      create_arrow(cr3,dx,0,width,height,nil)
    end

    dx = dx + width + 20
  end

  w:set_bg(cairo.Pattern.create_for_surface(img3))
  w.shape_bounding = img._native
  w.visible = true
end

function module.hide()
  w.visible = false
end

--Client related
local function client_icon(c,width,height)
  -- Get the content
  --TODO detect pure black frames
  local img = cairo.ImageSurface(cairo.Format.ARGB32, width, height)
  local rshape = beautiful.collision_max_shape or shape.rounded_rect
  local cr = cairo.Context(img)

  local geom = c:geometry()
  local scale = width/geom.width
  if geom.height*scale > height then
    scale = height/geom.height
  end
  local w,h = geom.width*scale,geom.height*scale

  -- Create a mask
  local s = shape.transform(rshape) : translate((width-w)/2, (height-h)/2)
  s(cr, w, h, 10)

  cr:clip()

  cr:translate((width-w)/2,(height-h)/2)

  -- Create a matrix to scale down the screenshot
  cr:save()
  cr:scale(scale,scale)

  -- Paint the screenshot in the rounded rectangle
  cr:set_source_surface(surface(c.content))

  cr:paint()
  cr:restore()

  -- Add icon on top, "solve" the black window issue
  local icon = surface(c.icon)

  if not icon then
    return img
  end

--   local w,h = icon:get_width(),icon:get_height()
--   local aspect,aspect_h = width / w,(height) / h
--   if aspect > aspect_h then aspect = aspect_h end
--   cr:translate((width-w*aspect)/2,(height-h*aspect)/2)
--   cr:scale(aspect, aspect)
--   cr:set_source_surface(icon)
--   cr:paint_with_alpha(0.5)

  return img
end

function module.display_clients(s,direction)
  if not w then
    init()
  end
  if direction then
    awful.client.focus.byidx(direction == "right" and 1 or -1)
    capi.client.focus:raise()
  end
  local clients = awful.client.tiled(s)
  local fk = awful.util.table.hasitem(clients,capi.client.focus)
  draw_shape(s,clients,fk,client_icon,nil,50)
end

function module.change_focus(mod,key,event,direction,is_swap,is_max)
  awful.client.focus.byidx(direction == "right" and 1 or -1)
  local c = capi.client.focus
  local s = c.screen
  c:raise()
  local clients = awful.client.tiled(s)
  local fk = awful.util.table.hasitem(clients,c)
  draw_shape(s,clients,fk,client_icon,nil,50)
  return true
end

--Tag related
local function tag_icon(t,width,height)
  local img = cairo.ImageSurface(cairo.Format.ARGB32, width, height)
  local cr = cairo.Context(img)

  local has_layout = layout.draw(t,cr,width,height)

  -- Create a monochrome representation of the icon
  local icon_orig = surface(t.icon)
    if icon_orig then
      local icon = cairo.ImageSurface(cairo.Format.ARGB32, icon_orig:get_width(), icon_orig:get_height())
      local cr2 = cairo.Context(icon)
      cr2:set_source_surface(icon_orig)
      cr2:paint()

      cr2:set_source(color(beautiful.fg_normal))
      cr2:set_operator(cairo.Operator.IN)
      cr2:paint()

      local w,h = icon:get_width(),icon:get_height()
      local aspect,aspect_h = width / w,(height) / h
      if aspect > aspect_h then aspect = aspect_h end
      cr:translate((width-w*aspect)/2,(height-h*aspect)/2)
      cr:scale(aspect, aspect)
      cr:set_source_surface(icon)
      cr:paint_with_alpha(has_layout and 0.35 or 1)
    end
  return img
end

local function change_tag(s,direction,is_swap)
  local s = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
  if not is_swap then
    awful.tag[direction == "left" and "viewprev" or "viewnext"](s)
  else
    -- Move the tag
    local t = capi.screen[s].selected_tag
    local cur_idx,count = awful.tag.getidx(t),#capi.screen[s].tags
    cur_idx = cur_idx + (direction == "left" and -1 or 1)
    cur_idx = cur_idx == 0 and count or cur_idx > count and 1 or cur_idx
    t.index = cur_idx
  end
  local tags = capi.screen[s].tags
  local fk = awful.util.table.hasitem(tags,capi.screen[s].selected_tag)
  draw_shape(s,tags,fk,tag_icon,capi.screen[s].workarea.y + 15,20)
end

function module.display_tags(s,direction,c,is_swap,is_max)
  if not w then
    init()
  end
  change_tag(s,direction,is_swap)
end

function module.change_tag(mod,key,event,direction,is_swap,is_max)
  local s = capi.client.focus and capi.client.focus.screen or capi.mouse.screen
  change_tag(s,direction,is_swap)
  return true
end

return module
-- kate: space-indent on; indent-width 2; replace-tabs on;
