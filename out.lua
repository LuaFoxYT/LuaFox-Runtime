{
  ["/src"] = {
    type = "dir"
  },
  ["/src/Data"] = {
    type = "dir"
  },
  ["/src/Data/bin"] = {
    type = "dir"
  },
  ["/src/Data/bin/External.lua"] = {
    content = "--check platform--\nif _PLATFORM[1] == 'linux' then\n\9local str = ''\n\9for i, v in ipairs({...}) do\n\9\9str = str .. string.format(\"%q \", tostring(v))\n\9end\n\9os.execute(str)\nelse\n\9error('cannot run external command: unsupported platform', 0)\nend",
    type = "file"
  },
  ["/src/Data/bin/lfcprg.lua"] = {
    content = "local json = class:getAPI('TheLuaFox86:json', 0)\nlocal term = class:getAPI('lfrt:term', 0)\nlocal vars = {i=0}\nlocal go = false\nfunction adi(i)\n\9vars.i = vars.i + i or 1\n\9go = true\nend\nlocal commands = {\n\9['term_write'] = function(data)\n\9\9term.write(json:decode(data) .. '\\n')\n\9\9adi()\n\9end\n\9['term_read'] = function(data)\n\9\9term.read(function(txt)\n\9\9\9vars[json:decode(data)[1]] = txt\n\9\9\9adi()\n\9\9end)\n\9end\n}\nlocal run = function(data)\n\9log(data)\n\9local lines = json:decode(data)\n\9vars.i = 0\n\9while true do\n\9\9pcall(commands[json:docode(lines[vars.i]).method], json:docode(lines[vars.i]).args)\n\9end\nend\nprint('ass')",
    type = "file"
  },
  ["/src/Data/lib"] = {
    type = "dir"
  },
  ["/src/Data/lib/001-json.lua"] = {
    content = "class.lfrt.api.api(require('json'), 'TheLuaFox86:json', 0)",
    type = "file"
  },
  ["/src/_MAIN_.lua"] = {
    content = "log('lfdev Terminal initialization')\nlocal term = class:getAPI('lfrt:term', 0)\nterm.write('loading...\\n')\nlocal fs = class:getAPI('lfrt:filesystem', 0)\nfor i=0, 999 do\n\9for _, fn in ipairs(fs.list(lfarP .. '/data/lib')) do\n\9\9if tonumber(fn:sub(1, 3)) == i then\n\9\9\9log('loading module: ' .. fn)\n\9\9\9local f = fs.open(lfarP .. '/data/lib/' .. fn, 'r')\n\9\9\9local ok, r = pcall(load(f:read(\"*all\") .. '\\nreturn class', '=lib', \"t\"))\n\9\9\9if ok then \n\9\9\9\9_G.class = r\n\9\9\9else\n\9\9\9\9log('module failed to load: ' .. r)\n\9\9\9end\n\9\9\9f:close()\n\9\9end\n\9end\nend\nterm.write('LFDev Terminal (LuaFox Runtime) Alpha1 \\n')\nterm.read(function(txt)\n\9local args = txt:split(' ')\n\9for i=1, #args do\n\9\9args[i] = args[i]:gsub('\\\\s', ' ')\n\9\9args[i] = args[i]:gsub('\\\\n', '\\n')\n\9end\n\9if args[1] == 'exit' then\n\9\9return true\n\9end\n\9pcall(function()\n\9\9local f = fs.open(lfarP .. '/Data/bin/' .. args[1] .. '.lua', 'r')\n\9\9log(pcall(load(f:read('*all'), '=cmd', 't'), table.unpack(args, 2, -1)))\n\9\9f:close()\n\9end)\nend, true)",
    type = "file"
  }
}