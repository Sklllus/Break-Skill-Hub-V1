--[
--UI Library Made By xX_XSI
--]

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local ClientUserId = Client.UserId
local ThumbType = Enum.ThumbnailType.HeadShot
local ThumbSize = Enum.ThumbnailSize.Size48x48

local Content, isReady = Players:GetUserThumbnailAsync(ClientUserId, ThumbType, ThumbSize)

local library = {
    Version = "1.0",
    WorkspaceName = "Break-Skill Hub - V1",
    Flags = {},
    Signals = {},
    Colors = {
        Main = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Configuration = {
        SmoothDragging = true
    },
    GUI_Parent = (function()
        local x, c = pcall(function()
            return CoreGui
        end)

        if x and c then
            return c
        end

        x, c = pcall(function()
            return (game:IsLoaded() or (game.Loaded:Wait() or 1)) and Client:WaitForChild("PlayerGui")
        end)

        if x and c then
            return c
        end

        x, c = pcall(function()
            return StarterGui
        end)

        if x and c then
            return c
        end
    end)()
}

local Flags = library.Flags
local GUI_Parent = library.GUI_Parent
local Colors = library.Colors
local Signals = library.Signals
local Configuration = library.Configuration

local isDraggingSomething = false

local ConvertFileName
local MakeDraggable

do
    local string_gsub

    function ConvertFileName(str, def, repl)
        repl = repl or "_"

        local Corrections = 0

        local PredName = string_gsub(str, "%W", function(c)
            local byt = c:byte()

            if ((byt == 0) or (byt == 32) or (byt == 33) or (byt == 59) or (byt == 61) or ((byt >= 35) and (byt <= 41)) or ((byt >= 43) and (byt <= 57)) or ((byt >= 64) and (byt <= 123)) or ((byt >= 125) and (byt <= 127))) then

            else
                Corrections = 1 + Corrections

                return repl
            end
        end)

        return (def and Corrections == #PredName and tostring(def)) or PredName
    end

    function MakeDraggable(topBarObject, object)
        local dragging = nil
        local dragInput = nil
        local dragStart = nil
        local startPosition = nil

        Signals[1 + #Signals] = topBarObject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPosition = object.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Signals[1 + #Signals] = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        Signals[1 + #Signals] = UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local Delta = input.Position - dragStart

                if not isDraggingSomething and Configuration.SmoothDragging then
                    TweenService:Create(object, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + Delta.X, startPosition.Y.Scale, startPosition.Y.Offset + Delta.Y)}):Play()
                elseif not isDraggingSomething and not Configuration.SmoothDragging then
                    object.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + Delta.X, startPosition.Y.Scale, startPosition.Y.Offset + Delta.Y)
                end
            end
        end)
    end
end

--[
--UI Functions
--]

--[
--CreateWindow
--]

function library:CreateWindow(options)
    local WindowName = (options.Name or options.Title or options.Text) or "New Window"
    local WindowLogo = (options.Logo or options.ID or options.Image) or "rbxassetid://7771536804"

    if WindowName and #WindowName > 0 and library.WorkspaceName == "Break-Skill Hub - V1" then
        library.WorkspaceName = ConvertFileName(WindowName, "Break-Skill Hub - V1")
    end

    local BreakSkillHub = Instance.new("ScreenGui", GUI_Parent)

    local Instances = {
        ["ImageLabel_1"] = Instance.new("ImageLabel"),
        ["Frame_3"] = Instance.new("Frame"),
        ["UICorner_3"] = Instance.new("UICorner"),
        ["TextLabel_1"] = Instance.new("TextLabel"),
        ["UICorner_1"] = Instance.new("UICorner"),
        ["UICorner_2"] = Instance.new("UICorner"),
        ["ImageLabel_2"] = Instance.new("ImageLabel"),
        ["UIGradient_2"] = Instance.new("UIGradient"),
        ["Frame_2"] = Instance.new("Frame"),
        ["TextLabel_2"] = Instance.new("TextLabel"),
        ["UIGradient_1"] = Instance.new("UIGradient"),
        ["Frame_1"] = Instance.new("Frame")
    }

    BreakSkillHub.Name = "Break-Skill Hub - V1"
    BreakSkillHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BreakSkillHub.DisplayOrder = 10
    BreakSkillHub.ResetOnSpawn = false

    Instances.Frame_1.Name = "MainFrame"
    Instances.Frame_1.Parent = BreakSkillHub
    Instances.Frame_1.BackgroundColor3 = Colors.Main
    Instances.Frame_1.BorderSizePixel = 0
    Instances.Frame_1.Position = UDim2.new(0.31683921813964844, 0, 0.09101516753435135, 0)
    Instances.Frame_1.Size = UDim2.new(0, 490, 0, 700)

    MakeDraggable(Instances.Frame_1, Instances.Frame_1)

    Instances.UICorner_1.Name = "UICorner_1"
    Instances.UICorner_1.Parent = Instances.Frame_1

    Instances.Frame_2.Name = "Splitter_1"
    Instances.Frame_2.Parent = Instances.Frame_1
    Instances.Frame_2.BorderSizePixel = 0
    Instances.Frame_2.Position = UDim2.new(0, 0, 0.04374168813228607, 0)
    Instances.Frame_2.Size = UDim2.new(0, 490, 0, 2)

    Instances.UIGradient_1.Name = "UIGradient_1"
    Instances.UIGradient_1.Parent = Instances.Frame_2
    Instances.UIGradient_1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 0, 0)),
        ColorSequenceKeypoint.new(0.410982, Color3.fromRGB(78, 39, 39)),
        ColorSequenceKeypoint.new(0.597338, Color3.fromRGB(57, 57, 57)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(79, 79, 79))
    }

    Instances.TextLabel_1.Name = "WindowName"
    Instances.TextLabel_1.Parent = Instances.Frame_1
    Instances.TextLabel_1.BackgroundTransparency = 1
    Instances.TextLabel_1.BorderSizePixel = 0
    Instances.TextLabel_1.Text = WindowName
    Instances.TextLabel_1.TextColor3 = Colors.Text
    Instances.TextLabel_1.TextSize = 14
    Instances.TextLabel_1.Font = Enum.Font.GothamSemibold
    Instances.TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
    Instances.TextLabel_1.Position = UDim2.new(0.09183673560619354, 0, 0, 0)
    Instances.TextLabel_1.Size = UDim2.new(0, 141, 0, 30)

    Instances.ImageLabel_1.Name = "WindowLogo"
    Instances.ImageLabel_1.Parent = Instances.Frame_1
    Instances.ImageLabel_1.BackgroundTransparency = 1
    Instances.ImageLabel_1.BorderSizePixel = 0
    Instances.ImageLabel_1.Image = WindowLogo
    Instances.ImageLabel_1.Size = UDim2.new(0, 35, 0, 30)

    Instances.UICorner_2.Name = "UICorner_2"
    Instances.UICorner_2.Parent = Instances.ImageLabel_1
    Instances.UICorner_2.CornerRadius = UDim.new(1, 4)

    Instances.ImageLabel_2.Name = "UserAvatar"
    Instances.ImageLabel_2.Parent = Instances.Frame_1
    Instances.ImageLabel_2.BackgroundTransparency = 1
    Instances.ImageLabel_2.BorderSizePixel = 0
    Instances.ImageLabel_2.Position = UDim2.new(0.9285714030265808, 0, 0, 0)
    Instances.ImageLabel_2.Size = UDim2.new(0, 35, 0, 30)
    Instances.ImageLabel_2.Image = Content

    Instances.UICorner_3.Name = "UICorner_3"
    Instances.UICorner_3.Parent = Instances.ImageLabel_2
    Instances.UICorner_3.CornerRadius = UDim.new(1, 4)

    Instances.TextLabel_2.Name = "UserName"
    Instances.TextLabel_2.Parent = Instances.Frame_1
    Instances.TextLabel_2.BackgroundTransparency = 1
    Instances.TextLabel_2.BorderSizePixel = 0
    Instances.TextLabel_2.Text = Client.Name
    Instances.TextLabel_2.TextColor3 = Colors.Text
    Instances.TextLabel_2.TextSize = 14
    Instances.TextLabel_2.Font = Enum.Font.GothamSemibold
    Instances.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right
    Instances.TextLabel_2.Position = UDim2.new(0.38367345929145813, 0, 0, 0)
    Instances.TextLabel_2.Size = UDim2.new(0, 257, 0, 30)

    Instances.Frame_3.Name = "Splitter_2"
    Instances.Frame_3.Parent = Instances.Frame_1
    Instances.Frame_3.BorderSizePixel = 0
    Instances.Frame_3.Position = UDim2.new(0.37959182262420654, 0, 0, 0)
    Instances.Frame_3.Size = UDim2.new(0, 2, 0, 30)

    Instances.UIGradient_2.Name = "UIGradient_2"
    Instances.UIGradient_2.Rotation = 190
    Instances.UIGradient_2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 39, 39)),
        ColorSequenceKeypoint.new(0.72213, Color3.fromRGB(54, 51, 51)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(94, 94, 94))
    }
end

return library
