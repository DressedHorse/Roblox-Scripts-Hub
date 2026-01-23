local src = game:HttpGet(DH.URL_BASE .. "scripts/rivals_gui.lua")
local fn, compileError = loadstring(src)

if not fn then
    error("Failed to load Rivals GUI: " .. tostring(compileError))
else
    fn()
end


local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- AutoShoot
local RELEASE_DELAY = 0.111

-- AutoScope
local COOLDOWN = false
local SCOPE_DELAY = 0.12


local leftMousePressed = false
local lostAimTime = nil 

local WeaponDelays = {
    Default = 1,

    ["Handgun"] = 0.11,
    ["Spray"] = 1.0,
    ["Shotgun"] = 0.7
}


local AUTOHOLD_WEAPONS = {
    "Rifle", "Uzi", "PaintballGun", "Hands", "Sniper"
}


-- Combat

local function isAutoHoldWeapon(name)
    for _, w in ipairs(AUTOHOLD_WEAPONS) do
        if string.find(name, w) then
            return true
        end
    end
    return false
end

local function updateAutoShoot()
    local aiming = DH.Utils.isAimingAtPlayer()
    local now = tick()

    local myPlayer = game:GetService("Players").LocalPlayer
    local myWeaponObj = DH.Utils.getHeldWeapon(myPlayer.Name)
    local myWeapon = myWeaponObj and myWeaponObj.Name or "None"

    if aiming then
        lostAimTime = nil

        local target = DH.Utils.getPlayerOnCrosshair()
        local targetHeldWeapon = target and DH.Utils.getHeldWeaponOther(target.Name)
        local isReflecting = DH.Utils.isReflectingWithKatana(target.Name)
            or (targetHeldWeapon and string.find(targetHeldWeapon.Name, "RiotShield"))

        if not leftMousePressed and not isReflecting then
            if isAutoHoldWeapon(myWeapon) then
                -- зажим ЛКМ
                mouse1press()
                leftMousePressed = true
            else
                -- спам ЛКМ с задержкой + рандом
                task.spawn(function()
                    leftMousePressed = true
                    while DH.Utils.isAimingAtPlayer() do
                        mouse1press()
                        task.wait((WeaponDelays[myWeapon] or WeaponDelays.Default))
                        mouse1release()
                        task.wait((WeaponDelays[myWeapon] or WeaponDelays.Default))
                    end
                    leftMousePressed = false
                end)
            end
        end
    elseif leftMousePressed then
        -- логика отпускания ЛКМ для зажимаемых оружий
        if isAutoHoldWeapon(myWeapon) then
            local forceStop = false
            local target = DH.Utils.getPlayerOnCrosshair()
            if target then
                local targetHeldWeapon = DH.Utils.getHeldWeaponOther(target.Name)
                local isReflecting = DH.Utils.isReflectingWithKatana(target.Name) 
                    or string.find(targetHeldWeapon.Name, "RiotShield")
                if isReflecting then
                    forceStop = true
                end
            end

            if not lostAimTime then lostAimTime = now end
            if now - lostAimTime >= RELEASE_DELAY or forceStop then
                mouse1release()
                leftMousePressed = false
                lostAimTime = nil
            end
        end
        -- для спам-оружий отпускание ЛКМ уже происходит автоматически в spawn
    end
end

local function updateAutoScope(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    if COOLDOWN then return end

    COOLDOWN = true

    -- ❌ отменяем обычный ЛКМ (он просто не пойдёт дальше)
    task.spawn(function()

        -- 👉 ПКМ DOWN (скоп)
        mouse2press()

        task.wait(0.011)

        -- 👉 ЛКМ CLICK
        mouse1press()
        task.wait(0.123)
        mouse1release()

        -- ⏱ держим скоп
        task.wait(SCOPE_DELAY)

        -- ❎ ПКМ UP (отскоп)
        mouse2release()

        task.wait(0.01)
        COOLDOWN = false
    end)
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

    fillEsps[player] = player.Character.HighlightikMoi
end

local function removeHighlight(player)
    if fillEsps[player] then
        fillEsps[player]:Destroy()
        fillEsps[player] = nil
    end
end

local function createBillboardGui(player, text, name, offset)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = name
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = offset
    billboard.Adornee = player.Character.Head
    billboard.Parent = player.Character.Head
    billboard.AlwaysOnTop = true
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = text
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 19
    nameLabel.Parent = billboard

    return billboard
end



local function nametagPlayer(player)
    if not player.Character or not player.Character.Head then return end
    if nameTags[player] then return end

    local weapon = "None"

    local viewModels = Workspace:WaitForChild("ViewModels")
    for _, item in pairs(viewModels:GetChildren()) do
          if string.find(item.Name, player.Name) then
			weapon = string.split(string.gsub(item.Name, " ", ""), "-")[2]
        end
    end
    
    nameTags[player] = {
        name = createBillboardGui(player, player.Name, "NameTagMoi", Vector3.new(0, 3, 0)),
        weapon = createBillboardGui(player, weapon, "NameTagMoi1", Vector3.new(0, -3, 0))
     }
    
end 

local function removeTag(player)
    local tag = nameTags[player]
    if not tag then return end

    if tag.name then
        tag.name:Destroy()
    end

    if tag.weapon then
        tag.weapon:Destroy()
    end

    nameTags[player] = nil
end


-- Hooks
local timeSinceUpdate = 0
RunService.Heartbeat:Connect(function()
    local time = tick()

    if DH.GUIs.Rivals.AutoShootEnabled then
        updateAutoShoot()
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local time = tick()

    if DH.GUIs.Rivals.EspNeedUpdate or time - timeSinceUpdate >= 1 then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
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
        timeSinceUpdate = time
    end
end)

UIS.InputBegan:Connect(function(input, gp)

end)

print("💅 Скрипт для Rivals загружен")