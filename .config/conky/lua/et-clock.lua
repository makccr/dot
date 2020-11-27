--[[
Original script Nexus Clock by ansem_of_nexus with various script by MrPeachy too
Edited & Modified by Etles_Team (23 June 2016 - 10 July 2017)

This command to load lua script in conky:
lua_load ~/.conky/Conky-Name/scripts/lua/clock.lua
lua_draw_hook_pre conky_clock

TEXT

]]

require 'cairo'

extents=cairo_text_extents_t:create()
tolua.takeownership(extents)

function conky_clock()
if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
cr = cairo_create(cs)
local updates=tonumber(conky_parse('${updates}'))
if updates>1 then

--#################################################
--#################### Settings ###################
--#################################################
center_x=110
center_y=110
--default option style is 1
style_set=1

--[[ COLOR SETTINGS ]]
--font color
d_font_red=1
d_font_green=1
d_font_blue=1
d_font_alpha=1

--border color
br_red=.65
br_green=.5
br_blue=.1
br_alpha=1

--background color
bg_red=.01
bg_green=.01
bg_blue=.08
bg_alpha=1

--light hands color for second
lights_red=1.0
lights_green=.8
lights_blue=.0
lights_alpha=1

--light hands color for hour & minutes
lights_red1=1.0
lights_green1=.6
lights_blue1=.0
lights_alpha1=1

--######################################################################
--########################### Style Sets ###############################
--######################################################################
if style_set == 1
then
clock_face=1
hours=12
lights=1
texts=1
seconds=5
end

--######################################################################
--########################### Strings ##################################
--######################################################################
d_line_width=1
d_math=math.pi/180
--radius clock face
outer_radius=100
second=tonumber(conky_parse("${time %S}"))
minute=tonumber(conky_parse("${time %M}"))
if hours == 12 then
hour=tonumber(conky_parse("${time %I}"))
i_start=1
i_end=12
end

--######################################################################
-- ###################### Clock Face one ###############################
--######################################################################
if clock_face == 1 then
-- Background and Border styles
cairo_set_line_width(cr)
cairo_arc(cr,center_x,center_y,outer_radius-5,(-90*d_math),(270*d_math))
cairo_arc_negative(cr,center_x,center_y,(outer_radius-63),(270*d_math),(-90*d_math)) --default other_radius "-35"
cairo_set_source_rgba(cr,bg_red,bg_green,bg_blue,bg_alpha)
cairo_fill_preserve(cr)
cairo_set_source_rgba(cr,br_red,br_green,br_blue,br_alpha)
cairo_stroke(cr)

-- Seconds
second_radius1=outer_radius-5.9 --2.2
second_radius2=second_radius1-9
for i=0,59 do
second_start=((i*(360/60))*d_math)
second_end=second_start+((360/60)*d_math)
second_start_math=(second_end-second_start)/2
second_start1=second_start-second_start_math-(90*d_math)
second_end1=second_start1+((360/60)*d_math)
cairo_set_line_width(cr,d_line_width)
cairo_arc(cr,center_x,center_y,second_radius1,second_start1,second_end1)
cairo_arc_negative(cr,center_x,center_y,second_radius2,second_end1,second_start1)
cairo_close_path(cr)
if lights == 1 then
if i == second then
cairo_set_source_rgba(cr,lights_red,lights_green,lights_blue,lights_alpha)
cairo_fill_preserve(cr)
end
end--lights
cairo_set_source_rgba(cr,.35,.35,.35,0.5)
cairo_stroke(cr)
end--for seconds end

-- Minutes
for i=0,59 do
minute_radius=second_radius2-9.5 --10
minute_start=((i*(360/60))*d_math)
minute_end=minute_start+((360/60)*d_math)
minute_start_math=(minute_end-minute_start)/2
minute_start1=minute_start-minute_start_math-(90*d_math)
minute_end1=minute_start1+((360/60)*d_math)
cairo_set_line_width(cr,d_line_width)
cairo_arc(cr,center_x,center_y,second_radius2,minute_start1,minute_end1)
cairo_arc_negative(cr,center_x,center_y,minute_radius,minute_end1,minute_start1)
cairo_close_path(cr)
if lights == 1 then
if i == minute then
cairo_set_source_rgba(cr,lights_red1,lights_green1,lights_blue1,lights_alpha1)
cairo_fill_preserve(cr)
end
end--lights
cairo_set_source_rgba(cr,.35,.35,.35,0.5)
cairo_stroke(cr)
end--for minutes end

-- Hours
for i=i_start,i_end do
hour_radius=minute_radius-15 --default radius -10
hour_start=((i*(360/hours))*d_math)
hour_end=hour_start+((360/hours)*d_math)
hour_start_math=((hour_end-hour_start)/2)
hour_start1=hour_start-hour_start_math-(90*d_math)
hour_end1=hour_start1+((360/hours)*d_math)
cairo_set_line_width(cr,d_line_width)
cairo_arc(cr,center_x,center_y,minute_radius,hour_start1,hour_end1)
cairo_arc_negative(cr,center_x,center_y,hour_radius,hour_end1,hour_start1)
cairo_close_path(cr)
if lights == 1 then
if i == hour then
cairo_set_source_rgba(cr,lights_red1,lights_green1,lights_blue1,lights_alpha1)
cairo_fill_preserve(cr)
end
end --lights
cairo_set_source_rgba(cr,.35,.35,.35,0.5)
cairo_stroke(cr)
end --for hours end

--######################################################################
--########################### mrpeacy code #############################
--######################################################################
if texts==1 then
cairo_set_source_rgba(cr,d_font_red,d_font_green,d_font_blue,d_font_alpha)
if i==0 or i==2 or i==4 or i==6 or i==8 or i==10 or i==12 then
end --for

--else
if hours==0 then
for i=1,12 do
x,y=pt(center_x,center_y,(hour_radius+7),((360/12)*i))
text({y=y,x=x,t=i,hj="c",vj="m"})
end --for
end --hours

if seconds==5 then
for i=0,59 do
if i==0 or i==5 or i==10 or i==15 or i==20 or i==25 or i==30 or i==35 or i==40 or i==45 or i==50 or i==55 then
x,y=pt(center_x,center_y,(second_radius2+-35),((360/60)*i))
text({y=y,x=x,t=i,hj="c",vj="m"})
end
end --for

elseif seconds==10 then
for i=0,59 do
if i==0 or i==10 or i==20 or i==30 or i==40 or i==50 then
x,y=pt(center_x,center_y,(second_radius2),((360/60)*i))
text({y=y,x=x,t=i,hj="c",vj="m"})
end
end --for

elseif seconds==15 then
for i=0,59 do
if i==0 or i==15 or i==30 or i==45 then
x,y=pt(center_x,center_y,(second_radius2),((360/60)*i))
text({y=y,x=x,t=i,hj="c",vj="m"})
end
end --for
end --second
cairo_stroke(cr)
end --texts
end --clock face one
end --if updates>1

cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
end --end main function

--######################################################################
--########################### mrpeacy code #############################
--######################################################################
function pt(px,py,prad,pdeg)
local ppo=(math.pi/180)*pdeg
local px1=px+prad*(math.sin(ppo))
local py1=py-prad*(math.cos(ppo))
return px1,py1
end

function font(fontt)
local name=fontt.f	or default_font_name	or "Ubuntu"
local size=fontt.fs	or default_font_size	or 12
local face=fontt.ff	or default_font_face	or "n"
if face=="n" then
cairo_select_font_face(cr,name,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
elseif face=="b" then
cairo_select_font_face(cr,name,CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_BOLD)
elseif face=="i" then
cairo_select_font_face(cr,name,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_NORMAL)
elseif face=="bi" then
cairo_select_font_face(cr,name,CAIRO_FONT_SLANT_ITALIC,CAIRO_FONT_WEIGHT_BOLD)
end
cairo_set_font_size(cr,size)
end

function hexcolor(hexcolort)
local col=hexcolort.c	or default_hex_color	or 0xffffff
local a=hexcolort.a	or default_alpha	or 1
local r,g,b=((col/0x10000) % 0x100)/255,((col/0x100) % 0x100)/255,(col % 0x100)/255
cairo_set_source_rgba(cr,r,g,b,a)
end

function text(textt)
local x=textt.x 		or 100
local y=textt.y 		or 100
local t=textt.t 		or "set txt"
local hj=textt.hj 		or default_horizontal_justify		or "l"
local vj=textt.vj 		or default_vertical_justify		or "n"
local r=textt.r			or default_rotation			or 0
cairo_text_extents(cr,t,extents)
local wx=extents.x_advance
local wd=extents.width
local hy=extents.height
local bx=extents.x_bearing
local by=extents.y_bearing+hy
--hl-- l=left, c=center, r=right

if hj=="l" then
xa=x-bx
rad=0
elseif hj=="c" then
xa=x-((wx-bx)/2)-bx
rad=(wx-bx)/2
elseif hj=="r" then
xa=x-wx
rad=wx-bx
else
print ('hj not set correctly for text: '..t..' - "l", "c" or "r"')
xa=0
rad=0
end

--vj-- n=normal, nb=normal-ybearing, m=middle, mb=middle-ybearing, t=top
if vj=="t" then
ya=y
rad2=0
ry=by
elseif vj=="nb" then
ya=y-by
rad2=-by
ry=by
elseif vj=="m" then
ya=y+((hy-by)/2)
rad2=((hy-by)/2)
ry=((hy-by)/2)-by
elseif vj=="mb" then
ya=y+(hy/2)-by
rad2=(hy/2)-by
ry=((hy-by)/2)-by
elseif vj=="t" then
ya=y+hy-by
rad2=hy-by
ry=0+by
else
print ('vj not set correctly for text: '..t..' - "n", "nb", "m", "mb" or "t"')
ya=0
rad2=0
ry=0
end

-- Rotation
if r~=0 then
local x2,y2=pt(x,y,rad2,r-180)
local x1,y1=pt(x2,y2,rad,r-90)
cairo_save (cr)
cairo_translate (cr,x1,y1)
cairo_rotate(cr,(math.pi/180)*r)
cairo_show_text (cr,t)
cairo_stroke (cr)
cairo_restore (cr)
else
cairo_move_to (cr,xa,ya)
cairo_show_text (cr,t)
cairo_stroke (cr)
end--if ro
--set non local variables to nil
xa=nil;ya=nil;rad=nil;rad2=nil;ry=nil
end --function text
--======================================= Regards, Etles_Team ====================================--
