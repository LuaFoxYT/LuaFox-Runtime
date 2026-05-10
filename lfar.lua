local lfar = {
  run = function(path, env, ...)
    local f = fs.open(path)
    local tb = table.parse(f:read('*all'))
    f:flush()
    f:close()
    for k, v in pairs(tb) do
      fs.create('./lfar' .. k, v.content)
    end
    env.lfarP = './lfar/'
    return pcall(loadfile('./lfar/_Main_.lua', 't', env))
  end
}
return lfar