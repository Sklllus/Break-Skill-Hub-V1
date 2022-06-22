if NetworkKeys and Network then
    return NetworkKeys, Network
end

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Network = debug.getupvalue(require(ReplicatedStorage.Module.AlexChassis).SetEvent, 1)
local KeysList = debug.getupvalue(debug.getupvalue(Network.FireServer, 1), 3)
local GameFolder = ReplicatedStorage.Game
local TeamChooseUI = require(GameFolder.TeamChooseUI)
local DefaultActions = require(GameFolder.DefaultActions)

local RobloxEnv = getrenv()

local NetworkKeys = {}

local function FetchKey(caller)
    local Consts = debug.getconstants(caller)

    for i, c in next, Consts do
        if KeysList[c] then
            return c
        elseif type(c) ~= "string" or c == "" or RobloxEnv[c] or string[c] or table[c] or #c > 7 or c:lower() ~= c then
            Consts[i] = nil
        end
    end

    for k, r in next, KeysList do
        local PrefixPassed = false
        local KeyLength = #k

        for i, c in next, c do
            local cLength = #c

            if not PrefixPassed and k:sub(1, cLength) == c then
                PrefixPassed = c
            elseif PrefixPassed and c ~= PrefixPassed and k:sub(KeyLength - (cLength - 1), KeyLength) == c then
                return k
            end
        end
    end
end

do
    local RedeemCodeFunction = debug.getproto(require(GameFolder.Codes).Init, 4)

    NetworkKeys.RedeemCode = FetchKey(RedeemCodeFunction)
end

do
    local DoorRemovedFunction = getconnections(CollectionService:GetInstanceRemovedSignal("Door"))[1].Function
    local KickFunction = debug.getupvalue(debug.getupvalue(debug.getupvalue(debug.getupvalue(DoorRemovedFunction, 2), 2).Run, 1), 1)[4].c

    NetworkKeys.Kick = FetchKey(KickFunction)
end

do
    local MilitaryAddedFunction = require(GameFolder.MilitaryTurret.MilitaryTurretBinder)._classAddedSignal._handlerListHead._fn
    local DamageFunction = debug.getproto(MilitaryAddedFunction, 1)

    NetworkKeys.Damage = FetchKey(DamageFunction)
end

do
    local SwitchTeamFunction = debug.getproto(TeamChooseUI.Show, 4)

    NetworkKeys.SwitchTeam = FetchKey(SwitchTeamFunction)
end

do
    local ExitCarFunction = debug.getupvalue(TeamChooseUI.Init, 3)

    NetworkKeys.ExitCar = FetchKey(ExitCarFunction)
end

do
    local TazeFunction = require(GameFolder.Item.Taser).Tase

    NetworkKeys.Taze = FetchKey(TazeFunction)
end

do
    local PunchFunction = debug.getupvalue(DefaultActions.punchButton.onPressed, 1).attemptPunch

    NetworkKeys.Punch = FetchKey(PunchFunction)
end

do
    local JumpFunction = DefaultActions.onJumpPressed._handlerListHead._next._fn
    local FallFunction = debug.getupvalue(debug.getupvalue(debug.getupvalue(JumpFunction, 1), 4), 3)

    NetworkKeys.FallDamage = FetchKey(FallFunction)
end

do
    local CharacterAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("Character"))[1].Function
    local InteractFunction = debug.getupvalue(CharacterAddedFunction, 2)
    local PickPocketFunction = debug.getupvalue(debug.getupvalue(InteractFunction, 2), 2)
    local ArrestFunction = debug.getupvalue(debug.getupvalue(InteractFunction, 1), 7)

    NetworkKeys.PickPocket = FetchKey(PickPocketFunction)
    NetworkKeys.Arrest = FetchKey(ArrestFunction)
end

do
    local EquipFunction = require(GameFolder.ItemSystem.ItemSystem)._equip
    local InputBeganFunction = debug.getproto(EquipFunction, 5)
    local InputEndedFunction = debug.getproto(EquipFunction, 6)

    NetworkKeys.BroadcastInputBegan = FetchKey(InputBeganFunction)
    NetworkKeys.BroadcastInputEnded = FetchKey(InputEndedFunction)
end

do
    local SeatAddedFunction = getconnections(CollectionService:GetInstanceAddedSignal("VehicleSeat"))[1].Function
    local SeatInteractFunction = debug.getupvalue(SeatAddedFunction, 1)
    local HijackFunction = debug.getupvalue(SeatInteractFunction, 1)
    local EjectFunction = debug.getupvalue(SeatInteractFunction, 2)
    local EnterCarFunction = debug.getupvalue(SeatInteractFunction, 3)

    NetworkKeys.Hijack = FetchKey(HijackFunction)
    NetworkKeys.Eject = FetchKey(EjectFunction)
    NetworkKeys.EnterCar = FetchKey(EnterCarFunction)
end

do
    for k, cf in next, debug.getupvalue(TeamChooseUI.Init, 2) do
        if type(cf) == "function" and debug.getconstants(cf)[1] == "Source" then
            NetworkKeys.PlaySound = k

            break
        end
    end
end

local Env = getgenv()

Env.NetworkKeys, Env.Network = NetworkKeys, Network

return NetworkKeys, Network
