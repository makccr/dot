
-- Set the path to the scripts folder
-- print(os.getenv("HOME"))
package.path = os.getenv ( "HOME" ) .. "/.config/conky/wo-conky-system-lua/scripts/?.lua"
-- ###################################


require 'lua0-box'
require 'lua1-graphs'
require 'lua2-text'
require 'lua3-bars'

function conky_main()
     conky_main_box()
     conky_main_graph()
     conky_draw_text()
     conky_main_bars()
end

--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]
