--[
--Da Hood
--]

getgenv()["Use_BreakSkill_Universal"] = false
getgenv()["BreakSkill_Loaded"] = true

--[
--UI Library And Teleport Place Library
--]

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()

local Wait = library.subs.Wait

library.WorkspaceName = "Break-Skill Hub - V1"

local TeleportPlaceLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

--Instances And Functions

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local Client = Players.LocalPlayer

local MainEvent = ReplicatedStorage.MainEvent

local Shop = {}

for i, v in pairs(Workspace.Ignored.Shop:GetChildren()) do
    if v.ClassName == "Model" and v:FindFirstChild("ClickDetector") then
        table.insert(Shop, v.Name)
    end
end

local HospitalJob = Workspace.Ignored.HospitalJob

local Method = "Tween"

local function Teleport(cframe)
    if Method == "Instant" then
        Client.Character.HumanoidRootPart.CFrame = cframe
    elseif Method == "Tween" then
        local Tween = TweenService:Create(Client.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(((Client.Character:FindFirstChild("HumanoidRootPart").Position - cframe.p).Magnitude / getgenv().TeleportSpeed), Enum.EasingStyle.Linear, Enum.EasingDirection.In), {CFrame = cframe})

        Tween:Play()

        Tween.Completed:Wait()
    end
end

--[
--Window
--]

local BreakSkillHub = library:CreateWindow({
    Name = "Break-Skill Hub - V1",
    DefaultTheme = '{"__Designer.Colors.section":"B0AFB0","__Designer.Colors.topGradient":"232323","__Designer.Settings.ShowHideKey":"Enum.KeyCode.RightShift","__Designer.Colors.otherElementText":"817F81","__Designer.Colors.hoveredOptionBottom":"2D2D2D","__Designer.Background.ImageAssetID":"rbxassetid://7771536804","__Designer.Colors.selectedOption":"373737","__Designer.Colors.unselectedOption":"282828","__Designer.Background.UseBackgroundImage":true,"__Designer.Files.WorkspaceFile":"Break-Skill Hub V1","__Designer.Colors.innerBorder":"493F49","__Designer.Colors.unhoveredOptionTop":"323232","__Designer.Colors.main":"750000","__Designer.Colors.outerBorder":"0F0F0F","__Designer.Background.ImageColor":"FFFFFF","__Designer.Colors.elementBorder":"141414","__Designer.Colors.sectionBackground":"232222","__Designer.Colors.background":"282828","__Designer.Colors.bottomGradient":"1D1D1D","__Designer.Background.ImageTransparency":35,"__Designer.Colors.hoveredOptionTop":"414141","__Designer.Colors.elementText":"939193","__Designer.Colors.unhoveredOptionBottom":"232323"}',
    Themeable = {
        Credit = false,
        Info = {
            "Hello, " .. Client.Name .. "!",
            "Using Executor: " .. getgenv()["exploit_type"],
            "Playing Game: " .. MarketplaceService:GetProductInfo(game.PlaceId).Name,
            "Discord: BtXYGMemTs",
            "Script Made By: xX_XSI",
            "Library Made By: Pepsi#5229"
        }
    }
})

--[
--Auto Farm Tab
--]

local AutoFarmTab = BreakSkillHub:CreateTab({
    Name = "Auto Farm"
})

--Auto Farm Section

local AutoFarmsSection = AutoFarmTab:CreateSection({
    Name = "Auto Farms",
    Side = "Left"
})

local AutoBreakCashiers = AutoFarmsSection:AddToggle({
    Name = "Auto Break Cashiers",
    Flag = "AutoFarmTab_AutoFarmsSections_AutoBreakCashiers",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoBreakCashiers = val

        while getgenv().AutoBreakCashiers and Wait(0.2) do
            pcall(function()
                for i, v in pairs(Workspace.Cashiers:GetChildren()) do
                    if v:IsA("Model") and v.Humanoid.Health >= 0 and v.Humanoid.Health > 5 then
                        repeat
                            wait(0.2)

                            if Client.Character.Humanoid.Sit == true then
                                Client.Character.Humanoid.Jump = true
                            end

                            Teleport(v.Open.CFrame * CFrame.new(0, 0, 2))

                            if Client.Backpack:FindFirstChild("Combat") then
                                Client.Character.Humanoid:EquipTool(Client.Backpack.Combat)
                            end

                            VirtualUser:ClickButton1(Vector2.new(9e9, 9e9))
                        until v.Head.Crash.Playing or not getgenv().AutoBreakCashiers and Client.DataFolder.Information.Jail.Value == 0

                        for i2, v2 in pairs(Workspace.Ignored.Drop:GetChildren()) do
                            if v2:IsA("BasePart") and v2.Name == "MoneyDrop" and (Client.Character.HumanoidRootPart.Position - v2.Position).Magnitude <= 50 then
                                repeat
                                    wait()

                                    Teleport(v2.CFrame)

                                    if (v2.Position - Client.Character.HumanoidRootPart.Position).Magnitude <= 12 and v2:FindFirstChildWhichIsA("ClickDetector") then
                                        fireclickdetector(v2:FindFirstChildWhichIsA("ClickDetector"))

                                        wait(getgenv().TeleportCooldown)
                                    end
                                until not v2:FindFirstChildWhichIsA("ClickDetector") or not getgenv().AutoBreakCashiers and Client.DataFolder.Information.Jail.Value == 0
                            end
                        end
                    end
                end
            end)
        end
    end
})

local AutoGrabCashAndItems = AutoFarmsSection:AddToggle({
    Name = "Auto Grab Cash And Items",
    Flag = "AutoFarmTab_AutoFarmSections_AutoGrabCash",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoGrabCashAndItems = val

        RunService.Stepped:Connect(function()
            while getgenv().AutoGrabCashAndItems do
                wait()

                pcall(function()
                    for i, v in pairs(Workspace.Ignored.Drop:GetChildren()) do
                        if v.ClassName == "Part" and v:FindFirstChild("ClickDetector") then
                            Teleport(v.CFrame)

                            wait(getgenv().TeleportCooldown)

                            fireclickdetector(v.ClickDetector)
                        end
                    end
                end)
            end
        end)
    end
})

local AutoHospitalJob = AutoFarmsSection:AddToggle({
    Name = "Auto Hospital Job",
    Flag = "AutoFarmTab_AutoFarmSection_AutoHospitalJob",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoHospitalJob = val

        while getgenv().AutoHospitalJob do
            pcall(function()
                local Patient = nil

                for i, v in pairs(HospitalJob:GetChildren()) do
                    if v:IsA("Model") then
                        Patient = v.Name

                        Teleport(HospitalJob[v.Name].HumanoidRootPart.CFrame * CFrame.new(Vector3.new(0, 0, 4), Vector3.new(0, 100, 0)))
                    end
                end

                for i, v in pairs(HospitalJob:GetChildren()) do
                    wait(0.5)

                    if HospitalJob:FindFirstChild("Can I get the Red bottle") then
                        fireclickdetector(HospitalJob.Red.ClickDetector)
                    elseif HospitalJob:FindFirstChild("Can I get the Green bottle") then
                        fireclickdetector(HospitalJob.Green.ClickDetector)
                    elseif HospitalJob:FindFirstChild("Can I get the Blue bottle") then
                        fireclickdetector(HospitalJob.Blue.ClickDetector)
                    end
                end

                local ClickPatient = HospitalJob[Patient].ClickDetector

                fireclickdetector(ClickPatient)
            end)
        end
    end
})

local AutoShoesJob = AutoFarmsSection:AddToggle({
    Name = "Auto Shoes Job",
    Flag = "AutoFarmTab_AutoFarmsSection_AutoShoesJob",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoShoesJob = val

        RunService.Stepped:Connect(function()
            if getgenv().AutoShoesJob then
                fireclickdetector(Workspace.Ignored["Clean the shoes on the floor and come to me for cash"].ClickDetector)

                for i, v in pairs(Workspace.Ignored.Drop:GetChildren()) do
                    if v.Transparency == 0 and v:IsA("MeshPart") then
                        Teleport(v.CFrame)

                        wait()

                        fireclickdetector(v.ClickDetector)
                    end
                end
            end
        end)
    end
})

--Auto Farms Settings Section

local AutoFarmsSettingsSection = AutoFarmTab:CreateSection({
    Name = "Auto Farms Settings",
    Side = "Right"
})

local TeleportMethod = AutoFarmsSettingsSection:AddSearchBox({
    Name = "Teleport Method",
    Flag = "AutoFarmTab_AutoFarmsSettingsSection_TeleportMethod",
    Value = "Tween (safer)",
    Sort = false,
    MultiSelect = false,
    List = {
        "Instant",
        "Tween (safer)"
    },
    Callback = function(val)
        if val == "Instant" then
            Method = "Instant"
        elseif val == "Tween (safer)" then
            Method = "Tween"
        end
    end
})

local TeleportCooldown = AutoFarmsSettingsSection:AddSlider({
    Name = "Teleport Cooldown",
    Flag = "AutoFarmTab_AutoFarmsSettingsSection_TeleportCooldown",
    Format = "Teleport Cooldown: %s",
    Value = 1,
    Min = 0,
    Max = 5,
    Decimals = 2,
    IllegalInput = false,
    CustomInput = {
        IllegalInput = false
    },
    Callback = function(val)
        getgenv().TeleportCooldown = val
    end
})

local TeleportSpeed = AutoFarmsSettingsSection:AddSlider({
    Name = "Teleport Speed",
    Flag = "AutoFarmTab_AutoFarmSettingsSection_TeleportSpeed",
    Format = "Teleport Speed",
    Value = 400,
    Min = 0,
    Max = 1000,
    IllegalInput = false,
    CustomInput = {
        IllegalInput = false
    },
    Callback = function(val)
        getgenv().TeleportSpeed = val
    end
})

--[
--Misc Tab
--]

local MiscTab = BreakSkillHub:CreateTab({
    Name = "Misc"
})

--Teleports Section

local TeleportsSection = MiscTab:CreateSection({
    Name = "Teleports",
    Side = "Left"
})

local PlayersTeleport = TeleportsSection:AddSearchBox({
    Name = "Players",
    Flag = "MiscTab_TeleportsSection_PlayersTeleport",
    Sort = false,
    MultiSelect = false,
    List = Players,
    Method = "GetPlayers",
    Callback = function(val)
        Teleport(val.Character.HumanoidRootPart.CFrame)
    end
})

--Buy Items Section

local BuyItemsSection = MiscTab:CreateSection({
    Name = "Buy Items",
    Side = "Right"
})

local BuySelectedItem = BuyItemsSection:AddButton({
    Name = "Buy Selected Item",
    Locked = false,
    Callback = function()
        local Save = Client.Character.HumanoidRootPart.CFrame

        Teleport(Workspace.Ignored.Shop[getgenv().SelectItem].Head.CFrame)

        wait(0.5)

        fireclickdetector(Workspace.Ignored.Shop[Shop].ClickDetector)

        wait(0.5)

        Teleport(Save)
    end
})

local SelectItem = BuyItemsSection:AddSearchBox({
    Name = "Select Item",
    Flag = "MiscTab_BuyItemsSection_SelectItem",
    Sort = false,
    MultiSelect = false,
    List = Shop,
    Callback = function(val)
        getgenv().SelectItem = val
    end
})

--[
--Settings Tab
--]

local SettingsTab = BreakSkillHub:CreateTab({
    Name = "Settings"
})

--Config Section

local ConfigSection = SettingsTab:CreateSection({
    Name = "Config",
    Side = "Left"
})

local SaveLoad = ConfigSection:AddPersistence({
    Name = "Save/Load",
    Flag = "SettingsTab_ConfigSection_SaveLoad",
    Flags = "all"
})

--Others Section

local OthersSection = SettingsTab:CreateSection({
    Name = "Others",
    Side = "Right"
})

local ServerHop = OthersSection:AddButton({
    Name = "Server Hop",
    Locked = false,
    Callback = function()
        TeleportPlaceLibrary:Teleport(game.PlaceId)
    end
})

local ReJoin = OthersSection:AddButton({
    Name = "Re-Join",
    Locked = false,
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Client)
    end
})

--XD

local Bypass = {
    "CHECKER_1",
    "TeleportDetect",
    "OneMoreTime"
}

local SpoofTable = {
    WalkSpeed = 16,
    JumpPower = 50
}

local Raw = getrawmetatable(game)

if setreadonly then
    setreadonly(Raw, false)
else
    make_writeable(Raw, true)
end

local OldNameCall

OldNameCall = hookmetamethod(game, "__namecall", function(...)
    local Args = {...}
    local self = Args[1]
    local GetMethod = getnamecallmethod()
    local Caller = checkcaller()

    if (GetMethod == "FireServer" and self == MainEvent and table.find(Bypass, Args[2])) then
        return task.wait(9e9)
    end

    if GetMethod == "Kick" then
        return task.wait(9e9)
    end

    if GetMethod == "IsStudio" then
        return true
    end

    if (not Caller and getfenv(2).crash) then
        hookfunction(getfenv(2).crash, function()
            warn("Brea-Skill Hub - V1 | Crash Attempt")
        end)
    end

    return OldNameCall(...)
end)

local OldIndex

OldIndex = hookmetamethod(game, "__index", function(t, k)
    local Caller = checkcaller()

    if (not Caller and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then
        return SpoofTable[k]
    end

    return OldIndex(t, k)
end)

local OldNewIndex

OldNewIndex = hookmetamethod(game, "__newindex", function(t, k, v)
    local Caller = checkcaller()

    if (not Caller and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower")) then
        SpoofTable[k] = v

        return
    end

    return OldNewIndex(t, k, v)
end)

if setreadonly then
    setreadonly(Raw, true)
else
    make_writeable(Raw, false)
end

Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
    Duration = 10,
    TitleSettings = {
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.SourceSansBold
    },
    GradientSettings = {
        GradientEnabled = false,
        SolidColorEnabled = true,
        SolidColor = Color3.fromRGB(255, 30, 30),
        Retract = true
    }
})

getgenv()["BreakSkill_DH_Loaded"] = true
