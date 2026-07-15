do
	local tbfs = class:getAPI("tbfs", 0)
	local fs = class:getAPI("filesystem", 0)
	local lfpk = {installed = {}}
	if fs.exists(fs.paths.AppData .. 'lfpk-lfrt.installed') then
		lfpk.installed = table.parse(fs.readAll(fs.paths.AppData .. 'lfpk-lfrt.installed'))
	end
	function lfpk.update(self, obj, isRM)
		if not isRM then
			local inf = obj.info
			self.installed[inf.packageID] = inf
		else
			self.installed[obj.info.packageID] = nil
		end
		fs.writeAll(fs.paths.AppData .. 'lfpk-lfrt.installed', table.stringify(self.installed))
	end		
	function lfpk.parse(self, path)
		local obj = {}
		obj.info = table.parse(tbfs.read(path, "/_INFO_.lua").content)
		obj.files = {}
		local a = table.parse(tbfs.read(path, '/_FILES_.tbfs').content)
		for entryPath, entry in pairs(a) do
			local b = entryPath
			for template, templatePath in pairs(fs.paths) do
				log(b, template, templatePath, 1)
				if b:sub(2, #template) == template then
					b ='/' .. b:sub(#template + 1, #b)
				end
				log(b, template, templatePath, 2)
			end
			obj.files[b] = entry
		end
		local d = obj.info.packageDependencies
		for entryPath, entry in pairs(d) do
			local b = entryPath
			for template, templatePath in pairs(fs.paths) do
				log(b, template, templatePath, 1)
				local f = b
				local e = f:sub(2, 26)
				local name = template .. ("_"):rep(25 - #template)
				if e == name then
					b = '/' .. templatePath .. b:sub(27, #b)
				end
				log(b, template, templatePath, 2)
			end
			obj.info.packageDependencies[b] = entry
		end
		return obj
	end
	function lfpk.generate(self, obj, path)
		local tmp = fs.pwd() .. "/.temp-" .. math.random(99999) .. '/'
		fs.create(tmp .. '_INFO_.lua', table.stringify(obj.info))
		fs.create(tmp .. '_FILES_.tbfs', table.stringify(obj.files))
		tbfs.compress(tmp, path or './' .. obj.info.packageID .. '.lfpk')
		fs.remove(tmp)
	end
	lfpk.install = function(self, obj)
		fs.writeAll('./temp.tbfs', table.stringify(obj.files))
		tbfs.extract('./temp.tbfs', '/')
		self:update(obj, true)
	end
	function lfpk.uninstall(self, obj)
		for k, v in pairs(self.installed[obj.info.packageID].files) do
			if v then
				log("removing " .. v)
				fs.remove(k)
			else
				log("skipping " .. v)
			end
		end
	end
	class.lfrt.api.api(lfpk, 'lfrt:lfpk', 0)
end
