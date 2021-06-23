local function proportional_resize()
    if LandingPad:isVisible() then
        local window_x, window_y, window_width, window_height = LandingPad:getPosition()
        LandingPad:setPosition ( window_x , window_y , window_width, window_width)
    end
end

function landing_debug()
    proportional_resize()
    sasl.gl.drawRectangle ( 000 , 000 , 600, 600, Black)

    drawTextCentered(Font_AirbusDUL, 110, 550, " m", 20, false, false, TEXT_ALIGN_CENTER, White)
    drawTextCentered(Font_AirbusDUL, 110, 520, "PAD BEARING: "..Round_fill(pad_bearing,1).." Deg", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 460, "ROL VELOCITY TGT: "..Round_fill(pad_command_x,1).." M/S", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 430, "PCH VELOCITY TGT: "..Round_fill(pad_command_y,1).." M/S", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 400, "ROL ACCEL TGT: "..Round_fill(velocity_roll ,1).." M/S2", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 370, "PCH ACCEL TGT: "..Round_fill(velocity_pitch,1).." M/S2", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 340, "ROL ANGLE TGT: "..Round_fill(acceleration_roll ,1).." Deg", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 310, "PCH ANGLE TGT: "..Round_fill(acceleration_pitch,1).." Deg", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 280, "ROL RATE TGT: "..Round_fill( roll_output,1).." Deg", 20, false, false, TEXT_ALIGN_LEFT, White)
    drawTextCentered(Font_AirbusDUL, 110, 250, "PCH RATE TGT: "..Round_fill(pitch_output,1).." Deg", 20, false, false, TEXT_ALIGN_LEFT, White)
end
    