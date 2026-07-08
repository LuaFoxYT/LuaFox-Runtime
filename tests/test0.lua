local lgi = require 'lgi'
local Gtk = lgi.Gtk
local Gdk = lgi.Gdk

local window = Gtk.Window {
    title = "Interactive Input Canvas",
    default_width = 400,
    default_height = 300,
    on_destroy = Gtk.main_quit
}

-- 1. Create the canvas and explicitly tell GTK to listen for clicks
local canvas = Gtk.DrawingArea {
    events = { Gdk.EventMask.BUTTON_PRESS_MASK }
}

-- Define our box bounds (X, Y, Width, Height)
local button_box = { x = 100, y = 100, w = 150, h = 50, color = {0.2, 0.4, 0.8} }

-- Draw loop (same as before)
canvas.on_draw = function(widget, cr)
    cr:set_source_rgb(1, 1, 1) -- White background
    cr:paint()

    -- Render our clickable box
    cr:set_source_rgb(table.unpack(button_box.color))
    cr:rectangle(button_box.x, button_box.y, button_box.w, button_box.h)
    cr:fill()
    return true
end

-- 2. Hook into the button press event
canvas.on_button_press_event = function(widget, event)
    -- Extract the exact pixel coordinate where the user clicked
    local click_x = event.button.x
    local click_y = event.button.y

    -- 3. Perform a bounding box check (Is click inside our box?)
    if click_x >= button_box.x and click_x <= (button_box.x + button_box.w) and
       click_y >= button_box.y and click_y <= (button_box.y + button_box.h) then
       
        -- Action: Change color to green on click and redraw
        print("Box clicked exactly at: " .. click_x .. ", " .. click_y)
        button_box.color = {0.2, 0.8, 0.2}
        canvas:queue_draw() -- Refresh canvas to show new color
    end

    return true
end

window:add(canvas)
window:show_all()
Gtk.main()
