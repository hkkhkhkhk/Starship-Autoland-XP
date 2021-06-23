local mrad = math.rad
local mdeg = math.deg
local mcos = math.cos
local msin = math.sin
local masin = math.asin
local macos = math.acos
local matan2= math.atan2


function Math_clamp(val, min, max)
    if min > max then LogWarning("Min is larger than Max invalid") end
    if val < min then
        return min
    elseif val > max then
        return max
    elseif val <= max and val >= min then
        return val
    end
end

function Math_clamp_lower(val, min)
    if val < min then
        return min
    elseif val >= min then
        return val
    end
end

function Math_clamp_higer(val, max)
    if val > max then
        return max
    elseif val <= max then
        return val
    end
end

function Table_interpolate(tab, x)
    local a = 1
    local b = #tab
    assert(b > 1)

    -- Simple cases
    if x <= tab[a][1] then
        return tab[a][2]
    end
    if x >= tab[b][1] then
        return tab[b][2]
    end

    local middle = 1

    while b-a > 1 do
        middle = math.floor((b+a)/2)
        local val = tab[middle][1]
        if val == x then
            break
        elseif val < x then
            a = middle
        else
            b = middle
        end
    end

    if x == tab[middle][1] then
        -- Found a perfect value
        return tab[middle][2]
    else
        -- (y-y0) / (y1-y0) = (x-x0) / (x1-x0)
        return tab[a][2] + ((x-tab[a][1])*(tab[b][2]-tab[a][2]))/(tab[b][1]-tab[a][1])
    end
end

function Table_extrapolate(tab, x)  -- This works like Table_interpolate, but it estimates the values
    -- even if x < minimum value of x > maximum value according to the
    -- last segment available

    local a = 1
    local b = #tab
    
    assert(b > 1)
    
    if x < tab[a][1] then
    return Math_rescale_no_lim(tab[a][1], tab[a][2], tab[a+1][1], tab[a+1][2], x) 
    end
    if x > tab[b][1] then
    return Math_rescale_no_lim(tab[b][1], tab[b][2], tab[b-1][1], tab[b-1][2], x) 
    end
    
    return Table_interpolate(tab, x)

end

function Set_anim_value(current_value, target, min, max, speed)

    if target >= (max - 0.001) and current_value >= (max - 0.01) then
        return max
    elseif target <= (min + 0.001) and current_value <= (min + 0.01) then
        return min
    else
        return current_value + ((target - current_value) * (speed * get(DELTA_TIME)))
    end

end

function Set_anim_value_no_lim(current_value, target, speed)
    return current_value + ((target - current_value) * (speed * get(DELTA_TIME)))
end

function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end


function FBW_PID_BP_ADV(pid_array, SP, PV)
    --sim paused no need to control
    if get(DELTA_TIME) == 0 then
        return 0
    end

    --Properties--
    local last_PV = pid_array.PV

    --inputs--
    pid_array.Error = SP - PV
    pid_array.PV = PV

    --Proportional--
    pid_array.Proportional = pid_array.Error * pid_array.P_gain

    --Back Propagation--
    pid_array.Backpropagation = pid_array.B_gain * (pid_array.Actual_output - pid_array.Desired_output)

    --Integral--
    local intergal_to_add = pid_array.I_gain * pid_array.Error + pid_array.Backpropagation
    pid_array.Integral = pid_array.Integral + intergal_to_add * get(DELTA_TIME)

    --Derivative
    pid_array.Derivative = ((last_PV - pid_array.PV) / get(DELTA_TIME)) * pid_array.D_gain

    --Sigma
    pid_array.Desired_output = pid_array.Proportional + pid_array.Integral + pid_array.Derivative

    --Output--
    return Math_clamp(pid_array.Desired_output, pid_array.Min_out, pid_array.Max_out)
end

function high_pass_filter(data)
    local dt = get(DELTA_TIME)
    local RC = 1/(2*math.pi*data.cut_frequency)
    local a = RC / (RC + dt)

    if data.prev_x_value == nil then
        data.prev_x_value = data.x
        data.prev_y_value = data.x
        return data.x
    else
        data.prev_y_value = a * (data.prev_y_value + data.x - data.prev_x_value)
    end

    return data.prev_y_value
end

function low_pass_filter(data)
    local dt = get(DELTA_TIME)
    local RC = 1/(2*math.pi*data.cut_frequency)
    local a = dt / (RC + dt)

    if data.prev_y_value == nil then
        data.prev_y_value = a * data.x
    else
        data.prev_y_value = a * data.x + (1-a) * data.prev_y_value
    end

    return data.prev_y_value
end



function GC_distance_kt(lat1, lon1, lat2, lon2)

    if lat1 == lat2 and lon1 == lon2 then
        return 0
    end

    local distance = macos(mcos(mrad(90-lat1))*mcos(mrad(90-lat2))+ msin(mrad(90-lat1))*msin(mrad(90-lat2))*mcos(mrad(lon1-lon2))) * (6378000/1852)

    return distance

end

function GC_distance_km(lat1, lon1, lat2, lon2)
    return GC_distance_kt(lat1, lon1, lat2, lon2) * 1.852
end

function get_bearing(lat1,lon1,lat2,lon2)
    local lat1_rad = mrad(lat1)
    local lat2_rad = mrad(lat2)
    local lon1_rad = mrad(lon1)
    local lon2_rad = mrad(lon2)

    local x = msin(lon2_rad - lon1_rad) * mcos(lat2_rad)
    local y = mcos(lat1_rad) * msin(lat2_rad) - msin(lat1_rad)*mcos(lat2_rad)*mcos(lon2_rad - lon1_rad)
    local theta = matan2(y, x)
    local brng = (theta * 180 / math.pi + 360) % 360

    return brng
end

function get_earth_bearing(lat1,lon1,lat2,lon2)
    return (90 - get_bearing(lat1,lon1,lat2,lon2)) % 360
end

function drawTextCentered(font, x, y, string, size, isbold, isitalic, alignment, colour)
    sasl.gl.drawText (font, x, y - (size/3),string, size, isbold, isitalic, alignment, colour)
end

--rounding
function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

--rounding - showing leading zeros
function Round_fill(num, numDecimalPlaces)
    return string.format("%."..numDecimalPlaces.."f", Round(num, numDecimalPlaces))
end