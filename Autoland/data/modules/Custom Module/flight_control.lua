size = {600, 600}

pad_distance = 0
pad_bearing = 0
pad_command_x = 0
pad_command_y = 0
velocity_roll = 0
velocity_pitch = 0
acceleration_roll = 0
acceleration_pitch = 0
roll_output = 0
roll_rate_output = 0
pitch_output = 0
pitch_rate_output = 0
yaw_output = 0
yaw_rate_output = 0

pitch_rate_filtered = 0
roll_rate_filtered = 0
pad_x_filtered = 0
pad_y_filtered = 0
acceleration_x_filtered = 0
acceleration_y_filtered = 0

gain_divider = 0

manual_control = false

include('pid_arrays.lua')
include('landing_debug.lua')

pad_coordinates = {25.997148, -97.155224}

local rates ={
    Roll = {
        x = 0,
        dataref = True_Roll
    },
    Pitch = {
        x = 0,
        dataref = True_Pitch
    },
    Yaw = {
        x = 0,
        dataref = Heading
    }
}

filters = {
    pitch_rate = {
       x = 0,
       cut_frequency = 6
    },
    roll_rate = {
        x = 0,
        cut_frequency = 6
     },
     pad_distance_x_filtered = {
        x = 0,
        cut_frequency = 0.1
     },
     pad_distance_y_filtered = {
        x = 0,
        cut_frequency = 0.1
     },
     accx_filtered = {
        x = 0,
        cut_frequency = 0.1
     },
     accy_filtered = {
        x = 0,
        cut_frequency = 0.1
     }
}

local function update_rates(table)
    for key, value in pairs(table) do
        --init tables--
        if table[key].previous_value == nil then
            table[key].previous_value = get(table[key].dataref)
        end
        if table[key].previous_time == nil then
            table[key].previous_time = get(TIME)
        end

        --check if paused--
        if get(TIME) - table[key].previous_time ~= 0 then
            --compute rates--
            table[key].x = (get(table[key].dataref) - table[key].previous_value) / (get(TIME) - table[key].previous_time)
        end

        --record value--
        table[key].previous_value = get(table[key].dataref)
        table[key].previous_time = get(TIME)
    end
end

function draw()
    landing_debug()
end

function filtering()
    filters.pitch_rate.x = rates.Pitch.x
    filters.roll_rate.x = rates.Roll.x
    filters.pad_distance_x_filtered.x = pad_distance_table[1]
    filters.pad_distance_y_filtered.x = pad_distance_table[2]
    filters.accx_filtered.x = get(Lon_accel)
    filters.accy_filtered.x = get(Lat_accel)
    pitch_rate_filtered = low_pass_filter(filters.pitch_rate)
    roll_rate_filtered = low_pass_filter(filters.roll_rate)
    pad_x_filtered = low_pass_filter(filters.pad_distance_x_filtered)
    pad_y_filtered = low_pass_filter(filters.pad_distance_y_filtered)
    acceleration_x_filtered = low_pass_filter(filters.accx_filtered)
    acceleration_y_filtered = low_pass_filter(filters.accy_filtered)
end

set( Override_fctl, 1)

function update()
    update_rates(rates)
    set(Fuel, 128647)
    pad_distance = GC_distance_km(pad_coordinates[1], pad_coordinates[2], get(Lat), get(Lon))*1000
    pad_bearing = get_earth_bearing(pad_coordinates[1], pad_coordinates[2], get(Lat), get(Lon))
    pad_distance_table = {     
        math.sin(math.rad(pad_bearing)) * pad_distance,
        -math.cos(math.rad(pad_bearing)) * pad_distance
    }

    filtering()
    
    if manual_control then
        roll_output = FBW_PID_BP_ADV( roll_array, 0 , get(True_Roll))
        pitch_output = FBW_PID_BP_ADV(pitch_array, -85 , get(True_Pitch))
        yaw_output = FBW_PID_BP_ADV( yaw_array, 180, get(True_Heading))
        set(Elevator, pitch_output)
        set(Aileron,roll_output)
        set(Rudder, yaw_output)
    else
        pad_command_x = FBW_PID_BP_ADV(landing_pad_roll , 0 ,  pad_x_filtered)
        pad_command_y = FBW_PID_BP_ADV(landing_pad_pitch , 0 ,  pad_y_filtered)
    
        velocity_roll = FBW_PID_BP_ADV( roll_veloc_array , pad_command_x ,  get(Lat_veloc))
        velocity_pitch = FBW_PID_BP_ADV( pitch_veloc_array, pad_command_y , get(Lon_veloc))
    
        acceleration_roll = FBW_PID_BP_ADV( roll_acc_array ,velocity_roll , acceleration_x_filtered)
        acceleration_pitch = FBW_PID_BP_ADV( pitch_acc_array, velocity_pitch, acceleration_y_filtered)
    
        roll_output = FBW_PID_BP_ADV( roll_array, -acceleration_roll , get(True_Roll))
        roll_rate_output = FBW_PID_BP_ADV(roll_rate_array, roll_output, rates.Roll.x)
    
        pitch_output = FBW_PID_BP_ADV(pitch_array, -acceleration_pitch , get(True_Pitch))
        pitch_rate_output = FBW_PID_BP_ADV(pitch_rate_array, pitch_output, pitch_rate_filtered)
    
        yaw_output = FBW_PID_BP_ADV( yaw_array, 180, get(True_Heading))
        yaw_rate_output = FBW_PID_BP_ADV(yaw_rate_array,  yaw_output, rates.Yaw.x)
    
       set(Elevator, pitch_rate_output)
       set(Aileron,roll_rate_output)
       set(Rudder, yaw_rate_output)
    end
end