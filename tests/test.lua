local sdl = class:getAPI('lfrt-beta:sdl2', 0)
assert(sdl.init())
local ttf = require('SDL.ttf')
ttf.init()
local win = assert(sdl.createWindow({
	title='Test 1',
	width=600,
	height=350,
}))
local rdr = assert(sdl.createRenderer(win, 0, 0))
local running = true
local ew = assert(sdl.addEventWatch(function(event)
	if event.type == sdl.event.KeyDown then
		log(sdl.getKeyName(event.keysym.sym))
	end
end))
local fontP = "/system/fonts/DroidSans.ttf"
local font = ttf.open(fontP, 1)
log(font)
local function draw()
	rdr:setDrawColor(0xFFFFFF)
	rdr:clear()
	rdr:copy(rdr:createTextureFromSurface(assert(font:renderText("hello", 'shaded', 0x000000, 0xffffff))), nil, {w=600, h=100, x=0, y=0})
end
while running do
	if sdl.quitRequested() then
		running = false
	end
	draw()
	rdr:present()
	sdl.delay(100)
end
sdl.quit()