local capi = {screen=screen,client=client,mouse=mouse, keygrabber = keygrabber}
local math,table = math,table
local wibox        = require( "wibox"          )
local awful        = require( "awful"          )
local cairo        = require( "lgi"            ).cairo
local color        = require( "gears.color"    )
local beautiful    = require( "beautiful"      )
local surface      = require( "gears.surface"  )
local col_utils    = require( "collision.util" )

local module = {}

local w = nil

function module.highlight()
  if not w then
    w = wibox{}
    w.height = 100
    w.width = 100
    w.ontop = true
    
    local img = cairo.ImageSurface(cairo.Format.A8, 100,100)
    local cr = cairo.Context(img)
--     cr:set_operator(cairo.Operator.CLEAR)
    cr:set_source_rgba(0,0,0,0)
    cr:paint()
    cr:set_operator(cairo.Operator.SOURCE)
    cr:set_source_rgba(1,1,1,1)
  
    cr:save()
    cr:translate(0,-30)
    cr:move_to(50,50)
    cr:rotate(math.pi)
    col_utils.arrow_path(cr,40,10)
    cr:fill()
    cr:restore()
  
    cr:save()
    cr:translate(-30,0)
    cr:move_to(50,50)
    cr:rotate(math.pi/2)
    col_utils.arrow_path(cr,40,10)
    cr:fill()
    cr:restore()
  
    cr:save()
    cr:translate(30,0)
    cr:move_to(50,50)
    cr:rotate(-math.pi/2)
    col_utils.arrow_path(cr,40,10)
    cr:fill()
    cr:restore()
  
    cr:save()
    cr:translate(0,30)
    cr:move_to(50,50)
    col_utils.arrow_path(cr,40,10)
    cr:fill()
    cr:restore()
    
    cr:arc(50,50,50-3,0,2*math.pi)
    cr:set_line_width(5)
    cr:stroke()
  
    cr:set_source_rgba(1,0,0,1)
    w.shape_bounding = img._native
    
    
    img = cairo.ImageSurface(cairo.Format.ARGB32, 100,100)
    cr = cairo.Context(img)
    cr:set_source(color(beautiful.bg_urgent))
    cr:paint()
    cr:set_source(color(beautiful.fg_normal))
    cr:arc(50,50,50-3,0,2*math.pi)
    cr:set_line_width(5)
    cr:stroke()
    w:set_bg(cairo.Pattern.create_for_surface(img))
  end
  w.x = capi.mouse.coords().x -50
  w.y = capi.mouse.coords().y -50
  w.visible = true
end

function module.hide()
  if w then
    w.visible = false
  end
end

return module
