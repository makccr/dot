
function conky_vars()

    -- Set network interface for all scripts here
    var_NETWORK = "enp0s31f6" --bars & graphs
    --for text
    var_NETWORK2 = "Down  ${downspeed enp0s31f6}${alignr}Up  ${upspeed enp0s31f6}"
    var_NETWORK3 = "Total: ${totaldown enp0s31f6}${alignr}Total: ${totalup enp0s31f6}"
  
end

--[[
#########################
# conky-system-lua-V3   #
# by +WillemO @wim66    #
# v1.0 8-dec-17         #
#                       #
#########################
]]
