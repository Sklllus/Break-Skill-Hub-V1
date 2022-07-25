--[
--Pet Simulator X
--]

while true do
    if workspace:FindFirstChild("__MAP") then
        break
    end

    task.wait()
end

getgenv()["Use_BreakSkill_Universal"] = false

--[
--UI Library, Teleport Place Library and Notification Library
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
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local Camera = workspace:WaitForChild("Camera", 5)

getgenv().UpdateLoop = type(getgenv().UpdateLoop) == "boolean" and getgenv().UpdateLoop or false
getgenv().UpdateCache = type(getgenv().UpdateCache) == "table" and getgenv().UpdateCache or {}
getgenv().GameConnections = type(getgenv().GameConnections) == "table" and getgenv().GameConnections or {}

local Save = require(ReplicatedStorage.Framework.Library).Save.Get
local Commas = require(ReplicatedStorage.Framework.Library).Functions.Commas

local __THINGS = Workspace["__THINGS"]

local PlrWalk = Client ~= nil and Client.Character ~= nil and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.WalkSpeed or 0
local PlrJump = Client ~= nil and Client.Character ~= nil and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.JumpPower or 0

local Menu = Client.PlayerGui.Main.Right

local Tables = {}
local PetSDK = {}

local GameNetwork
local GameData

for _, ggc in pairs(getgc(true)) do
    if type(ggc) == "table" then
        if rawget(ggc, "Network") then
            GameNetwork = ggc.Network
        end

        if rawget(ggc, "Save") then
            if type(ggc.Save) == "table" then
                GameData = ggc.Save
            end
        end
    end
end

if GameNetwork == nil then
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nFailed to get game data!\nContact with script developer on our discord!\ndiscordd.gg/BtXYGMemTs (Copied)")

    setclipboard("discord.gg/BtXYGMemTs")

    return
end

if GameData == nil then
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nFailed to get game data!\nContact with script developer on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

    setclipboard("discord.gg/BtXYGMemTs")

    return
end

for i, v in pairs(Client.PlayerGui.Main.Right:GetChildren()) do
    if v.ClassName == "Frame" and v.Name ~= "Rank" and not string.find(v.Name, "2") then
        table.insert(Tables, v.Name)
    end
end

if type(getgenv().GameConnections) == "table" then
    for i, s in pairs(getgenv().GameConnections) do
        if typeof(s) == "RBXScriptConnection" then
            s:Disconnect()
        end
    end

    table.clear(getgenv().GameConnections)
end

local function Get(v)
    return Save()[v]
end

PetSDK.EquippedPets = {}
PetSDK.CoinsCache = {}
PetSDK.ItemTypeCache = {}
PetSDK.Blacklisted = {}

PetSDK.Types = {
    Coin = "Coin",
    Orb = "Orb",
    Lootbag = "LootBag",
    Diamond = "Diamond",
    Chest = "Chest"
}

PetSDK.CoinCacheTime = 999999
PetSDK.EquippedPetsTime = 999999

local ChestMeshIDs = (function()
    local Data = {}

    local CoinAssets = ReplicatedStorage:FindFirstChild("CoinAssets", true)

    if CoinAssets then
        for _, ca in ipairs(CoinAssets:GetDescendants()) do
            if ca:IsA("MeshPart") then
                if tostring(ca):lower():find("chest") then
                    table.insert(Data, tostring(ca.MeshId))
                end
            end
        end
    end

    return Data
end)()

PetSDK.GetAllPets = function()
    local Pets = {}

    if GameData then
        local PlayerData = GameData.Get()

        if type(PlayerData) == "table" then
            if type(PlayerData.Pets) == "table" then
                for _, p in ipairs(PlayerData.Pets) do
                    if p.nk ~= nil then
                        table.insert(Pets, {
                            PetName = p.nk,
                            PetEquipped = p.e,
                            PetID = p.uid,
                            PetPower = p.powers or {}
                        })
                    end
                end
            end
        end
    end

    return Pets
end

PetSDK.GetEquippedPets = function()
    local Pets = {}

    local PetResults = PetSDK.GetAllPets()

    for _, pd in ipairs(type(PetResults) == "table" and PetResults or {}) do
        if type(pd) == "table" then
            if pd.PetEquipped == true then
                table.insert(Pets, pd)
            end
        end
    end

    return Pets
end

PetSDK.GetCoins = function()
    return type(PetSDK.CoinsCache) == "table" and PetSDK.CoinsCache or {}
end

PetSDK.CollectCoin = function(coin, useAllPets)
    local EquippedPets = PetSDK.EquippedPets

    if GameNetwork ~= nil then
        if #EquippedPets > 0 then
            local Pets = useAllPets == true and (function()
                local PetIDs = {}

                for _, pd in ipairs(EquippedPets) do
                    table.insert(PetIDs, pd.PetID)
                end

                return PetIDs
            end)() or {[1] = EquippedPets[1].PetID}

            if #Pets > 0 then
                local JoinCallResult = GameNetwork.Invoke("Join Coin", coin.Name, Pets)

                for i, p in ipairs(Pets) do
                    GameNetwork.Fire("Change Pet Target", p, "Coin", coin:GetAttribute("ID"))
                    GameNetwork.Fire("Farm Coin", coin.Name, p)
                end
            end
        end
    end
end

PetSDK.IsOrb = function(object)
    if PetSDK.ItemTypeCache[object] then
        return PetSDK.ItemTypeCache[object] == PetSDK.Types.Orb and true or false
    end

    local Check1 = typeof(object) == "Instance" and true or false
    local Check2 = Check1 == true and object:FindFirstChild("Orb") and true or false

    if Check2 == true then
        PetSDK.ItemTypeCache[object] = PetSDK.Types.Orb
    end

    return Check2
end

PetSDK.IsLootBag = function(object)
    if PetSDK.ItemTypeCache[object] then
        return PetSDK.ItemTypeCache[object] == PetSDK.Types.Lootbag and true or false
    end

    local Check1 = typeof(object) == "Instance" and true or false
    local Check2 = Check1 == true and object:IsA("MeshPart") and tostring(object.MeshId) == "rbxassetid://7205419138" and true or false
    local Check3 = Check1 == true and object:IsA("MeshPart") and tostring(object.MeshId) == "rbxassetid://8159964896" and true or false
    local Check4 = Check1 == true and object:IsA("MeshPart") and tostring(object.MeshId) == "rbxassetid://8159969008" and true or false

    if Check2 or Check3 or Check4 then
        PetSDK.ItemTypeCache[object] = PetSDK.Types.Lootbag
    end

    return Check2 or Check3 or Check4
end

PetSDK.IsDiamond = function(object)
    if PetSDK.ItemTypeCache[object] then
        return PetSDK.ItemTypeCache[object] == PetSDK.Types.Diamond and true or false
    end

    local Check1 = typeof(object) == "Instance" and true or false
    local Check2 = Check1 == true and object:FindFirstChild("Coin") and true or false
    local Check3 = Check2 == true and object.Coin:IsA("MeshPart") and tostring(object.Coin.MeshId) == "rbxassetid://7041620873" and true or false
    local Check4 = Check2 == true and object.Coin:IsA("MeshPart") and tostring(object.Coin.MeshId) == "rbxassetid://7041621431" and true or false

    if Check3 or Check4 then
        PetSDK.ItemTypeCache[object] = PetSDK.Types.Diamond
    end

    if Check3 == true then
        return true
    end

    if Check4 == true then
        return true
    end

    return false
end

PetSDK.IsChest = function(object)
    if PetSDK.ItemTypeCache[object] then
        return PetSDK.ItemTypeCache[object] == PetSDK.Types.Chest and true or false
    end

    local Check1 = typeof(object) == "Instance" and true or false
    local Check2 = Check1 == true and object:FindFirstChild("Coin") and true or false
    local Check3 = Check2 == true and object.Coin:IsA("MeshPart") and table.find(ChestMeshIDs, tostring(object.Coin.MeshId)) ~= nil and true or false

    if Check3 then
        PetSDK.ItemTypeCache[object] = PetSDK.Types.Chest
    end

    return Check3
end

PetSDK.IsCoin = function(object)
    if PetSDK.ItemTypeCache[object] then
        return PetSDK.ItemTypeCache[object] == PetSDK.Types.Coin and true or false
    end

    local Check1 = typeof(object) == "Instance" and true or false
    local Check2 = Check1 == true and object:FindFirstChild("Coin") and true or false

    if Check2 == true and PetSDK.IsChest(object) == false and PetSDK.IsDiamond(object) == false then
        PetSDK.ItemTypeCache[object] = PetSDK.Types.Coin
    end

    return Check2 == true and PetSDK.IsChest(object) == false and PetSDK.IsDiamond(object) == false and true or false
end

PetSDK.GetType = function(object)
    if PetSDK.IsCoin(object) == true then
        return PetSDK.Types.Coin
    end

    if PetSDK.IsOrb(object) == true then
        return PetSDK.Types.Orb
    end

    if PetSDK.IsLootBag(object) == true then
        return PetSDK.Types.Lootbag
    end

    if PetSDK.IsDiamond(object) == true then
        return PetSDK.Types.Diamond
    end

    if PetSDK.IsChest(object) == true then
        return PetSDK.Types.Chest
    end

    return nil
end

PetSDK.IsBlacklisted = function(type)
    return PetSDK.Blacklisted[type] ~= nil and true or false
end

local function GetCoinCache()
    local CoinData = __THINGS and __THINGS:FindFirstChild("Coins") and __THINGS.Coins:GetChildren() or {}

    for _, o in ipairs(CoinData) do
        PetSDK.GetType(o)
    end

    return CoinData
end


getgenv().UpdateCache.PlayerController = function()
    if Client then
        if Client.Character then
            local Humanoid = Client.Character:FindFirstChild("Humanoid")

            if Humanoid then
                Humanoid.WalkSpeed = PlrWalk
                Humanoid.JumpPower = PlrJump
            end

            if PetSDK.EquippedPetsTime == 999999 or (os.time() - PetSDK.EquippedPetsTime) >= 1 then
                PetSDK.EquippedPetsTime = os.time()
                PetSDK.EquippedPets = PetSDK.GetEquippedPets()
            end
        end
    end

    if PetSDK.CoinCacheTime == 999999 or (os.time() - PetSDK.CoinCacheTime) >= 2 then
        PetSDK.CoinCacheTime = os.time()

        PetSDK.CoinsCache = GetCoinCache()

        for i, v in pairs(PetSDK.ItemTypeCache) do
            if typeof(i) == "Instance" then
                if i.Parent == nil then
                    PetSDK.ItemTypeCache[i] = nil
                end
            else
                PetSDK.ItemTypeCache[i] = nil
            end
        end
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

--Auto Farms Section

local AutoFarmsSection = AutoFarmTab:CreateSection({
    Name = "Auto Farms",
    Side = "Left"
})

local UltraAutoFarm = AutoFarmsSection:AddToggle({
    Name = "Ultra Auto Farm",
    Flag = "AutoFarmTab_AutoFarmsSection_UltraAutoFarm",
    Enabled = false,
    Locked = true
})

local AutoFarm = AutoFarmsSection:AddToggle({
    Name = "Auto Farm",
    Flag = "AutoFarmTab_AutoFarmsSection",
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

local StatsTracker = AutoFarmSettingsSection:AddToggle({
    Name = "Stats Tracker",
    Flag = "AutoFarmTab_AutoFarmSettingsSection_StatsTracker",
    Enabled = false,
    Locked = false,
    Callback = function(val)
        getgenv().StatsTracker = val

        if getgenv().StatsTracker then
            getgenv().MyTable = {}

            pcall(function()
                Menu["Diamonds"].LayoutOrder = 999910
            end)
            pcall(function()
                Menu["Coins"].LayoutOrder = 999920
            end)
            pcall(function()
                Menu["Fantasy Coins"].LayoutOrder = 999930
            end)
            pcall(function()
                Menu["Tech Coins"].LayoutOrder = 999940
            end)
            pcall(function()
                Menu["Rainbow Coins"].LayoutOrder = 999950
            end)

            Menu.UIListLayout.HorizontalAlignment = 2

            for i, v in pairs(Tables) do
                if Menu:FindFirstChild(v .. "2") then
                    Menu:FindFirstChild(v .. "2"):Destroy()
                end
            end

            for i, v in pairs(Tables) do
                if not Menu:FindFirstChild(v .. "2") then
                    local TempMaker = Menu:FindFirstChild(v):Clone()

                    TempMaker.Name = tostring(TempMaker.Name .. "2")
                    TempMaker.Parent = Menu
                    TempMaker.Size = UDim2.new(0, 175, 0, 30)
                    TempMaker.LayoutOrder = TempMaker.LayoutOrder + 1

                    getgenv().MyTable[v] = TempMaker
                end
            end

            Menu.Diamonds2.Add.Visible = false

            for i, v in pairs(Tables) do
                spawn(function()
                    local MegaTable = {}
                    local ImaginaryI = 1
                    local PTime = 0
                    local Last = tick()
                    local Now = Last
                    local Tick_Time = 0.5

                    while true do
                        if PTime >= Tick_Time then
                            while PTime >= Tick_Time do
                                PTime = PTime - Tick_Time
                            end

                            local CurrentBal = Get(v)

                            MegaTable[ImaginaryI] = CurrentBal

                            local Diffy = CurrentBal - (MegaTable[ImaginaryI - 120] or MegaTable[1])

                            ImaginaryI = ImaginaryI + 1

                            getgenv().MyTable[v].Amount.Text = tostring(Commas(Diffy) .. " in 60s")
                            getgenv().MyTable[v]["Amount_odometerGUIFX"].Text = tostring(Commas(Diffy) .. "in 60s")
                        end

                        task.wait(0.001)

                        Now = tick()

                        PTime = PTime + (Now - Last)

                        Last = Now
                    end
                end)
            end
        else
            for i, v in pairs(Tables) do
                if Menu:FindFirstChild(v .. "2") then
                    Menu:FindFirstChild(v .. "2"):Destroy()
                end
            end

            table.clear(getgenv().MyTable)
        end
    end
})

--[
--Pets Tab
--]

local PetsTab = BreakSkillHub:CreateTab({
    Name = "Pets"
})

--Eggs Section

local EggsSection = PetsTab:CreateSection({
    Name = "Eggs",
    Side = "Left"
})

--[
--Player Tab
--]

local PlayerTab = BreakSkillHub:CreateTab({
    Name = "Player"
})

--Others Section

local OthersSection = PlayerTab:CreateSection({
    Name = "Others",
    Side = "Right"
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

local SettingsOthersSection = SettingsTab:CreateSection({
    Name = "Others",
    Side = "Right"
})

local ServerHop = SettingsOthersSection:AddButton({
    Name = "Server Hop",
    Locked = false,
    Callback = function()
        TeleportPlaceLibrary:Teleport(game.PlaceId)
    end
})

local ReJoin = SettingsOthersSection:AddButton({
    Name = "Re-Join",
    Locked = false,
    Callback = function()
        TeleportService:Teleport(game.PlaceId, Client)
    end
})

--XD

if not getgenv().UpdateLoop then
    getgenv().UpdateLoop = true

    RunService.RenderStepped:Connect(function(deltaTime)
        for _, f in pairs(getgenv().UpdateCache) do
            if type(f) == "function" then
                pcall(f, deltaTime)
            end
        end
    end)
end

task.spawn(function()
    while getgenv().AutoFarm do
        if Client.Character == nil then
            task.wait(1 / 50)

            continue
        end

        local Root = Client.Character:FindFirstChild("HumanoidRootPart")

        if #PetSDK.EquippedPets > 0 then
            local CanProceed = true

            if CanProceed then
                local Coins = PetSDK.GetCoins()

                if #Coins > 0 then
                    for _, c in ipairs(Coins) do
                        if c ~= nil then
                            if c:FindFirstChild("Coin") then
                                if (c.Coin.Position - (Root ~= nil and Root.Position or Camera.CFrame.p)).Magnitude <= 150 then
                                    local CoinType = PetSDK.GetType(c)

                                    if CoinType ~= nil then
                                        if PetSDK.IsBlacklisted(tostring(CoinType)) == false then
                                            PetSDK.CollectCoin(c, true)

                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(1 / 50)
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

getgenv()["BreakSkill_PSX_Loaded"] = true
getgenv()["BreakSkill_Loaded"] = true
