DELTA_TIME = globalProperty("sim/operation/misc/frame_rate_period")
TIME = globalProperty("sim/time/total_running_time_sec")

Throttle = globalProperty("sim/cockpit2/engine/actuators/throttle_beta_rev_ratio_all")

Airspeed = globalProperty("sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
Pitch = globalProperty("sim/cockpit2/gauges/indicators/pitch_AHARS_deg_pilot")
Roll = globalProperty("sim/cockpit2/gauges/indicators/roll_AHARS_deg_pilot")
Heading = globalProperty("sim/cockpit2/gauges/indicators/heading_AHARS_deg_mag_pilot")

True_Pitch = globalProperty("sim/flightmodel/position/true_theta")
True_Roll = globalProperty("sim/flightmodel/position/true_phi")
True_Heading = globalProperty("sim/flightmodel/position/true_psi")

Override_fctl = globalProperty("sim/operation/override/override_flightcontrol")
Aileron = globalProperty("sim/cockpit2/controls/total_roll_ratio")
Elevator = globalProperty("sim/cockpit2/controls/total_pitch_ratio")
Rudder = globalProperty("sim/cockpit2/controls/total_heading_ratio")

Stick_roll = globalProperty("sim/joystick/yolk_roll_ratio")
Stick_pitch = globalProperty("sim/joystick/yolk_pitch_ratio")
Stick_yaw = globalProperty("sim/joystick/yolk_heading_ratio")

Lat = globalProperty("sim/flightmodel/position/latitude")
Lon = globalProperty("sim/flightmodel/position/longitude")

Lat_accel = globalProperty("sim/flightmodel/position/local_ax")
Lon_accel = globalProperty("sim/flightmodel/position/local_az")

Lat_veloc = globalProperty("sim/flightmodel/position/local_vx")
Lon_veloc = globalProperty("sim/flightmodel/position/local_vz")

Fuel = globalProperty("sim/flightmodel/weight/m_fuel[0]")