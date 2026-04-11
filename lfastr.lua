_G.string.split = function(str, del)
  local out = {}
local a = ''
local i = 1
for _=1, #str do
  if str:sub(i, i + (#del - 1)) == del then
    table.insert(out, a)
    a = ''
    i = i + #del
  else
    a = a .. str:sub(i, i)
    i = i + 1
  end 
end
table.insert(out, a)
return out
end
--end