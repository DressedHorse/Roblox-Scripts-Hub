local src = game:HttpGet(DH.URL_BASE .. "scripts/rivals_gui.lua")
local fn, compileError = loadstring(src)

if not fn then
    error("Failed to load Rivals GUI: " .. tostring(compileError))
else
    fn()
end


local RunService = game:GetService("RunService")

local RELEASE_DELAY = 0.111

local rightMousePressed = false
local lostAimTime = nil 

-- Combatt

local function updateAutoShoot()
    local aiming = DH.Utils.isAimingAtPlayer()
    local now = tick()

 

    if aiming then
        lostAimTime = nil

        if not rightMousePressed then
            mouse1press()
           
            rightMousePressed = true
        end
    elseif rightMousePressed then
        if not lostAimTime then
            lostAimTime = now 
        end

        if now - lostAimTime >= RELEASE_DELAY then
            mouse1release()
           
            rightMousePressed = false
            lostAimTime = nil
        end
    end
end

-- Esp

local nameTags = {}
local fillEsps = {}

local function highlightPlayer(player)
    if fillEsps[player] then return end

    local highlight = Instance.new("Highlight")

    highlight.Name = "HighlightikMoi"
    highlight.Adornee = player.Character

    highlight.FillColor = DH.GUIs.Rivals.EspFillColor or Color3.fromRGB(0, 0, 0)
    highlight.FillTransparency = DH.GUIs.Rivals.EspFillTransp or 0.1

    highlight.OutlineColor = DH.GUIs.Rivals.EspOutlineColor or Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = DH.GUIs.Rivals.EspOutlineTransp or 0.1

    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character

    fillEsps[player] = player.Character.Head.HighlightikMoi
end

local function removeHighlight(player)
    if fillEsps[player] then
        fillEsps[player]:Destroy()
        fillEsps[player] = nil
    end
end

local function nametagPlayer(player)
    if nameTags[player] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NametagMoi"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = player.Character.Head
    billboard.Parent = player.Character.Head
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboard

    nameTags[player] = player.Character.Head.NametagMoi
end 

local function removeTag(player)
    if nameTags[player] then
        nameTags[player]:Destroy()
        nameTags[player] = nil
    end
end



-- Hooks

RunService.Heartbeat:Connect(function()
    if DH.GUIs.Rivals.AutoShootEnabled then
        updateAutoShoot()
    end

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= 1 then
                removeHighlight(player)
                removeTag(player)   

                if DH.GUIs.Rivals.FillEspEnabled then
                    highlightPlayer(player)
                end

                if DH.GUIs.Rivals.NameTagEnabled then
                    nametagPlayer(player)
                end
            end
        end

    DH.GUIs.Rivals.EspNeedUpdate = false

end)

print("💅 Скрипт для Rivals загружен")