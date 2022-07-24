--[
--Arsenal
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
local VirtualInputManager = game:GetService("VirtualInputManager")

local Client = Players.LocalPlayer

local function GetUserRole(i, v)
    return i:GetRoleInGroup(v)
end

local function Nope()
    Client.PlayerGui.Menew.Enabled = false
    Client.PlayerGui.GUI.Enabled = true
    Client.PlayerGui.GUI.TeamSelection.Visible = false
    Client.PlayerGui.GUI.BottomFrame.Visible = false
    Client.PlayerGui.GUI.Interface.Visible = true
end

local function Spawn()
    repeat
        wait()
    until ReplicatedStorage.wkspc.Status.RoundOver.Value == true

    wait(1)

    ReplicatedStorage.Events.JoinTeam:FireServer("TBC")
    ReplicatedStorage.Events.LoadCharacter:FireServer()

    Nope()

    wait(1)

    if Client.Status.Team.Value == "Spectator" then
        ReplicatedStorage.Events.JoinTeam:FireServer("TBC")
        ReplicatedStorage.Events.LoadCharacter:FireServer()

        Nope()
    end

    wait(1)

    if Client.PlayerGui.Status.Team.Value == "Spectator" then
        ReplicatedStorage.Events.JoinTeam:FireServer("TRC")
        ReplicatedStorage.Events.LoadCharacter:FireServer()

        Nope()
    end

    wait(1)

    if Client.PlayerGui.Status.Team.Value == "Spectator" then
        ReplicatedStorage.Events.JoinTeam:FireServer("TRC")
        ReplicatedStorage.Events.LoadCharacter:FireServer()

        Nope()
    end

    wait(1)

    if game.Players.LocalPlayer.Status.Team.Value == "Spectator" then
        game:GetService("ReplicatedStorage").Events.JoinTeam:FireServer("Random")
        game:GetService("ReplicatedStorage").Events.LoadCharacter:FireServer()
        Nope()
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

local AutoFarmSection = AutoFarmTab:CreateSection({
    Name = "Auto Farm Section",
    Side = "Left"
})

local AutoFarm = AutoFarmSection:AddToggle({
    Name = "Auto Farm",
    Flag = "AutoFarmTab_AutoFarmSection_AutoFarm",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoFarm = val

        RunService.Stepped:Connect(function()
            if getgenv().AutoFarm then
                for i, v in pairs(Players:GetPlayers()) do
                    if Client.Character ~= nil and v ~= Client and (v.TeamColor ~= Client.TeamColor or v.TeamColor == "Bright blue") and v.Character ~= nil and v.Character:FindFirstChild("Gun") then
                        if v ~= Client and v:FindFirstChild("NRPBS") and v.NRPBS.Health.Value > 0 and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Hitbox") then
                            Client.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)

                            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, v.Character.UpperTorso.CFrame.p)

                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        end
                    end
                end
            end
        end)
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

Players.PlayerAdded:Connect(function(v)
    if GetUserRole(v, 2613928) == "Game Moderators" or GetUserRole(v, 2613928) == "Interns" or GetUserRole(v, 2613928) == "Contractors" or GetUserRole(v, 2613928) == "Beloved" or GetUserRole(v, 2613928) == "Main Developers" or GetUserRole(v, 2613928) == "Founder/Main Developer" then
        Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Admin joined the game!</font> <font color=\"rgb(30, 255, 30)\">" .. v.Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
            Duration = 10,
            TitleSettings = {
                TextXAlignment = Enum.TextXAlignment.Left,
                Font = Enum.Font.SourceSansBold
            },
            GradientEnabled = {
                GradientEnabled = false,
                SolidColorEnabled = true,
                SolidColor = Color3.fromRGB(255, 30, 30),
                Retract = true
            }
        })

        wait(2.5)

        if getgenv().AutoServerHopWhenAdminJoin then
            TeleportPlaceLibrary:Teleport(game.PlaceId)
        end
    end
end)

spawn(function()
    while wait() and getgenv().AutoFarm do
        Spawn()
    end
end)

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

getgenv()["BreakSkill_A_Loaded"] = true
