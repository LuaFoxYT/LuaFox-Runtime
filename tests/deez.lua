-- Save this as gui.lua
local lgi = require('lgi')
local Gtk = lgi.Gtk

-- Initialize GTK
Gtk.init()

-- Create the main window
local window = Gtk.Window {
    title = "Luafox Runtime GUI",
    default_width = 400,
    default_height = 200,
    -- Handle window close event cleanly
    on_destroy = Gtk.main_quit
}

-- Create a vertical layout container
local box = Gtk.Box {
    orientation = Gtk.Orientation.VERTICAL,
    spacing = 10,
    margin = 15
}

-- Add a crisp text label
local label = Gtk.Label {
    label = "Welcome to Luafox!",
    halign = Gtk.Align.CENTER
}
box:add(label)

-- Add a button with a click event
local button = Gtk.Button { label = "Click Me" }
function button:on_clicked()
    label:set_text("Button Clicked Natively!")
end
box:add(button)

-- Put layout in window and display everything
window:add(box)
window:show_all()

-- Start the main event loop
Gtk.main()
