require('lfpp')(function()
local lfrt = require('lfrt')
local lfar = require('lfrt.lfar')
local function doCmd(a, args)			
if a == 'lfar' then
  local ok, _ = lfrt:lfar(args[2], table.unpack(args, 3, #args))
elseif a == 'path' then
  log(lfrt:path(args[2], table.unpack(args, 3, #args)))
elseif a == 'lua' then
  local f = io.open(args[2], 'r')
	local dat = f:read('*all')
	f:flush()
	f:close()
  lfrt.run(dat, table.unpack(args, 3, #args))
elseif a == 'launch' then
lfrt:lfar(fs.paths.AppData .. 'lfrt/prg/' .. args[2] .. '.lfar', table.unpack(args, 3, #args))
end
end
	b = {'', arg[1]}
	for k, v in ipairs(arg) do
		log(k, v)
		if k > 1 then
			b[k - 2] = v
		end
	end
	if arg[1]:match('.lua') then
		doCmd('lua', b)
	elseif arg[1]:match(".lfar") then
		doCmd('lfar', b)
	elseif arg[1]:match(".lfrt-src") then
			doCmd('path', b)
	else
			doCmd(arg[1], arg)
	end
end)