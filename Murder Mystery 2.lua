--[
--Murder Mystery 2
--]

getgenv()["Use_BreakSkill_Universal"] = false

--[
--UI Library
--]

local library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()

local Wait = library.subs.Wait

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
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local Murderer, Sheriff

local Roles = {}
local Acc = {}

local Colors = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Hero = Color3.fromRGB(255, 255, 0),
    Unknown = Color3.fromRGB(55, 55, 55),
    Gun = Color3.fromRGB(255, 255, 0)
}

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

local function GodModeFunction()
    if Client.Character then
        if Client.Character:FindFirstChild("Humanoid") then
            for _, a in pairs(Client.Character.Humanoid:GetAccessories()) do
                table.insert(Acc, a:Clone())
            end

            Client.Character.Humanoid.Name = "1"
        end

        local Fake = Client.Character["1"]:Clone()

        Fake.Parent = Client.Character
        Fake.Name = "Humanoid"

        wait(0.1)

        Client.Character["1"]:Destroy()

        workspace.CurrentCamera.CameraSubject = Client.Character.Humanoid

        for _, a in pairs(Acc) do
            Client.Character.Humanoid:AddAccessory(a)
        end

        Client.Character.Animate.Disabled = true

        wait(0.1)

        Client.Character.Animate.Disabled = false

        local Tag = Instance.new("BoolValue", Client.Character)

        Tag.Name = "God Mode"
        Tag.Value = true

        spawn(function()
            local Jumping = false
            local Died = false

            Client.Character.Humanoid.Died:Connect(function()
                Died = true
            end)

            UserInputService.InputBegan:Connect(function(i, v)
                if not v and not Died then
                    Jumping = false

                    spawn(function()
                        repeat
                            RunService.RenderStepped:Wait()
                        until not Jumping or Died
                    end)
                else
                    repeat
                        RunService.RenderStepped:Wait()
                    until not Jumping
                end
            end)

            UserInputService.InputEnded:Connect(function(i, v)
                if not v and not Died then
                    Jumping = false
                end
            end)
        end)
    end
end

local function InvisibleFunction()
    local SavePos = Client.Character.HumanoidRootPart.CFrame

    Teleport(CFrame.new(-85.1800766, 137.657455, -58.091156))

    Client.Character.Humanoid:Destroy()

    Instance.new("Humanoid", Client.Character)

    Workspace[Client.Name]:FindFirstAncestorOfClass("Humanoid").HipHeight = 2

    local Tag = Instance.new("BoolValue", Client.Character)

    Tag.Name = "Invisible"
    Tag.Value = true

    wait(0.3)

    Client.Character.RightUpperArm:Destroy()
    Client.Character.LeftUpperArm:Destroy()
    Client.Character.LeftLowerArm:Destroy()
    Client.Character.LowerTorso:Destroy()
    Client.Character.RightLowerArm:Destroy()
    Client.Character.LeftUpperLeg:Destroy()
    Client.Character.Head:Destroy()
    Client.Character.RightUpperLeg:Destroy()
    Client.Character.RightUpperArm:Destroy()
    Client.Character.LeftFoot:Destroy()
    Client.Character.LeftLowerLeg:Destroy()
    Client.Character.RightFoot:Destroy()
    Client.Character.RightLowerLeg:Destroy()
    Client.Character.RightUpperArm:Destroy()
    Client.Character.UpperTorso:Destroy()
    Client.Character.Torso:Destroy()
    Client.Character.LowerTorso:Destroy()
    Client.Character.UpperTorso:Destroy()
    Client.Character.Head:Destroy()

    Teleport(SavePos)
end

local function Action(object, func)
    if object ~= nil then
        func(object)
    end
end

local function GetClosestCoin()
    local TargetDistance = 100

    for i, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("CoinContainer") then
            for i, v in pairs(v.CoinContainer:GetChildren()) do
                if v.Name == "Coin_Server" and v.Name ~= "CollectedCoin" then
                    local Mag = (Client.Character.HumanoidRootPart.Position - v.Position).magnitude

                    if Mag < TargetDistance then
                        TargetDistance = Mag
                        CoinTarget = v
                    end
                end
            end
        end
    end
end

local function UpdateRole(player, info)
    if player then
        local Role = typeof(info) == "table" and info.Role or info
        local RoleColor = Colors.Unknown

        if Role == "Murderer" then
            Murderer = player

            Roles[player] = "Murderer"

            RoleColor = Colors.Murderer
        elseif Role == "Sheriff" then
            Sheriff = player

            Roles[player] = "Sheriff"

            RoleColor = Colors.Sheriff
        elseif Role == "Hero" then
            Sheriff = player

            Roles[player] = "Hero"

            RoleColor = Colors.Hero
        elseif Role == "Innocent" then
            if Murderer == player then
                Murderer = nil
            elseif Sheriff == player then
                Sheriff = nil
            end

            Roles[player] = "Innocent"

            RoleColor = Colors.Innocent
        else
            Roles[player] = "Unknown"
        end
    end
end

local function ManualUpdate()
    local Data = ReplicatedStorage.GetPlayerData:InvokeServer()

    for i, v in ipairs(Players:GetPlayers()) do
        pcall(UpdateRole, v, Data[v.Name])
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
    Name = "Auto Farm",
    Side = "Left"
})

local AutoFarm = AutoFarmSection:AddToggle({
    Name = "Auto Farm",
    Flag = "AutoFarmTab_AutoFarmSection_AutoFarm",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoFarm = val
    end
})

--Auto Farm Settings Section

local AutoFarmSettingsSection = AutoFarmTab:CreateSection({
    Name = "Auto Farm Settings",
    Side = "Right"
})

local AutoFarmAutoGodMode = AutoFarmSettingsSection:AddToggle({
    Name = "Auto God Mode",
    Flag = "AutoFarmTab_AutoFarmSettingsSection_AutoFarmAutoGodMode",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoFarmAutoGodMode = val
    end
})

local AutoFarmAutoInvisible = AutoFarmSettingsSection:AddToggle({
    Name = "Auto Invisible",
    Flag = "AutoFarmTab_AutoFarmSettingsSection_AutoFarmAutoInvisible",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().AutoFarmAutoInvisible = val
    end
})

local TeleportMethod = AutoFarmSettingsSection:AddSearchBox({
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

local TeleportCooldown = AutoFarmSettingsSection:AddSlider({
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

local TeleportSpeed = AutoFarmSettingsSection:AddSlider({
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
--Visuals Tab
--]

local VisualsTab = BreakSkillHub:CreateTab({
    Name = "Visuals"
})

--Effects Section

local EffectsSection = VisualsTab:CreateSection({
    Name = "Effects",
    Side = "Left"
})

local ShowSprintTrail = EffectsSection:AddToggle({
    Name = "Show Sprint Trail",
    Flag = "VisualsTab_EffectsSection_ShowSprintTrail",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().ShowSprintTrail = val

        Client.Character.SpeedTrail.Toggle:FireServer(getgenv().ShowSprintTrail)
    end
})

local InfiniteGhostPerk = EffectsSection:AddToggle({
    Name = "Infinite Ghost Perk",
    Flag = "VisualsTab_EffectsSection_InfiniteGhostPerk",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().InfiniteGhostPerk = val

        ReplicatedStorage.Remotes.Gameplay.Stealth:FireServer(getgenv().InfiniteGhostPerk)
    end
})

--Other Visuals Section

local OtherVisualsSection = VisualsTab:CreateSection({
    Name = "Other Visuals",
    Side = "Right"
})

local Role = OtherVisualsSection:AddLabel({
    Name = "Your Role: ",
    Flag = "VisualsTab_OtherVisualsSection_Role"
})

local InstantRoleDisplay = OtherVisualsSection:AddToggle({
    Name = "Instant Role Display",
    Flag = "VisualsTab_OtherVisualsSection_InstantRoleDisplay",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().InstantRoleDisplay = val
    end
})

--[
--Player Tab
--]

local PlayerTab = BreakSkillHub:CreateTab({
    Name = "Player"
})

--Player Section

local PlayerSection = PlayerTab:CreateSection({
    Name = "Player",
    Side = "Left"
})

local InfiniteJump = PlayerSection:AddToggle({
    Name = "Infinite Jump",
    Flag = "PlayerTab_PlayerSection_InfiniteJump",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().InfiniteJump = val
    end
})

local WalkSpeed = PlayerSection:AddSlider({
    Name = "Walk Speed",
    Flag = "PlayerTab_PlayerSection_WalkSpeed",
    Format = "Walk Speed: %s",
    Value = 16,
    Min = 0,
    Max = 500,
    IllegalInput = false,
    CustomInput = {
        IllegalInput = false
    },
    Callback = function(val)
        getgenv().WalkSpeed = val
    end
})

local JumpPower = PlayerSection:AddSlider({
    Name = "Jump Power",
    Flag = "PlayerTab_PlayerSection_JumpPower",
    Format = "Jump Power: %s",
    Value = 50,
    Min = 0,
    Max = 500,
    IllegalInput = false,
    CustomInput = {
        IllegalInput = false
    },
    Callback = function(val)
        getgenv().JumpPower = val
    end
})

local GetXboxKnife = PlayerSection:AddButton({
    Name = "Get Xbox Knife",
    Locked = false,
    Callback = function()
        local IsXbox = game:GetService("ReplicatedStorage").Remotes.Extras.IsXbox
        IsXbox:FireServer()
    end
})

local GodMode = PlayerSection:AddButton({
    Name = "God Mode",
    Locked = false,
    Callback = function()
        GodModeFunction()
    end
})

local Invisible = PlayerSection:AddButton({
    Name = "Invisible",
    Locked = false,
    Callback = function()
        InvisibleFunction()
    end
})

--Emotes Section

local EmotesSection = PlayerTab:AddSection({
    Name = "Emotes",
    Side = "Right"
})

local PaidEmotes = EmotesSection:AddSearchBox({
    Name = "Paid Emotes",
    Flag = "PlayerTab_EmotesSection_PaidEmotes",
    Sort = false,
    MultiSelect = false,
    List = {
        "Floss",
        "Zen",
        "Dab",
        "Sit",
        "Ninja Rest",
        "Zombie",
        "Headless"
    },
    Callback = function(val)
        if val == "Floss" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("floss")
        elseif val == "Zen" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zen")
        elseif val == "Dab" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dab")
        elseif val == "Sit" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("sit")
        elseif val == "Ninja Rest" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("ninja")
        elseif val == "Zombie" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("zombie")
        elseif val == "Headless" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("headless")
        end
    end
})

local FreeEmotes = EmotesSection:AddSearchBox({
    Name = "Free Emotes",
    Flag = "PlayerTab_EmotesSection_FreeEmotes",
    Sort = false,
    MultiSelect = false,
    List = {
        "Wave",
        "Cheer",
        "Laugh",
        "Dance 1",
        "Dance 2",
        "Dance 3"
    },
    Callback = function(val)
        if val == "Wave" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("wave")
        elseif val == "Cheer" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("cheer")
        elseif val == "Laugh" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("laugh")
        elseif val == "Dance 1" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dance1")
        elseif val == "Dance 2" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dance2")
        elseif val == "Dance 3" then
            ReplicatedStorage.Remotes.Misc.PlayEmote:Fire("dance3")
        end
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

RunService.Stepped:Connect(function()
    ManualUpdate()

    if Roles[Client] == "Murderer" then
        Role:Set("Your Role: Murderer")
    elseif Roles[Client] == "Sheriff" then
        Role:Set("Your Role: Sheriff")
    elseif Roles[Client] == "Hero" then
        Role:Set("Your Role: Hero")
    elseif Roles[Client] == "Innocent" then
        Role:Set("Your Role: Innocent")
    elseif Roles[Client] == "Unknown" then
        Role:Set("Your Role: Unknown")
    end
end)

spawn(function()
    while RunService.RenderStepped:Wait() do
        if Client.Character and Client.Character:FindFirstChild("Humanoid") then
            Client.Character.Humanoid.WalkSpeed = getgenv().WalkSpeed

            if Client.Character.Humanoid.UseJumpPower == true then
                Client.Character.Humanoid.JumpPower = getgenv().JumpPower
            else
                Client.Character.Humanoid.JumpHeight = getgenv().JumpPower
            end
        end
    end
end)

spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoFarm and Client.PlayerGui.MainGUI.Game.CashBag.Visible and not Client.PlayerGui.MainGUI.Game.CashBag.Full.Visible and Client.Character and Client.Character:FindFirstChild("HumanoidRootPart") then
                if getgenv().AutoFarmAutoGodMode and getgenv().AutoFarmAutoInvisible and not Client.Character:FindFirstChild("GodMode") and not Client.Character:FindFirstChild("Invisible") then
                    InvisibleFunction()
                elseif getgenv().AutoFarmAutoGodMode and not getgenv().AutoFarmAutoInvisible and not Client.Character:FindFirstChild("Invisible") and not Client.Character:FindFirstChild("God Mode") then
                    GodModeFunction()
                elseif not getgenv().AutoFarmAutoGodMode and getgenv().AutoFarmAutoInvisible and not Client.Character:FindFirstChild("Invisible") and not Client.Character:FindFirstChild("God Mode") then
                    InvisibleFunction()
                end

                GetClosestCoin()

                if CoinTarget ~= nil then
                    spawn(function()
                        Teleport(CFrame.new(CoinTarget.Position.X, CoinTarget.Position.Y + 1.5, CoinTarget.Position.Z))

                        wait()

                        local Dist = 10

                        for i, v in pairs(workspace:GetChildren()) do
                            if v:IsA("Model") and v:FindFirstChild("CoinContainer") then
                                for i, v in pairs(v.CoinContainer:GetChildren()) do
                                    if v.Name == "Coin_Server" and v.Name ~= "CollectedCoin" then
                                        local Mag = (CoinTarget.Position - v.Position).Magnitude

                                        if Mag < Dist then
                                            ---@diagnostic disable-next-line: undefined-global
                                            CoinMag = v

                                            firetouchinterest(Client.Character.HumanoidRootPart, CoinMag, 0)
                                            firetouchinterest(Client.Character.HumanoidRootPart, CoinMag, 1)
                                        end
                                    end
                                end
                            end
                        end

                        firetouchinterest(Client.Character.HumanoidRootPart, CoinTarget, 0)
                        firetouchinterest(Client.Character.HumanoidRootPart, CoinTarget, 1)
                    end)
                end

                wait(getgenv().TeleportCooldown)

                CoinTarget = nil
            end
        end)
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if getgenv().InfiniteJump == true then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
            Action(Client.Character.Humanoid, function(self)
                if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                    Action(self.Parent.HumanoidRootPart, function(self)
                        self.Velocity = Vector3.new(0, getgenv().JumpPower, 0)
                    end)
                end
            end)
        end
    end
end)

local OldNameCall

OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    if getnamecallmethod() == "Kick" then
        return wait(9e9)
    end

    return OldNameCall(self, ...)
end)

getgenv()["BreakSkill_MM2_Loaded"] = true
getgenv()["BreakSkill_Loaded"] = true
