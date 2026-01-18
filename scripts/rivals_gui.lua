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
        FolderName = "dhsave", -- Create a custom folder for your hub/game
        FileName = "Donum Hub"
    }
})

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", 17225649668)

local ShootToggle = CombatTab:CreateToggle({
   Name = "Shoot",
   CurrentValue = false,
   Flag = "AutoShootToggle",
   Callback = function(Value)
        dhGui.AutoShootEnabled = Value
   end,
})

-- Visuals Tab
local EspTab = Window:CreateTab("ESP", 17332217644)

local FillEsp = EspTab:CreateToggle({
   Name = "Fill ESP",
   CurrentValue = false,
   Flag = "FillEspToggle",
   Callback = function(Value)
        dhGui.FillEspEnabled = Value
        dhGui.EspNeedUpdate = true
   end,
})


local EspFillColor = EspTab:CreateColorPicker({
    Name = "Fill Color",
    Color = Color3.fromRGB(0,0,0),
    Flag = "EspFillColorPicker",
    Callback = function(Value)
        dhGui.EspFillColor = Value
        dhGui.EspNeedUpdate = true
    end
})
local EspFillTransp = EspTab:CreateSlider({
   Name = "Fill Transparency",
   Range = {0, 100},
   Increment = 1,
   Suffix = "",
   CurrentValue = 10,
   Flag = "EspFillTranspSlider",
   Callback = function(Value)
        dhGui.EspFillTransp = Value / 100
        dhGui.EspNeedUpdate = true
   end,
})

local EspOutColor = EspTab:CreateColorPicker({
    Name = "Outline Color",
    Color = Color3.fromRGB(255,255,255),
    Flag = "EspOutColorPicker", 
    Callback = function(Value)
        dhGui.EspOutlineColor = Value
        dhGui.EspNeedUpdate = true
    end
})
local EspOutTransp = EspTab:CreateSlider({
   Name = "Outline Transparency",
   Range = {0, 100},
   Increment = 1,
   Suffix = "",
   CurrentValue = 10,
   Flag = "EspOutTranspSlider",
   Callback = function(Value)
        dhGui.EspOutlineTransp = Value / 100
        dhGui.EspNeedUpdate = true
   end,
})

local EspTabDivider1 = EspTab:CreateDivider()

local nameTag = EspTab:CreateToggle({
   Name = "Nametag",
   CurrentValue = false,
   Flag = "NameTagToggle",
   Callback = function(Value)
        dhGui.NameTagEnabled = Value
        dhGui.EspNeedUpdate = true
   end,
})



