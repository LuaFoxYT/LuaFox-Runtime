local cURL = require("cURL")

local file = io.open("downloaded_image.png", "wb")
local c = cURL.easy_init()

c:setopt_url("https://luafoxyt.github.io/")
c:setopt_writefunction(function(_, data)
file:write(data)
end, "write") -- Writes chunks directly to file disk

local success, err = pcall(function() c:perform() end)
file:close()
c:close()

if success then print("Download complete!") else print("Error:", err) end
