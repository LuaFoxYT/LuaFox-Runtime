
local lfar = require('lfrt.lfar')
local lfrt = {}
local function buff(data, ch)
	return '--[[' .. ch .. ']]--\n local f, r = load(' .. string.format('%q, %q, ', data, '=' .. ch) .. '"t", _ENV)\nif f then local ok, re =  pcall(f, ...)\n if not ok then log(re) end else log(tostring(r)) end\n'
end
for i=1, 678 do
	for _, fn in ipairs(fs.list(os.getenv("HOME") .. '/.config/lfrt/lib', true)) do
		if tonumber(fn:split('/')[#(fn:split('/'))]:sub(1, 3)) == i then
			local f0 = fs.open(fn, 'r')
			 BuiltBuffer = BuiltBuffer .. buff(f0:read('*all'), 'External: ' .. fn)
			f0:flush()
			f0:close()
		end
	end
end

function lfrt.run(buffer, ...)
	local a = 'log(\'--[LuaFox Runtime Initialization]--\')\n' .. BuiltBuffer .. 'log(\'--[Appliation Start]--\')\n' .. buff(buffer, 'Application Main Chunk')
	--log(a)
	local f, r = load(a, '=lfrt')
	if f then
		return pcall(f, ...)
	end
	return false, r
end
lfrt.path = function(self, path, ...)
	local ogd = fs.pwd()
	fs.pwd(path)
	local fp = fs.pwd() .. '/'
	log(fp)
	fs.pwd(ogd)
	
	_ENV.lfarP = fp
	local f = fs.open(lfarP .. '_MAIN_.lua', 'r')
  local dat = f:read('*all')
  f:flush()
  f:close()

	return (function(...)
		local tb = table.pack(self.run(dat, ...))
		fs.remove(lfarP)
		return table.unpack(tb, 1, -1)
	end)(...)
end
lfrt.lfar = function(self, path, ...)
	local mypath = fs.pwd()
	local prgp = mypath .. '.lfar-' .. math.random(99999)  .. "/"
	local f = fs.open(path)
    local tb = table.parse(f:read('*all'))
    f:flush()
    f:close()
    for k, v in pairs(tb) do
      fs.create(prgp .. k, v.content)
    end
    
    return self:path(prgp, ...)
  end
return lfrt
