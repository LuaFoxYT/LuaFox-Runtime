
_G.class =  {}
class._searchers = {
'lfrt',
'FlashFox',
'TheLuaFox86',
}
class._types = {}
function class:addSearcher(name, place)
	local i = place
	if place == nil then
		i = #self._searchers + 1
	end
	self._searchers[i] = name
end
function class:append(tb)
  if not self[tb.domain] then self[tb.domain] = {} end
  self[tb.domain][tb.type] = tb
  self._types[tb.type] = tb
end
function class:getById(t, id)
  local a = {}
  for i, v in ipairs(id:split(":")) do
    a[i]=v
  end
  if not a[2] then
  	a[2] = a[1]
    a[1] = self._searchers[1]
    for i=1, #self._searchers do
    	if self[self._searchers[i]] then
    		if self[self._searchers[i]][t] then
    			if self[self._searchers[i]][t][a[2]] then
    				a[1] = self._searchers[i]
    				break
    			end
    		end
    	end
    end
  end
  if not self[a[1]] then
	return nil
  elseif not self[a[1]][t] then
	return nil
  elseif not self[a[1]][t][a[2]] then
	return nil
end
  return self[a[1]][t][a[2]]
end
function class:setById(t, id, val)
  local a = {}
  for i, v in ipairs(id:split(":")) do
    a[i]=v
  end
  if not a[2] then
    a[2] = a[1]
    a[1] = self._searchers[1]
    for i=1, #self._searchers do
    	if self[self._searchers[i]] then
    		if self[self._searchers[i]][t] then
    			if self[self._searchers[i]][t][a[2]] then
    				a[1] = self._searchers[i]
    				break
    			end
    		end
    	end
    end
  end
  if not self[a[1]] then
    self[a[1]] = {}
  end
  if not self[a[1]][t] then
    self[a[1]][t] = self._types[t]
  end
  self[a[1]][t][a[2]] = val
 end
function class:newType(id, tb)
  tb.domain = id:split(":")[1]
  tb.type = id:split(":")[2]
  local out = setmetatable(tb, {__index = function(s, k)
    if k == id:split(":")[2] then
      return function(...)
        local a = tb.constructor(self, s, ...)
        local obj = setmetatable(a, {__index = function(_s, _k)
          if _k == "push" then
            return function()
              class:setById(tb.type, rawget(s, "id"))
            end 
          elseif _k == "pull" then
            return function()
              _s = class:getById(s.id)
            end
          else
            return rawget(_s, _k)
          end
        end})
        class:setById(s.type, obj.id, obj)
        log('added class: ' .. obj.id .. ' of type [' .. id:split(':')[2] .. ']')
      end
    else
      return rawget(s, k)
  	end
  end})
  return out
end
function class:getAPI(id, version)
  local a = self:getById("api", id)
  if not a then
  	error('API not defined (API: ' .. id .. ' v' .. version, 2)
  end
  local b = a.VERSIONS[version]
  if not b then
  	error('API of that version not available (API: ' .. id .. ' v' .. version, 2)
  end
  b.version = version
  setmetatable(b, {__index=function(s, k)
    if k == "pull" then
      s = _G.class:getById('api', id).VERSIONS[version]
    elseif k == 'push' then
      local c = _G.class:getById('api', id)
      c.VERSIONS[version] = s
      _G.class:setById('api', id, class)
    else
    	return rawget(s, k)
    end
  end})
  return b
end