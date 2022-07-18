--[
--UI Library Made By xX_XSI
--]

--Instances And Functions

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Client = Players.LocalPlayer

local ClientUserId = Client.UserId
local ThumbType = Enum.ThumbnailType.HeadShot
local ThumbSize = Enum.ThumbnailSize.Size48x48

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
    }
}

local Flags = library.Flags
local GUI_Parent = library.GUI_Parent
local Colors = library.Colors
local Signals = library.Signals
local Configuration = library.Configuration

local isDraggingSomething = false

local function MakeDraggable(topBarObject, object)
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

--[
--UI Functions
--]

--[
--CreateWindow
--]

function library:CreateWindow(options)
    local WindowName = (options.Name or options.Title or options.Text) or "New Window"
    local WindowLogo = (options.Logo or options.ID or options.Image) or "rbxassetid://7771536804"

    local BreakSkillHub = Instance.new("ScreenGui", CoreGui)
    local ImageLabel_1 = Instance.new("ImageLabel")
    local Frame_3 = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local TextLabel_1 = Instance.new("TextLabel")
    local UICorner_1 = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")
    local ImageLabel_2 = Instance.new("ImageLabel")
    local UIGradient_2 = Instance.new("UIGradient")
    local Frame_2 = Instance.new("Frame")
    local TextLabel_2 = Instance.new("TextLabel")
    local UIGradient_1 = Instance.new("UIGradient")
    local Frame_1 = Instance.new("Frame")

    BreakSkillHub.Name = "Break-Skill Hub - V1"
    BreakSkillHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BreakSkillHub.DisplayOrder = 10
    BreakSkillHub.ResetOnSpawn = false

    Frame_1.Name = "MainFrame"
    Frame_1.Parent = BreakSkillHub
    Frame_1.BackgroundColor3 = Colors.Main
    Frame_1.BorderSizePixel = 0
    Frame_1.Position = UDim2.new(0.31683921813964844, 0, 0.09101516753435135, 0)
    Frame_1.Size = UDim2.new(0, 490, 0, 700)

    MakeDraggable(Frame_1, Frame_1)

    UICorner_1.Name = "UICorner_1"
    UICorner_1.Parent = Frame_1

    Frame_2.Name = "Splitter_1"
    Frame_2.Parent = Frame_1
    Frame_2.BorderSizePixel = 0
    Frame_2.Position = UDim2.new(0, 0, 0.04374168813228607, 0)
    Frame_2.Size = UDim2.new(0, 490, 0, 2)

    UIGradient_1.Name = "UIGradient_1"
    UIGradient_1.Parent = Frame_2
    UIGradient_1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 0, 0)),
        ColorSequenceKeypoint.new(0.410982, Color3.fromRGB(78, 39, 39)),
        ColorSequenceKeypoint.new(0.597338, Color3.fromRGB(57, 57, 57)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(79, 79, 79))
    }

    TextLabel_1.Name = "WindowName"
    TextLabel_1.Parent = Frame_1
    TextLabel_1.BackgroundTransparency = 1
    TextLabel_1.BorderSizePixel = 0
    TextLabel_1.Text = WindowName
    TextLabel_1.TextColor3 = Colors.Text
    TextLabel_1.TextSize = 14
    TextLabel_1.Font = Enum.Font.GothamSemibold
    TextLabel_1.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel_1.Position = UDim2.new(0.09183673560619354, 0, 0, 0)
    TextLabel_1.Size = UDim2.new(0, 141, 0, 30)

    ImageLabel_1.Name = "WindowLogo"
    ImageLabel_1.Parent = Frame_1
    ImageLabel_1.BackgroundTransparency = 1
    ImageLabel_1.BorderSizePixel = 0
    ImageLabel_1.Image = WindowLogo
    ImageLabel_1.Size = UDim2.new(0, 35, 0, 30)

    UICorner_2.Name = "UICorner_2"
    UICorner_2.Parent = ImageLabel_1
    UICorner_2.CornerRadius = UDim.new(1, 4)

    ImageLabel_2.Name = "UserAvatar"
    ImageLabel_2.Parent = Frame_1
    ImageLabel_2.BackgroundTransparency = 1
    ImageLabel_2.BorderSizePixel = 0
    ImageLabel_2.Position = UDim2.new(0.9285714030265808, 0, 0, 0)
    ImageLabel_2.Size = UDim2.new(0, 35, 0, 30)
    ImageLabel_2.Image = Players:GetUserThumbnailAsync(ClientUserId, ThumbType, ThumbSize)

    UICorner_3.Name = "UICorner_3"
    UICorner_3.Parent = ImageLabel_2
    UICorner_3.CornerRadius = UDim.new(1, 4)

    TextLabel_2.Name = "UserName"
    TextLabel_2.Parent = Frame_1
    TextLabel_2.BackgroundTransparency = 1
    TextLabel_2.BorderSizePixel = 0
    TextLabel_2.Text = Client.Name
    TextLabel_2.TextColor3 = Colors.Text
    TextLabel_2.TextSize = 14
    TextLabel_2.Font = Enum.Font.GothamSemibold
    TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel_2.Position = UDim2.new(0.38367345929145813, 0, 0, 0)
    TextLabel_2.Size = UDim2.new(0, 257, 0, 30)

    Frame_3.Name = "Splitter_2"
    Frame_3.Parent = Frame_1
    Frame_3.BorderSizePixel = 0
    Frame_3.Position = UDim2.new(0.37959182262420654, 0, 0, 0)
    Frame_3.Size = UDim2.new(0, 2, 0, 30)

    UIGradient_2.Name = "UIGradient_2"
    UIGradient_2.Rotation = 190
    UIGradient_2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 39, 39)),
        ColorSequenceKeypoint.new(0.72213, Color3.fromRGB(54, 51, 51)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(94, 94, 94))
    }
end

return library
