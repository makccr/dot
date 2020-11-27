--[[
clock-dots-grey.lua

Analog Clock, based on code for Air Clock by Alison Pitt (2009)
Clock marks based on code from <MrPeachy>

Modified by damo <damo@bunsenlabs.org> April 2015

This clock is designed to look like KDE 4.3's "Air" clock, but from inside Conky.

You can adjust the clock's radius and placement, and can also choose whether to display the seconds hand. This clock updates every time Conky does, so if you want to show seconds, it is recommended that you set update_interval to no more than 0.5s. If you turn off seconds, you can set the update_interval to as long as 30s.  The settings are in the "Settings" section, starting at Line 21.

Call this script in Conky using the following before TEXT (assuming you save this script to ~/scripts/clock.lua):
    lua_load ~/scripts/clock.lua
    lua_draw_hook_pre draw_clock
]]

require 'cairo'
function conky_draw_clock()
    if conky_window==nil then return end
    local w=conky_window.width
    local h=conky_window.height
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
    cr=cairo_create(cs)
            
    -- Settings
    
    -- What radius should the clock face (not including border) be, in pixels?
    local clock_r=50

    -- x and y coordinates, relative to the top left corner of Conky, in pixels
    --local xc=148
    --local yc=63
    local xc=165
    local yc=60

    --  Do you want to show the second hand? Use this if you use a Conky update_interval > 1s. Can be true or false.
    show_seconds=true
    
    -- Grab time
    
    local hours=os.date("%I")
    local mins=os.date("%M")
    local secs=os.date("%S")
    
    secs_arc=(2*math.pi/60)*secs
    mins_arc=(2*math.pi/60)*mins
    hours_arc=(2*math.pi/12)*hours+mins_arc/12

    -- Set clock face
    
    cairo_arc(cr,xc,yc,clock_r*0.2,0,2*math.pi)
    cairo_close_path(cr)
    local face_pat=cairo_pattern_create_radial(xc,yc-clock_r*0.98,0,xc,yc,clock_r)
    cairo_set_source_rgba(cr,1,1,1,0.2)
    cairo_set_line_width(cr, clock_r*1.55)
    cairo_stroke (cr)
    
    -- draw clock marks

    b_to_m=5    -- gap from clock border to edge marks
    m_length=1    -- set mark length
    m_end_rad=clock_r-b_to_m    -- calculate mark outer radius
    m_start_rad=m_end_rad-m_length    -- calculate mark start radius
    m_width=2    -- set mark width
    m_cap=CAIRO_LINE_CAP_ROUND    -- set mark cap type
    mr,mg,mb,ma=1,1,1,0.5    --set mark colour and alpha, rgba
    
    cairo_set_line_width (cr,m_width)
    cairo_set_line_cap (cr,m_cap)
    cairo_set_source_rgba (cr,mr,mg,mb,ma)
    
    for i=1,12 do
    -- start point for 12 oclock mark
    radius=m_start_rad
    point=(math.pi/180)*((i-1)*30)
    xdots=0+radius*(math.sin(point))
    ydots=0-radius*(math.cos(point))
    
    --set start point for line
    cairo_move_to (cr,xc+xdots,yc+ydots)
    
    -- calculate endpoint for12 oclock mark
    radius=m_end_rad
    point=(math.pi/180)*((i-1)*30)
    xdots=0+radius*(math.sin(point))
    ydots=0-radius*(math.cos(point))
    
    --set path for line
    cairo_line_to (cr,xc+xdots,yc+ydots)
    
    -- draw the line
    cairo_stroke (cr)
    end -- of for loop
    -- end of clock marks
    
    -- Draw hour hand
    
    xh=xc+0.7*clock_r*math.sin(hours_arc)
    yh=yc-0.7*clock_r*math.cos(hours_arc)
    cairo_move_to(cr,xc,yc)
    cairo_line_to(cr,xh,yh)
    
    cairo_set_line_cap(cr,CAIRO_LINE_CAP_ROUND)
    cairo_set_line_width(cr,2)
    cairo_set_source_rgba(cr,1,1,1,0.9)
    cairo_stroke(cr)
    
    -- Draw minute hand
    
    xm=xc+0.9*clock_r*math.sin(mins_arc)
    ym=yc-0.9*clock_r*math.cos(mins_arc)
    cairo_move_to(cr,xc,yc)
    cairo_line_to(cr,xm,ym)
    
    cairo_set_line_width(cr,2)
    cairo_stroke(cr)
    
    -- Draw seconds hand
    
    if show_seconds then
        xs=xc+0.9*clock_r*math.sin(secs_arc)
        ys=yc-0.9*clock_r*math.cos(secs_arc)
        cairo_move_to(cr,xc,yc)
        cairo_line_to(cr,xs,ys)
    
        cairo_set_line_width(cr,1)
        cairo_stroke(cr)
    end
    
end
