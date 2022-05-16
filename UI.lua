--[
--Script Made By xS_Killus
--]

--Instances and Functions

local library = {
    ColorPicker = false,
    Flags = {},
    Elements = {},
    Colors = {
        Main = Color3.fromRGB(255, 40, 40),
        Background = Color3.fromRGB(40, 40, 40),
        OuterBorder = Color3.fromRGB(15, 15, 15),
        InnerBorder = Color3.fromRGB(75, 65, 75),
        TopGradient = Color3.fromRGB(35, 35, 35),
        BottomGradient = Color3.fromRGB(30, 30, 30),
        SectionBackground = Color3.fromRGB(35, 35, 35),
        Section = Color3.fromRGB(175, 175, 175),
        OtherElementText = Color3.fromRGB(130, 125, 130),
        ElementText = Color3.fromRGB(145, 145, 145),
        ElementBorder = Color3.fromRGB(20, 20, 20),
        SelectedOption = Color3.fromRGB(55, 55, 55),
        UnSelectedOption = Color3.fromRGB(40, 40, 40),
        HoveredOptionTop = Color3.fromRGB(65, 65, 65),
        UnHoveredOptionTop = Color3.fromRGB(50, 50, 50),
        HoveredOptionBottom = Color3.fromRGB(45, 45, 45),
        UnHoveredOptionBottom = Color3.fromRGB(35, 35, 35),
        TabText = Color3.fromRGB(185, 185, 185)
    },
    Configuration = {
        SmoothDragging = false,
        EasingStyle = Enum.EasingStyle.Linear,
        EasingDirection = Enum.EasingDirection.In,
        HideKeybind = Enum.KeyCode.RightShift
    }
}

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer

local IsDraggingSomething = false
local LastHideBing = 0

local GUI_Parent = (function()
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
        return
    end
end)()

local function MakeDraggable(topBarObject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPos = nil

    topBarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topBarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart

            if not IsDraggingSomething and library.Configuration.SmoothDragging then
                TweenService:Create(object, TweenInfo.new(0.35, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)}):Play()
            elseif not IsDraggingSomething and not library.Configuration.SmoothDragging then
                object.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end
    end)
end

local function TextToSize(object)
    if object ~= nil then
        local Output = TextService:GetTextSize(object.Text, object.TextSize, object.Font, Vector2.new(math.huge, math.huge))

        return {
            X = Output.X,
            Y = Output.Y
        }
    end
end

--[
--UI Library Functions
--]

--[
--CreateWindow
--]

function library:CreateWindow(options)
    local WindowName = (options.Name or options.Title or options.Text) or "New Window"
    local WindowOptions = options

    local SubMenuOpen = nil
    local HomePage = nil

    for i, v in pairs(CoreGui:GetChildren()) do
        if v.Name == WindowName then
            v:Destroy()
        end
    end

    local BreakSkillHub = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local MainBorder = Instance.new("Frame")
    local TabsSlider = Instance.new("Frame")
    local InnerMain = Instance.new("Frame")
    local InnerMainBorder = Instance.new("Frame")
    local InnerMainHolder = Instance.new("Frame")
    local InnerBackDrop = Instance.new("ImageLabel")
    local TabsHolder = Instance.new("ImageLabel")
    local TabsHolderList = Instance.new("UIListLayout")
    local TabsHolderPadding = Instance.new("UIPadding")
    local HeadLine = Instance.new("TextLabel")
    local Splitter = Instance.new("TextLabel")

    BreakSkillHub.Name = "Break-Skill Hub - V1"
    BreakSkillHub.Parent = GUI_Parent
    BreakSkillHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BreakSkillHub.DisplayOrder = 10
    BreakSkillHub.ResetOnSpawn = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = BreakSkillHub
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = library.Colors.Background
    MainFrame.BorderColor3 = library.Colors.OuterBorder
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.Size = UDim2.fromOffset(500, 545)

    MakeDraggable(MainFrame, MainFrame)

    MainBorder.Name = "MainBorder"
    MainBorder.Parent = MainFrame
    MainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBorder.BackgroundColor3 = library.Colors.Background
    MainBorder.BorderColor3 = library.Colors.InnerBorder
    MainBorder.BorderMode = Enum.BorderMode.Inset
    MainBorder.Position = UDim2.fromScale(0.5, 0.5)
    MainBorder.Size = UDim2.fromScale(1, 1)

    InnerMain.Name = "InnerMain"
    InnerMain.Parent = MainFrame
    InnerMain.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerMain.BackgroundColor3 = library.Colors.Background
    InnerMain.BorderColor3 = library.Colors.OuterBorder
    InnerMain.Position = UDim2.fromScale(0.5, 0.5)
    InnerMain.Size = UDim2.new(1, -14, 1, -14)

    InnerMainBorder.Name = "InnerMainBorder"
    InnerMainBorder.Parent = InnerMain
    InnerMainBorder.AnchorPoint = Vector2.new(0.5, 0.5)
    InnerMainBorder.BackgroundColor3 = library.Colors.Background
    InnerMainBorder.BorderColor3 = library.Colors.InnerBorder
    InnerMainBorder.BorderMode = Enum.BorderMode.Inset
    InnerMainBorder.Position = UDim2.fromScale(0.5, 0.5)
    InnerMainBorder.Size = UDim2.fromScale(1, 1)

    InnerMainHolder.Name = "InnerMainHolder"
    InnerMainHolder.Parent = InnerMain
    InnerMainHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerMainHolder.BackgroundTransparency = 1
    InnerMainHolder.Position = UDim2:fromOffset(25)
    InnerMainHolder.Size = UDim2.new(1, 0, 1, -25)

    InnerBackDrop.Name = "InnerBackDrop"
    InnerBackDrop.Parent = InnerMainHolder
    InnerBackDrop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerBackDrop.BackgroundTransparency = 1
    InnerBackDrop.Size = UDim2.fromScale(1, 1)
    InnerBackDrop.ZIndex = -1
    InnerBackDrop.Visible = true
    InnerBackDrop.ImageColor3 = Color3.fromRGB(255, 255, 255)
    InnerBackDrop.ImageTransparency = 70 / 100
    InnerBackDrop.Image = "rbxassetid://7771536804"

    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = InnerMain
    TabsHolder.BackgroundColor3 = library.Colors.TopGradient
    TabsHolder.BorderSizePixel = 0
    TabsHolder.Position = UDim2.fromOffset(1, 1)
    TabsHolder.Size = UDim2.new(1, -2, 0, 23)
    TabsHolder.Image = "rbxassetid://2454009026"
    TabsHolder.ImageColor3 = library.Colors.BottomGradient

    TabsHolderList.Name = "TabsHolderList"
    TabsHolderList.Parent = TabsHolder
    TabsHolderList.FillDirection = Enum.FillDirection.Horizontal
    TabsHolderList.SortOrder = Enum.SortOrder.LayoutOrder
    TabsHolderList.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsHolderList.Padding = UDim:new(3)

    TabsHolderPadding.Name = "TabsHolderPadding"
    TabsHolderPadding.Parent = TabsHolder
    TabsHolderPadding.PaddingLeft = UDim:new(7)

    HeadLine.Name = "HeadLine"
    HeadLine.Parent = TabsHolder
    HeadLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeadLine.BackgroundTransparency = 1
    HeadLine.LayoutOrder = 1
    HeadLine.Font = Enum.Font.SourceSansBold
    HeadLine.Text = WindowName
    HeadLine.TextColor3 = library.Colors.Main
    HeadLine.TextSize = 14
    HeadLine.TextStrokeColor3 = library.Colors.OuterBorder
    HeadLine.TextStrokeTransparency = 0.75
    HeadLine.Size = UDim2:new(TextToSize(HeadLine).X + 4, 1)

    Splitter.Name = "Splitter"
    Splitter.Parent = TabsHolder
    Splitter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Splitter.BackgroundTransparency = 1
    Splitter.LayoutOrder = 2
    Splitter.Size = UDim2:new(6, 1)
    Splitter.Font = Enum.Font.SourceSansBold
    Splitter.Text = "|"
    Splitter.TextColor3 = library.Colors.TabText
    Splitter.TextSize = 14
    Splitter.TextStrokeColor3 = library.Colors.TabText
    Splitter.TextStrokeTransparency = 0.75

    TabsSlider.Name = "TabsSlider"
    TabsSlider.Parent = MainFrame
    TabsSlider.BackgroundColor3 = library.Colors.Main
    TabsSlider.BorderSizePixel = 0
    TabsSlider.Position = UDim2.fromOffset(100, 30)
    TabsSlider.Size = UDim2:fromOffset(1)
    TabsSlider.Visible = false

    do
        local Os_Clock = os.clock

        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if not gameProcessedEvent and input.KeyCode == library.Configuration.HideKeybind then
                if not LastHideBing or Os_Clock() - LastHideBing > 12 then
                    MainFrame.Visible = not MainFrame.Visible
                end

                LastHideBing = nil
            end
        end)
    end

    local WindowFunctions = {
        TabCount = 0,
        Flags = library.Elements,
        Selected = {}
    }

    --[
    --Show
    --]

    function WindowFunctions:Show(x)
        MainFrame.Visible = x == nil or x == true or x == 1
    end

    --[
    --Hide
    --]

    function WindowFunctions:Hide(x)
        MainFrame.Visible = x == false or x == 0
    end

    --[
    --Visibility
    --]

    function WindowFunctions:Visibility(x)
        if x == nil then
            MainFrame.Visible = not MainFrame.Visible
        else
            MainFrame.Visible = not not x
        end
    end

    --[
    --MoveTabSlider
    --]

    function WindowFunctions:MoveTabSlider(tabObject)
        spawn(function()
            TabsSlider.Visible = true

            TweenService:Create(TabsSlider, TweenInfo.new(0.35, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {Size = UDim2.fromOffset(tabObject.AbsoluteSize.X, 1), Position = UDim2.fromOffset(tabObject.AbsolutePosition.X, tabObject.AbsolutePosition.Y + tabObject.AbsoluteSize.Y) - UDim2.fromOffset(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)}):Play()
        end)
    end

    WindowFunctions.LastTab = nil

    --[
    --CreateTab
    --]

    function WindowFunctions:CreateTab(options, ...)
        local TabName = (options.Name or options.Title or options.Text) or "New Tab"
        local TabImage = (options.Image or options.ID or options.AssetID or options.Asset) or nil

        WindowFunctions.TabCount = WindowFunctions.TabCount + 1

        local NewTab = Instance.new((TabImage and "ImageButton") or "TextButton")
        local NewTabHolder = Instance.new("Frame")
        local LeftSide = Instance.new("ScrollingFrame")
        local LeftSideList = Instance.new("UIListLayout")
        local LeftSidePadding = Instance.new("UIPadding")
        local RightSide = Instance.new("ScrollingFrame")
        local RightSideList = Instance.new("UIListLayout")
        local RightSidePadding = Instance.new("UIPadding")

        NewTab.Name = "New Tab"
        NewTab.Parent = TabsHolder
        NewTab.BackgroundTransparency = 1
        NewTab.LayoutOrder = (options.LastTab and 99999) or tonumber(options.TabOrder or options.LayoutOrder) or (2 + WindowFunctions.TabCount)

        if TabImage then
            NewTab.Image = TabImage
            NewTab.ImageColor3 = Color3.fromRGB(255, 255, 255)
            NewTab.Size = UDim2:new(TabsHolder.AbsoluteSize.Y, 1)
        else
            NewTab.Font = Enum.Font.SourceSansBold
            NewTab.Text = TabName
            NewTab.TextColor3 = library.Colors.TabText
            NewTab.TextSize = 14
            NewTab.TextStrokeColor3 = Color3.fromRGB(40, 40, 40)
            NewTab.TextStrokeTransparency = 0.75
            NewTab.Size = UDim2:new(TextToSize(NewTab).X + 4, 1)
        end

        local function GoTo()
            if not library.ColorPicker and not SubMenuOpen and WindowFunctions.Selected.Button ~= NewTab then
                pcall(function()
                    for _, v in next, library.Elements do
                        if v and type(v) == "table" and v.Update then
                            pcall(v.Update)
                        end
                    end
                end)

                if WindowFunctions.LastTab then
                    WindowFunctions.LastTab[4] = 1.35
                end

                WindowFunctions:MoveTabSlider(NewTab)

                if WindowFunctions.Selected.Button.ClassName == "TextButton" then
                    TweenService:Create(WindowFunctions.Selected.Button, TweenInfo.new(0.35, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {TextColor3 = library.Colors.TabText}):Play()
                end

                WindowFunctions.Selected.Holder.Visible = false
                WindowFunctions.Selected.Button = NewTab
                WindowFunctions.Selected.Holder = NewTabHolder

                if WindowFunctions.Selected.Button.ClassName == "TextButton" then
                    TweenService:Create(WindowFunctions.Selected.Button, TweenInfo.new(0.35, library.Configuration.EasingStyle, library.Configuration.EasingDirection), {TextColor3 = library.Colors.TabText})
                end

                WindowFunctions.Selected.Holder.Visible = true
            end
        end

        if not HomePage and NewTab.LayoutOrder <= 4 then
            HomePage = GoTo
        end

        NewTab.MouseButton1Click:Connect(GoTo)

        if WindowFunctions.TabCount == 1 then
            TabsSlider.Size = UDim2.fromOffset(NewTab.AbsoluteSize.X, 1)
            TabsSlider.Position = UDim2.fromOffset(NewTab.AbsolutePosition.X, NewTab.AbsolutePosition.Y + NewTab.AbsoluteSize.Y) - UDim2.fromOffset(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
            TabsSlider.Visible = true

            WindowFunctions.Selected.Holder = NewTabHolder
            WindowFunctions.Selected.Button = NewTab
        end

        NewTabHolder.Name = TabName
        NewTabHolder.Parent = InnerMainHolder
        NewTabHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NewTabHolder.BackgroundTransparency = 1
        NewTabHolder.Size = UDim2.fromScale(1, 1)
        NewTabHolder.Visible = WindowFunctions.TabCount == 1

        LeftSide.Name = "LeftSide"
        LeftSide.Parent = NewTabHolder
        LeftSide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        LeftSide.BackgroundTransparency = 1
        LeftSide.Size = UDim2.fromScale(0.5, 1)
        LeftSide.CanvasSize = UDim2.new()
        LeftSide.ScrollBarThickness = 0

        LeftSideList.Name = "LeftSideList"
        LeftSideList.Parent = LeftSide
        LeftSideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        LeftSideList.SortOrder = Enum.SortOrder.LayoutOrder
        LeftSideList.Padding = UDim:new(14)

        LeftSidePadding.Name = "LeftSidePadding"
        LeftSidePadding.Parent = LeftSide
        LeftSidePadding.PaddingTop = UDim:new(12)

        RightSide.Name = "RightSide"
        RightSide.Parent = NewTabHolder
        RightSide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        RightSide.BackgroundTransparency = 1
        RightSide.Size = UDim2.fromScale(0.5, 1)
        RightSide.CanvasSize = UDim2.new()
        RightSide.ScrollBarThickness = 0
        RightSide.Position = UDim2.new(0.5)

        RightSideList.Name = "RightSideList"
        RightSideList.Parent = RightSide
        RightSideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        RightSideList.SortOrder = Enum.SortOrder.LayoutOrder
        RightSideList.Padding = UDim:new(14)

        RightSidePadding.Name = "RightSidePadding"
        RightSidePadding.Parent = RightSide
        RightSidePadding.PaddingTop = UDim:new(12)

        local TabFunctions = {
            Flags = {}
        }

        --[
        --CreateSection
        --]

        function TabFunctions:CreateSection(options, ...)
            local SectionName = (options.Name or options.Title or options.Text) or "New Section"
            local SectionSide = options.Side

            local NewSection = Instance.new("Frame")
            local NewSectionBorder = Instance.new("Frame")
            local InsideBorderHider = Instance.new("Frame")
            local OutsideBorderHider = Instance.new("Frame")
            local SectionHolder = Instance.new("Frame")
            local SectionList = Instance.new("UIListLayout")
            local SectionPadding = Instance.new("UIPadding")
            local SectionHeadLine = Instance.new("TextLabel")

            NewSection.Name = SectionName
            NewSection.Parent = (SectionSide and (SectionSide == "Left" and LeftSide) or RightSide) or LeftSide
            NewSection.BackgroundColor3 = library.Colors.SectionBackground
            NewSection.BorderColor3 = library.Colors.OuterBorder
            NewSection.Size = UDim2.new(1, -20)
            NewSection.Visible = false

            NewSectionBorder.Name = "NewSectionBorder"
            NewSectionBorder.Parent = NewSection
            NewSectionBorder.BackgroundColor3 = library.Colors.SectionBackground
            NewSectionBorder.BorderColor3 = library.Colors.InnerBorder
            NewSectionBorder.BorderMode = Enum.BorderMode.Inset
            NewSectionBorder.Size = UDim2.fromScale(1, 1)

            SectionHolder.Name = "SectionHolder"
            SectionHolder.Parent = NewSection
            SectionHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionHolder.BackgroundTransparency = 1
            SectionHolder.Size = UDim2.fromScale(1, 1)

            SectionList.Name = "SectionList"
            SectionList.Parent = SectionHolder
            SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim:new(1)

            SectionPadding.Name = "SectionPadding"
            SectionPadding.Parent = SectionHolder
            SectionPadding.PaddingTop = UDim:new(9)

            SectionHeadLine.Name = "SectionHeadLine"
            SectionHeadLine.Parent = NewSection
            SectionHeadLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SectionHeadLine.BackgroundTransparency = 1
            SectionHeadLine.Position = UDim2.fromOffset(18, -8)
            SectionHeadLine.ZIndex = 2
            SectionHeadLine.Font = Enum.Font.SourceSansBold
            SectionHeadLine.LineHeight = 1.15
            SectionHeadLine.Text = (SectionName and SectionName or "New Section")
            SectionHeadLine.TextColor3 = library.Colors.Section
            SectionHeadLine.TextSize = 14
            SectionHeadLine.Size = UDim2.fromOffset(TextToSize(SectionHeadLine).X + 4, 12)

            InsideBorderHider.Name = "InsideBorderHider"
            InsideBorderHider.Parent = NewSection
            InsideBorderHider.BackgroundColor3 = library.Colors.SectionBackground
            InsideBorderHider.BorderSizePixel = 0
            InsideBorderHider.Position = UDim2.fromOffset(15)
            InsideBorderHider.Size = UDim2.fromOffset(SectionHeadLine.AbsoluteSize.X + 4, 1)

            OutsideBorderHider.Name = "OutsideBorderHider"
            OutsideBorderHider.Parent = NewSection
            OutsideBorderHider.BackgroundColor3 = library.Colors.Background
            OutsideBorderHider.BorderSizePixel = 0
            OutsideBorderHider.Position = UDim2.fromOffset(15, -1)
            OutsideBorderHider.Size = UDim2.fromOffset(SectionHeadLine.AbsoluteSize.X + 3, 1)

            local SectionFunctions = {
                Flags = {}
            }

            --[
            --Update
            --]

            function SectionFunctions:Update(extra)
                local CurrentHolder = NewSection.Parent

                if not NewSection.Visible then
                    NewSection.Visible = true
                end

                NewSection.Size = UDim2.new(1, -20, 0, (SectionList.AbsoluteContentSize.Y + 15))

                CurrentHolder.CanvasSize = UDim2:fromOffset(CurrentHolder:FindFirstAncestorOfClass("UIListLayout").AbsoluteContentSize.Y + 22 + (extra and extra or 0))
            end

            --[
            --AddLabel
            --]

            function SectionFunctions:AddLabel(options, ...)
                local LabelName = (options.Name or options.Title or options.Text) or "New Label"
                local LabelFlag = options.Flag or (function ()
                    library.UnnamedLabels = 1 + (library.UnnamedLabels or 0)

                    return "Label" .. tostring(library.UnnamedLabels)
                end)()

                local NewLabel = Instance.new("Frame")
                local LabelHeadLine = Instance.new("TextLabel")
                local LabelPositioner = Instance.new("Frame")

                NewLabel.Name = "NewLabel"
                NewLabel.Parent = SectionHolder
                NewLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                NewLabel.BackgroundTransparency = 1
                NewLabel.Size = UDim2.new(1, 0, 0, 19)

                LabelHeadLine.Name = "LabelHeadLine"
                LabelHeadLine.Parent = NewLabel
                LabelHeadLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LabelHeadLine.BackgroundTransparency = 1
                LabelHeadLine.Position = UDim2.fromScale(0.031, 0.165842161)
                LabelHeadLine.Size = UDim2.fromOffset(215, 12)
                LabelHeadLine.Font = Enum.Font.SourceSansBold
                LabelHeadLine.Text = LabelName
                LabelHeadLine.TextColor3 = library.Colors.ElementText
                LabelHeadLine.TextSize = 14
                LabelHeadLine.TextXAlignment = Enum.TextXAlignment.Left

                LabelPositioner.Name = "LabelPositioner"
                LabelPositioner.Parent = NewLabel
                LabelPositioner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LabelPositioner.BackgroundTransparency = 1
                LabelPositioner.Position = UDim2.new(0.00448430516)
                LabelPositioner.Size = UDim2.fromOffset(214, 19)

                SectionFunctions:Update()

                local function Set(t, str)
                    if nil == str and t ~= nil then
                        str = t
                    end

                    LabelHeadLine.Text = (nil ~= str and tostring(str)) or "New Label"

                    return str
                end

                local Defualt = LabelHeadLine.Text

                local ObjectData = {
                    Options = options,
                    Name = LabelFlag,
                    Flag = LabelFlag,
                    Type = "Label",
                    Default = Defualt,
                    Parent = SectionFunctions,
                    Instance = LabelHeadLine,
                    Set = Set,
                    RawSet = Set,
                    Get = function()
                        return LabelHeadLine.Text, LabelHeadLine
                    end,
                    Update = function()
                        return LabelHeadLine.Text
                    end,
                    Reset = function()
                        return Set(nil, Defualt)
                    end
                }

                TabFunctions.Flags[LabelFlag], SectionFunctions.Flags[LabelFlag], library.Elements[LabelFlag] = ObjectData, ObjectData, ObjectData

                return ObjectData
            end

            return SectionFunctions
        end

        return TabFunctions
    end

    return WindowFunctions
end

return library
