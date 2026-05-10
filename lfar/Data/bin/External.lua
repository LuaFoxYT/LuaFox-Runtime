--check platform--
if _PLATFORM[1] == 'linux' then
	local str = ''
	for i, v in ipairs({...}) do
		str = str .. string.format("%q ", tostring(v))
	end
	os.execute(str)
else
	error('cannot run external command: unsupported platform', 0)
end