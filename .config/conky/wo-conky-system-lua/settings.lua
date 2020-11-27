
function conky_vars()

    -- Set network interface for all scripts here
    var_NETWORK = "enp0s31f6" --bars & graphs
    --for text
    
    var_NETUP = "${upspeed enp0s31f6}"
    var_NETDOWN = "${downspeed enp0s31f6}"
    
    var_TOTALUP = "${totalup enp0s31f6}"
    var_TOTALDOWN = "${totaldown enp0s31f6}"
      
end

--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]
