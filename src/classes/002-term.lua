local term = {
  write = function(txt)
    io.write(tostring(txt))
  end,
  read = function(callback, cont)
  	assert(type(callback) == 'function', 'invalid argument #1, function expected got ' .. type(callback))
  	assert(type(cont) == 'boolean', 'invalid argument #2, boolean expected got ' .. type(cont)))
    coroutine.resume(coroutine.create(function()
      if cont then
        repeat
        ok, go = pcall(callback, io.read('*line'))
        until not ok or go == true
      else
        local ok, r pcall(callback, io.read('*line'))
        if ok == false then
        	log('term.read error: ', r)
        end
      end
    end))
  end,
  clear = function()
  	return os.execute('clear')
  end
}
class.lfrt.api.api(term, 'lfrt:term', 0)