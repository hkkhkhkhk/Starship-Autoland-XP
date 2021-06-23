function Show_hide_landing_pad()
    SSS_FBW_UI:setIsVisible(not SSS_FBW_UI:isVisible())
end

Menu_master	= sasl.appendMenuItem (PLUGINS_MENU_ID, "LANDING PAD TELEMETRY" )
Menu_main	= sasl.createMenu ("", PLUGINS_MENU_ID, Menu_master)
ShowHideFBWUI	= sasl.appendMenuItem(Menu_main, "Toggle Landing Telemetry", Show_hide_landing_pad)

LandingPad = contextWindow {
    name = "Landing Telemetry";
    position = { 0 , 0 , 600 , 600};
    noBackground = true ;
    proportional = true ;
    minimumSize = {300 , 300};
    maximumSize = {900 , 900};
    gravity = { 0 , 1 , 0 , 1 };
    visible = true ;
    components = {
      flight_control {position = { 0 , 0 , 600 , 600 }}
    };
  }
