local args = {...}
local csr = {lfarP .. '/Data/bin/', './'}
local function cmdexec(name, ...)
	local tb = {}
	for _, v in ipairs(csr) do
		local ok = fs.exists(v .. (name or 'nomedia') .. '.lua')
		if ok then
			tb = table.pack(pcall(loadfile(v .. name .. '.lua', 't', _ENV), ...))
			break
		end
	end
	return tb
end
log('lfdev Terminal initialization')
cmdexec('tbfs', '-e', os.getenv('HOME') .. '/lfdev-save.tbfs', lfarP .. '/Data')
local term = class:getAPI('lfrt:term', 0)
term.write('loading...\n')
local fs = class:getAPI('lfrt:filesystem', 0)
for i=0, 999 do
	for _, fn in ipairs(fs.list(lfarP .. '/Data/lib')) do
		if tonumber(fn:sub(1, 3)) == i then
			log('loading module: ' .. fn)
			local f = fs.open(lfarP .. '/Data/lib/' .. fn, 'r')
			local env = {}
			for k, v in pairs(_ENV) do
				env[k] = v
			end

			env._G = env
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
term.write(fs.pwd() .. '> ')
if args[1] then
	cmdexec(table.unpack(args, 1, #args))
else
	print('ok')
term.read(function(txt)
	local args = txt:split(' ')
	for i=1, #args do
	   	args[i] = args[i]:gsub('\\s', ' ')
		args[i] = args[i]:gsub('\\n', '\n')
	end
	if args[1] == 'exit' then
		cmdexec('tbfs', '-c', lfarP .. '/Data', os.getenv('HOME') .. '/lfdev-save.tbfs')
		return true
	elseif args[1] == 'cd' then
		fs.pwd(args[2])
    term.write(fs.pwd() .. '> ')
		return nil
	end
	cmdexec(table.unpack(args, 1, #args))
end, true)
end