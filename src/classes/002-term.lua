local term = {
  write = function(txt)
    io.write(txt)
  end,
  read = function(callback, cont)
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
  end
}
class.lfrt.api.api(term, 'lfrt:term', 0)