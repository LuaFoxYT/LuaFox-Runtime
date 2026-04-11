--made for luafox runtime--
local lfastr = require("lfastr")
local serpent = require("serpent")
local lfs = require("lfs")
-- global adjustmemts--
_G.clear = function()
	os.execute('clear')
end
_G._PLATFORM = {"linux", "lua", _VERSION}
function _G.dostring(str)
  return load(str, '=DoString_Chunk', 'bt')
end
--table adjustments--
table.stringify = function(tb)
  return serpent.line(tb, {comment=false})
end
function table.parse(str)
  return load("return " .. str, '=Table_Parser', 't')()
end
--filesystem--
do
  local fs = {}
  fs.exists = function(path)
    if lfs.touch(path) then
      return true
    else
      return false
    end
  end
  fs.create = function(path, data)
    local a = ''
    for i, v in ipairs(path:split('/')) do
      a = a .. v .. '/'
      b, c = lfs.touch(a)
      if not b then
        if data ~= nil and i >= #path:split('/') then
          local f0 = io.open(path, 'wb')
          f0:write(data)
          f0:flush()
          f0:close()
        else
          lfs.mkdir(a)
        end
      end
    end
  end
  fs.list = function(path, isFull, recurse)
    local out = {}
    local function cycle(s, p)
      for f in lfs.dir(path) do
        if fs.attributes(path .. f).mode == 'file' then
          if isFull then
            table.insert(out, path .. '/' .. f)
          else
            table.insert(out, f) 
          end
        else
          cycle(s, p .. '/' .. f)
          if isFull then
            table.insert(out, s .. p .. '/' .. f)
          else
            table.insert(out, p .. '/' .. f)
          end
        end
      end
    end
    if recurse then
    	cycle(path, '')
    else
    	for f in lfs.dir(path) do
    		if isFull then
    			table.insert(out, path .. '/' .. f)
    		else
    			table.insert(out, f) 
    		end
    	end
    end
    return out
  end
  fs.open = io.open
  fs.attributes = lfs.attributes
  fs.remove = function(path)
    if lfs.attributes(path).mode == 'directory' then
      local function cycle(s, p)
        for f in lfs.dir(s .. p) do
          if f ~= '.' and f ~= '..' then
            if lfs.attributes(s .. p .. '/' .. f).mode == 'file' then
              os.remove(s .. p .. '/' .. f)
            elseif lfs.attributes(s .. p .. './' .. f).mode == 'directory' then
              cycle(s, p .. '/' .. f)
              lfs.rmdir(s .. p .. '/' ..  f)
            end
          end
        end
      end
      cycle(path, "")
    else
      os.remove(path)
    end
  end
  fs.pwd = function(val)
    if val then
      lfs.chwdir(val)
    end
    return lfs.currentdir()
  end
	_G.fs = fs
end
do
local f = io.open('./log.txt', 'w+')
_G.log = function(...)
	local a = ''
	for k, v in ipairs({...}) do
		a = a .. tostring(v) .. '\t'
	end
	f:write(a .. '\n')
end
return function(cb, ...)
	local tb = {pcall(cb, ...)}
	f:flush()
	f:close()
	if not tb[1] then
		log('Error: ' .. tb[2])
		return nil, tb[2]
	end
	return table.unpack(tb, 2, -1)
end
end