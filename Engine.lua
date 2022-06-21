local Players = game:GetService("Players")

local Client = Players.LocalPlayer

local Engine = {}
Engine.Doors = {}
Engine.Backups = {}
Engine.OtherValues = {}

Engine.OtherValues.Time = require(game:GetService("ReplicatedStorage").Resource.Settings).Time
Engine.Backups.IsFlying = require(game:GetService("ReplicatedStorage").Game.Paraglide).IsFlying

for i, v in pairs(getgc(true)) do
    if type(v) == "table" then
        if rawget(v, "Event") and rawget(v, "Fireworks") then
            Engine.em = v.em
            Engine.GetVehiclePacket = v.GetVehiclePacket
            Engine.Fireworks = v.Fireworks
            Engine.Network = v.Event
        elseif rawget(v, "State") and rawget(v, "OpenFun") then
            table.insert(Engine.Doors, v)
        elseif rawget(v, "Ragdoll") then
            Engine.Backups.Ragdoll = v.Ragdoll
        end
    elseif type(v) == "function" then
        if getfenv(v).script == Client.PlayerScripts.LocalScript then
            local con = debug.getconstants(v)

            if table.find(con, "SequenceRequireState") then
                Engine.OpenDoor = v
            elseif table.find(con, "Play") and table.find(con, "Source") and table.find(con, "FireServer") then
                Engine.PlaySound = v
            elseif table.find(con, "PlusCash") then
                Engine.AddCashScam = v
            elseif table.find(con, "Punch") then
                Engine.GUIFunc = v
            end
        end
    end
end

local gmt = getrawmetatable(game)

setreadonly(gmt, false)

local OldIndex = gmt.__index

gmt.__index = newcclosure(function(self, b)
    if b == "WalkSpeed" then
        return 16
    end

    if b == "JumpPower" then
        return 50
    end

    return OldIndex(self, b)
end)

return Engine
