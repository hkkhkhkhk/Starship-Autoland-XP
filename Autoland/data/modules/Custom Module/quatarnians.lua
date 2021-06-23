qw = globalProperty("sim/flightmodel/position/q[0]")
qx = globalProperty("sim/flightmodel/position/q[1]")
qy = globalProperty("sim/flightmodel/position/q[2]")
qz = globalProperty("sim/flightmodel/position/q[3]")


function update()
    local hdg = 0
    local pch = 0
    local bnk = 0
    
    if get(qx)*get(qy) + get(qz)*get(qw) ==  0.5 then
        hdg = math.deg(2 * math.atan2(get(qx),get(qw)))
        bnk = 0
        pch = 90
    elseif get(qx)*get(qy) + get(qz)*get(qw) == -0.5 then
        hdg = math.deg(-2 * math.atan2(get(qx),get(qw)))
        bnk = 0
        pch = -90
    else
        hdg = math.deg(math.atan2(2*get(qw)*get(qx)+2*get(qy)*get(qz) , 1 - 2*get(qx)^2 - 2*get(qy)^2))
        pch = math.deg(math.asin(2*get(qw)*get(qy) + 2*get(qz)*get(qx)))
        bnk = math.deg(math.atan2(2*get(qw)*get(qz)+2*get(qx)*get(qy) , 1 - 2*get(qy)^2 - 2*get(qz)^2))
    end
end