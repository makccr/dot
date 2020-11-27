--[[
minimal clock for conky
based upon similar android clock widget

written by easysid
Tuesday, 03 February 2015 16:20 IST
]]--


require 'cairo'


clock_table = {
        -- clock style options
        use12hourformat = true,  -- 12 hr format. Set to false for 24 hrs
        showday = true,      -- show the day of the week
        draw_background = true, -- set to false if you do not want a bg fill
        draw_seconds = true, -- draw the seconds ring
            -- options if above is true
            seconds_ring_width = 4, -- seconds ring width
            seconds_ring_base_color = {0x909090, 0.8}, -- base color
            seconds_ring_fill_color = {0xFFFFFF, 0.8},-- fill color
        --
        -- main settings
        --
        xc = 120, -- centre of the clock
        yc = 170,
        R  = 90, -- outer radius
        r  = 25, -- minute ring radius
        border_width = 2,
        -- color settings. {color, alpha}
        background_color = {0xFFFFFF, 0.5}, -- bgcolor id draw_background is true.
        fill_color   = {0xb5145c, 1},       -- fill color for minutes ring
        border_color = {0xFFFFFF, 1},       -- border color
        text_color   = {0xFFFFFF, 1},       -- color of numbers
        -- font settings
        -- specify the font as font:face, where face is bold, italic, bolditalic
        hour_font = "noto",  -- font face for hours
        min_font  = "noto",  -- font face for minutes
        day_font  = "noto",  -- font face for day and time period
        hour_font_size = 75,  -- font size for hours
        min_font_size  = 18,   -- font size for minutes
        day_font_size  = 24,   -- font size for day and period
}


function conky_main()
    if conky_window == nil then return end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    cr = cairo_create(cs)
    draw_clock(cr, clock_table)
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end -- end main function

function draw_clock(cr, t)
    -- The primary function to draw the clock
    local divs = 60
    local hour = tonumber(os.date("%H"))
    local minutes = tonumber(os.date("%M"))
    local m_theta = minutes*2*math.pi/divs - math.pi/2 -- calculate the angle
    local xm = t.xc + t.R*math.cos(m_theta)
    local ym = t.yc + t.R*math.sin(m_theta)
    -- get font and font face
    local dfont, dface = splitfont(t.day_font)
    local mfont, mface = splitfont(t.min_font)
    --print(mfont,mface)
    -- calculate text extents
    if t.use12hourformat or t.showday then
         hy = getheight(hour,t.hour_font, 'normal', t.hour_font_size)
    end
    -- draw the outer ring
    if t.draw_background then
        cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.background_color))
        cairo_arc(cr, t.xc, t.yc, t.R, 0, 2*math.pi)
        cairo_fill(cr)
    end
    if t.draw_seconds then
        local seconds = tonumber(os.date("%S"))
        local s_theta = seconds*2*math.pi/divs - math.pi/2 -- calculate the angle
        cairo_set_line_width(cr, t.seconds_ring_width)
        cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.seconds_ring_base_color))
        -- draw the base ring
        cairo_arc(cr, t.xc, t.yc, t.R, 0, 2*math.pi)
        cairo_stroke(cr)
        -- draw the seconds indicator circle
        cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.seconds_ring_fill_color))
        cairo_arc(cr, t.xc, t.yc, t.R, -math.pi/2, s_theta)
        cairo_stroke(cr)
    else
        cairo_set_line_width(cr, t.border_width)
        cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.border_color))
        cairo_arc(cr, t.xc, t.yc, t.R, 0, 2*math.pi)
        cairo_stroke(cr)
    end
    -- draw the minutes ring
    cairo_set_line_width(cr, t.border_width)
    cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.fill_color))
    cairo_arc(cr, xm, ym, t.r, 0, 2*math.pi)
    cairo_fill(cr)
    cairo_set_source_rgba(cr, rgba_to_r_g_b_a(t.border_color))
    cairo_arc(cr, xm, ym, t.r, 0, 2*math.pi)
    cairo_stroke(cr)
    --
    -- text drawing
    --
    -- check the time format
    if t.use12hourformat then
        hour = tonumber(os.date("%l"))
        local ampm = os.date("%p")
        out({x=t.xc,y=t.yc+hy,f=dfont,face=dface,fs=t.day_font_size,c=t.text_color,txt=ampm,hj='c',vj='n'})
    end
    if t.showday then
        local day = os.date("%a")
        out({x=t.xc,y=t.yc-hy,f=dfont,face=dface,fs=t.day_font_size,c=t.text_color,txt=day,hj='c',vj='t'})
    end
    out({x=t.xc,y=t.yc,f=t.hour_font,fs=t.hour_font_size,c=t.text_color,txt=hour,hj='c',vj='m'})
    out({x=xm,y=ym,f=mfont,face=mface,fs=t.min_font_size,c=t.text_color,txt=minutes,hj='c',vj='m'})
end -- end draw_clock

function out(txj)--c,a,f,fs,face,x,y,txt,hj,vj,ro,sxo,syo,sfs,sface,sc,sa #
   -- Taken from mrpeachy's wun.lua
    local extents=cairo_text_extents_t:create()
    tolua.takeownership(extents)
    local function justify(jtxt,x,hj,y,vj,f,face,fs)
        if face=="normal" then
            face={f,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL}
        elseif face=="bold" then
            face={f,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD}
        elseif face=="italic" then
            face={f,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_NORMAL}
        elseif face=="bolditalic" then
            face={f,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_BOLD}
        else
            print ('face not set correctly - "normal","bold","italic","bolditalic"')
        end
        cairo_select_font_face (cr,face[1],face[2],face[3])
        cairo_set_font_size(cr,fs)
        cairo_text_extents(cr,jtxt,extents)
        local wx=extents.x_advance
        local wd=extents.width
        local hy=extents.height
        local bx=extents.x_bearing
        local by=extents.y_bearing+hy
        local tx=x
        local ty=y
        --set horizontal alignment - l, c, r
        if hj=="l" then
            x=x-bx
        elseif hj=="c" then
            x=x-((wx-bx)/2)-bx
        elseif hj=="r" then
            x=x-wx
        else
            print ("hj not set correctly - l, c, r")
        end
        --vj. n=normal, nb=normal-ybearing, m=middle, mb=middle-ybearing, t=top
        if vj=="n" then
            y=y
        elseif vj=="nb" then
            y=y-by
        elseif vj=="m" then
            y=y+((hy-by)/2)
        elseif vj=="mb" then
            y=y+(hy/2)-by
        elseif vj=="t" then
            y=y+hy-by
        else
            print ("vj not set correctly - n, nb, m, mb, t")
        end
        return face,fs,x,y,rad,rad2,tx,ty
    end--justify local function #########################################################
    --set variables
    local c=txj.c 			or {0xffffff, 1}
    local a=txj.a 			or 1
    local f=txj.f 			or "monospace"
    local fs=txj.fs 	    or 12
    local x=txj.x 		    or 100
    local y=txj.y 			or 100
    local txt=txj.txt 		or "text"
    local hj=txj.hj 		or "l"
    local vj=txj.vj 		or "n"
    local face=txj.face		or "normal"
    --print text ##################################################################
    local face,fs,x,y=justify(txt,x,hj,y,vj,f,face,fs)
    cairo_select_font_face (cr,face[1],face[2],face[3])
    cairo_set_font_size(cr,fs)
    cairo_move_to (cr,x,y)
    cairo_set_source_rgba (cr,rgba_to_r_g_b_a(c))
    cairo_show_text (cr,txt)
    cairo_stroke (cr)
    return nx
end--function ou

function rgba_to_r_g_b_a(tcolor)
	local color,alpha=tcolor[1],tcolor[2]
	return ((color / 0x10000) % 0x100) / 255.,
		((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end --end rgba

function getheight(txt,f,face,fs)
    -- Return the height of text. Needed for proper placement
    local extents=cairo_text_extents_t:create()
    tolua.takeownership(extents)
    if face=="normal" then
        face={f,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL}
    elseif face=="bold" then
        face={f,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD}
    elseif face=="italic" then
        face={f,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_NORMAL}
    elseif face=="bolditalic" then
        face={f,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_BOLD}
    else
        print ('face not set correctly - "normal","bold","italic","bolditalic"')
    end
    cairo_select_font_face (cr,face[1],face[2],face[3])
    cairo_set_font_size(cr,fs)
    cairo_text_extents(cr,txt,extents)
    return extents.height
end -- end getheight

function splitfont(s)
    -- Return font and face
    if s:find(':') then
       return s:match("([^:]+):([^:]+)")
    else
        return s, nil
    end
end -- end splitfont

