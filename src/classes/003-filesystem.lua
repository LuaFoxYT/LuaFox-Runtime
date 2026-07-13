class.lfrt.api.api(fs, 'lfrt:filesystem', 0)
do
	local fsa = {}
	for k, v in pairs(fs) do
		fsa[k] = rawget(fs, k)
	end
	--custom lfrt filesystem functions here (if i add)--
	fsa.open = nil
	--end--
	class.lfrt.api.api(fsa, "lfrt:fs", 1)
end
