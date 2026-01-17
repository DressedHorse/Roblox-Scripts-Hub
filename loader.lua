getgenv().DH = {
    Utils = {}
}

local base = "https://raw.githubusercontent.com/you/repo/main/"

local files = {
    "utils.lua",
}

local function loadFiles()
    for _, file in ipairs(files) do
        local src = game:HttpGet(base .. file)
        local fn = loadstring(src)

        if not fn then
            error("Failed to load " .. file)
        end

        fn()
    end
end

loadFiles()

