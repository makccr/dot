--[[
Clock Rings by Linux Mint (2011) reEdited by despot77

This script draws percentage meters as rings, and also draws clock hands if you want! It is fully customisable; all options are described in the script. This script is based off a combination of my clock.lua script and my rings.lua script.

IMPORTANT: if you are using the 'cpu' function, it will cause a segmentation fault if it tries to draw a ring straight away. The if statement on line 145 uses a delay to make sure that this doesn't happen. It calculates the length of the delay by the number of updates since Conky started. Generally, a value of 5s is long enough, so if you update Conky every 1s, use update_num>5 in that if statement (the default). If you only update Conky every 2s, you should change it to update_num>3; conversely if you update Conky every 0.5s, you should use update_num>10. ALSO, if you change your Conky, is it best to use "killall conky; conky" to update it, otherwise the update_num will not be reset and you will get an error.

To call this script in Conky, use the following (assuming that you save this script to ~/scripts/rings.lua):
    lua_load ~/scripts/clock_rings.lua
    lua_draw_hook_pre clock_rings
    
Changelog:
+ v1.0 -- Original release (30.09.2009)
   v1.1p -- Jpope edit londonali1010 (05.10.2009)
*v 2011mint -- reEdit despot77 (18.02.2011)
]]

settings_table = {
    {
        -- Edit this table to customise your rings.
        -- You can create more rings simply by adding more elements to settings_table.
        -- "name" is the type of stat to display; you can choose from 'cpu', 'memperc', 'fs_used_perc', 'battery_used_perc'.
        name='cpu',
        -- "arg" is the argument to the stat type, e.g. if in Conky you would write ${cpu cpu0}, 'cpu0' would be the argument. If you would not use an argument in the Conky variable, use ''.
        arg='cpu1',
        -- "max" is the maximum value of the ring. If the Conky variable outputs a percentage, use 100.
        max=100,
        -- "bg_colour" is the colour of the base ring.
        bg_colour=0x95C2BB,
        -- "bg_alpha" is the alpha value of the base ring.
        bg_alpha=0.0,
        -- "fg_colour" is the colour of the indicator part of the ring.
        fg_colour=0xff3744,
        -- "fg_alpha" is the alpha value of the indicator part of the ring.
        fg_alpha=0.8,
        -- "x" and "y" are the x and y coordinates of the centre of the ring, relative to the top left corner of the Conky window.
        x=261, y=260,
        -- "radius" is the radius of the ring.
        radius=46,
        -- "thickness" is the thickness of the ring, centred around the radius.
        thickness=9,
        -- "start_angle" is the starting angle of the ring, in degrees, clockwise from top. Value can be either positive or negative.
        start_angle=-120,
        -- "end_angle" is the ending angle of the ring, in degrees, clockwise from top. Value can be either positive or negative, but must be larger than start_angle.
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=56,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=66,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=76,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=86,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=96,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu1',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=106,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
    {
        name='cpu',
        arg='cpu2',
        max=100,
        bg_colour=0x95C2BB,
        bg_alpha=0.2,
        fg_colour=0xff3744,
        fg_alpha=0.8,
        x=261, y=260,
        radius=116,
        thickness=9,
        start_angle=-120,
        end_angle=120
    },
}

    corner_r=55

    -- Set the colour and transparency (alpha) of your background.

    bg_colour=0x000000
    bg_alpha=0.0

require 'cairo'

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)

    -- Draw background ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)
    
    -- Draw indicator ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)        
end

function conky_stargate_bgAndRings()
    local function setup_rings(cr,pt)
        local str=''
        local value=0
        
        str=string.format('${%s %s}',pt['name'],pt['arg'])
        str=conky_parse(str)
        
        value=tonumber(str)
        pct=value/pt['max']
        
        draw_ring(cr,pct,pt)
    end
    
    -- Check that Conky has been running for at least 5s

    if conky_window==nil then return end

    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    
    local cr=cairo_create(cs)    
    local w,h=conky_window.width,conky_window.height

	-- Draw translucent background (0,0) is top-left corner
	cairo_move_to(cr,corner_r,0)
	cairo_line_to(cr,w,0)
	cairo_line_to(cr,w,h)
	cairo_line_to(cr,0,h)
	cairo_line_to(cr,0,0)
	cairo_line_to(cr,0,corner_r)
	cairo_line_to(cr,corner_r,0)
	cairo_close_path(cr)

	cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
	cairo_fill(cr)

    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)
    
    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
    end

    -- Return empty string to shut up annoying "No return value" prompts
    return ''
end
