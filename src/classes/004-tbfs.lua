do
	local fs = class:getAPI("filesystem", 0)
  local tbfs = {}
  tbfs.read = function(ap, fp)
  	argc(type(ap) == 'string', 'invalid argument #1; expected string got ' .. type(ap))
  	argc(type(fp) == 'string', 'invalid argument #2; expected string got ' .. type(fp))
  	argc(fs.exists(ap), 'archive not found at ' .. ap)
     local dat = table.parse(fs.readAll(ap))[fp]
     argc(dat, 'file in archive not found at' .. fp)
    return dat
  end
  function tbfs.extract(fr, to)
  	argc(type(fr) == 'string', 'invalid argument #1; expected string got ' .. type(fr))
  	argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	argc(fs.exists(fr), 'file not found; ' .. fr)
    local f = fs.open(fr, 'r')
    local tb = table.parse(f:read('*all'))
    f:close()
    for path, stats in pairs(tb) do
      fs.create(to .. path, stats.content)
    end
  end
  function tbfs.compress(from, to)
  	argc(type(from) == 'string', 'invalid argument #1; expected string got ' .. type(from))
  	argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	argc(fs.exists(from), 'file not found; ' .. from)
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

do
	local fs = class:getAPI("filesystem", 1)
  local tbfs = {}
  tbfs.read = function(ap, fp)
  	argc(type(ap) == 'string', 'invalid argument #1; expected string got ' .. type(ap))
  	argc(type(fp) == 'string', 'invalid argument #2; expected string got ' .. type(fp))
  	argc(fs.exists(ap), 'archive not found at ' .. ap)
     local dat = table.parse(fs.readAll(ap))[fp]
     argc(dat, 'file in archive not found at' .. fp)
    return dat
  end
  function tbfs.extract(fr, to)
  	argc(type(fr) == 'string', 'invalid argument #1; expected string got ' .. type(fr))
  	argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	argc(fs.exists(fr), 'file not found; ' .. fr)
    local tb = table.parse(fw.readAll('*all'))
    for path, stats in pairs(tb) do
      fs.create(to .. path, stats.content)
    end
  end
  function tbfs.compress(from, to)
  	argc(type(from) == 'string', 'invalid argument #1; expected string got ' .. type(from))
  	argc(type(to) == 'string', 'invalid argument #2; expected string got ' .. type(to))
  	argc(fs.exists(from), 'file not found; ' .. from)
  	local tb = {}
  	for _, fn in ipairs(fs.list(from, false, true)) do
  		if fs.attributes(from .. fn).mode == 'file' then
  			tb[fn] = {type='file', content=fs.readAll(from .. fn), date=0}
  		else
  			tb[fn] = {type='dir', date=0}
  		end
  	end
  	fs.writeAll(table.stringify(tb))
  end
	class.lfrt.api.api(tbfs, 'lfrt:tbfs', 1)
end

