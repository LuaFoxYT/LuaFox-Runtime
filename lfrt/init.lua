local BuiltBuffer = "\
\
_G.class =  {}\
class._searchers = {\
'lfrt',\
'FlashFox',\
'TheLuaFox86',\
}\
class._types = {}\
function class:addSearcher(name, place)\
\9local i = place\
\9if place == nil then\
\9\9i = #self._searchers + 1\
\9end\
\9self._searchers[i] = name\
end\
function class:append(tb)\
  if not self[tb.domain] then self[tb.domain] = {} end\
  self[tb.domain][tb.type] = tb\
  self._types[tb.type] = tb\
end\
function class:getById(t, id)\
  local a = {}\
  for i, v in ipairs(id:split(\":\")) do\
    a[i]=v\
  end\
  if not a[2] then\
  \9a[2] = a[1]\
    a[1] = self._searchers[1]\
    for i=1, #self._searchers do\
    \9if self[self._searchers[i]] then\
    \9\9if self[self._searchers[i]][t] then\
    \9\9\9if self[self._searchers[i]][t][a[2]] then\
    \9\9\9\9a[1] = self._searchers[i]\
    \9\9\9\9break\
    \9\9\9end\
    \9\9end\
    \9end\
    end\
  end\
  if not self[a[1]] then\
\9return nil\
  elseif not self[a[1]][t] then\
\9return nil\
  elseif not self[a[1]][t][a[2]] then\
\9return nil\
end\
  return self[a[1]][t][a[2]]\
end\
function class:setById(t, id, val)\
  local a = {}\
  for i, v in ipairs(id:split(\":\")) do\
    a[i]=v\
  end\
  if not a[2] then\
    a[2] = a[1]\
    a[1] = self._searchers[1]\
    for i=1, #self._searchers do\
    \9if self[self._searchers[i]] then\
    \9\9if self[self._searchers[i]][t] then\
    \9\9\9if self[self._searchers[i]][t][a[2]] then\
    \9\9\9\9a[1] = self._searchers[i]\
    \9\9\9\9break\
    \9\9\9end\
    \9\9end\
    \9end\
    end\
  end\
  if not self[a[1]] then\
    self[a[1]] = {}\
  end\
  if not self[a[1]][t] then\
    self[a[1]][t] = self._types[t]\
  end\
  self[a[1]][t][a[2]] = val\
 end\
function class:newType(id, tb)\
  tb.domain = id:split(\":\")[1]\
  tb.type = id:split(\":\")[2]\
  local out = setmetatable(tb, {__index = function(s, k)\
    if k == id:split(\":\")[2] then\
      return function(...)\
        local a = tb.constructor(self, s, ...)\
        local obj = setmetatable(a, {__index = function(_s, _k)\
          if _k == \"push\" then\
            return function()\
              class:setById(tb.type, rawget(s, \"id\"))\
            end \
          elseif _k == \"pull\" then\
            return function()\
              _s = class:getById(s.id)\
            end\
          else\
            return rawget(_s, _k)\
          end\
        end})\
        class:setById(s.type, obj.id, obj)\
        log('added class: ' .. obj.id .. ' of type [' .. id:split(':')[2] .. ']')\
      end\
    else\
      return rawget(s, k)\
  \9end\
  end})\
  return out\
end\
function class:getAPI(id, version)\
  local a = self:getById(\"api\", id)\
  if not a then\
  \9error('API not defined (API: ' .. id .. ' v' .. version, 2)\
  end\
  local b = a.VERSIONS[version]\
  b.version = version\
  setmetatable(b, {__index=function(s, k)\
    if k == \"pull\" then\
      s = _G.class:getById('api', id).VERSIONS[version]\
    elseif k == 'push' then\
      local c = _G.class:getById('api', id)\
      c.VERSIONS[version] = s\
      _G.class:setById('api', id, class)\
    else\
    \9return rawget(s, k)\
    end\
  end})\
  return b\
end\
--[[--LFRT-Domain--]]--\
--[[classtype: 001-api.lua]]--\
 local f, r = load(\"--creation of api ClassType--\\\
class:append(class:newType(\\\"lfrt:api\\\", {\\\
  constructor = function(cls, clst, api, id, version)\\\
  \\9log('creating api: ' .. id .. ' version ' .. version)\\\
    local a = {VERSIONS={}, id=id}\\\
    if cls:getById(\\\"api\\\", id) then\\\
      a = (cls:getByID(\\\"api\\\", id) or {VERSIONS={}, id=id})\\\
    end\\\
    a.VERSIONS[version] = api\\\
    return a\\\
  end\\\
}))\", \"=classtype: 001-api.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 002-term.lua]]--\
 local f, r = load(\"local term = {\\\
  write = function(txt)\\\
    io.write(txt)\\\
  end,\\\
  read = function(callback, cont)\\\
    coroutine.resume(coroutine.create(function()\\\
      if cont then\\\
        repeat\\\
        ok, go = pcall(callback, io.read('*line'))\\\
        until not ok or go == true\\\
      else\\\
        local ok, r pcall(callback, io.read('*line'))\\\
        if ok == false then\\\
        \\9log('term.read error: ', r)\\\
        end\\\
      end\\\
    end))\\\
  end\\\
}\\\
class.lfrt.api.api(term, 'lfrt:term', 0)\", \"=classtype: 002-term.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 003-filesystem.lua]]--\
 local f, r = load(\"class.lfrt.api.api(fs, 'lfrt:filesystem', 0)\", \"=classtype: 003-filesystem.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 004-tbfs.lua]]--\
 local f, r = load(\"do\\\
  local tbfs = {} \\\
  tbfs.read = function(ap, fp)\\\
    local f = fs.open(ap, 'r')\\\
     local dat = table.parse(f:read('*all'))[fp].content\\\
    f:flush()\\\
\\9\\9f:close()\\\
    return dat\\\
  end\\\
  function tbfs.extract(fr, to)\\\
    local f = fs.open(fr, 'r')\\\
    local tb = table.parse(f:read('*all'))\\\
    f:close()\\\
    for path, stats in pairs(tb) do\\\
      fs.create(to .. path, stats.content)\\\
    end\\\
  end\\\
  function tbfs.compress(from, to)\\\
  \\9local tb = {}\\\
  \\9for _, fn in ipairs(fs.list(from, false, true)) do\\\
  \\9\\9if fs.attributes(from .. fn).mode == 'file' then\\\
  \\9\\9\\9local f = fs.open(from .. fn, 'rb')\\\
  \\9\\9\\9local dat = f:read('*all')\\\
  \\9\\9\\9f:flush()\\\
  \\9\\9\\9f:close()\\\
  \\9\\9\\9tb[fn] = {type='file', content=dat, date=0}\\\
  \\9\\9else\\\
  \\9\\9\\9tb[fn] = {type='dir', date=0}\\\
  \\9\\9end\\\
  \\9end\\\
  \\9local f = fs.open(to, 'w+')\\\
  \\9f:write(table.stringify(tb))\\\
  \\9f:flush()\\\
  \\9f:close()\\\
  end\\\
\\9class.lfrt.api.api(tbfs, 'lfrt:tbfs', 0)\\\
end\", \"=classtype: 004-tbfs.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 005-json.lua]]--\
 local f, r = load(\"class.lfrt.api.api((require('json') or {}), 'lfrt:json', 0)\", \"=classtype: 005-json.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
--[[classtype: 356-runtime.lua]]--\
 local f, r = load(\"local lfar = require(\\\"lfrt.lfar\\\")\\\
--local lfsp = require('lfsp')\\\
class.lfrt.api.api({\\\
  execLFAR = function(path, ...)\\\
  lfar.run(path, nil, ...)\\\
  end,\\\
  chunkBuffer = function(data, ch)\\\
\\9\\9return '--[[' .. ch .. ']]--\\\\n local f, r = load(' .. string.format('%q, %q, ', data, '=' .. ch) .. '\\\"t\\\", _ENV)\\\\nif f then local ok, re =  pcall(f)\\\\n if not ok then log(re) end else log(tostring(r)) end\\\\n'\\\
\\9end,\\\
}, 'lfrt:runtime', 0)\", \"=classtype: 356-runtime.lua\", \"t\", _ENV)\
if f then local ok, re =  pcall(f, ...)\
 if not ok then log(re) end else log(tostring(r)) end\
"

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
lfrt.lfar = function(self, path, ...)
	local f = fs.open(path)
    local tb = table.parse(f:read('*all'))
    f:flush()
    f:close()
    for k, v in pairs(tb) do
      fs.create('./.lfar' .. k, v.content)
    end
    local f = fs.open('./.lfar/_MAIN_.lua', 'r')
    local dat = f:read('*all')
    f:flush()
    f:close()
    _G.lfarP = './.lfar/'
    return (function(...)
	local tb = table.pack(self.run(dat, ...))
	fs.remove('./.lfar/')
	return table.unpack(tb, 1, -1)
	end)(...)
  end
return lfrt

