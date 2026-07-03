local L = require("linenoise")
local reading = false
local latest = ""
local term = {
  write = function(txt)
    a = tostring(txt)
    latest = a
    if not reading then
    io.write(a)
    else
      reading = false
    end
  end,
  read = function(callback, cont, text)
  	assert(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))
  	assert(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont))
    coroutine.resume(coroutine.create(function()
      reading = true
      if cont then
        repeat
        ok, go = pcall(callback, L.linenoise((text or latest)))
        until not ok or go == true
      else
        local ok, r pcall(callback, L.linenoise((text or latest)))
        if ok == false then
        	log('term.read error: ', r)
        end
      end
    end))
  end,
  clear = function()
  	return L.clearscreen()
  end
}
class.lfrt.api.api(term, 'lfrt:term', 0)