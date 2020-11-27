--[[Background originally by londonali1010 (2009)
    ability to set any size for background mrpeachy 2011
    ability to set variables for bg in conkyrc dk75

  the change is that if you set width and/or height to 0
  then it assumes the width and/or height of the conky window

so:

Above and After TEXT  (requires a composite manager or it blinks!)

 lua_load ~/wea_conky/draw_bg.lua
 TEXT
 ${lua conky_draw_bg 10 0 0 0 0 0x000000 0.2}

OR Both above TEXT (no composite manager required - no blinking!)

 lua_load ~/wea_conky/draw_bg.lua
 lua_draw_hook_pre draw_bg 10 0 0 0 0 0x000000 0.2
 TEXT

Note
${lua conky_draw_bg 20 0 0 0 0 0x000000 0.2}
  See below:        1  2 3 4 5 6        7

${lua conky_draw_bg corner_radius x_position y_position width height color alpha}

covers the whole window and will change if you change the minimum_size setting

1 = 20            corner_radius
2 = 0             x_position l|r
3 = 0             y_position u|d
4 = 0             width
5 = 0             height
6 = 0x000000      color
7 = 0.4           alpha

######### calendar function ##################################################

then to use it, you activate the calendar function BELOW TEXT like this

${lua luacal {settings}}

#${lua luacal {x=,y=,tf="",tfs=,tc=,ta=,bf="",bfs=,bc=,ba=,hf="",hfs=,hc=,ha=,sp="",gh=,gt=,gv=,sd=}}
#    x=x position top left
#    y=y position top left
#    tf=title font, eg "mono" must be in quotes
#    tfs=title font size
#    tc=title color
#    ta=title alpha
#    bf=body font, eg "mono" must be in quotes
#    bfs=body font size
#    bc=body color
#    ba=body alpha
#    hf=highlight font, eg "mono" must be in quotes
#    hfs=highlight font size
#    hc=highlight color
#    ha=highlight alpha
#    sp=spacer, eg " " or sp="0"... 0,1 or 2 spaces can help with positioning of non-monospaced fonts

#    gt=gap from title to body
#    gh=gap horizontal between columns
#    gv=gap vertical between rows
#    sd=start day, 0=Sun, 1=Mon

#    hstyle = heading style, 0=just days, 1=date insert
#    tdf=title date font, eg "mono" must be in quotes
#    tdfs=title date font size
#    tdc=title date color
#    tda=title date alpha

# test line
-- ${lua luacal {x=40,y=40,tf="Monofur",tfs=24,tc=0xFFDEAD,ta=1,bf="Monofur",bfs=24,bc=0xFFDEAD,ba=1,hf="Monofur",hfs=24,hc=0x00BFFF,ha=1,sp=" ",gh=40,gt=25,gv=20,sd=0,hstyle=1,tdf="Monofur",tdfs=24,tdc=0x00BFFF,tda=1}}


]]

require 'cairo'
local    cs, cr = nil
function rgb_to_r_g_b(colour,alpha)
return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end
function conky_draw_bg(r,x,y,w,h,color,alpha)
if conky_window == nil then return end
if cs == nil then cairo_surface_destroy(cs) end
if cr == nil then cairo_destroy(cr) end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
local cr = cairo_create(cs)
w=w
h=h
if w=="0" then w=tonumber(conky_window.width) end
if h=="0" then h=tonumber(conky_window.height) end
cairo_set_source_rgba (cr,rgb_to_r_g_b(color,alpha))
--top left mid circle
local xtl=x+r
local ytl=y+r
--top right mid circle
local xtr=(x+r)+((w)-(2*r))
local ytr=y+r
--bottom right mid circle
local xbr=(x+r)+((w)-(2*r))
local ybr=(y+r)+((h)-(2*r))
--bottom right mid circle
local xbl=(x+r)
local ybl=(y+r)+((h)-(2*r))
-----------------------------
cairo_move_to (cr,xtl,ytl-r)
cairo_line_to (cr,xtr,ytr-r)
cairo_arc(cr,xtr,ytr,r,((2*math.pi/4)*3),((2*math.pi/4)*4))
cairo_line_to (cr,xbr+r,ybr)
cairo_arc(cr,xbr,ybr,r,((2*math.pi/4)*4),((2*math.pi/4)*1))
cairo_line_to (cr,xbl,ybl+r)
cairo_arc(cr,xbl,ybl,r,((2*math.pi/4)*1),((2*math.pi/4)*2))
cairo_line_to (cr,xtl-r,ytl)
cairo_arc(cr,xtl,ytl,r,((2*math.pi/4)*2),((2*math.pi/4)*3))
cairo_close_path(cr)
cairo_fill (cr)
------------------------------------------------------------
cairo_surface_destroy(cs)
cairo_destroy(cr)
return ""
end
-- ###### calendar function ##################################################
function conky_luacal(caltab) -- {x=,y=,tf="",tfs=,tc=,ta=,bf="",bfs=,bc=,ba=,hf="",hfs=,hc=,ha=,sp="",gt=,gh=,gv=,sd=,hstyle=,tdf=,tdfs=,tdc=,tda=}
if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
local cr = cairo_create(cs)
--############################################################################
if caltab.x==nil then
caltab=loadstring("return" .. caltab)()
end
local cal_x=caltab.x
local cal_y=caltab.y
local tfont=caltab.tf		or "mono"
local tfontsize=caltab.tfs	or 12
local tc=caltab.tc			or 0xffffff
local ta=caltab.ta			or 1
local bfont=caltab.bf		or "mono"
local bfontsize=caltab.bfs	or 12
local bc=caltab.bc			or 0xffffff
local ba=caltab.ba			or 1
local hfont=caltab.hf		or "mono"
local hfontsize=caltab.hfs	or 12
local hc=caltab.hc			or 0xff0000
local ha=caltab.ha			or 1
local spacer=caltab.sp		or " "
local gaph=caltab.gh		or 20
local gapt=caltab.gt		or 15
local gapl=caltab.gv		or 15
local sday=caltab.sd		or 0
local hstyle=caltab.hstyle	or 0
--convert colors
--local font=string.gsub(font,"_"," ")
local tred,tgreen,tblue,talpha=rgb_to_r_g_b(tc,ta)
--main body text color
local bred,bgreen,bblue,balpha=rgb_to_r_g_b(bc,ba)
--highlight text color
local hred,hgreen,hblue,halpha=rgb_to_r_g_b(hc,ha)
--############################################################################
--calendar calcs
local year=os.date("%G")
local today=tonumber(os.date("%d"))
local t1 = os.time( {    year=year,month=03,day=01,hour=00,min=0,sec=0} );
local t2 = os.time( {    year=year,month=02,day=01,hour=00,min=0,sec=0} );
local feb=(os.difftime(t1,t2))/(24*60*60)
local monthdays={ 31, feb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
local day=tonumber(os.date("%w"))+1-sday
local day_num = today
local remainder=day_num % 7
local start_day=day-(day_num % 7)
if start_day<0 then start_day=7+start_day end
local month=os.date("%m")
local mdays=monthdays[tonumber(month)]
local x=mdays+start_day
local dnum={}
local dnumh={}
if mdays+start_day<36 then
dlen=35
plen=29
else
dlen=42
plen=36
end
for i=1,dlen do
    if i<=start_day then
    dnum[i]="  "
    else
    dn=i-start_day
        if dn=="nil" then dn=0 end
        if dn<=9 then dn=(spacer .. dn) end
        if i>x then dn="" end
        dnum[i]=dn
        dnumh[i]=dn
        if dn==(spacer .. today) or dn==today then
        dnum[i]=""
        end
        if dn==(spacer .. today) or dn==today then
        dnumh[i]=dn
        place=i
        else dnumh[i]="  "
        end
    end
end--for
cairo_select_font_face (cr, tfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, tfontsize);
cairo_set_source_rgba (cr,tred,tgreen,tblue,talpha)
local extents=cairo_text_extents_t:create()
tolua.takeownership(extents)
if hstyle==0 then
    if tonumber(sday)==0 then
    dys={"SU","MO","TU","WE","TH","FR","SA"}
    else
    dys={"MO","TU","WE","TH","FR","SA","SU"}
    end
    --draw calendar titles
elseif hstyle==1 then
    if tonumber(sday)==0 then
    dys={"SU","MO"," ","  ","  ","FR","SA"}
    cairo_text_extents(cr,"MO",extents)
    local s=extents.x_advance+gaph
    local f=gaph*5
    local tdfont=caltab.tdf        or "mono"
    local tdfontsize=caltab.tdfs    or 12
    local tdc=caltab.tdc        or 0xffffff
    local tda=caltab.tda        or 1
    cairo_select_font_face (cr, tdfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
    cairo_set_font_size (cr, tdfontsize);
    local tdred,tdgreen,tdblue,tdalpha=rgb_to_r_g_b(tdc,tda)
    cairo_set_source_rgba (cr,tdred,tdgreen,tdblue,tdalpha)
    local insert=os.date("%b %y")
    cairo_text_extents(cr,insert,extents)
    local w=extents.x_advance
    cairo_move_to (cr, cal_x+((s+f)/2)-(w/2), cal_y)
    cairo_show_text (cr,insert)
    cairo_stroke (cr)
    else
    dys={"MO","TU"," ","  ","  ","SA","SU"}
    cairo_text_extents(cr,"TU",extents)
    local s=extents.x_advance+gaph
    local f=gaph*5
    local tdfont=caltab.tdf        or "mono"
    local tdfontsize=caltab.tdfs    or 12
    local tdc=caltab.tdc        or 0xffffff
    local tda=caltab.tda        or 1
    cairo_select_font_face (cr, tdfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
    cairo_set_font_size (cr, tdfontsize);
    local tdred,tdgreen,tdblue,tdalpha=rgb_to_r_g_b(tdc,tda)
    cairo_set_source_rgba (cr,tdred,tdgreen,tdblue,tdalpha)
    local insert=os.date("%b %y")
    cairo_text_extents(cr,insert,extents)
    local w=extents.x_advance
    cairo_move_to (cr, cal_x+((s+f)/2)-(w/2), cal_y)
    cairo_show_text (cr,insert)
    cairo_stroke (cr)
    end
end
--draw calendar titles
for i=1,7 do
cairo_select_font_face (cr, tfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, tfontsize);
cairo_set_source_rgba (cr,tred,tgreen,tblue,talpha)
cairo_move_to (cr, cal_x+(gaph*(i-1)), cal_y)
cairo_show_text (cr, dys[i])
cairo_stroke (cr)
end
--draw calendar body
cairo_select_font_face (cr, bfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, bfontsize);
cairo_set_source_rgba (cr,bred,bgreen,bblue,balpha)
for i=1,plen,7 do
local fn=i
    for i=fn,fn+6 do
    cairo_move_to (cr, cal_x+(gaph*(i-fn)),cal_y+gapt+(gapl*((fn-1)/7)))
    cairo_show_text (cr, dnum[i])
    cairo_stroke (cr)
    end
end
--highlight
cairo_select_font_face (cr, hfont, CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
cairo_set_font_size (cr, hfontsize);
cairo_set_source_rgba (cr,hred,hgreen,hblue,halpha)
for i=1,plen,7 do
local fn=i
    for i=fn,fn+6 do
    cairo_move_to (cr, cal_x+(gaph*(i-fn)),cal_y+gapt+(gapl*((fn-1)/7)))
    cairo_show_text (cr, dnumh[i])
    cairo_stroke (cr)
    end
end
--############################################################################
caltab=nil
dlen=nil
plen=nil
cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil
return ""
end
-- end main function #########################################################
