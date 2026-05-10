require('lfpp')(function()
local lfrt = require('lfrt')
local lfar = require('lfrt.lfar')
if arg[1] == 'lfar' then
  local ok, _ = lfrt:lfar(table.unpack(arg, 2, #arg))
elseif arg[1] == 'path' then
  print('comming soon')
elseif arg[1] == 'lua' then
  local f = io.open(arg[2], 'r')
	local dat = f:read('*all')
	f:flush()
	f:close()
  lfrt.run(dat, table.unpack(arg, 3, #arg))
elseif arg[1] == 'launch' then
lfrt:lfar(fs.paths.AppData .. 'lfrt/prg/' .. arg[2] .. '.lfar', table.unpack(arg, 3, #arg))
end
end)