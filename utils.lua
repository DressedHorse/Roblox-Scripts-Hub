local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()


local DH = getgenv().DH
if not DH then
    error("DonumHub namespace not found")
end

DH.Utils = DH.Utils or {}


DH.Utils.isRightMousePressed = function()
    return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
end

DH.Utils.getClosestPlayerToMouse = function()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePosition = UserInputService:GetMouseLocation()

    for _, player1 in ipairs(Players:GetPlayers()) do
        if player1 ~= player and player1.Character and player1.Character:FindFirstChild("Head") then
            local head = player1.Character.Head
            local headPosition, onScreen = camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local screenPosition = Vector2.new(headPosition.X, headPosition.Y)
                local distance = (screenPosition - mousePosition).Magnitude

                if distance < shortestDistance then
                    closestPlayer = player1
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

DH.Utils.lockCameraToHead = function(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local head = targetPlayer.Character.Head
        local headPosition = camera:WorldToViewportPoint(head.Position)
        if headPosition.Z > 0 then
            local cameraPosition = camera.CFrame.Position
            local direction = (head.Position - cameraPosition).Unit
            camera.CFrame = CFrame.new(cameraPosition, head.Position)
        end
    end
end

DH.Utils.isAimingAtPlayer = function()
    if not player.Character then return false end

    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { player.Character }
    params.IgnoreWater = true

    local result = workspace:Raycast(ray.Origin, ray.Direction * 2500, params)
    if not result then return false end

    local model = result.Instance:FindFirstAncestorOfClass("Model")
    if not model then return false end

   -- print("Aimed at model: " .. model:GetFullName() .. " : " .. result:GetFullName())

    return model:FindFirstChildOfClass("Humanoid")
       and Players:GetPlayerFromCharacter(model)
end

DH.Utils.isReflectingWithKatana = function(playerName)
    local heldWeapon = DH.Utils.getHeldWeaponOther(playerName)
    if not heldWeapon then return false end

    if not string.find(heldWeapon.Name, "Katana") then
        return false
    end

    local katanaAnimator = heldWeapon:FindFirstChildWhichIsA("AnimationController"):FindFirstChild("Animator")
    if not katanaAnimator then return false end

    for _, track in ipairs(katanaAnimator:GetPlayingAnimationTracks()) do
        if track.Animation.AnimationId:match("%d+") == "14761220206" then
            return true
        end
    end

    return false
end

DH.Utils.getPlayerOnCrosshair = function()
    if not player.Character then return false end

    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = { player.Character }
    params.IgnoreWater = true

    local result = workspace:Raycast(ray.Origin, ray.Direction * 2500, params)
    if not result then return false end

    local model = result.Instance:FindFirstAncestorOfClass("Model")
    if not model then return false end

   -- print("Aimed at model: " .. model:GetFullName() .. " : " .. result:GetFullName())

    return Players:GetPlayerFromCharacter(model)
end

DH.Utils.getHeldWeapon = function(playerName)
    local viewModels = Workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson")

    for _, item in pairs(viewModels:GetChildren()) do
        if string.find(item.Name, playerName) then
			return item
        end
    end

    return nil
end

DH.Utils.getHeldWeaponOther = function(playerName)
    local viewModels = Workspace:WaitForChild("ViewModels")

    for _, item in pairs(viewModels:GetChildren()) do
        if string.find(item.Name, playerName) then
			return item
        end
    end

    return nil
end