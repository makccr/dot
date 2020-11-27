--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]


--[[TEXT WIDGET v1.3 by Wlourf 25/06/2010
This widget can drawn texts set in the "text_settings" table with some parameters
http://u-scripts.blogspot.com/2010/06/text-widget.html

The parameters (all optionals) are :
text        - text to display, default = "Conky is good for you"
			  use conky_parse to display conky value ie text=conly_parse("${cpu cpu1}")
            - coordinates below are relative to top left corner of the conky window
x           - x coordinate of first letter (bottom-left), default = center of conky window
y           - y coordinate of first letter (bottom-left), default = center of conky window
h_align		- horizontal alignement of text relative to point (x,y), default="l"
			  available values are "l": left, "c" : center, "r" : right
v_align		- vertical alignment of text relative to point (x,y), default="b"
			  available values "t" : top, "m" : middle, "b" : bottom
font_name   - name of font to use, default = Free Sans
font_size   - size of font to use, default = 14
italic      - display text in italic (true/false), default=false
oblique     - display text in oblique (true/false), default=false (I don' see the difference with italic!)
bold        - display text in bold (true/false), default=false
angle       - rotation of text in degrees, default = 0 (horizontal)
colour      - table of colours for text, default = plain white {{1,0xFFFFFF,1}}
			  this table contains one or more tables with format {P,C,A}
              P=position of gradient (0 = beginning of text, 1= end of text)
              C=hexadecimal colour 
              A=alpha (opacity) of color (0=invisible,1=opacity 100%)
              Examples :
              for a plain color {{1,0x00FF00,0.5}}
              for a gradient with two colours {{0,0x00FF00,0.5},{1,0x000033,1}}
              or {{0.5,0x00FF00,1},{1,0x000033,1}} -with this one, gradient will start in the middle of the text
              for a gradient with three colours {{0,0x00FF00,0.5},{0.5,0x000033,1},{1,0x440033,1}}
			  and so on ...
orientation	- in case of gradient, "orientation" defines the starting point of the gradient, default="ww"
			  there are 8 available starting points : "nw","nn","ne","ee","se","ss","sw","ww"
			  (n for north, w for west ...)
			  theses 8 points are the 4 corners + the 4 middles of text's outline
			  so a gradient "nn" will go from "nn" to "ss" (top to bottom, parallele to text)
			  a gradient "nw" will go from "nw" to "se" (left-top corner to right-bottom corner)
radial		- define a radial gradient (if present at the same time as "orientation", "orientation" will have no effect)
			  this parameter is a table with 6 numbers : {xa,ya,ra,xb,yb,rb}
			  they define two circle for the gradient :
			  xa, ya, xb and yb are relative to x and y values above
reflection_alpha    - add a reflection effect (values from 0 to 1) default = 0 = no reflection
                      other values = starting opacity
reflection_scale    - scale of the reflection (default = 1 = height of text)
reflection_length   - length of reflection, define where the opacity will be set to zero
					  calues from 0 to 1, default =1
skew_x,skew_y    - skew text around x or y axis
			  

Needs conky 1.8.0 

To call this script in the conkyrc, in before-TEXT section:
    lua_load /path/to/the/lua/script/text.lua
    lua_draw_hook_pre draw_text
 
v1.0	07/06/2010, Original release
v1.1	10/06/2010	Add "orientation" parameter
v1.2	15/06/2010  Add "h_align", "v_align" and "radial" parameters
v1.3	25/06/2010  Add "reflection_alpha", "reflection_length", "reflection_scale", 
                    "skew_x" et "skew_y"


]]
require 'cairo'

function conky_draw_text()
	--BEGIN OF PARAMETRES
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height
		local xc=w/2
		local yc=h/2
   		local color1={{0,0xE7660B,1}}
		local color2={{0,0xFAAD3E,1}}
		local color3={{0,0xDCE142,1}}

    text_settings={

		{
			text=conky_parse("${if_existing /usr/bin/lsb_release} ${execi 10000 lsb_release -d | cut -f 2}${else} $distribution  ${endif}"),
			font_name="ubuntu",
			font_size=22,
			h_align="c",
			x=xc,
			y=35,
			colour=color1,
		},

		{
			text=conky_parse( "$sysname ${kernel}" ),
			x=20,
			y=55,
			colour=color2,
		},

		{
			text=conky_parse( "Uptime:       ${uptime}" ),
			x=20,
			y=72,
			colour=color2,
		},
        
        {
			text=conky_parse("${execi 6000 cat /proc/cpuinfo | grep -i 'Model name' -m 1 | cut -c14-43}"),
			x=20,
			y=92,
			colour=color2,
		},

		{
			text=conky_parse("CPU: ${execi 5 sensors|grep 'Package'|awk '{print $4}'}  ${cpu cpu1}%"),
			h_align="c",
			x=xc,
			y=117,
			colour=color2,
		},

		{
			text="Memory",
			h_align="c",
			x=xc,
			y=200,
			colour=color3,
		},

		{
			text=conky_parse("Used ${mem}                         Free ${memeasyfree}"),

			x=20,
			y=216,
			colour=color2,
		},

		{
			text="Disks",
			h_align="c",
			x=xc,
			y=266,
			colour=color3,
		},

		{
			text=conky_parse("Root Used ${fs_used /}              Free ${fs_free /}"),
			x=20,
			y=285,
			colour=color2,
		},

		{
			text=conky_parse("Home Used ${fs_used /home/}           Free ${fs_free /home/}"),
			x=20,
			y=320,
			colour=color2,
		},

		{
			text="Network speed",
			h_align="c",
			x=xc,
			y=360,
			colour=color3,
		},

		{
			text="Up",
			x=23,
			y=380,
			colour=color2,
		},
		{
			text=conky_parse(var_NETUP),
			h_align="r",            
			x=120,
			y=380,
			colour=color2,
		},
        
   		{
			text="Down",
			x=142,
			y=380,
			colour=color2,
		},
		{
			text=conky_parse(var_NETDOWN),
			h_align="r",            
			x=240,
			y=380,
			colour=color2,
		},     
        
        {
			text="Total",
			x=23,
			y=442,
			colour=color2,
		},

        {
			text=conky_parse(var_TOTALUP),
			h_align="r",            
			x=120,
			y=442,
			colour=color2,
		},

        {
			text="Total",
			x=142,
			y=442,
			colour=color2,
		},

        {
			text=conky_parse(var_TOTALDOWN),
			h_align="r",            
			x=240,
			y=442,
			colour=color2,
		},
        
		{
			text="Processes",
			h_align="c",
			x=xc,
			y=464,
			colour=color3,
		},

		{text=conky_parse("${top name 1}"),x=20,y=480,colour={{0,0X42E147,1}},font_size=16,},  
		{text=conky_parse("${top name 2}"),x=20,y=498,colour={{0,0X42E147,0.85}},font_size=16,},
		{text=conky_parse("${top name 3}"),x=20,y=516,colour={{0,0X42E147,0.70}},font_size=16,},
		{text=conky_parse("${top name 4}"),x=20,y=534,colour={{0,0X42E147,0.55}},font_size=16,},
		{text=conky_parse("${top name 5}"),x=20,y=552,colour={{0,0X42E147,0.40}},font_size=16,},
		{text=conky_parse("${top name 6}"),x=20,y=570,colour={{0,0X42E147,0.25}},font_size=16,},
        

		{text=conky_parse("${top cpu 1}%"),x=228,y=480,h_align="r",colour={{0,0X42E147,1}},font_size=16,},
		{text=conky_parse("${top cpu 2}%"),x=228,y=498,h_align="r",colour={{0,0X42E147,0.85}},font_size=16,},
		{text=conky_parse("${top cpu 3}%"),x=228,y=516,h_align="r",colour={{0,0X42E147,0.70}},font_size=16,},
		{text=conky_parse("${top cpu 4}%"),x=228,y=534,h_align="r",colour={{0,0X42E147,0.55}},font_size=16,},
		{text=conky_parse("${top cpu 5}%"),x=228,y=552,h_align="r",colour={{0,0X42E147,0.40}},font_size=16,},
		{text=conky_parse("${top cpu 6}%"),x=228,y=570,h_align="r",colour={{0,0X42E147,0.25}},font_size=16,},

        
   		{
			text=conky_parse("Available updates: ${execi 3000 checkupdates | wc -l}"),
			h_align="c",
			x=xc,
			y=620,
            font_size=12,
			colour=color3,
		},
	}


    
--------------END OF PARAMETERES----------------
    if conky_window == nil then return end
    if tonumber(conky_parse("$updates"))<3 then return end
       
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

    for i,v in pairs(text_settings) do    
        cr = cairo_create (cs)
        display_text(v)
        cairo_destroy(cr)
    end
    
    cairo_surface_destroy(cs)
    


end

function rgb_to_r_g_b2(tcolour)
    colour,alpha=tcolour[2],tcolour[3]
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function display_text(t)

    local function set_pattern()
        --this function set the pattern
        if #t.colour==1 then 
            cairo_set_source_rgba(cr,rgb_to_r_g_b2(t.colour[1]))
        else
            local pat
            
            if t.radial==nil then
                local pts=linear_orientation(t,te)
                pat = cairo_pattern_create_linear (pts[1],pts[2],pts[3],pts[4])
            else
                pat = cairo_pattern_create_radial (t.radial[1],t.radial[2],t.radial[3],t.radial[4],t.radial[5],t.radial[6])
            end
        
            for i=1, #t.colour do
                cairo_pattern_add_color_stop_rgba (pat, t.colour[i][1], rgb_to_r_g_b2(t.colour[i]))
            end
            cairo_set_source (cr, pat)
        end
    end
    
    --set default values if needed
    if t.text==nil then t.text="Conky is good for you !" end
    if t.x==nil then t.x = conky_window.width/2 end
    if t.y==nil then t.y = conky_window.height/2 end
    if t.colour==nil then t.colour={{0,0XFFFFFF,1},{0.6,0xFFFFFF,0.7}, {1,0xFFFFFF,0.2}} end
    if t.font_name==nil then t.font_name="ubuntu" end
    if t.font_size==nil then t.font_size=14 end
    if t.angle==nil then t.angle=0 end
    if t.italic==nil then t.italic=false end
    if t.oblique==nil then t.oblique=false end
    if t.bold==nil then t.bold=false end
    if t.radial ~= nil then
        if #t.radial~=6 then 
            print ("error in radial table")
            t.radial=nil 
        end
    end
    if t.orientation==nil then t.orientation="nn" end
    if t.h_align==nil then t.h_align="l" end
    if t.v_align==nil then t.v_align="b" end    
    if t.reflection_alpha == nil then t.reflection_alpha=0 end
    if t.reflection_length == nil then t.reflection_length=1 end
    if t.reflection_scale == nil then t.reflection_scale=1 end
    if t.skew_x==nil then t.skew_x=0 end
    if t.skew_y==nil then t.skew_y=0 end    
    cairo_translate(cr,t.x,t.y)
    cairo_rotate(cr,t.angle*math.pi/180)
    cairo_save(cr)       
     
 

    local slant = CAIRO_FONT_SLANT_NORMAL
    local weight =CAIRO_FONT_WEIGHT_NORMAL
    if t.italic then slant = CAIRO_FONT_SLANT_ITALIC end
    if t.oblique then slant = CAIRO_FONT_SLANT_OBLIQUE end
    if t.bold then weight = CAIRO_FONT_WEIGHT_BOLD end
    
    cairo_select_font_face(cr, t.font_name, slant,weight)
 
    for i=1, #t.colour do    
        if #t.colour[i]~=3 then 
            print ("error in color table")
            t.colour[i]={1,0xFFFFFF,1} 
        end
    end

    local matrix0 = cairo_matrix_t:create()
    skew_x,skew_y=t.skew_x/t.font_size,t.skew_y/t.font_size
    cairo_matrix_init (matrix0, 1,skew_y,skew_x,1,0,0)
    cairo_transform(cr,matrix0)
    cairo_set_font_size(cr,t.font_size)
    te=cairo_text_extents_t:create()
    cairo_text_extents (cr,t.text,te)
    
    set_pattern()


            
    mx,my=0,0
    
    if t.h_align=="c" then
        mx=-te.width/2
    elseif t.h_align=="r" then
        mx=-te.width
    end
    if t.v_align=="m" then
        my=-te.height/2-te.y_bearing
    elseif t.v_align=="t" then
        my=-te.y_bearing
    end
    cairo_move_to(cr,mx,my)
    
    cairo_show_text(cr,t.text)

     
        
        
   if t.reflection_alpha ~= 0 then 
        local matrix1 = cairo_matrix_t:create()
        cairo_set_font_size(cr,t.font_size)

        cairo_matrix_init (matrix1,1,0,0,-1*t.reflection_scale,0,(te.height+te.y_bearing+my)*(1+t.reflection_scale))
        cairo_set_font_size(cr,t.font_size)
        te=cairo_text_extents_t:create()
        cairo_text_extents (cr,t.text,te)
        
                
        cairo_transform(cr,matrix1)
        set_pattern()
        cairo_move_to(cr,mx,my)
        cairo_show_text(cr,t.text)

        local pat2 = cairo_pattern_create_linear (0,
                                        (te.y_bearing+te.height+my),
                                        0,
                                        te.y_bearing+my)
        cairo_pattern_add_color_stop_rgba (pat2, 0,1,0,0,1-t.reflection_alpha)
        cairo_pattern_add_color_stop_rgba (pat2, t.reflection_length,0,0,0,1)    
        
        
        cairo_set_line_width(cr,1)
        dy=te.x_bearing
        if dy<0 then dy=dy*(-1) end
        cairo_rectangle(cr,mx+te.x_bearing,te.y_bearing+te.height+my,te.width+dy,-te.height*1.05)
        cairo_clip_preserve(cr)
        cairo_set_operator(cr,CAIRO_OPERATOR_CLEAR)
        --cairo_stroke(cr)
        cairo_mask(cr,pat2)
        cairo_pattern_destroy(pat2)
        cairo_set_operator(cr,CAIRO_OPERATOR_OVER)
    end
    
end


function linear_orientation(t,te)
    local w,h=te.width,te.height
    local xb,yb=te.x_bearing,te.y_bearing
    
    if t.h_align=="c" then
        xb=xb-w/2
    elseif t.h_align=="r" then
        xb=xb-w
       end    
    if t.v_align=="m" then
        yb=-h/2
    elseif t.v_align=="t" then
        yb=0
       end    
       
    if t.orientation=="nn" then
        p={xb+w/2,yb,xb+w/2,yb+h}
    elseif t.orientation=="ne" then
        p={xb+w,yb,xb,yb+h}
    elseif t.orientation=="ww" then
        p={xb,h/2,xb+w,h/2}
    elseif vorientation=="se" then
        p={xb+w,yb+h,xb,yb}
    elseif t.orientation=="ss" then
        p={xb+w/2,yb+h,xb+w/2,yb}
    elseif vorientation=="ee" then
        p={xb+w,h/2,xb,h/2}        
    elseif t.orientation=="sw" then
        p={xb,yb+h,xb+w,yb}
    elseif t.orientation=="nw" then
        p={xb,yb,xb+w,yb+h}
    end
    return p
end
