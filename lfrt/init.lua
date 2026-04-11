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
--[[001-api.lua]]--\
--creation of api ClassType--\
class:append(class:newType(\"lfrt:api\", {\
  constructor = function(cls, clst, api, id, version)\
  \9log('creating api: ' .. id .. ' version ' .. version)\
    local a = {VERSIONS={}, id=id}\
    if cls:getById(\"api\", id) then\
      a = cls:getByID(\"api\", id)\
    end\
    a.VERSIONS[version] = api\
    return a\
  end\
}))\
--[[002-term.lua]]--\
local term = {\
  write = function(txt)\
    io.write(txt)\
  end,\
  read = function(callback, cont)\
    coroutine.resume(coroutine.create(function()\
      if cont then\
        repeat\
        ok, go = pcall(callback, io.read('*line'))\
        until not ok or go == true\
      else\
        local ok, r pcall(callback, io.read('*line'))\
        if ok == false then\
        \9log('term.read error: ', r)\
        end\
      end\
    end))\
  end\
}\
class.lfrt.api.api(term, 'lfrt:term', 0)\
--[[003-filesystem.lua]]--\
class.lfrt.api.api(fs, 'lfrt:filesystem', 0)\
--[[356-runtime.lua]]--\
local lfar = require(\"lfrt.lfar\")\
--local lfsp = require('lfsp')\
class.lfrt.api.api({\
  execLFAR = function(path, ...)\
  lfar.run(path, nil, ...)\
  end,\
}, 'lfrt:runtime', 0)\
"

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
