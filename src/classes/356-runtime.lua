local lfar = require("lfrt.lfar")
--local lfsp = require('lfsp')
class.lfrt.api.api({
  execLFAR = function(path, ...)
  lfar.run(path, nil, ...)
  end,
}, 'lfrt:runtime', 0)