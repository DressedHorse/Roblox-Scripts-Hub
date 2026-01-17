getgenv().DH = {
    Utils = {}
}

local base = "https://raw.githubusercontent.com/DressedHorse/Roblox-Scripts-Hub/main/"

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


local PLACE_SCRIPT = {
    [17625359962] = "rivals.lua"
}

local placeId = game.PlaceId
if PLACE_SCRIPT[placeId] then
    local src = game:HttpGet(base .. "scripts/" .. PLACE_SCRIPT[placeId])
    local fn = loadstring(src)

    if not fn then
        error("Failed to load place-specific script for place ID " .. placeId)
    else
        fn()
        print("🙌 Loaded script for place ID " .. placeId)
    end
else
    print("😡 Script for game " .. place .. "is not found!")
end