local lfar = require("lfrt.lfar")
--local lfsp = require('lfsp')
class.lfrt.api.api({
  execLFAR = function(path, ...)
  lfar.run(path, nil, ...)
  end,
  chunkBuffer = function(data, ch)
		return '--[[' .. ch .. ']]--\n local f, r = load(' .. string.format('%q, %q, ', data, '=' .. ch) .. '"t", _ENV)\nif f then local ok, re =  pcall(f)\n if not ok then log(re) end else log(tostring(r)) end\n'
	end,
}, 'lfrt:runtime', 0)