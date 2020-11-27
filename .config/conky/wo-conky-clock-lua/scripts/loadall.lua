-- Set the path to the scripts folder
-- print(os.getenv("HOME"))
package.path = os.getenv ( "HOME" ) .. "/.config/conky/wo-conky-clock-lua/scripts/?.lua"
-- ###################################


require 'box'
require 'text'
require 'clock'

function conky_main()
     conky_main_box()
     conky_draw_text()
     conky_main_clock()
end

--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]
