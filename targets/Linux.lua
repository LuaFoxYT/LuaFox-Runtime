local buffer = ''
local function buff(data, ch)
	return '--[[' .. ch .. ']]--\n local f, r = load(' .. string.format('%q, %q, ', data, '=' .. ch) .. '"t", _ENV)\nif f then local ok, re =  pcall(f, ...)\n if not ok then log(re) end else log(tostring(r)) end\n'
end
local lfpp = require('lfpp')
--lfpp._G = lfpp
--_ENV = lfpp
print('classtypes')
for i=0, 356 do
  for _, fn in ipairs(fs.list('./src/classtypes')) do
    if tonumber(fn:sub(1, 3)) == i then
    	print(fn)
      local f = fs.open('./src/classtypes/' .. fn, 'r')
      buffer = buffer .. buff(f:read('*all'), 'classtype: ' .. fn)
      f:close()
      break
    end
  end
end
print('classes:')
for i=0, 356 do
  for _, fn in ipairs(fs.list('./src/classes')) do
    if tonumber(fn:sub(1, 3)) == i then
    	print(fn)
      local f = fs.open('./src/classes/' .. fn, 'r')
      buffer = buffer .. buff(f:read('*all'), 'classtype: ' .. fn)
      f:close()
      break
    end
  end
end
print('adding MAIN.lua to buffer')
local f = fs.open('./src/MAIN.lua', 'r')
buffer = '\n' .. f:read('*all') .. '\n--[[--LFRT-Domain--]]--\n' .. buffer
f:close()
print('building byte escaped strings')
local a = buffer
for i=1, #buffer do
	--a = a .. '\\' .. buffer:byte(i)
end
print(buffer)
a = 'local BuiltBuffer = ' .. string.format('%q', a).. '\n'
print('creating init.lua')
local f = fs.open('./src/interface.lua', 'r')
a = a .. f:read('*all') .. '\n'
f:close()
local f = fs.open('./init.lua', 'w+')
f:write(a)
f:flush()
f:close()