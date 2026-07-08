do
  local tbfs = {}
  tbfs.read = function(ap, fp)
  	assert(type(ap) == 'string', 'invalid argument #1; expected string got ' .. type(ap))
  	assert(type(fp) == 'string', 'invalid argument #2; expected string got ' .. type(fp))
  	assert(fs.exists(ap), 'archive not found at ' .. ap)
    local f = fs.open(ap, 'r')
     local dat = table.parse(f:read('*all'))[fp]
     assert(dat, 'file in archive not found at' .. fp)
    f:flush()
		f:close()
    return dat
  end
  function tbfs.extract(fr, to)
  	assert(type(fr) == 'string', 'invalid argument #1; expected string got ' .. type(fr))
  	assert(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	assert(fs.exists(fr), 'file not found; ' .. fr)
    local f = fs.open(fr, 'r')
    local tb = table.parse(f:read('*all'))
    f:close()
    for path, stats in pairs(tb) do
      fs.create(to .. path, stats.content)
    end
  end
  function tbfs.compress(from, to)
  	assert(type(from) == 'string', 'invalid argument #1; expected string got ' .. type(from))
  	assert(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	assert(fs.exists(from), 'file not found; ' .. from)
  	local tb = {}
  	for _, fn in ipairs(fs.list(from, false, true)) do
  		if fs.attributes(from .. fn).mode == 'file' then
  			local f = fs.open(from .. fn, 'rb')
  			local dat = f:read('*all')
  			f:flush()
  			f:close()
  			tb[fn] = {type='file', content=dat, date=0}
  		else
  			tb[fn] = {type='dir', date=0}
  		end
  	end
  	local f = fs.open(to, 'w+')
  	f:write(table.stringify(tb))
  	f:flush()
  	f:close()
  end
	class.lfrt.api.api(tbfs, 'lfrt:tbfs', 0)
end