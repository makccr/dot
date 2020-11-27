
--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]

--[[BOX WIDGET v1.1 by Wlourf 27/01/2011
This widget can drawn some boxes, even circles in your conky window
http://u-scripts.blogspot.com/2011/01/box-widget.html)

Inspired by Background by londonali1010 (2009), thanks ;-) 

The parameters (all optionals) are :
x           - x coordinate of top-left corner of the box, default = 0 = (top-left corner of conky window)
y           - y coordinate of top-left corner of the box, default = 0 = (top-left corner of conky window)
w           - width of the box, default = width of the conky window
h           - height of the box, default = height of the conky window
corners     - corners is a table for the four corners in this order : top-left, top-right,bottom-right, bottom-left
              each corner is defined in a table with a shape and a radius, available shapes are : "curve","circle","line"
              example for the same shapes for all corners:
              { {"circle",10} }
              example for first corner different from the three others
              { {"circle",10}, {"circle",5}  }              
              example for top corners differents from bottom corners
              { {"circle",10}, {"circle",10}, {"line",0}  }   
              default = { {"line",0} } i.e=no corner
operator    - set the compositing operator (needs in the conkyrc : own_window_argb_visual yes)                          
              see http://cairographics.org/operators/
              available operators are :
              "clear","source","over","in","out","atop","dest","dest_over","dest_in","dest_out","dest_atop","xor","add","saturate"
              default = "over"
border      - if border>0, the script draws only the border, like a frame, default=0
dash        - if border>0 and dash>0, the border is draw with dashes, default=0
skew_x      - skew box around x axis, default = 0
skew_y      - skew box around y axis, default = 0
scale_x     - rescale the x axis, default=1, useful for drawing elipses ...
scale_y     - rescale the x axis, default=1
angle	    - angle of rotation of the box in degrees, default = 0
              i.e. a horizontal graph
rot_x       - x point of rotation's axis, default = 0,
              relative to top-left corner of the box, (not the conky window)
rot_y       - y point of rotation's axis, default = 0              
              relative to top-left corner of the box, (not the conky window)
draw_me     - if set to false, box is not drawn (default = true or 1)
              it can be used with a conky string, if the string returns 1, the box is drawn :
              example : "${if_empty ${wireless_essid wlan0}}${else}1$endif",              
              
linear_gradient - table with the coordinates of two points to define a linear gradient,
                  points are relative to top-left corner of the box, (not the conky window)
                  {x1,y1,x2,y2}
radial_gradient - table with the coordinates of two circle to define a radial gradient,
                  points are relative to top-left corner of the box, (not the conky window)
                  {x1,y1,r1,x2,y2,r2} (r=radius)
colour      - table of colours, default = plain white {{1,0xFFFFFF,0.5}}
              this table contains one or more tables with format {P,C,A}
              P=position of gradient (0 = start of the gradient, 1= end of the gradient)
              C=hexadecimal colour 
              A=alpha (opacity) of color (0=invisible,1=opacity 100%)
              Examples :
              for a plain color {{1,0x00FF00,0.5}}
              for a gradient with two colours {{0,0x00FF00,0.5},{1,0x000033,1}}        {x=80,y=150,w=20,h=20,
        radial_gradient={20,20,0,20,20,20},
        colour={{0.5,0xFFFFFF,1},{1,0x000000,0}},
              or {{0.5,0x00FF00,1},{1,0x000033,1}} -with this one, gradient will start in the middle
              for a gradient with three colours {{0,0x00FF00,0.5},{0.5,0x000033,1},{1,0x440033,1}}
              and so on ...



To call this script in Conky, use (assuming you have saved this script to ~/scripts/):
    lua_load ~/scripts/box.lua
    lua_draw_hook_pre main_box
    
And leave one line blank or not after TEXT

Changelog:
+ v1.0 -- Original release (19.12.2010)
+ v1.1 -- Adding parameters: operator, dash, angle, skew_x, skew_y, draw_me
          corners are described in a table

--      This program is free software; you can redistribute it and/or modify
--      it under the terms of the GNU General Public License as published by
--      the Free Software Foundation version 3 (GPLv3)
--     
--      This program is distributed in the hope that it will be useful,
--      but WITHOUT ANY WARRANTY; without even the implied warranty of
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--      GNU General Public License for more details.
--     
--      You should have received a copy of the GNU General Public License
--      along with this program; if not, write to the Free Software
--      Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
--      MA 02110-1301, USA.		


]]

  
require 'cairo'
    
function conky_main_box()

    if conky_window==nil then return end
    
	---------------------- PARAMETERS BEGIN HERE
    local boxes_settings={

{
	x=10,y=10,w=245,h=638,
	colour= { {1,0x000000,0.66} }, 
        corners={ {"circle",5},},
	},

	{
	x=4,y=4,w=257,h=650,
	colour= { {1,0x34495E,1} }, 
        corners={ {"circle",5},}, border=4 
	},

	{
	x=8,y=8,w=249,h=642,
	colour= { {0,0xFFFFFF,0.05}, {0.5,0xC2C2C2,0.2}, {1,0xFFFFFF,0.05}}, linear_gradient={0,30,0,506},
	},

}

    ---------------------------- PARAMETERS END HERE
    
    local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local cr=cairo_create(cs)
    
    if tonumber(conky_parse("$updates"))<5 then return end
    for i in pairs(boxes_settings) do
        draw_box (cr,boxes_settings[i])
    end
    cairo_destroy(cr)
    cairo_surface_destroy(cs)    
end

    
function draw_box(cr,t)

	if t.draw_me == true then t.draw_me = nil end
	if t.draw_me ~= nil and conky_parse(tostring(t.draw_me)) ~= "1" then return end	

    local table_corners={"circle","curve","line"}

    local t_operators={
        clear   = CAIRO_OPERATOR_CLEAR,
        source  = CAIRO_OPERATOR_SOURCE,
        over    = CAIRO_OPERATOR_OVER,
        ["in"]      = CAIRO_OPERATOR_IN,
        out     = CAIRO_OPERATOR_OUT,
        atop    = CAIRO_OPERATOR_ATOP,
        dest    = CAIRO_OPERATOR_DEST,
        dest_over   = CAIRO_OPERATOR_DEST_OVER,
        dest_in = CAIRO_OPERATOR_DEST_IN,
        dest_out = CAIRO_OPERATOR_DEST_OUT,
        dest_atop = CAIRO_OPERATOR_DEST_ATOP,
        xor = CAIRO_OPERATOR_XOR,
        add = CAIRO_OPERATOR_ADD,
        saturate =  CAIRO_OPERATOR_SATURATE,
    }
        
    function rgba_to_r_g_b_a(tc)
        --tc={position,colour,alpha}
        local colour = tc[2]
        local alpha = tc[3]
        return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
    end

    function table.copy(t)
      local t2 = {}
      for k,v in pairs(t) do
       t2[k] = {v[1],v[2]}
      end
      return t2
    end

    function draw_corner(num,t)
        local shape=t[1]
        local radius=t[2]
        local x,y = t[3],t[4]
        if shape=="line" then
            if num == 1 then cairo_line_to(cr,radius,0) 
                elseif num == 2 then cairo_line_to(cr,x,radius) 
                elseif num == 3 then cairo_line_to(cr,x-radius,y)
                elseif num == 4 then cairo_line_to(cr,0,y-radius)
            end
        end
        if shape=="circle" then
		    local PI = math.pi
           if num == 1 then cairo_arc(cr,radius,radius,radius,-PI,-PI/2)
                elseif num == 2 then cairo_arc(cr,x-radius,y+radius,radius,-PI/2,0)
                elseif num == 3 then cairo_arc(cr,x-radius,y-radius,radius,0,PI/2) 
                elseif num == 4 then cairo_arc(cr,radius,y-radius,radius,PI/2,-PI)
            end
        end
        if shape=="curve" then
            if num == 1 then cairo_curve_to(cr,0,radius ,0,0 ,radius,0) 
                elseif num == 2 then cairo_curve_to(cr,x-radius,0, x,y, x,radius)
                elseif num == 3 then cairo_curve_to(cr,x,y-radius, x,y, x-radius,y)
                elseif num == 4 then cairo_curve_to(cr,radius,y, x,y, 0,y-radius)
            end
        end        
    end   

    --check values and set default values
    if t.x == nil then t.x = 0 end
    if t.y == nil then t.y = 0 end
    if t.w == nil then t.w = conky_window.width end
    if t.h == nil then t.h = conky_window.height end
    if t.radius == nil then t.radius = 0 end
    if t.border == nil then t.border = 0 end
    if t.colour==nil then t.colour={{1,0xFFFFFF,0.5}} end
    if t.linear_gradient ~= nil then 
        if #t.linear_gradient ~= 4 then
            t.linear_gradient = {t.x,t.y,t.width,t.height}
        end
    end 
    if t.angle==nil then t.angle = 0 end

	if t.skew_x == nil then t.skew_x=0  end
	if t.skew_y == nil then  t.skew_y=0 end
	if t.scale_x==nil then t.scale_x=1 end
	if t.scale_y==nil then t.scale_y=1 end	
	if t.rot_x == nil then t.rot_x=0  end
	if t.rot_y == nil then  t.rot_y=0 end
    
    if t.operator == nil then t.operator = "over" end
    if (t_operators[t.operator]) == nil then
        print ("wrong operator :",t.operator)
        t.operator = "over"
    end
    
    if t.radial_gradient ~= nil then 
        if #t.radial_gradient ~= 6 then
            t.radial_gradient = {t.x,t.y,0, t.x,t.y, t.width}
        end
    end 
    
    for i=1, #t.colour do    
        if #t.colour[i]~=3 then 
            print ("error in color table")
            t.colour[i]={1,0xFFFFFF,1} 
        end
    end

    if t.corners == nil then t.corners={ {"line",0} } end
    local t_corners = {}
    local t_corners = table.copy(t.corners)
    --don't use t_corners=t.corners otherwise t.corners is altered

    --complete the t_corners table if needed
    for i=#t_corners+1,4 do    
        t_corners[i]=t_corners[#t_corners]
        local flag=false
        for j,v in pairs(table_corners) do flag=flag or (t_corners[i][1]==v) end 
        if not flag then print ("error in corners table :",t_corners[i][1]);t_corners[i][1]="curve"  end
    end

    --this way :    
    --    t_corners[1][4]=x    
    --    t_corners[2][3]=y
    --doesn't work
    t_corners[1]={t_corners[1][1],t_corners[1][2],0,0}
    t_corners[2]={t_corners[2][1],t_corners[2][2],t.w,0}
    t_corners[3]={t_corners[3][1],t_corners[3][2],t.w,t.h}    
    t_corners[4]={t_corners[4][1],t_corners[4][2],0,t.h}        

    t.no_gradient = (t.linear_gradient == nil ) and (t.radial_gradient == nil )

    cairo_save(cr)
    cairo_translate(cr, t.x, t.y)
    if t.rot_x~=0 or t.rot_y~=0 or t.angle~=0 then
        cairo_translate(cr,t.rot_x,t.rot_y)
        cairo_rotate(cr,t.angle*math.pi/180)
        cairo_translate(cr,-t.rot_x,-t.rot_y)
    end
    if t.scale_x~=1 or t.scale_y~=1 or t.skew_x~=0 or t.skew_y~=0 then
	    local matrix0 = cairo_matrix_t:create()
	    tolua.takeownership(matrix0)
	    cairo_matrix_init (matrix0, t.scale_x,math.pi*t.skew_y/180	, math.pi*t.skew_x/180	,t.scale_y,0,0)
	    cairo_transform(cr,matrix0)    
    end
    
    local tc=t_corners
    cairo_move_to(cr,tc[1][2],0)
    cairo_line_to(cr,t.w-tc[2][2],0)
    draw_corner(2,tc[2])
    cairo_line_to(cr,t.w,t.h-tc[3][2])
    draw_corner(3,tc[3])
    cairo_line_to(cr,tc[4][2],t.h)
    draw_corner(4,tc[4])
    cairo_line_to(cr,0,tc[1][2])
    draw_corner(1,tc[1])
    
    if t.no_gradient then
        cairo_set_source_rgba(cr,rgba_to_r_g_b_a(t.colour[1]))
    else
        if t.linear_gradient ~= nil then
            pat = cairo_pattern_create_linear (t.linear_gradient[1],t.linear_gradient[2],t.linear_gradient[3],t.linear_gradient[4])
        elseif t.radial_gradient ~= nil then
            pat = cairo_pattern_create_radial (t.radial_gradient[1],t.radial_gradient[2],t.radial_gradient[3],
            	t.radial_gradient[4],t.radial_gradient[5],t.radial_gradient[6])
        end
        for i=1, #t.colour do
            cairo_pattern_add_color_stop_rgba (pat, t.colour[i][1], rgba_to_r_g_b_a(t.colour[i]))
        end
        cairo_set_source (cr, pat)
        cairo_pattern_destroy(pat)
    end 
     
    cairo_set_operator(cr,t_operators[t.operator]) 

    if t.border>0 then
        cairo_close_path(cr)
        if t.dash ~= nil then cairo_set_dash(cr, t.dash, 1, 0.0) end
        cairo_set_line_width(cr,t.border)
        cairo_stroke(cr)
    else
        cairo_fill(cr)
    end

    cairo_restore(cr)
end

