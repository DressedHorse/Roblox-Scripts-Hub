local DH = getgenv().DH
if not DH then
    error("DonumHub namespace not found")
end

DH.GUIs.Rivals = DH.GUIs.Rivals or {}
local dhGui = DH.GUIs.Rivals

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rivals",
    Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by vpb_",
    ShowText = "Donum Hub", -- for mobile users to unhide rayfield, change if you'd like
    Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

    ToggleUIKeybind = Enum.KeyCode.RightShift, -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, -- Create a custom folder for your hub/game
        FileName = "Donum Hub"
    }
})

local CombatTab = Window:CreateTab("Combat", 4483362458)

local Toggle = CombatTab:CreateToggle({
   Name = "Shoot",
   CurrentValue = false,
   Flag = "AutoShootToggle",
   Callback = function(Value)
        dhGui.AutoShootEnabled = Value
        print("AutoShoot toggle set to: " .. tostring(Value))
   end,
})

