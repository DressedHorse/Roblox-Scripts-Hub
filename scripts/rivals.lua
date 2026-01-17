local src = game:HttpGet(DH.URL_BASE .. "scripts/rivals_gui.lua")
local fn, compileError = loadstring(src)

if not fn then
    error("Failed to load Rivals GUI: " .. tostring(compileError))
else
    fn()
end


local RunService = game:GetService("RunService")

local RELEASE_DELAY = 0.21

local rightMousePressed = false
local lostAimTime = nil 

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

RunService.Heartbeat:Connect(function()
    if DH.GUIs.Rivals.AutoShootEnabled then
        updateAutoShoot()
    end
end)

print("💅 Скрипт для Rivals загружен")