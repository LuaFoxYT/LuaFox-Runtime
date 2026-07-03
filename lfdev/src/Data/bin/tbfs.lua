local args = {...}
local fs = class:getAPI('filesystem', 0)
print(args[1])
local tb = {}
if args[1] == '-c' then
  print(args[2])
	for i, fn in ipairs(fs.list(args[2], false, true)) do
		if fs.attributes(args[2] .. fn).mode == 'file' then
			local f = fs.open(args[2] .. fn, 'rb')
			tb[fn] = {type='file', content=f:read('*all')}
		else
			tb[fn] = {type='dir'}
		end 
	end
	local f = fs.open((args[3] or './out.tbfs'), 'w+')
	f:write(table.stringify(tb))
	f:flush()
	f:close()
elseif args[1] == '-e' then
	local f = fs.open(args[2], 'r')
	local tb = table.parse(f:read('*all'))
	f:close()
	for k, v in pairs(tb) do
		fs.create((args[3] or './output') .. k, v.content)
	end
end