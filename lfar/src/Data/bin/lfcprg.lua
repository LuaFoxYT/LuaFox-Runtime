local json = class:getAPI('TheLuaFox86:json', 0)
local term = class:getAPI('lfrt:term', 0)
local vars = {i=0}
local go = false
function adi(i)
	vars.i = vars.i + i or 1
	go = true
end
local commands = {
	['term_write'] = function(data)
		term.write(json:decode(data) .. '\n')
		adi()
	end
	['term_read'] = function(data)
		term.read(function(txt)
			vars[json:decode(data)[1]] = txt
			adi()
		end)
	end
}
local run = function(data)
	log(data)
	local lines = json:decode(data)
	vars.i = 0
	while true do
		pcall(commands[json:docode(lines[vars.i]).method], json:docode(lines[vars.i]).args)
	end
end
print('ass')