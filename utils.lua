local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()


local DH = getgenv().DH
if not DH then
    error("DonumHub namespace not found")
end

DH.Utils = DH.Utils or {}


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

    print("Aimed at model: " .. model:getFullName() ": " .. result:getFullName())

    return model:FindFirstChildOfClass("Humanoid")
       and Players:GetPlayerFromCharacter(model)
end

DH.Utils.getHeldWeapon = function(playerName)
    local viewModels = Workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson")

    for _, item in pairs(firstPerson:GetChildren()) do
        if string.find(item.Name, playerName) then
			return item
        end
    end

    return nil
end