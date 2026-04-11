
local lfar = require('lfrt.lfar')
local lfrt = {}
function lfrt.run(buffer, ...)
	local a = BuiltBuffer .. '\n' .. buffer
	--print(a)
	local f, r = load(a, '=lfrt')
	if f then
		return pcall(f, ...)
	end
	return false, r
end
lfrt.lfar = function(self, path, ...)
	local f = fs.open(path)
    local tb = table.parse(f:read('*all'))
    f:flush()
    f:close()
    for k, v in pairs(tb) do
      fs.create('./lfar' .. k, v.content)
    end
    local f = fs.open('./lfar/_MAIN_.lua', 'r')
    local dat = f:read('*all')
    f:flush()
    f:close()
    _G.lfarP = './lfar/'
    return self.run(dat, ...)
  end
return lfrt