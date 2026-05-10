local args = {...}
local fs = class:getAPI('filesystem', 0)
local tbfs = class:getAPI('tbfs', 0)
local tb = {}
if args[1] == '-c' then
	tbfs.compress(args[2], (args[3] or './out.tbfs'))
elseif args[1] == '-e' then
	tbfs.extract(args[2], (args[3] or './lfar-output/'))
end