getgenv().DH = {
    Utils = {},
    GUIs = {},
    URL_BASE = "https://raw.githubusercontent.com/DressedHorse/Roblox-Scripts-Hub/main/"
}

local files = {
    "utils.lua",
}

print("💋 Hello!")

-- Load imports
for _, file in ipairs(files) do
    local success, src = pcall(function()
        return game:HttpGetAsync(DH.URL_BASE .. file)
    end)
    
    if not success then
        warn("Ошибка HTTP-запроса для " .. file .. ": " .. tostring(src))
        continue
    end
    
    local fn, err = loadstring(src)
    
    if not fn then
        error("Failed to compile " .. file .. ": " .. tostring(err))
    else
        local success, execErr = pcall(fn)
        if not success then
            error("Failed to execute " .. file .. ": " .. tostring(execErr))
        end
    end
end

local placeId = game.PlaceId
local PLACE_SCRIPT = {
    [117398147513099] = "rivals.lua",
    [17625359962] = "rivals.lua",
    [133215910299950] = "rivals.lua"
}

-- Load script for the current game!
if PLACE_SCRIPT[placeId] then
    print(placeId)
    local src = game:HttpGet(DH.URL_BASE .. "scripts/" .. PLACE_SCRIPT[placeId])
    local fn, compileError = loadstring(src)

    if not fn then
        error("Failed to load script for place ID " .. placeId .. ": " .. tostring(compileError))
    else
        fn()
        print("🙌 Loaded script for place ID " .. placeId)
    end
else
    print("😡 Script for game " .. placeId .. "is not found!")
end