local lfar = require("lfrt.lfar")
local tbfs = class:getAPI("tbfs", 0)
local fs = class:getAPI("filesystem", 0)
--local lfsp = require('lfsp')
class.lfrt.api.api({
  _searchers = {lfarP .. "lib/", fs.paths.lfrtLib, './_lib_'},
  loadLib = function(self, name, ...)
    local tb
    local ok, reason
    for _, path in ipairs(self._searchers) do
      ok, reason = pcall(function(...)
        for _, v in ipairs(fs.list(path)) do
          if v:sub(#v - (#name + 6), #v) == '/' .. name .. '.lfar' then
            tbfs.extract(path .. v, lfarP .. 'lib/' .. name .. '/')
            local env = {}
            for k, v in pairs(_ENV) do
              if k == "lfarP" then
                env.parentP = v
                env.lfarP = lfarP .. 'lib/' .. name .. '/'
              else
                env[k] = v
              end
            end
            env._G = env
            local chunk, loadErr = loadfile(lfarP .. 'lib/' .. name .. '/_MAIN_.lua', 't', env)
            if not chunk then
              error(loadErr)
            end
            local ok_load, tb_loaded = pcall(chunk, ...)
            if ok_load and type(tb_loaded) == 'table' then
              class.api.api(tb_loaded, tb_loaded.moduleID, tb_loaded.moduleVersion)
              tb = tb_loaded
            end
          end
        end
      end, ...)
      if ok then
        break
      end
    end
    if tb then
      return {tb.moduleID, tb.moduleVersion}
    end
    return nil, reason
  end,
}, 'lfrt:runtime', 0)
