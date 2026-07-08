
local lfar = require('lfrt.lfar')
local lfrt = {}
local function buff(data, ch)
	return '--[[' .. ch .. ']]--\n local f, r = load(' .. string.format('%q, %q, ', data, '=' .. ch) .. '"t", _ENV)\nif f then local ok, re =  pcall(f, ...)\n if not ok then log(re) end else log(tostring(r)) end\n'
end

function lfrt.run_new(buffer, path, ...)
	local mypath = fs.pwd()
	_ENV.lfarP = (path or mypath .. '/.lfar-' .. math.random(99999)  .. "/")
	fs.create(lfarP)
	local a = 'log(\'--[LuaFox Runtime Initialization]--\')\n' .. BuiltBuffer .. 'log(\'--[Appliation Start]--\')\n' .. buff(buffer, 'Application Main Chunk')
	--log(a)
	local f, r = load(a, '=lfrt')
	if f then
		return pcall(f, ...)
	end
	return false, r
end
lfrt.run = function(b, ...)
	return lfrt.run_new(b, nil, ...)
end
lfrt.path = function(self, path, ...)
	local ogd = fs.pwd()
	fs.pwd(path)
	local fp = fs.pwd() .. '/'
	log(fp)
	fs.pwd(ogd)
	
  local dat = fs.readAll(fp .. '_MAIN_.lua')
	return (function(...)
		local tb = table.pack(self.run_new(dat, fp, ...))
		return table.unpack(tb, 1, #tb)
	end)(...)
end
lfrt.lfar = function(self, path, ...)
	local mypath = fs.pwd()
	local prgp = mypath .. '/.lfar-' .. math.random(99999)  .. "/"
  local tb = table.parse(fs.readAll(path))
  for k, v in pairs(tb) do
    fs.create(prgp .. k, v.content)
  end
  local out = self:path(prgp, ...)
	fs.remove(prgp)
	return out
end
return lfrt
