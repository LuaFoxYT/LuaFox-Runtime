local args = {...}
local csr = {}
local libp = {}
local function cmdexec(name, ...)
	local tb = {}
	local ok = false
	for _, v in ipairs(csr) do
		ok = fs.exists(v .. (name or 'nomedia') .. '.lua')
		if ok then
			local f, r = loadfile(v .. name .. '.lua', 't', _ENV)
			log(tostring(f), tostring(r))
			tb = table.pack(pcall(f, ...))
			break
		end
	end
	if not ok then
		if _PLATFORM[1] == 'linux' then
			local str = ''
			for i, v in ipairs({name, ...}) do
				str = str .. string.format("%q ", tostring(v))
			end
			os.execute(str)
		end
	end
	return table.unpack(tb, 1, #tb)
end
log('lfdev Terminal initialization')

local term = class:getAPI('lfrt:term', 0)
term.clear()
term.write('loading...\n')
local fs = class:getAPI('lfrt:filesystem', 0)
if not fs.exists(fs.paths.User .. '.lfdev') then
	local tbfs = class:getAPI('tbfs', 0)
	fs.create(fs.paths.User .. ".lfdev")
	tbfs.compress(lfarP .. 'Data/', lfarP .. 'data.tbfs')
	tbfs.extract(lfarP .. 'data.tbfs', fs.paths.User .. '.lfdev')
end
table.insert(csr, fs.paths.User .. ".lfdev/bin/")
table.insert(csr, "./")
table.insert(libp, fs.paths.User .. ".lfdev/lib/")
local lfdevP = fs.paths.User .. ".lfdev/"
for _, v in ipairs(libp) do
	for i=0, 999 do
		for _, fn in ipairs(fs.list(v)) do
			if tonumber(fn:sub(1, 3)) == i then
				log('loading module: ' .. fn)
				local env = {}
				for k, v in pairs(_ENV) do
					env[k] = v
				end
		
				env._G = env
				local ok, r = pcall(load(fs.readAll(v .. fn) .. '\nreturn class', '=lib', "t", env))
				if ok then 
					_G.class = r
				else
					log('module failed to load: ' .. r)
				end
			end
		end
	end
end
pwd = fs.pwd()
term.write('LFDev Terminal (LuaFox Runtime) Alpha1\n\n')
if args[1] then
	cmdexec(args[1], table.unpack(args, 2, #args))
else
term.write("CurrentDir: [" .. pwd .. "]\n")
term.read(function(txt)
	local args = txt:split(' ')
	for i=1, #args do
	   	args[i] = args[i]:gsub('\\s', ' ')
		args[i] = args[i]:gsub('\\n', '\n')
	end
	local argsb = {}
	for k, v in pairs(args) do
		--print(k, v)
		table.insert(argsb, v)
	end
	if args[1] == 'exit' then
		return true
	elseif args[1] == 'cd' then
		pwd = fs.pwd(args[2])
	else
		log(cmdexec(table.unpack(argsb, 1, #argsb)))
	end
	term.write("CurrentDir: [" .. pwd .. "]\n")
end, true, '~~> ')
end
