class.lfui.window.window({
	title="LFUI test #2",
	id="LuaFoxYT:Main",
})
class.lfui.label.label({
	label="type anything in text box and i will be replaced with what you typed.",
	id="LuaFoxYT:label",
	align={"CENTER", "FILL"},
	expand={true, false},
})
local win = class:getById("window", "LuaFoxYT:Main")
local label = class:getById("label", "LuaFoxYT:label")
class.lfui.entry.entry({
	id='LuaFoxYT:entry0',
	align={"CENTER", "CENTER"},
	expand={false, true},
})

local btn = class:getById("entry", "LuaFoxYT:entry0")
win:appendChild(label)
win:appendChild(btn)
btn.onSubmit = function()
	btn:fetch()
	label.label = btn.text
	label:update()
end
btn:update()
win:show()

win:loop()
