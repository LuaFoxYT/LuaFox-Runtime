--luafox ui library--
log("checking for luagoobject")
local ok, lgi = pcall(require, "LuaGObject")
if lgi then log("found!") else error("Could Not Load LFui: not found are you on linux if so make sure you installed LuaGObject and its dependancies", 0) end
local Gtk = lgi.Gtk
local gio = lgi.Gio
local glib = lgi.GLib
class:append(class:newType("lfui:window", {
	constructor=function(cls, clst, obj0)
		local obj = {}
		obj.title = (obj0.title or "Blank LuaFoxUI Window")
		obj.default_width=(obj0.width or 400)
		obj.default_height=(obj0.height or 200)
		obj.on_destroy = Gtk.main_quit
		local win = obj0
		win._window = Gtk.Window(obj)
		win._obj = Gtk.Box({
		    orientation = Gtk.Orientation.HORIZONTAL,
			spacing = 10,
			margin = 15
		})
		win._window:add(win._obj)
		function win:show()
			self._window:show_all()
		end
		function win:appendChild(v)
			self._obj:add(v._obj)
		end
		function win:loop()
			Gtk.main()
		end
		return win
	end
}))
--widget creator handler--
function whandle(func, props, obj0)
	local obj = {}
	for k, v in pairs(props) do
		obj[v.rKey] = obj0[k]
	end 
	obj.valign = Gtk.Align[(obj0.align[1] or "START")]
	obj.halign = Gtk.Align[(obj0.align[2] or "START")]
	obj.vexpand = obj0.expand[1]
	obj.hexpand = obj0.expand[2]
	local box = obj0
	box._obj = func(obj)
	function box:update()
		local obj = {}
		for k, v in pairs(props) do
			obj[v.rKey] = self[k]
		end 
		obj.halign = Gtk.Align[(self.align[1] or "START")]
		obj.valign = Gtk.Align[(self.align[2] or "START")]
		obj.hexpand = self.expand[1]
		obj.vexpand = self.expand[2]
		for k, v in pairs(obj) do
			if k:sub(1, 3) == "on_" then
				self._obj[k] = v
			else
				self._obj["set_" .. k](self._obj, v)
			end
		end
	end
	function box:destroy()
		self._obj:destroy()
	end
	return box
end

class:append(class:newType("lfui:label", {
	constructor=function(cls, clst, obj0)
		return whandle(Gtk.Label, {label = {rKey='label'}}, obj0)
	end
}))
class:append(class:newType("lfui:button", {
	constructor=function(cls, clst, obj0)
		return whandle(Gtk.Button, {label = {rKey='label'}, onClick={rKey="on_clicked"}}, obj0)
	end
}))


