--[[ System Info widget for use with Conky
     by debianmainuser (07/11/2015 <debianmainuser@gmail.com>)
	Based off of Basic V0.7 by Moob (20-10-2015 <moobvda@gmail.com>)
	This widget draws the Wired Conky interface to display system information

        Used some mods from soundrolf

	Start conky with '-q' to get rid of conky statfs64 messages when a usb stick/disk is unmounted.

	Prerequisites : lm-sensors, Conky version 1.10.0 (only!!!)

	debianmainuser	Modified function: conky_wired_tab_system for system info, such as OS, Kernel, CPU Type & Speed.
	07/11/2015      Added: conky_wired_tab_cpu_temp & gpu_temp for CPU temp & GPU temp. Locked CPU Load & Temp to 4 CPU's
                        (modify if you need less info. GPU temp is for Nvidia cards only--mod as you need for ATI cards)
                        Added: conky_wired_bar_temp to support temp bar functions. (replaces "%" with "C". 100 = 100C)
                        Removed: Battery tab  (for desktop use only)
                        Removed: Radio tab
                        Added: semi-transparent surrounding box to allow monitor to be seen with any wallpaper(in conky config)
                        Changed: Default font type -added "purple" color for monitor
                        Sized for 1920x1080 window (change max height below for smaller monitors-designed for Gnome3 top panel use)
                        Modify the X number value (150,X) in the needed --show ("") area to change height of tabs
                        Compact & clean up code--add comments
]]

-- user parameters, change them if you want.
use_theme = "silver"					-- can be 'red','green','silver','gold','black','maroon','sienna', 'purple' or 'default'
squash_cpu_cores = "no"			-- display overall cpu speed, not per core
battery_low_alert = 10			-- low battery level alert, for laptops.
show_cpu = "yes"						-- yes, detect CPU's presence and show CPU load
show_cpu_temp = "yes"				-- yes, show cpu temp
-- storage is not working - if anyone can fix it?
-- show_storage = "no"		-- yes, detect and show attached storage devices
show_memory = "yes"					-- yes, show internal and swap memory
show_network = "yes"				-- yes, detect and show network information
show_system = "yes"					-- yes, show system info's such as cpu + gpu temp, fan speed cpu + chassis, uptime
show_netinfo = "yes"				-- yes, show local + public IP
show_processes = "yes"			-- yes, show running processes

------------------------------------------------------------------------
-- nothing exciting beyond here, trust me.. (see notes for moding use)
------------------------------------------------------------------------

require 'cairo'

-- global variables
themes={}
themes.red={.65,0,0}
themes.white={255,255,255}
themes.green={0,.65,0}
themes.silver={.752,.752,.752}
themes.gold={.831,.686,.215}
themes.black={.031,.031,.031}
themes.maroon={.501,0,0}
themes.sienna={.627,.321,.176}
themes.purple={.600,.500,.650}
themes.blue={0,0,.65}
themes.tred=0
themes.tgreen=0
themes.tblue=0

info = {}
info.iface = ""
info.ifacetype = ""
info.battalert = battery_low_alert
info.battalerttrigger = 1
info.scpu = squash_cpu_cores
info.conkyversiondetection = ""
info.scrollcounter = 1


-- vars below are filled by conky_detect_hardware
cpucores={} 	        -- number of detected cpu cores
fsnames={}	        -- full path to disk aka /media/data1
disknames={}	        -- last part of path aka data1
diskdevicenames={}	-- devicename aka sda etc
hardware={}
hardware.flag=1
hardware.cpucores=0
hardware.numofhdd=0
hardware.battery="none"

function conky_main()

if conky_window == nil then return end
local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
cr = cairo_create(cs)

-- detect hardware
conky_detect_hardware()

updates=tonumber(conky_parse('${updates}'))

	-- default theme colors
	themes.tred=.61
	themes.tgreen=.81
	themes.tblue=1

	-- theme colors
	if string.lower(use_theme) == "red" then
		themes.tred=themes.red[1]
		themes.tgreen=themes.red[2]
		themes.tblue=themes.red[3]
	end
	if string.lower(use_theme) == "green" then
		themes.tred=themes.green[1]
		themes.tgreen=themes.green[2]
		themes.tblue=themes.green[3]
	end
	if string.lower(use_theme) == "silver" then
		themes.tred=themes.silver[1]
		themes.tgreen=themes.silver[2]
		themes.tblue=themes.silver[3]
	end
	if string.lower(use_theme) == "gold" then
		themes.tred=themes.gold[1]
		themes.tgreen=themes.gold[2]
		themes.tblue=themes.gold[3]
	end
	if string.lower(use_theme) == "black" then
		themes.tred=themes.black[1]
		themes.tgreen=themes.black[2]
		themes.tblue=themes.black[3]
	end
	if string.lower(use_theme) == "maroon" then
		themes.tred=themes.maroon[1]
		themes.tgreen=themes.maroon[2]
		themes.tblue=themes.maroon[3]
	end
	if string.lower(use_theme) == "sienna" then
		themes.tred=themes.sienna[1]
		themes.tgreen=themes.sienna[2]
		themes.tblue=themes.sienna[3]
	end
	if string.lower(use_theme) == "purple" then
		themes.tred=themes.purple[1]
		themes.tgreen=themes.purple[2]
		themes.tblue=themes.purple[3]
	end

	local onebarheight=15+8
	local tabvsep = 6  --vertical gap between tab's
	local barfs=12     --VU bar fontsize
	-- start coordinates
	local basey=2
	local starty=basey
	local startx=12
	local retx,rety=0,basey

	-- show system info
	if show_system == "yes" then
		retx,rety=conky_wired_tab_system(startx,rety+tabvsep,150,78,"System Info","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- show cpu load
	if show_cpu == "yes" then
		retx,rety=conky_wired_tab_cpu(startx,rety+tabvsep,150,100,"CPU Load","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- cpu temp
	if show_cpu_temp == "yes" then
		retx,rety=conky_wired_tab_cpu_temp(startx,rety+tabvsep,150,150,"CPU Temp","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- show processes
	if show_processes == "yes" then
		-- 5 is the number of processes shown
		retx,rety=conky_wired_tab_process(startx,rety+tabvsep,150,100,"Processes",6,"Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- memory
	if show_memory == "yes" then
		retx,rety=conky_wired_tab_mem(startx,rety+tabvsep,150,60,"Memory","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- network
	if show_network == "yes" then
		retx,rety=conky_wired_tab_network(startx,rety+tabvsep,150,85,info.ifacetype.." Network","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- show netinfo
	if show_netinfo == "yes" then
		retx,rety=conky_wired_tab_netinfo(startx,rety+tabvsep,150,60,"Net","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

	-- show harddisk usage
	if show_storage == "yes" then
		retx,rety=conky_wired_tab_storage(startx,rety+tabvsep,150,100,"Storage","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	end

-- destroy graphic instance
cairo_destroy(cr)
cairo_surface_destroy(cs)
cr=nil

end-- end main function

-- wired functions
function conky_wired_tab(x,y,width,height,text,font,font_size,r,g,b)
	if height < 60 then
		print("ERROR conky_wired_tab: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

end -- conky_wired_tab

--Mod Info

-- Name : conky_wired_tab_cpu
-- Function : Display al the CPU's present and their load
-- Return value : returns highest x and y value
-- Parameters
---- x : left x coordinate
---- y : top y coordinate
---- width : width of the tab
---- height: inital height of the tab. Will be adjusted as needed by the function
---- text : text to show in the upper righthand corner
---- font : font to use
---- font_size : font size to use
---- r,g,b : color specification
-- Global variables used
---- info.scpu : to check if all or just the overal CPU load needs to be displayed
---- updates : the number of conky update cycles

-- parameters idem conky_wired_tab_cpu
function conky_wired_tab_cpu(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	--local numofcpus=table.getn(cpucores)
	local numofcpus= tonumber(conky_ownpreexec("cat /proc/cpuinfo | grep 'processor' | wc -l | tr -d ' '"))
	--  local numofcpus="4"

	local cpustr,cpuval="",0

	-- if squashed CPU or only 1 CPU present
	if info.scpu == "yes" or numofcpus == 1 then
		height=2.7*onebarheight
	else
		height=(numofcpus*onebarheight)+(numofcpus*10)+onebarheight
	end

	-- can be lower than 60 but then you need to adjust the aspect and  corner_radius values
	-- to get the correct rounded corners
	if height < 60 then
		print("ERROR conky_wired_tab_cpu: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0
	local barfs=12     --VU bar fontsize

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	-- draw tab contents
	if updates > 5 then
		if info.scpu == "yes" or numofcpus == 1 then
			cpustr="${cpu cpu0}"
			cpuval=tonumber(conky_parse(cpustr))
			conky_wired_bar(x+6,y+onebarheight,vuheight,"CPU","Technical CE",barfs,cpuval)
		else
			for i=1,numofcpus,1 do
				cpustr="${cpu cpu"..i.."}"
				cpuval=tonumber(conky_parse(cpustr))
				conky_wired_bar(x+6,y+onebarheight,vuheight,"CPU "..i,"Technical CE",barfs,cpuval)
				y=y+onebarheight+10
			end
		end
	else
		-- show VU bar with no values for the first 5 cycles
		if info.scpu == "yes" or numofcpus == 1 then
			conky_wired_bar(x+6,y+onebarheight,vuheight,"CPU","Technical CE",barfs,0)
		else
			for i,cpu in ipairs(cpucores) do
				conky_wired_bar(x+6,y+onebarheight,vuheight,"CPU "..cpu,"Technical CE",barfs,0)
				y=y+onebarheight+10
			end
		end
	end

	return (x+width),(basey+height)

end -- conky_wired_tab_cpu

-- parameters idem conky_wired_tab_cpu_temp
function conky_wired_tab_cpu_temp(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	if height < 60 then
		print("ERROR conky_wired_tab_cpu_temp: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

-- Modify below for less than 4 CPUs

	conky_wired_bar_temp(x+6,y+onebarheight,vuheight,"CPU0","Technical CE",barfs,tonumber(conky_parse("${execi 5 sensors|grep 'Core 0'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}")))
	conky_wired_bar_temp(x+6,y+54,vuheight,"CPU1","Technical CE",barfs,tonumber(conky_parse("${execi 5 sensors|grep 'Core 1'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}")))
	conky_wired_bar_temp(x+6,y+86,vuheight,"CPU2","Technical CE",barfs,tonumber(conky_parse("${execi 5 sensors|grep 'Core 2'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}")))
	conky_wired_bar_temp(x+6,y+118,vuheight,"CPU3","Technical CE",barfs,tonumber(conky_parse("${execi 5 sensors|grep 'Core 3'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}")))

-- Use code below if you want text-based temp info without bars

--      conky_lctext(x+6,y+32,"CPU0","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+32,conky_parse("${execi 5 sensors|grep 'Core 0'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}"),"Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctext(x+6,y+48,"CPU1","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+48,conky_parse("${execi 5 sensors|grep 'Core 1'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}"),"Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--        conky_lctext(x+6,y+64,"CPU2","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+64,conky_parse("${execi 5 sensors|grep 'Core 2'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}"),"Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctext(x+6,y+80,"CPU3","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+80,conky_parse("${execi 5 sensors|grep 'Core 3'| awk -F'+' '{print $2}' | awk -F'.' '{print $1}'}"),"Technical CE",13,themes.tred,themes.tgreen,themes.tblue)

	return (x+width),(y+height)

end -- conky_wired_tab_cpu_temp

-- parameters idem conky_wired_tab_mem
function conky_wired_tab_mem(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	if height < 60 then
		print("ERROR conky_wired_tab_mem: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	conky_wired_bar(x+6,y+onebarheight,vuheight,"RAM","Technical CE",barfs,tonumber(conky_parse("${memperc}")))

-- Add below as wanted

--	conky_lctext(x+6,y+62,"RAM Total","Technical CE",10,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+62,conky_parse("${memmax}"),font,font_size,r,g,b)
--	conky_lctext(x+6,y+74,"RAM Free","Technical CE",10,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+74,conky_parse("${memeasyfree}"),font,font_size,r,g,b)
--	conky_lctext(x+6,y+86,"Swap","Technical CE",10,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctexta(x+150,y+86,conky_parse("${swap}"),font,font_size,r,g,b)

	return (x+width),(y+height)

end -- conky_wired_tab_mem


-- parameters idem conky_wired_tab_network
function conky_wired_tab_network(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	if height < 60 then
		print("ERROR conky_wired_tab_network: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	conky_lctext(x+6,y+30,"Upspeed ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+6,y+46,"Downspeed ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+6,y+62,"Up Total ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+6,y+78,"Down Total ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
--	conky_lctext(x+6,y+92,"Local IP ","Technical CE",13,themes.tred,themes.tgreen,themes.tblue)
	conky_lctexta(x+150,y+30,conky_parse("${upspeed "..info.iface.."}"),font,font_size,r,g,b)
	conky_lctexta(x+150,y+46,conky_parse("${downspeed "..info.iface.."}"),font,font_size,r,g,b)
	conky_lctexta(x+150,y+62,conky_parse("${totalup "..info.iface.."}"),font,font_size,r,g,b)
	conky_lctexta(x+150,y+76,conky_parse("${totaldown "..info.iface.."}"),font,font_size,r,g,b)
--	conky_lctexta(x+150,y+92,conky_parse("${addr "..info.iface.."}"),font,font_size,r,g,b)

	return (x+width),(y+height)

end -- conky_wired_tab_network

-- parameters idem conky_wired_tab_storage
function conky_wired_tab_storage(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	-- adjust tab height to content
	if hardware.numofhdd == 1 then
		height=(1*onebarheight)+(2*10)+onebarheight
	else
		height=(hardware.numofhdd*onebarheight)+(hardware.numofhdd*10)+onebarheight
	end

	if height < 60 then
		print("ERROR conky_wired_tab_storage: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	local y2=y+25
	for i,hdd in ipairs(fsnames) do
		y2=conky_display_hdd(x,y2,hdd,i)
	end

	return (x+width),(y+height)

end -- conky_wired_tab_storage

-- parameters idem conky_wired_tab_system
function conky_wired_tab_system(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	if height < 60 then
		print("ERROR conky_wired_tab_system: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	conky_lctext(x+6,y+30,"OS:","Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+6,y+43,conky_parse("${execi 1000 cat /proc/cpuinfo|grep 'model name'|sed -e 's/model name.*: //'| uniq | cut -c 10-26}"),"Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctexta(x+150,y+30,conky_parse("${execi 1000 /bin/cat /etc/*release* | grep DISTRIB_CODENAME | cut -c 18-30}"),"Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+6,y+57,"CPU:","Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctexta(x+120,y+57,conky_parse("${freq_g 1}"),"Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctext(x+115,y+57,"GHZ","Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	--conky_lctext(x+6,y+70,"Kernel:","Technical CE",12,themes.tred,themes.tgreen,themes.tblue)
	conky_lctexta(x+145,y+70,conky_parse("$kernel"),"Technical CE",12,themes.tred,themes.tgreen,themes.tblue)

	return (x+width),(y+height)

end -- conky_wired_tab_system

-- parameters idem conky_wired_tab_netinfo
function conky_wired_tab_netinfo(x,y,width,height,text,font,font_size,r,g,b)
	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y
	local barfs=12     --VU bar fontsize

	if height < 60 then
		print("ERROR conky_wired_tab_netinfo: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

		conky_lctext(x+6,y+30,"Local IP ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
		conky_lctext(x+6,y+42,"Public IP ",font,font_size,themes.tred,themes.tgreen,themes.tblue)
		conky_lctexta(x+150,y+30,conky_parse("${addr enp0s31f6}"),font,font_size,r,g,b)
		conky_lctexta(x+150,y+42,conky_parse("Unhide line"),font,font_size,r,g,b)
		--conky_lctexta(x+150,y+42,conky_parse("Unhide${execi 1000 wget -O - -q icanhazip.com}"),font,font_size,r,g,b)

	return (x+width),(y+height)

end -- conky_wired_tab_netinfo

-- parameters idem conky_wired_tab_process
-- numofproc is the number of processes to show
function conky_wired_tab_process(x,y,width,height,text,numofproc,font,font_size,r,g,b)
	-- input sanitation for the number of processes shown
	if numofproc == 0  or numofproc < 0 then
		numofproc = 1  -- show 1 process
	end
	if numofproc > 10 then
		numofproc = 10 -- you can only show 10 processes
	end

	local vuheight=15  --VU barheight
	local onebarheight=vuheight+8
	local basey=y

	-- if squashed CPU or only 1 CPU present
	if numofproc == 1 then
		height=2.7*onebarheight
	else
		height=(numofproc*onebarheight)+(numofproc*10)+onebarheight
	end

	-- can be lower than 60 but then you need to adjust the aspect and  corner_radius values
	-- to get the correct rounded corners
	if height < 60 then
		print("ERROR conky_wired_tab_process: insufficient height. Must be higher than 60")
		return
	end

	local aspect=math.floor(height/60)
	local corner_radius = height / 10.0
	local radius = corner_radius / aspect
	local degrees = math.pi / 180.0
	local barfs=11     --VU bar fontsize

	-- draw text
	conky_lctexta(x+width,y+15,text,font,font_size,r,g,b)
	-- draw tab
	cairo_new_sub_path (cr)
	cairo_arc (cr, x + width - radius, y + radius, radius, -90 * degrees, 0 * degrees)
	cairo_arc (cr, x + width - radius, y + height - radius, radius, 0 * degrees, 90 * degrees)
	cairo_arc (cr, x + radius, y + height - radius, radius, 90 * degrees, 180 * degrees)
	cairo_arc (cr, x + radius, y + radius, radius, 180 * degrees, 270 * degrees)
	cairo_close_path (cr)
	cairo_set_source_rgba (cr, r,g,b,.6)
	cairo_set_line_width (cr, 2)
	cairo_stroke (cr)

	-- draw tab contents
	if numofproc == 1 then
		local name = conky_parse("${top name 1}")
		local cpu = tonumber(conky_parse("${top cpu 1}"))
		conky_wired_bar(x+6,y+onebarheight,vuheight,name,"Technical CE",barfs,cpu)
	else
		for i=1,numofproc,1 do
			local name = conky_parse("${top name "..i.."}")
			local cpu = tonumber(conky_parse("${top cpu "..i.."}"))
			conky_wired_bar(x+6,y+onebarheight,vuheight,name,"Technical CE",barfs,cpu)
			y=y+onebarheight+10
		end
	end

	return (x+width),(basey+height)

end -- conky_wired_tab_process


-- parameters idem conky_wired_bar
-- displays horizontal VU like bar
function conky_wired_bar(sx, sy,barheight,text,font,font_size,value)
	value = value or 0

	local percentage = {"5","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90","95","100"}
	local sx2=sx
	local line_width=1
	local line_cap=CAIRO_LINE_CAP_SQUARE
	local red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.75
	local font_slant=CAIRO_FONT_SLANT_ITALIC
	local font_face=CAIRO_FONT_WEIGHT_BOLD
	cairo_select_font_face (cr, font, font_slant, font_face);
	cairo_set_font_size (cr, font_size)
	cairo_set_source_rgba (cr,red,green,blue,alpha)
	cairo_move_to (cr,sx,sy+barheight+font_size)
	cairo_show_text (cr,text)

	-- prevent higher numbers than 100%
	if value > 100 then
		value=100
	end

	-- draw VU background parts
	for i,v in ipairs(percentage) do
		red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.3
		cairo_set_source_rgba (cr,red,green,blue,alpha)
		cairo_rectangle (cr,sx,sy,5,barheight)
		cairo_fill(cr)
		sx=sx+7
	end

	-- display percentage value
	cairo_move_to (cr,sx-30,sy+barheight+font_size)
	cairo_set_source_rgba (cr, red, green,blue, 0.6);
	cairo_show_text(cr,value.."%")
	-- draw highlighted VU parts
	for i,v in ipairs(percentage) do
		if value >= tonumber(v) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,1
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			sx2=sx2+7
		end
		if (value < 5 and value > 0) or value > tonumber(v) and value < tonumber(percentage[i+1]) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.5
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			break
		end
	end

end -- conky_wired_bar

-- displays horizontal VU like bar
function conky_wired_bar_temp(sx, sy,barheight,text,font,font_size,value)
	value = value or 0

	local percentage = {"5","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90","95","100"}
	local sx2=sx
	local line_width=1
	local line_cap=CAIRO_LINE_CAP_SQUARE
	local red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.75
	local font_slant=CAIRO_FONT_SLANT_ITALIC
	local font_face=CAIRO_FONT_WEIGHT_BOLD
	cairo_select_font_face (cr, font, font_slant, font_face);
	cairo_set_font_size (cr, font_size)
	cairo_set_source_rgba (cr,red,green,blue,alpha)
	cairo_move_to (cr,sx,sy+barheight+font_size)
	cairo_show_text (cr,text)

	-- prevent higher numbers than 100%
	if value > 100 then
		value=100
	end

	-- draw VU background parts
	for i,v in ipairs(percentage) do
		red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.3
		cairo_set_source_rgba (cr,red,green,blue,alpha)
		cairo_rectangle (cr,sx,sy,5,barheight)
		cairo_fill(cr)
		sx=sx+7
	end

	-- display temperature value
	cairo_move_to (cr,sx-30,sy+barheight+font_size)
	cairo_set_source_rgba (cr, red, green,blue, 0.6);
	cairo_show_text(cr,value.."C")
	-- draw highlighted VU parts
	for i,v in ipairs(percentage) do
		if value >= tonumber(v) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,1
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			sx2=sx2+7
		end
		if (value < 5 and value > 0) or value > tonumber(v) and value < tonumber(percentage[i+1]) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.5
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			break
		end
	end

end -- conky_wired_bar_temp

-- parameters idem conky_wired_hdd
-- displays horizontal VU like HDD bar
function conky_wired_hdd_bar(sx, sy,barheight,text,font,font_size,hdd,value)
	value = value or 0

	local percentage = {"5","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90","95","100"}
	local sx2=sx
	local line_width=1
	local line_cap=CAIRO_LINE_CAP_SQUARE
	local red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.75
	local font_slant=CAIRO_FONT_SLANT_ITALIC
	local font_face=CAIRO_FONT_WEIGHT_BOLD
	cairo_select_font_face (cr, font, font_slant, font_face);
	cairo_set_font_size (cr, font_size)
	cairo_set_source_rgba (cr,red,green,blue,alpha)
	cairo_move_to (cr,sx,sy+barheight+font_size)
	cairo_show_text (cr,text)

	-- prevent higher numbers than 100%
	if value > 100 then
		value=100
	end

	-- draw VU background parts
	for i,v in ipairs(percentage) do
		red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.3
		cairo_set_source_rgba (cr,red,green,blue,alpha)
		cairo_rectangle (cr,sx,sy,5,barheight)
		cairo_fill(cr)
		sx=sx+7
	end

	-- display percentage value
	cairo_move_to (cr,sx-30,sy+barheight+font_size)
	cairo_show_text(cr,value.."%")
	-- draw highlighted VU parts
	for i,v in ipairs(percentage) do
		if value >= tonumber(v) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,1
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			sx2=sx2+7
		end
		if (value < 5 and value > 0) or value > tonumber(v) and value < tonumber(percentage[i+1]) then
			red,green,blue,alpha=themes.tred,themes.tgreen,themes.tblue,.5
			cairo_set_source_rgba (cr,red,green,blue,alpha)
			cairo_rectangle (cr,sx2,sy,5,barheight)
			cairo_fill(cr)
			break
		end
	end


end -- conky_wired_bar_hdd

-- parameters idem conky_display_hdd
-- display harddisk
function conky_display_hdd(sx,sy,hdd,max)

	local name=disknames[max]
	local disk_perc_used=conky_parse("${if_mounted "..hdd.."}${fs_used_perc "..hdd.."}${endif}")
	if name == "/" then
		name = "Disk"
	end
	conky_wired_hdd_bar(sx+6,sy,15,name,"Technical CE",12,hdd,tonumber(disk_perc_used))
	sy=sy+32

	return sy
end -- conky_display_hdd

-- end wired functions

-- generic text function
function conky_lctext(sx,sy,tekst,font,fontsize,r,g,b)
	cairo_select_font_face (cr, font, CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD);
	cairo_set_font_size (cr, fontsize)
	cairo_set_source_rgba (cr,r,g,b,1)
	cairo_move_to (cr,sx,sy)
	cairo_show_text (cr,tekst)
end -- conky_lctext

-- calculate the length of the text and then apply it to coordinate sx
function conky_lctexta(sx,sy,tekst,font,fontsize,r,g,b)
	local txt_ext = cairo_text_extents_t:create()
	cairo_select_font_face (cr, font, CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD);
	cairo_set_font_size (cr, fontsize)
	cairo_set_source_rgba (cr,r,g,b,.6)
	cairo_text_extents(cr, tekst, txt_ext)
	cairo_move_to (cr,sx-txt_ext.width-8,sy)
	cairo_show_text (cr,tekst)
end -- conky_lctexta

-- calculate the length of the text and put it in the middle
function conky_lctextc(sx,sy,width,tekst,font,fontsize,r,g,b)
	local txt_ext = cairo_text_extents_t:create()
	local txt_ext2 = cairo_text_extents_t:create()
	local maxstr = 0
	local strpart =""
	local textpos=5

	cairo_select_font_face (cr, font, CAIRO_FONT_SLANT_ITALIC, CAIRO_FONT_WEIGHT_BOLD);
	cairo_set_font_size (cr, fontsize)
	cairo_set_source_rgba (cr,r,g,b,.75)
	cairo_text_extents(cr, tekst, txt_ext)

	if txt_ext.width >= width then
		-- get maximum number of characters
		-- this checks if text is wider than the tab width. If it is it simply swithes between text parts.
		-- It only switches between 2 text parts, so it's not an actual scroller.
		-- If the text is less than width is centres the text else it aligns to the left.
		for i=info.scrollcounter,string.len(tekst),1 do
			cairo_text_extents(cr, string.sub(tekst,1,i), txt_ext2)
			if txt_ext2.width >= (width - textpos) then
				maxstr = i-2
				info.scrollcounter = maxstr
				strpart=string.sub(tekst,1,maxstr)
				break
			else
				if info.scrollcounter > 1 then
				strpart=string.sub(tekst,info.scrollcounter+2,string.len(tekst))
				info.scrollcounter = 1
				break
				end
			end
		end
		tekst = strpart
	else
		-- center text
		textpos = (width/2)-(txt_ext.width/2)
	end

	cairo_move_to (cr,sx+textpos,sy)
	cairo_show_text (cr,tekst)


end -- conky_lctextc

-- check which network interface is used
function conky_check_network_interfaces(iface)
	if iface == "enp0s31f6" then
		info.iface = "enp0s31f6"
		info.ifacetype = "LAN"
	end
	if iface == "wlan0" then
		info.iface = "wlan0"
		info.ifacetype = "WLAN"
	end
	return ""
end

-- check if a disk is mountend/umounted and adjust number of disks
function conky_check_for_disk_change()
	local numofhdd=0
	if info.conkyversiondetection == "1.10" then
		local fs=conky_ownpreexec("df -h | grep ^/dev/s | sort |grep -o '[^ ]*$' | grep -v 'efi'")
		for w in string.gfind(fs, "\n") do
			numofhdd=numofhdd+1
		end
	end

	return tonumber(numofhdd)
end

-- Conky version 1.10.0 does not support ${pre_exec} anymore. Maybe in the future, who knows.
-- That is were this function comes in, as a replacement for ${pre_exec}
-- Keep in mind that 1.10.0 is an unstable conky version as per their maintainers
function conky_ownpreexec(command)
      fp = io.popen(command, 'r')
      return fp:read('*a')
end

function conky_check_version()
	local i,j

	i,j=string.find(conky_version,"1.9")
	if i ~= nil and j ~= nil then
		print("ERROR conky: Wrong conky version being used. Must be higher than 1.9")
                return
	end
	i,j=0,0
	i,j=string.find(conky_version,"1.10")
	if i ~= nil and j ~= nil then
		info.conkyversiondetection = "1.10"
	end

end

-- detect what kind of hardware is present at startup or ondemand
function conky_detect_hardware()
	local debug = false

	if show_storage == "yes" then
		local adjust=0
		adjust=conky_check_for_disk_change()
		if adjust ~= hardware.numofhdd then
			hardware.flag = 1
			if debug == true then
				print("Adjusting...")
			end
		end
	end

	if hardware.flag == 1 then

		-- detect conky version
		conky_check_version()

		-- only perform on conky startup, not every cycle
		hardware.flag = 2
		if debug == true then
			print("in hardware detect functie")
		end

		-- which network interface to display
		if show_network == "yes" then
			conky_parse("${if_up enp0s31f6}${lua_parse check_network_interfaces enp0s31f6}${endif}")
			conky_parse("${if_up wlan0}${lua_parse check_network_interfaces wlan0}${endif}")
			if debug == true then
			print("network interface "..info.iface.." is being used")
			end
		end

		-- number of cpu cores
		if show_cpu == "yes" then
			if info.conkyversiondetection == "1.10" then
				-- Conky 1.10.0 workaround to get cpu[1-4] working. Giving a call to cpu0 seems to kickstart it
				conky_parse("${cpu cpu0}")
				--hardware.cpucores = 4
                                -- Change here for number of CPUs
				hardware.cpucores = tonumber(conky_ownpreexec("cat /proc/cpuinfo | grep 'processor' | wc -l | tr -d ' '"))
                                -- Use this code for CPU number auto-detection
			end

			for i=1,hardware.cpucores do
				cpucores[i]=i
			end
			if debug == true then
			print(hardware.cpucores.." cpu cores found")
			end
		end

		if show_storage == "yes" then
			local fs
			-- disk names
			if info.conkyversiondetection == "1.10" then
				fs=conky_ownpreexec("df -h | grep ^/dev/s | sort |grep -o '[^ ]*$' | grep -v 'efi'")
			end

			if debug == true then
			print(fs.."were the harddisks found")
			end
			-- number of disks
			hardware.numofhdd=0
			for w in string.gfind(fs, "\n") do
				hardware.numofhdd=hardware.numofhdd+1
			end
			if debug == true then
			print(hardware.numofhdd.." harddisks in total")
			end
			-- convert string to table
			local t,s,i=1,0,0
			for i=1, hardware.numofhdd do
				s=string.find(fs,"\n",t)
				fsnames[i]=string.sub(fs,t,s-1)
				t=s+1
			end

			-- add disknames for displaying purposes
			local r,key,value,name
			for i,v in ipairs(fsnames) do
				r=string.match(v,"^.*()/")
				if string.len(v) == 1 and r == 1 then
					disknames[i] = "/"
				else
					r=r+1
					key,value,name=string.find(v,"(.*)",r)
					if string.len(name) > 12 then
						name = string.sub(name,1,12).."..."
					end
					disknames[i] = name
				end
			end
			local df
			-- get disk device names

			if info.conkyversiondetection == "1.10" then
				df=conky_ownpreexec("df -h | grep ^/dev/s | sort | grep -v 'efi' | grep -o 'sd[^ ]'")
			end
			-- add the final newline
			df=df.."\n"
			if debug == true then
			print(df.."were the disk devices found")
			end
			-- convert string to table
			local t,s,i=1,0,0
			for i=1, hardware.numofhdd do
				s=string.find(df,"\n",t)
				diskdevicenames[i]=string.sub(df,t,s-1)
				t=s+1
			end

			if debug == true then
				for i,v in ipairs(disknames) do
				print ("disk name "..i.." is "..v)
				end
				for i,v in ipairs(fsnames) do
				print ("fs name "..i.." is "..v)
				end
				print("num of hdd is "..hardware.numofhdd)
				print("hardware fs is \n"..fs)
			end

			-- when usb drive/stick removed, adjust the number of disks
			local dcount,fcount,dncount = 0,0,0
	  		for _ in ipairs(disknames) do dcount = dcount + 1 end
	  		for _ in ipairs(fsnames) do fcount = fcount + 1 end
	  		for _ in ipairs(diskdevicenames) do dncount = dncount + 1 end
			if dcount ~= hardware.numofhdd or fcount ~= hardware.numofhdd or dncount ~= hardware.numofhdd then
				fsnames[fcount]=nil
				disknames[dcount]=nil
				diskdevicenames[dncount]=nil
			end
		end
	end
end
