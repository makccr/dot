
require 'cairo'

--[[CLOCK SHADED WIDGET by wlourf
	http://u-scripts.blogspot.com/
	This clock is designed to draw only hands with some shadows and a small dot in the center.

	Was originaly based on  Air Clock by londonali (2009)

	You can adjust the clock's radius for each hand, as well as the size and offset of the drop shadow.
	You can also choose whether to display the seconds hand. 
	This clock updates every time Conky does, so if you want to show seconds, it is recommended that you set update_interval to no more than 0.5s.
	If you turn off seconds, you can set the update_interval to as long as 30s.

Call this script in Conky using the following before TEXT (assuming you save this script to ~/scripts/clock/clock.lua):
	lua_load ~/scripts/clock/clock.lua
	lua_draw_hook_pre main

-- 10 jan. 2010 v1.0 original release
   07 feb. 2010 v1.1 turn the clock into a widget + some improvments
   06 apr. 2010 v1.2 the surface is now created in the clock_widget function, before it was in the main function
	
	
	== PARAMETERS ==
	
	clock_r 	= Radius of the clock, in pixels
	xc, yc 		= x and y coordinates of center, relative to the top left corner of Conky, in pixels
	
	rh, lgh, fgh, bosh, bofgh, shadh,
	rm, lgm, fgm, bosm, bofgm, shadm,
	rs, lgs, fgs, boss, bofgs, shads,
	--r.    = radius of footer of hand
	--lg.   = length of hand (it's a kind of proportion of clock_r, not pixels
	--        a value of 2 is close to the radius )
	--fg.   = foreground color of hand (can be nil)
	--bos.  = border size of hand (can be zero)
	--bofg. = border foreground color (can be nil)
	--shad. = shadow foreground color (can be nil) 
	
	show_seconds [true/false]	display seconds hand ?
	 
	shadow_xoffset, shadow_yoffset
	-- x and y offsets of the drop shadow, relative to the centre of the clock face, in pixels. 
	-- Can be positive (downward) or negative (upward)	
	shadow_opacity [0 to 1]  	set the opacity of the shadow
	
	dot_pc,dot_color,dot_shadow_color,shadow_length
	-- dot_pc [0 to 1] 	is the size of the dot percent of the minimum radius (rh,rm,rs)
    -- dot_color = the foreground color of the dot
    -- dot_shadow_color = the foreground color of the shadow of the dot
    -- shadow_length =  length of the shadow

]]

function clock_widget(clock_r,xc,yc,
	rh, lgh, fgh, bosh, bofgh, shadh,
	rm, lgm, fgm, bosm, bofgm, shadm,
	rs, lgs, fgs, boss, bofgs, shads,
	show_seconds,
	shadow_xoffset,shadow_yoffset,
	shadow_opacity,
	dot_pc,dot_color,dot_shadow_color,shadow_length
)

	local w=conky_window.width
	local h=conky_window.height
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr=cairo_create(cs)
	
	
	--local to global
	g_clock_r=clock_r
	g_xc,g_yc=xc,yc
	g_shadow_xoffset,g_shadow_yoffset,g_shadow_opacity=shadow_xoffset,shadow_yoffset,shadow_opacity
	
	-- Grab time
	local hours=os.date("%I")
	local mins=os.date("%M")
	local secs=os.date("%S")

	--angles needed to draw the hands	
	gamma = math.pi/2-math.atan(rs/(clock_r*lgs))
	secs_arc=(2*math.pi/60)*secs
	secs_arc0=secs_arc-gamma
	secs_arc1=secs_arc+gamma
	
	gamma = math.pi/2-math.atan(rm/(clock_r*lgm))
	mins_arc=(2*math.pi/60)*mins + secs_arc/60
	mins_arc0=mins_arc-gamma
	mins_arc1=mins_arc+gamma
	
	gamma = math.pi/2-math.atan(rh/(clock_r*lgh))
	hours_arc=(2*math.pi/12)*hours+mins_arc/12
	hours_arc0=hours_arc-gamma
	hours_arc1=hours_arc+gamma

	--draw hands
	draw_hand(hours_arc,hours_arc0,hours_arc1,lgh,rh,fgh,bosh,bofgh,shadh)
	draw_hand(mins_arc, mins_arc0, mins_arc1, lgm,rm,fgm,bosm,bofgm,shadm)
	
	if show_seconds then
		draw_hand(secs_arc, secs_arc0, secs_arc1, lgs,rs,fgs,boss,bofgs,shads)
	end
	
	if dot_pc>0 then
		--draw dot center
		lg_shadow_center=5
		radius=math.min(rh,rm,rs)*dot_pc
		if radius<1 then radius=1 end
		ang = math.atan(shadow_yoffset/ shadow_xoffset)
		
		if shadow_xoffset>=0 then ang=ang+math.pi/2 end
		if shadow_xoffset<0 then ang=ang-math.pi/2 end

		x0 = xc + radius*math.sin(ang-math.pi/2)
		y0 = yc - radius*math.cos(ang-math.pi/2)
		xx = xc + (radius)*math.sin(ang-math.pi)*shadow_length
		yy = yc - (radius)*math.cos(ang-math.pi)*shadow_length
		x1 = xc - radius*math.sin(ang-math.pi/2)
		y1 = yc + radius*math.cos(ang-math.pi/2)

		cairo_move_to(cr,x0,y0)
		cairo_curve_to(cr,x0,y0,xx,yy,x1,y1)

		pat = cairo_pattern_create_radial (xc, yc, 0,
		                           			xc,yc, radius*2);

		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(dot_shadow_color,shadow_opacity));
		cairo_pattern_add_color_stop_rgba (pat, 1, rgb_to_r_g_b(dot_shadow_color,0));
		cairo_set_source (cr, pat);
		cairo_fill (cr);

		--gradient inside the dot circle
		xshad = xc + radius*math.sin(ang)*.5
		if shadow_xoffset==0 then xshad = xc  end
		yshad = yc - radius*math.cos(ang)*.5
		if shadow_yoffset==0 then yshad = yc  end
		local ds_pat=cairo_pattern_create_radial(xc,yc,0,
			xshad,yshad,radius)
		cairo_pattern_add_color_stop_rgba(ds_pat,0,rgb_to_r_g_b(dot_color,1))
		cairo_pattern_add_color_stop_rgba(ds_pat,1,0,0,0,1)

		cairo_arc(cr,xc,yc,radius,0,2*math.pi)
		cairo_set_source(cr,ds_pat)
		cairo_fill(cr)
	end
	
	cairo_select_font_face (cr, "Sans", CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
	cairo_set_font_size (cr, 12.0);

	cairo_destroy(cr)
	
end 

function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255.,alpha
end


function draw_hand(arc,arc0,arc1,lg,r,fg_color,border_size,border_color,shadow_color)
	--global to local
	xc=g_xc
	yc=g_yc
	clock_r=g_clock_r
	shadow_xoffset,shadow_yoffset,shadow_opacity=g_shadow_xoffset,g_shadow_yoffset,g_shadow_opacity
	
	--calculs
	xx = xc + clock_r*math.sin(arc)*lg
	yy = yc - clock_r*math.cos(arc)*lg
	x0 = xc + r*math.sin(arc0)
	y0 = yc - r*math.cos(arc0)
	x1 = xc + r*math.sin(arc1)
	y1 = yc - r*math.cos(arc1)
	
	--shadow
	--shadow header
	if shadow_color ~= nil then
		cairo_move_to (cr, x0, y0)
		cairo_curve_to (cr, x0, y0, xx-shadow_xoffset, yy-shadow_yoffset, x1, y1)
		--shadow footer
		cairo_arc(cr,xc,yc,r,arc1-math.pi/2,arc0-math.pi/2)	
		pat = cairo_pattern_create_radial (xc, yc, 0,
		                           			xc,yc, (clock_r/2)*lg)
		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(shadow_color,shadow_opacity))
		cairo_pattern_add_color_stop_rgba (pat, 1, 0, 0, 0, 0)
		cairo_set_source (cr, pat)
		cairo_fill (cr)
	end	
	
	--border
	if border_size>0 and border_color~=nil then
		cairo_set_line_width(cr,border_size)
		pat = cairo_pattern_create_radial (xc, yc, clock_r/10,
		                           			xc,yc, clock_r*lg)
		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(border_color,1))
		cairo_pattern_add_color_stop_rgba (pat, 0.75, 0, 0, 0, 1)
		cairo_set_source (cr, pat)
		--header
		cairo_move_to (cr, x0, y0)
		cairo_curve_to (cr, x0, y0, xx, yy, x1, y1)
		--footer
		cairo_arc(cr,xc,yc,r,arc1-math.pi/2,arc0-math.pi/2)
		cairo_stroke(cr)
	end	

	if border_size>0 and border_color==nil then
		print ("Error : try to draw a border with color set to nil")
	end	
	
	--hand
	--hand header
	if fg_color ~= nil then
		cairo_move_to (cr, x0, y0)
		cairo_curve_to (cr, x0, y0, xx, yy, x1, y1)
		--hand footer
		cairo_arc(cr,xc,yc,r,arc1-math.pi/2,arc0-math.pi/2)	
		pat = cairo_pattern_create_radial (xc, yc, clock_r/10,
		                           			xc,yc, clock_r*lg)
		cairo_pattern_add_color_stop_rgba (pat, 0, rgb_to_r_g_b(fg_color,1))
		cairo_pattern_add_color_stop_rgba (pat, 0.75, 0, 0, 0, 1)
		cairo_set_source (cr, pat)
		cairo_fill (cr)
	end
	cairo_pattern_destroy (pat)
	
end
--]] END OF WIDGET


--main function
function conky_main_clock()
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height
    local yc=h/2

	--the black with colored colors and shadows
	clock_widget(
		50,70,yc,						--radius, xc, yc
		9,2,0x000000,5,0xFFFF00,0xFFFF00, --h: radius, lg, color, border size, border_color, shadow_color
		7,2,0x000000,5,0x00FF00,0x00FF00,  --m; the same
		5,2,0x000000,5,0xFF00FF,0xFF00FF, --s : the same
		true,							    --show second hand	
		20,20,1, 							--shadow x , y & opacity 
		0,0x000000,0x000000,0 				--dot percent, color and shadow color and shadow length
		)

	
end
