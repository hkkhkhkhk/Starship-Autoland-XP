-- main.lua

sasl.options.setAircraftPanelRendering(true)
sasl.options.setInteractivity(true)
sasl.options.set3DRendering(true)

-- devel
sasl.options.setLuaErrorsHandling(SASL_STOP_PROCESSING)

-- Initialize the random seed for math.random
math.randomseed( os.time() )

include('functions.lua')
include('datarefs.lua')
include("constants.lua")
include(moduleDirectory .. "/main_windows.lua")

components = {
	flight_control{},
	quatarnians{},
}







