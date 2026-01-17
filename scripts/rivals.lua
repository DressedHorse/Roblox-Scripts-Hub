local RunService = game:GetService("RunService")

local RELEASE_DELAY = 0.21

local rightMousePressed = false
local lostAimTime = nil 

RunService.Heartbeat:Connect(function()
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

end)

print("💅 Скрипт для Rivals загружен")