local Keys, Network = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Key%20Fetcher.lua"))()

local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Client = Players.LocalPlayer

local Dep = {
    Var = {
        UPVector = Vector3.new(0, 500, 0),
        RayCastParams = RaycastParams.new(),
        Path = PathfindingService:CreatePath({WaypointSpacing = 3}),
        PlayerSpeed = 150,
        VehicleSpeed = 450
    },
    Modules = {
        UI = require(ReplicatedStorage.Module.UI),
        Store = require(ReplicatedStorage.App.store),
        PlayerUtils = require(ReplicatedStorage.Game.PlayerUtils),
        VehData = require(ReplicatedStorage.Game.Garage.VehicleData)
    },
    Heli = {
        Heli = true
    },
    Motorcycles = {
        Volt = true
    },
    FreeVeh = {},
    UnSupportedVehs = {},
    DoorPos = {}
}

local Movement = {}
local Utilities = {}

function Utilities:ToggleDoorCollision(door, toggle)
    for i, c in next, door.Model:GetChildren() do
        if c:IsA("BasePart") then
            c.CanCollide = toggle
        end
    end
end

function Utilities:GetNearestVehicle(tried)
    local Nearest
    local Distance = math.huge

    for i, a in next, Dep.Modules.UI.CircleAction.Specs do
        if a.IsVehicle and a.ShouldAllowEntry == true and a.Enabled == true and a.Name == "Enter Driver" then
            local Vehicle = a.ValidRoot

            if not table.find(tried, Vehicle) and workspace.VehicleSpawns:FindFirstChild(Vehicle.Name) then
                if not Dep.UnSupportedVehs[Vehicle.Name] and (Dep.Modules.Store._state.garageOwned.Vehicles[Vehicle.Name] or Dep.FreeVeh[Vehicle.Name]) and not Vehicle.Seat.Player.Value then
                    if not workspace:Raycast(Vehicle.Seat.Position, Dep.Var.UPVector, Dep.Var.RayCastParams) then
                        local Mag = (Vehicle.Seat.Position - Client.Character.HumanoidRootPart.Position).Magnitude

                        if Mag < Distance then
                            Distance = Mag
                            Nearest = Vehicle
                        end
                    end
                end
            end
        end
    end

    return Nearest
end

function Movement:PathFind(tried)
    local Distance = math.huge
    local Nearest

    tried = tried or {}

    for i, v in next, Dep.DoorPos do
        if not table.find(tried, v) then
            local Mag = (v.Position - Client.Character.HumanoidRootPart.Position).Magnitude

            if Mag < Distance then
                Distance = Mag
                Nearest = v
            end
        end
    end

    table.insert(tried, Nearest)

    Utilities:ToggleDoorCollision(Nearest.instance, false)

    local Path = Dep.Var.Path

    Path:ComputeAsync(Client.Character.HumanoidRootPart.Position, Nearest.Position)

    if Path.Status == Enum.PathStatus.Success then
        local Waypoints = Path:GetWaypoints()

        for i = 1, #Waypoints do
            local Waypoint = Waypoints[i]

            Client.Character.HumanoidRootPart.CFrame = CFrame.new(Waypoint.Position + Vector3.new(0, 2.5, 0))

            if not workspace:Raycast(Client.Character.HumanoidRootPart.Position, Dep.Var.UPVector, Dep.Var.RayCastParams) then
                Utilities:ToggleDoorCollision(Nearest.instance, true)

                return
            end

            task.wait(0.05)
        end
    end

    Utilities:ToggleDoorCollision(Nearest.instance, true)

    Movement:PathFind(tried)
end

function Movement:MoveToPosition(part, cframe, speed, car, target, tried)
    local VecPos = cframe.Position

    if not car and workspace:Raycast(part.Position, Dep.Var.UPVector, Dep.Var.RayCastParams) then
        Movement:PathFind()

        task.wait(0.5)
    end

    local YLevel = 500
    local HigherPos = Vector3.new(VecPos.X, YLevel, VecPos.Z)

    repeat
        local VelocityUnit = (HigherPos - part.Position).Unit * speed

        part.Velocity = Vector3.new(VelocityUnit.X, 0, VelocityUnit.Z)

        task.wait()

        part.CFrame = CFrame.new(part.CFrame.X, YLevel, part.CFrame.Z)

        if target and target.Seat.Player.Value then
            table.insert(tried, target)

            local Nearest = Utilities:GetNearestVehicle(tried)

            if Nearest then
                Movement:MoveToPosition(Client.Character.HumanoidRootPart, Nearest.Seat.CFrame, 135, false, Nearest)
            end

            return
        end
    until (part.Position - HigherPos).Magnitude < 10

    part.CFrame = CFrame.new(part.Position.X, VecPos.Y, part.Position.Z)
    part.Velocity = Vector3.new(0, 0, 0)
end

Dep.Var.RayCastParams.FilterType = Enum.RaycastFilterType.Blacklist
Dep.Var.RayCastParams.FilterDescendantsInstances = {Client.Character, workspace.Vehicles, workspace:FindFirstChild("Rain")}

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Rain" then
        table.insert(Dep.Var.RayCastParams.FilterDescendantsInstances, child)
    end
end)

Client.CharacterAdded:Connect(function(character)
    table.insert(Dep.Var.RayCastParams.FilterDescendantsInstances, character)
end)

for i, vd in next, Dep.Modules.VehData do
    if vd.Type == "Heli" then
        Dep.Heli[vd.Make] = true
    elseif vd.Type == "Motorcycle" then
        Dep.Motorcycles[vd.Make] = true
    end

    if vd.Type ~= "Chassis" and vd.Type ~= "Motorcycle" and vd.Type ~= "Heli" and vd.Type ~= "DuneBuggy" and vd.Make ~= "Volt" then
        Dep.UnSupportedVehs[vd.Make] = true
    end

    if not vd.Price then
        Dep.FreeVeh[vd.Make] = true
    end
end

for i, v in next, workspace:GetChildren() do
    if v.Name:sub(-4, -1) == "Door" then
        local TouchPart = v:FindFirstChild("Touch")

        if TouchPart and TouchPart:IsA("BasePart") then
            for dist = 5, 100, 5 do
                local ForwardPos, BackwardPos = TouchPart.Position + TouchPart.CFrame.LookVector * (dist + 3), TouchPart.Position + TouchPart.CFrame.LookVector * -(dist + 3)

                if not workspace:Raycast(ForwardPos, Dep.Var.UPVector, Dep.Var.RayCastParams) then
                    table.insert(Dep.DoorPos, {instance = v, position = ForwardPos})

                    break
                elseif not workspace:Raycast(BackwardPos, Dep.Var.UPVector, Dep.Var.RayCastParams) then
                    table.insert(Dep.DoorPos, {instance = v, position = BackwardPos})

                    break
                end
            end
        end
    end
end

local OldFireServer = debug.getupvalue(Network.FireServer, 1)

debug.setupvalue(Network.FireServer, 1, function(key, ...)
    if key == Keys.Damage then
        return
    end

    return OldFireServer(key, ...)
end)

local OldIsPointInTag = Dep.Modules.PlayerUtils.isPointInTag

Dep.Modules.PlayerUtils.isPointInTag = function(point, tag)
    if tag == "NoRagdoll" or tag == "NoFallDamage" then
        return true
    end

    return OldIsPointInTag(point, tag)
end

local function TP(cframe, tried)
    local RealitvePos = (cframe.Position - Client.Character.HumanoidRootPart.Position)
    local TargetDistance = RealitvePos.Magnitude

    if TargetDistance <= 20 and not workspace:Raycast(Client.Character.HumanoidRootPart.Position, RealitvePos.Unit * TargetDistance, Dep.Var.RayCastParams) then
        Client.Character.HumanoidRootPart.CFrame = cframe

        return
    end

    tried = tried or {}

    local NearestVeh = Utilities:GetNearestVehicle(tried)

    if NearestVeh then
        local VehDistance = (NearestVeh.Seat.Position - Client.Character.HumanoidRootPart.Position).Magnitude

        if TargetDistance < VehDistance then
            Movement:MoveToPosition(Client.Character.HumanoidRootPart, cframe, Dep.Var.PlayerSpeed)
        else
            if NearestVeh.Seat.PlayerName.Value ~= Client.Name then
                Movement:MoveToPosition(Client.Character.HumanoidRootPart, NearestVeh.Seat.CFrame, Dep.Var.PlayerSpeed, false, NearestVeh, tried)

                local EnterAttempts = 1

                repeat
                    Network:FireServer(Keys.EnterCar, NearestVeh, NearestVeh.Seat)

                    EnterAttempts = EnterAttempts + 1

                    task.wait(0.1)
                until EnterAttempts == 10 or NearestVeh.Seat.PlayerName.Value == Client.Name

                if NearestVeh.Seat.PlayerName.Value ~= Client.Name then
                    table.insert(tried, NearestVeh)

                    return TP(cframe, tried or {NearestVeh})
                end
            end

            local VehRootPart

            if Dep.Heli[NearestVeh.Name] then
                VehRootPart = NearestVeh.Model.TopDisc
            elseif Dep.Motorcycles[NearestVeh.Name] then
                VehRootPart = NearestVeh.CameraVehicleSeat
            elseif NearestVeh.Name == "DuneBuggy" then
                VehRootPart = NearestVeh.BoundingBox
            else
                VehRootPart = NearestVeh.PrimaryPart
            end

            Movement:MoveToPosition(VehRootPart, cframe, Dep.Var.PlayerSpeed, true)

            repeat
                task.wait(0.15)

                Network:FireServer(Keys.ExitCar)
            until NearestVeh.Seat.PlayerName.Value ~= Client.Name
        end
    end
end

return TP
