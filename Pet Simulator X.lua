do
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
    local GameFramework = ReplicatedStorage:WaitForChild("Framework", 5)
    local GameLibrary = GameFramework:WaitForChild("Library", 5)
    local PlayerScripts = Client:WaitForChild("PlayerScripts", 5)
    local GameScripts_V1 = PlayerScripts:WaitForChild("Scripts", 5)
    local GameScripts_V2 = GameScripts_V1:WaitForChild("Game", 5)
    local OrbsClient = GameScripts_V2:WaitForChild("Orbs", 5)

    local GameLibrarySuccess, GameLibraryContents = pcall(require, GameLibrary)

    getgenv().UpdateLoop = type(getgenv().UpdateLoop) == "boolean" and getgenv().UpdateLoop or false
    getgenv().UpdateCache = type(getgenv().UpdateCache) == "table" and getgenv().UpdateCache or {}
    getgenv().GameConnections = type(getgenv().GameConnections) == "table" and getgenv().GameConnections or {}

    local Save = require(GameLibrary).Save.Get
    local Commas = require(GameLibrary).Functions.Commas

    local __VARIABLES = workspace["__VARIABLES"]
    local __THINGS = Workspace["__THINGS"]
    local __MAP = Workspace["__MAP"]

    local PlrWalk = Client ~= nil and Client.Character ~= nil and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.WalkSpeed or 0
    local PlrJump = Client ~= nil and Client.Character ~= nil and Client.Character:FindFirstChild("Humanoid") and Client.Character.Humanoid.JumpPower or 0

    local Menu = Client.PlayerGui.Main.Right

    local Tables = {}
    local PetSDK = {}

    local GameNetwork
    local GameData

    for _, GameGC in pairs(getgc(true)) do
        if type(GameGC) == "table" then
            if rawget(GameGC, "Network") then
                GameNetwork = GameGC.Network
            end

            if rawget(GameGC, "Save") then
                if type(GameGC.Save) == "table" then
                    if rawget(GameGC.Save, "Get") then
                        GameData = GameGC.Save
                    end
                end
            end
        end
    end

    if not GameLibrarySuccess then
        Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nFailed to get game library!\nContact with script developer on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

        setclipboard("discord.gg/BtXYGMemTs")

        return
    end

    if GameNetwork == nil then
        Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nFailed to get game data!\nContact with script developer on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

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
        for IndexName, Signal in pairs(getgenv().GameConnections) do
            if typeof(Signal) == "RBXScriptConnection" then
                Signal:Disconnect()
            end
        end

        table.clear(getgenv().GameConnections)
    end

    local function Get(v)
        return Save()[v]
    end

    do
        local TeleportsData = {
            Worlds = {},
            Areas = {}
        }

        local OldOwnFunction = nil
        local OrbEnv = nil

        local ChestMeshIDs = (function()
            local Data = {}

            local CoinAssets = ReplicatedStorage:FindFirstChild("CoinAssets", true)

            if CoinAssets then
                for _, ChestAsset in ipairs(CoinAssets:GetDescendants()) do
                    if ChestAsset:IsA("MeshPart") then
                        if tostring(ChestAsset):lower():find("chest") then
                            table.insert(Data, tostring(ChestAsset.MeshId))
                        end
                    end
                end
            end

            return Data
        end)()

        local Teleports = (function()
            for I, V in pairs(GameLibraryContents.Directory.Areas) do
                if V.world ~= nil and V.world ~= "" then
                    if not TeleportsData.Worlds[tostring(V.world)] then
                        TeleportsData.Worlds[tostring(V.world)] = tostring(V.world)
                    end

                    if not TeleportsData.Areas[tostring(I)] then
                        TeleportsData.Areas[tostring(I)] = tostring(V.world)
                    end
                end
            end

            return TeleportsData
        end)()

        function GetCoinCache()
            local CoinData = __THINGS and __THINGS:FindFirstChild("Coins") and __THINGS.Coins:GetChildren() or {}

            for _, Object in ipairs(CoinData) do
                PetSDK.GetType(Object)
            end

            return CoinData
        end

        PetSDK.CoinsCache = {}
        PetSDK.ItemTypeCache = {}
        PetSDK.EquippedPets = {}
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

        PetSDK.LoadMap = function(MapName)
            if workspace:FindFirstChild("__MAP") then
                workspace:FindFirstChild("__MAP"):Destroy()
            end
        end

        PetSDK.FreeGamepasses = function()
            if GameLibrarySuccess then
                if OldOwnFunction == nil then
                    OldOwnFunction = hookfunction(GameLibraryContents.Gamepasses.Owns, function(...)
                        return true
                    end)
                end
            end
        end

        PetSDK.GetAllPets = function()
            local Pets = {}

            if GameData then
                local PlayerData = GameData.Get()

                if type(PlayerData) == "table" then
                    if type(PlayerData.Pets) == "table" then
                        for _, V in ipairs(PlayerData.Pets) do
                            if V.nk ~= nil then
                                table.insert(Pets, {
                                    PetName = V.nk,
                                    PetEquipped = V.e,
                                    PetID = V.uid,
                                    PetPowers = V.powers or {}
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

            for _, PetData in ipairs(type(PetResults) == "table" and PetResults or {}) do
                if type(PetData) == "table" then
                    if PetData.PetEquipped == true then
                        table.insert(Pets, PetData)
                    end
                end
            end

            return Pets
        end

        PetSDK.GetCoins = function()
            return type(PetSDK.CoinsCache) == "table" and PetSDK.CoinsCache or {}
        end

        PetSDK.CollectCoin = function(Coin, UseAllPets)
            local EquippedPets = PetSDK.EquippedPets

            if GameNetwork ~= nil then
                if #EquippedPets > 0 then
                    local Pets = UseAllPets == true and (function()
                        local PetIDs = {}

                        for _, PetData in ipairs(EquippedPets) do
                            table.insert(PetIDs, PetData.PetID)
                        end

                        return PetIDs
                    end)() or {[1] = EquippedPets[1].PetID}

                    if #Pets > 0 then
                        local JoinCallResult = GameNetwork.Invoke("Join Coin", Coin.Name, Pets)

                        for PetIndex, PetId in ipairs(Pets) do
                            GameNetwork.Fire("Change Pet Target", PetId, "Coin", Coin:GetAttribute("ID"))
                            GameNetwork.Fire("Farm Coin", Coin.Name, PetId)
                        end
                    end
                end
            end
        end

        PetSDK.GetOrbs = function()
            return __THINGS and __THINGS:FindFirstChild("Orbs") and __THINGS.Orbs:GetChildren() or {}
        end

        PetSDK.IsOrb = function(Object)
            if PetSDK.ItemTypeCache[Object] then
                return PetSDK.ItemTypeCache[Object] == PetSDK.Types.Orb and true or false
            end

            local Check1 = typeof(Object) == "Instance" and true or false
            local Check2 = Check1 == true and Object:FindFirstChild("Orb") and true or false

            if Check2 == true then
                PetSDK.ItemTypeCache[Object] = PetSDK.Types.Orb
            end

            return Check2
        end

        PetSDK.CollectOrb = function(Orb)
            if PetSDK.IsOrb(Orb) and GameNetwork ~= nil then
                if OrbsClient then
                    if OrbsClient:IsA("LocalScript") then
                        if OrbEnv == nil then
                            local OrbScriptEnvSuccess, OrbScriptEnv = pcall(getsenv, OrbsClient)

                            if OrbScriptEnvSuccess then
                                OrbEnv = OrbScriptEnv
                            end
                        end

                        if OrbEnv ~= nil then
                            return OrbEnv.Collect(Orb)
                        end
                    end
                end
            end
        end

        PetSDK.GetLootBags = function()
            return __THINGS and __THINGS:FindFirstChild("Lootbags") and __THINGS.Lootbags:GetChildren() or {}
        end

        PetSDK.IsLootBag = function(Object)
            if PetSDK.ItemTypeCache[Object] then
                return PetSDK.ItemTypeCache[Object] == PetSDK.Types.Lootbag and true or false
            end

            local Check1 = typeof(Object) == "Instance" and true or false
            local Check2 = Check1 == true and Object:IsA("MeshPart") and tostring(Object.MeshId) == "rbxassetid://7205419138" and true or false
            local Check3 = Check1 == true and Object:IsA("MeshPart") and tostring(Object.MeshId) == "rbxassetid://8159964896" and true or false
            local Check4 = Check1 == true and Object:IsA("MeshPart") and tostring(Object.MeshId) == "rbxassetid://8159969008" and true or false

            if Check2 or Check3 or Check4 then
                PetSDK.ItemTypeCache[Object] = PetSDK.Types.Lootbag
            end

            return Check2 or Check3 or Check4
        end

        PetSDK.CollectLootBag = function(LootBag)
            if PetSDK.IsLootBag(LootBag) and GameNetwork ~= nil then
                GameNetwork.Fire("Collect Lootbag", LootBag:GetAttribute("ID"), LootBag.CFrame.p)

                LootBag:Destroy()
            end
        end

        PetSDK.IsDiamond = function(Object)
            if PetSDK.ItemTypeCache[Object] then
                return PetSDK.ItemTypeCache[Object] == PetSDK.Types.Diamond and true or false
            end

            local Check1 = typeof(Object) == "Instance" and true or false
            local Check2 = Check1 == true and Object:FindFirstChild("Coin") and true or false
            local Check3 = Check2 == true and Object.Coin:IsA("MeshPart") and tostring(Object.Coin.MeshId) == "rbxassetid://7041620873" and true or false
            local Check4 = Check2 == true and Object.Coin:IsA("MeshPart") and tostring(Object.Coin.MeshId) == "rbxassetid://7041621431" and true or false

            if Check3 or Check4 then
                PetSDK.ItemTypeCache[Object] = PetSDK.Types.Diamond
            end

            if Check3 == true then return true end
            if Check4 == true then return true end

            return false
        end

        PetSDK.IsChest = function(Object)
            if PetSDK.ItemTypeCache[Object] then
                return PetSDK.ItemTypeCache[Object] == PetSDK.Types.Chest and true or false
            end

            local Check1 = typeof(Object) == "Instance" and true or false
            local Check2 = Check1 == true and Object:FindFirstChild("Coin") and true or false
            local Check3 = Check2 == true and Object.Coin:IsA("MeshPart") and table.find(ChestMeshIDs, tostring(Object.Coin.MeshId)) ~= nil and true or false

            if Check3 then
                PetSDK.ItemTypeCache[Object] = PetSDK.Types.Chest
            end

            return Check3
        end

        PetSDK.IsCoin = function(Object)
            if PetSDK.ItemTypeCache[Object] then
                return PetSDK.ItemTypeCache[Object] == PetSDK.Types.Coin and true or false
            end

            local Check1 = typeof(Object) == "Instance" and true or false
            local Check2 = Check1 == true and Object:FindFirstChild("Coin") and true or false

            if Check2 == true and PetSDK.IsChest(Object) == false and PetSDK.IsDiamond(Object) == false then
                PetSDK.ItemTypeCache[Object] = PetSDK.Types.Coin
            end

            return Check2 == true and PetSDK.IsChest(Object) == false and PetSDK.IsDiamond(Object) == false and true or false
        end

        PetSDK.GetType = function(Object)
            if PetSDK.IsCoin(Object) == true then return PetSDK.Types.Coin end
            if PetSDK.IsOrb(Object) == true then return PetSDK.Types.Orb end
            if PetSDK.IsLootBag(Object) == true then return PetSDK.Types.Lootbag end
            if PetSDK.IsDiamond(Object) == true then return PetSDK.Types.Diamond end
            if PetSDK.IsChest(Object) == true then return PetSDK.Types.Chest end

            return nil
        end

        PetSDK.IsBlacklisted = function(Type)
            return PetSDK.Blacklisted[Type] ~= nil and true or false
        end

        PetSDK.RedeemFreeGifts = function()
            if GameLibrarySuccess and GameNetwork ~= nil then
                for I, V in pairs(GameLibraryContents.Directory.FreeGifts) do
                    task.spawn(function()
                        GameNetwork.Invoke("Redeem Free Gift", I)
                    end)
                end
            end
        end

        PetSDK.GetAllEggs = function()
            local Data = {}

            if GameLibrarySuccess then
                for I, _ in pairs(GameLibraryContents.Directory.Eggs) do
                    table.insert(Data, tostring(I))
                end
            end

            return Data
        end

        PetSDK.GetTeleportsRaw = function()
            return Teleports
        end

        PetSDK.GetMapTeleports = function()
            return __MAP and __MAP:FindFirstChild("Teleports") and __MAP.Teleports or "NONE"
        end

        PetSDK.GetCoinsFolder = function()
            return __THINGS and __THINGS:FindFirstChild("Coins") and __THINGS.Coins
        end

        PetSDK.GetOrbsFolder = function()
            return __THINGS and __THINGS:FindFirstChild("Orbs") and __THINGS.Orbs
        end

        PetSDK.GetLootbagsFolder = function()
            return __THINGS and __THINGS:FindFirstChild("Lootbags") and __THINGS.Lootbags
        end

        PetSDK.MapLoader = function(AreaName)
            if AreaName == "Trading Plaza" then
                AreaName = "Spawn"
            end

            GameNetwork.Fire("Request World", AreaName)

            while not Client.PlayerGui:FindFirstChild("__MAP") do
                GameLibraryContents.RenderStepped()
            end

            Client.Character.HumanoidRootPart.Anchored = true

            if __MAP then
                __MAP:Destroy()
            end

            PetSDK.GetCoinsFolder():ClearAllChildren()
            PetSDK.GetOrbsFolder():ClearAllChildren()
            PetSDK.GetLootbagsFolder():ClearAllChildren()

            local NewMapFolder = Client.PlayerGui:WaitForChild("__MAP", 5)
            local NewMap = NewMapFolder:WaitForChild("MAP", 5)

            if NewMap then
                local WorldData = GameLibraryContents.Directory.Worlds[AreaName]

                if not WorldData then return warn("World data not found!") end

                if NewMap:FindFirstChild("Spawns") then
                    NewMap.Spawns:Destroy()
                end

                local MapDebris = GameLibraryContents.Debris:FindFirstChild("__MAPDEBRIS")

                if not MapDebris then
                    MapDebris = Instance.new("Folder")
                    MapDebris.Name = "__MAPDEBRIS"
                    MapDebris.Parent = u1.Debris
                else
                    MapDebris:ClearAllChildren()
                end

                NewMap.Name = "__MAP"
                NewMap.Parent = workspace
            end
        end

        PetSDK.Teleport = function(Place, TeleportType)
            if GameLibrarySuccess and Client.Character then
                task.spawn(function()
                    local RawData = PetSDK.GetTeleportsRaw()

                    local TP_DATA = RawData.Worlds[tostring(Place)] or RawData.Areas[tostring(Place)]

                    pcall(function()
                        GameLibraryContents.WorldCmds.Load(TP_DATA)
                    end)

                    if TeleportType == "Area" then
                        local TeleportsFolder = PetSDK.GetMapTeleports()

                        local TeleportCheck = TeleportsFolder ~= "NONE" and typeof(TeleportsFolder) == "Instance" and TeleportsFolder:FindFirstChild(tostring(Place)) or nil

                        repeat
                            TeleportsFolder = PetSDK.GetMapTeleports()

                            TeleportCheck = TeleportsFolder ~= "NONE" and typeof(TeleportsFolder) == "Instance" and TeleportsFolder:FindFirstChild(tostring(Place)) or nil

                            task.wait(1 / 10000)
                        until TeleportCheck ~= nil and TeleportCheck ~= "NONE"

                        if TeleportCheck ~= nil then
                            if Client.Character then
                                local Humanoid = Client.Character:FindFirstChild("Humanoid")

                                if Humanoid then
                                    Client.Character:SetPrimaryPartCFrame(TeleportCheck.CFrame + Vector3.new(0, Humanoid.HipHeight + 1, 0))
                                end
                            end
                        end
                    end
                end)
            end
        end
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

        __VARIABLES = workspace:FindFirstChild("__VARIABLES")
        __THINGS = workspace:FindFirstChild("__THINGS")
        __MAP = workspace:FindFirstChild("__MAP")

        if PetSDK.CoinCacheTime == 999999 or (os.time() - PetSDK.CoinCacheTime) >= 2 then
            PetSDK.CoinCacheTime = os.time()

            PetSDK.CoinsCache = GetCoinCache()

            for Index, Value in pairs(PetSDK.ItemTypeCache) do
                if typeof(Index) == "Instance" then
                    if Index.Parent == nil then
                        PetSDK.ItemTypeCache[Index] = nil
                    end
                else
                    PetSDK.ItemTypeCache[Index] = nil
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

            task.spawn(function()
                while getgenv().AutoFarm == true do
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
                                for _, Coin in ipairs(Coins) do
                                    if Coin ~= nil then
                                        if Coin:FindFirstChild("Coin") then
                                            if (Coin.Coin.Position - (Root ~= nil and Root.Position or Camera.CFrame.p)).Magnitude <= 150 then
                                                local CoinType = PetSDK.GetType(Coin)

                                                if CoinType ~= nil then
                                                    if PetSDK.IsBlacklisted(tostring(CoinType)) == false then
                                                        PetSDK.CollectCoin(Coin, getgenv().AllPets)

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
        end
    })

    local UseAllPets = AutoFarmsSection:AddToggle({
        Name = "Use All Pets",
        Flag = "sdfd",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().AllPets = val
        end
    })

    --Auto Farm Settings Section

    local AutoFarmsSettingsSection = AutoFarmTab:CreateSection({
        Name = "Auto Farms Settings",
        Side = "Right"
    })

    local InstantCollect = AutoFarmsSettingsSection:AddToggle({
        Name = "Instant Collect",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_InstantCollect",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().InstantCollect = val

            task.spawn(function()
                while getgenv().InstantCollect do
                    if Client.Character == nil then
                        task.wait(1 / 250)

                        continue
                    end

                    local Orbs = PetSDK.GetOrbs()

                    if #Orbs > 0 then
                        for _, Orb in ipairs(Orbs) do
                            PetSDK.CollectOrb(Orb)
                        end
                    end

                    task.wait(1 / 250)
                end
            end)
        end
    })

    local CollectLootBags = AutoFarmsSettingsSection:AddToggle({
        Name = "Collect Lootbags",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_ColledtLootbags",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().CollectLootbags = val

            task.spawn(function()
                while getgenv().CollectLootbags do
                    if Client.Character == nil then
                        task.wait(1 / 250)

                        continue
                    end

                    local Root = Client.Character:FindFirstChild("HumanoidRootPart")

                    local Lootbags = PetSDK.GetLootBags()

                    if #Lootbags > 0 then
                        for _, LootBag in ipairs(Lootbags) do
                            if (LootBag.Position - (Root ~= nil and Root.Position or Camera.CFrame.p)).Magnitude <= 150 then
                                PetSDK.CollectLootBag(LootBag)
                            end
                        end
                    end

                    task.wait(1 / 250)
                end
            end)
        end
    })

    local StatsTracker = AutoFarmsSettingsSection:AddToggle({
        Name = "Stats Tracker",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_StatsTracker",
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

    local IgnoreCoins = AutoFarmsSettingsSection:AddToggle({
        Name = "Ignore Coins",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_IgnoreCoins",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().IgnoreCoins = val

            if getgenv().IgnoreCoins then
                PetSDK.Blacklisted[PetSDK.Types.Coin] = true
            else
                PetSDK.Blacklisted[PetSDK.Types.Coin] = nil
            end
        end
    })

    local IgnoreChests = AutoFarmsSettingsSection:AddToggle({
        Name = "Ignore Chests",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_IgnoreChests",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().IgnoreChests = val

            if getgenv().IgnoreChests then
                PetSDK.Blacklisted[PetSDK.Types.Chest] = true
            else
                PetSDK.Blacklisted[PetSDK.Types.Chest] = nil
            end
        end
    })

    local IgnoreDiamonds = AutoFarmsSettingsSection:AddToggle({
        Name = "Ignore Diamonds",
        Flag = "AutoFarmTab_AutoFarmsSettingsSection_IgnoreDiamonds",
        Enabled = false,
        Locked = false,
        Callback = function(val)
            getgenv().IgnoreDiamonds = val

            if getgenv().IgnoreDiamonds then
                PetSDK.Blacklisted[PetSDK.Types.Diamond] = true
            else
                PetSDK.Blacklisted[PetSDK.Types.Diamond] = nil
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

        RunService.RenderStepped:Connect(function(_Delta)
            for _, Function in pairs(getgenv().UpdateCache) do
                if type(Function) == "function" then
                    pcall(Function, _Delta)
                end
            end
        end)
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

    getgenv()["BreakSkill_PSX_Loaded"] = true
    getgenv()["BreakSkill_Loaded"] = true
end
