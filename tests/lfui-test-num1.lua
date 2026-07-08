class.lfui.window.window({
	title="LFUI test #1",
	id="LuaFoxYT:Main",
})
class.lfui.label.label({
	label="guess what i got in the mail.",
	id="LuaFoxYT:label",
	align={"CENTER", "FILL"},
	expand={true, false},
})
local win = class:getById("window", "LuaFoxYT:Main")
local label = class:getById("label", "LuaFoxYT:label")
class.lfui.button.button({
	id='LuaFoxYT:button0',
	label="What Did You Get?",
	align={"CENTER", "CENTER"},
	expand={false, true},
})

local btn = class:getById("button", "LuaFoxYT:button0")
win:appendChild(label)
win:appendChild(btn)
btn.onClick = function()
	label.label = "DeezNuts! Gottem!"
	label:update()
	btn:destroy()
end
btn:update()
win:show()

win:loop()
