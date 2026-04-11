log('lfdev Terminal initialization')
local term = class:getAPI('lfrt:term', 0)
term.write('loading...\n')
local fs = class:getAPI('lfrt:filesystem', 0)
for i=0, 999 do
	for _, fn in ipairs(fs.list(lfarP .. '/data/lib')) do
		if tonumber(fn:sub(1, 3)) == i then
			log('loading module: ' .. fn)
			local f = fs.open(lfarP .. '/data/lib/' .. fn, 'r')
			local env = {}
			for k, v in pairs(_ENV) do
				env[k] = v
			end
			local ok, r = pcall(load(f:read("*all") .. '\nreturn class', '=lib', "t", env))
			if ok then 
				_G.class = r
			else
				log('module failed to load: ' .. r)
			end
				f:close()
		end
	end
end
term.write('LFDev Terminal (LuaFox Runtime) Alpha1 \n')
term.read(function(txt)
	local args = txt:split(' ')
	for i=1, #args do
		args[i] = args[i]:gsub('\\s', ' ')
		args[i] = args[i]:gsub('\\n', '\n')
	end
	if args[1] == 'exit' then
		return true
	end
	pcall(function()
		local f = fs.open(lfarP .. '/Data/bin/' .. args[1] .. '.lua', 'r')
		log(pcall(load(f:read('*all'), '=cmd', 't'), table.unpack(args, 2, -1)))
		f:close()
	end)
end, true)