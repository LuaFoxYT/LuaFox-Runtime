{
  ["/Data"] = {
    type = "dir"
  },
  ["/Data/bin"] = {
    type = "dir"
  },
  ["/Data/bin/External.lua"] = {
    content = "--check platform--\nif _PLATFORM[1] == 'linux' then\n\9local str = ''\n\9for i, v in ipairs({...}) do\n\9\9str = str .. string.format(\"%q \", tostring(v))\n\9end\n\9os.execute(str)\nelse\n\9error('cannot run external command: unsupported platform', 0)\nend",
    type = "file"
  },
  ["/Data/bin/python.lua"] = {
    content = "",
    type = "file"
  },
  ["/Data/bin/tbfs.lua"] = {
    content = "local args = {...}\nlocal fs = class:getAPI('filesystem', 0)\nprint(args[1])\nlocal tb = {}\nif args[1] == '-c' then\n\9for i, fn in ipairs(fs.list(args[2], false, true)) do\n\9\9if fs.attributes(args[2] .. fn).mode == 'file' then\n\9\9\9local f = fs.open(args[2] .. fn, 'rb')\n\9\9\9tb[fn] = {type='file', content=f:read('*all')}\n\9\9else\n\9\9\9tb[fn] = {type='dir'}\n\9\9end   \n\9end\n\9local f = fs.open((args[3] or './out.tbfs'), 'w+')\n\9f:write(table.stringify(tb))\n\9f:flush()\n\9f:close()\nelseif args[1] == '-e' then\n\9local f = fs.open(args[2], 'r')\n\9local tb = table.parse(f:read('*all'))\n\9f:close()\n\9for k, v in pairs(tb) do\n\9\9fs.create((args[3] or './output') .. k, v.content)\n\9end\nend",
    type = "file"
  },
  ["/Data/lib"] = {
    type = "dir"
  },
  ["/Data/lib/001-json.lua"] = {
    content = "class.lfrt.api.api(require('json'), 'TheLuaFox86:json', 0)",
    type = "file"
  },
  ["/_MAIN_.lua"] = {
    content = "local args = {...}\nlocal csr = {lfarP .. '/Data/bin/', './'}\nlocal function cmdexec(name, ...)\n\9local tb = {}\n\9for _, v in ipairs(csr) do\n\9\9local ok = fs.exists(v .. (name or 'nomedia') .. '.lua')\n\9\9if ok then\n\9\9\9tb = table.pack(pcall(loadfile(v .. name .. '.lua', 't', _ENV), ...))\n\9\9\9break\n\9\9end\n\9end\n\9return tb\nend\nlog('lfdev Terminal initialization')\ncmdexec('tbfs', '-e', os.getenv('HOME') .. '/lfdev-save.tbfs', lfarP .. '/Data')\nlocal term = class:getAPI('lfrt:term', 0)\nterm.write('loading...\\n')\nlocal fs = class:getAPI('lfrt:filesystem', 0)\nfor i=0, 999 do\n\9for _, fn in ipairs(fs.list(lfarP .. '/Data/lib')) do\n\9\9if tonumber(fn:sub(1, 3)) == i then\n\9\9\9log('loading module: ' .. fn)\n\9\9\9local f = fs.open(lfarP .. '/Data/lib/' .. fn, 'r')\n\9\9\9local env = {}\n\9\9\9for k, v in pairs(_ENV) do\n\9\9\9\9env[k] = v\n\9\9\9end\n\n\9\9\9env._G = env\n\9\9\9local ok, r = pcall(load(f:read(\"*all\") .. '\\nreturn class', '=lib', \"t\", env))\n\9\9\9if ok then \n\9\9\9\9_G.class = r\n\9\9\9else\n\9\9\9\9log('module failed to load: ' .. r)\n\9\9\9end\n\9\9\9f:close()\n\9\9end\n\9end\nend\nterm.write('LFDev Terminal (LuaFox Runtime) Alpha1 \\n')\nterm.write(fs.pwd() .. '> ')\nif args[1] then\n\9cmdexec(table.unpack(args, 1, #args))\nelse\n\9print('ok')\nterm.read(function(txt)\n\9local args = txt:split(' ')\n\9for i=1, #args do\n\9   \9args[i] = args[i]:gsub('\\\\s', ' ')\n\9\9args[i] = args[i]:gsub('\\\\n', '\\n')\n\9end\n\9if args[1] == 'exit' then\n\9\9cmdexec('tbfs', '-c', lfarP .. '/Data', os.getenv('HOME') .. '/lfdev-save.tbfs')\n\9\9return true\n\9elseif args[1] == 'cd' then\n\9\9fs.pwd(args[2])\n    term.write(fs.pwd() .. '> ')\n\9\9return nil\n\9end\n\9cmdexec(table.unpack(args, 1, #args))\nend, true)\nend",
    type = "file"
  }
}