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

-- Combat

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

local function highlightPlayer(player)
    if player.Character and not player.Character:FindFirstChild("HighlightikMoi") then
        local highlight = Instance.new("Highlight")

        highlight.Name = "HighlightikMoi"
        highlight.Adornee = player.Character

        highlight.FillColor = DH.GUIs.Rivals.EspFillColor or Color3.fromRGB(0, 0, 0)
        highlight.FillTransparency = 1

        highlight.OutlineColor = DH.GUIs.Rivals.EspOutlineColor or Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = (DH.GUIs.Rivals.EspOutlineTransparency or 10) / 100

        print(tostring((DH.GUIs.Rivals.EspOutlineTransparency or 10) / 100))

        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
    end
end

local function removeHighlight(player)
    if player.Character then
        local highlight = player.Character:FindFirstChild("HighlightikMoi")
        if highlight then
            highlight:Destroy()
        end
    end
end





-- Hooks

RunService.Heartbeat:Connect(function()
    if DH.GUIs.Rivals.AutoShootEnabled then
        updateAutoShoot()
    end

    if DH.GUIs.Rivals.EspNeedUpdate then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= 1 then
                removeHighlight(player)

                if DH.GUIs.Rivals.FillEspEnabled then
                    highlightPlayer(player)
                end
            end
        end

        DH.GUIs.Rivals.EspNeedUpdate = false
    end
end)

print("💅 Скрипт для Rivals загружен")