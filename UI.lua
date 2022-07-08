local BreakSkill = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

local function Dragify(frame)
    local DragToggle = nil
    local DragInput = nil
    local DragStart = nil
    local DragPos = nil
    local StartPos
    local DragSpeed = .25

    local function UpdateInput(input)
        local Delta = input.Position - DragStart
        local Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)

        TweenService:Create(frame, TweenInfo.new(DragSpeed), {Position = Position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            DragToggle = true
            DragStart = input.Position
            StartPos = frame.Position

            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    DragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input == DragInput and DragToggle) then
            UpdateInput(input)
        end
    end)
end

for i, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "Break-Skill Hub - V1" then
        v:Destroy()
    end
end

--[
--CreateWindow
--]

function BreakSkill:CreateWindow(options)
    local Title = (options.Title or options.Name or options.WindowName or options.WindowTitle or options.WindowText or options.Text) or "Break-Skill Hub - V1"

    local GameTitle = MarketplaceService:GetProductInfo(game.PlaceId).Name

    local BreakSkillHub = Instance.new("ScreenGui", CoreGui)
    local BackFrame = Instance.new("Frame", BreakSkillHub)
    local UICorner_1 = Instance.new("UICorner", BackFrame)
    local TopBar = Instance.new("Frame", BackFrame)
    local UICorner_2 = Instance.new("UICorner", TopBar)
    local SideBar = Instance.new("Frame", BackFrame)
    local UICorner_3 = Instance.new("UICorner", SideBar)
    local Cover_1 = Instance.new("Frame", TopBar)
    local Cover_2 = Instance.new("Frame", SideBar)
    local TextTitle = Instance.new("TextLabel", TopBar)
    local TextGame = Instance.new("TextLabel", TopBar)
    local User = Instance.new("ImageLabel", TopBar)
    local AllTabs = Instance.new("Frame", SideBar)
    local ScrollingFrame = Instance.new("ScrollingFrame", AllTabs)
    local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
    local PagesFolder = Instance.new("Folder", BackFrame)

    BreakSkillHub.Name = "Break-Skill Hub - V1"
    BreakSkillHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    BackFrame.Name = "BackFrame"
    BackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    BackFrame.BorderSizePixel = 0
    BackFrame.Position = UDim2.new(0.0170925632, 0, 0.25677368, 0)
    BackFrame.Size = UDim2.new(0, 759, 0, 440)

    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(-0.000528850709, 0, -0.00112308154, 0)
    TopBar.Size = UDim2.new(0, 759, 0, 38)

    Cover_1.Name = "Cover"
    Cover_1.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Cover_1.BorderSizePixel = 0
    Cover_1.Position = UDim2.new(0.000529453857, 0, 0.333095938, 0)
    Cover_1.Size = UDim2.new(0, 758, 0, 43)

    TextTitle.Name = "Title"
    TextTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextTitle.BackgroundTransparency = 1
    TextTitle.Position = UDim2.new(0.242099673, 0, 0.0526315793, 0)
    TextTitle.Size = UDim2.new(0, 232, 0, 30)
    TextTitle.Font = Enum.Font.Gotham
    TextTitle.Text = Title
    TextTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextTitle.TextSize = 20
    TextTitle.TextXAlignment = Enum.TextXAlignment.Left

    TextGame.Name = "Game"
    TextGame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextGame.BackgroundTransparency = 1
    TextGame.Position = UDim2.new(0.242099673, 0, 0.684210479, 0)
    TextGame.Size = UDim2.new(0, 232, 0, 27)
    TextGame.Font = Enum.Font.Gotham
    TextGame.Text = GameTitle
    TextGame.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextGame.TextSize = 15
    TextGame.TextTransparency = 0.67
    TextGame.TextXAlignment = Enum.TextXAlignment.Left

    User.Name = "User"
    User.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    User.BackgroundTransparency = 1
    User.Position = UDim2.new(0.948616505, 0, 0.421052635, 0)
    User.Size = UDim2.new(0, 23, 0, 23)
    User.Image = "rbxassetid://7072724349"
    User.ImageTransparency = 0.8

    SideBar.Name = "SideBar"
    SideBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    SideBar.BorderSizePixel = 0
    SideBar.Position = UDim2.new(-0.000528147095, 0, -0.00112326827, 0)
    SideBar.Size = UDim2.new(0, 175, 0, 440)

    Cover_2.Name = "Cover"
    Cover_2.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Cover_2.BorderSizePixel = 0
    Cover_2.Position = UDim2.new(0.422661394, 0, 0.00112179841, 0)
    Cover_2.Size = UDim2.new(0, 101, 0, 439)

    AllTabs.Name = "AllTabs"
    AllTabs.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    AllTabs.BorderSizePixel = 0
    AllTabs.Size = UDim2.new(0, 159, 0, 423)

    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(0, 165, 0, 423)
    ScrollingFrame.ScrollBarThickness = 0

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)

    Dragify(BackFrame)

    local Tabs = {}

    --[
    --SetTitle
    --]

    function Tabs:SetTitle(title)
        TextTitle.Text = title

        return title
    end

    Tabs.SetName = Tabs.SetTitle
    Tabs.SetText = Tabs.SetTitle
    Tabs.Name = Tabs.SetTitle
    Tabs.Text = Tabs.SetTitle
    Tabs.Title = Tabs.SetTitle

    --[
    --CreateTab
    --]

    function Tabs:CreateTab(options)
        local TabTitle = (options.Title or options.Name or options.TabName or options.TabTitle or options.Text or options.TabText) or "New Tab"
        local TabLogo = (options.TabLogo or options.Logo or options.TabID or options.ID) or "rbxassetid://7429253275"

        local TabButton = Instance.new("TextButton", ScrollingFrame)
        local Logo = Instance.new("ImageLabel", TabButton)
        local TextLabel = Instance.new("TextLabel", TabButton)
        local ChosenFrame = Instance.new("Frame", TabButton)
        local UICorner_4 = Instance.new("UICorner", ChosenFrame)

        TabButton.Name = "TabButton"
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 159, 0, 41)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.SourceSans
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 14

        Logo.Name = "TabLogo"
        Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Logo.BackgroundTransparency = 1
        Logo.Position = UDim2.new(0.0691823959, 0, 0.24390243, 0)
        Logo.Size = UDim2.new(0, 20, 0, 20)
        Logo.Image = TabLogo
        Logo.ImageTransparency = 0.58

        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0.301886708, 0, -0.073170729, 0)
        TextLabel.Size = UDim2.new(0, 117, 0, 47)
        TextLabel.Font = Enum.Font.GothamSemibold
        TextLabel.Text = TabTitle
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextSize = 14
        TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        ChosenFrame.Name = "ChosenFrame"
        ChosenFrame.BackgroundColor3 = Color3.fromRGB(115, 125, 190)
        ChosenFrame.BackgroundTransparency = 1
        ChosenFrame.Position = UDim2.new(0.999999881, 0, 0.0567158014, 0)
        ChosenFrame.Size = UDim2.new(0, 23, 0, 34)
        ChosenFrame.ZIndex = 2

        UICorner_4.CornerRadius = UDim.new(0, 5)

        local Tab = Instance.new("Frame", PagesFolder)
        local ShadowPX = Instance.new("ImageLabel", Tab)
        local TitleTab = Instance.new("TextLabel", Tab)
        local UICorner_5 = Instance.new("UICorner", Tab)
        local Scroll = Instance.new("ScrollingFrame", Tab)
        local ElementList = Instance.new("UIListLayout", Scroll)

        Tab.Name = "Tab"
        Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.251118749, 0, 0.220086664, 0)
        Tab.Size = UDim2.new(0, 552, 0, 327)
        Tab.Visible = false

        ShadowPX.Name = "ShadowPX"
        ShadowPX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ShadowPX.BackgroundTransparency = 1
        ShadowPX.Position = UDim2.new(-0.0561594181, 0, -0.0536723025, 0)
        ShadowPX.Size = UDim2.new(0, 613, 0, 362)
        ShadowPX.ZIndex = 0
        ShadowPX.Image = "rbxassetid://7429253275"
        ShadowPX.ImageColor3 = Color3.fromRGB(0, 0, 0)
        ShadowPX.ImageTransparency = 0.8

        TitleTab.Name = "TabTitle"
        TitleTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TitleTab.BackgroundTransparency = 1
        TitleTab.Position = UDim2.new(0.00724637695, 0, -0.127445415, 0)
        TitleTab.Size = UDim2.new(0, 208, 0, 41)
        TitleTab.Font = Enum.Font.GothamSemibold
        TitleTab.Text = TabTitle
        TitleTab.TextColor3 = Color3.fromRGB(115, 125, 190)
        TitleTab.TextSize = 15
        TitleTab.TextXAlignment = Enum.TextXAlignment.Left

        UICorner_5 = UDim.new(0, 6)

        Scroll.Name = "Scroll"
        Scroll.Active = true
        Scroll.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Scroll.BorderSizePixel = 0
        Scroll.Position = UDim2.new(0.0181159414, 0, 0.0214067269, 0)
        Scroll.Size = UDim2.new(0, 534, 0, 320)
        Scroll.ScrollBarThickness = 0

        ElementList.Name = "ElementsList"
        ElementList.SortOrder = Enum.SortOrder.LayoutOrder
        ElementList.Padding = UDim.new(0, 4)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in next, PagesFolder:GetChildren() do
                v.Visible = false
            end

            Tab.Visible = true

            for _, v in next, AllTabs:GetDescendants() do
                if v:IsA("TextButton") then
                    TweenService:Create(v.TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {TextTransparency = 0.58, TextStrokeTransparency = 1}):Play()
                    TweenService:Create(v.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 0.58}):Play()
                    TweenService:Create(v.ChosenFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                end
            end

            TweenService:Create(TabButton.TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {TextTransparency = 0, TextStrokeTransparency = 0.88}):Play()
            TweenService:Create(TabButton.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 0}):Play()
            TweenService:Create(ChosenFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
        end)

        local Elements = {}

        --[
        --SetTitle
        --]

        function Elements:SetTitle(title)
            TitleTab.Text = title

            return title
        end

        Elements.SetName = Elements.SetTitle
        Elements.SetText = Elements.SetTitle
        Elements.Text = Elements.SetTitle
        Elements.Name = Elements.SetTitle
        Elements.Title = Elements.SetTitle

        --[
        --SetLogo
        --]

        function Elements:SetLogo(logo)
            Logo.Image = logo

            return logo
        end

        Elements.SetID = Elements.SetLogo
        Elements.SetImage = Elements.SetLogo
        Elements.SetImg = Elements.SetLogo
        Elements.ID = Elements.SetLogo
        Elements.Img = Elements.SetLogo
        Elements.Image = Elements.SetLogo

        --[
        --AddLabel
        --]

        function Elements:AddLabel(options)
            local LabelName = (options.Name or options.Title or options.Text or options.LabelName or options.LabelTitle or options.LabelText) or "New Label"

            local Label = Instance.new("TextLabel", Scroll)
            local LabelCorner = Instance.new("UICorner", Label)

            Label.Name = "Label"
            Label.BackgroundColor3 = Color3.fromRGB(110, 120, 200)
            Label.Position = UDim2.new(0, 0, 0.581250012, 0)
            Label.Size = UDim2.new(0, 534, 0, 34)
            Label.Font = Enum.Font.Gotham
            Label.Text = LabelName
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14

            LabelCorner.CornerRadius = UDim.new(0, 3)
            LabelCorner.Name = "Label Corner"

            local LabelFunctions = {}

            --[
            --SetTitle
            --]

            function LabelFunctions:SetTitle(title)
                Label.Text = title

                return title
            end

            LabelFunctions.SetName = LabelFunctions.SetTitle
            LabelFunctions.SetText = LabelFunctions.SetTitle
            LabelFunctions.Name = LabelFunctions.SetTitle
            LabelFunctions.Text = LabelFunctions.SetTitle
            LabelFunctions.Title = LabelFunctions.SetTitle

            return LabelFunctions
        end

        Elements.CreateLabel = Elements.AddLabel
        Elements.Label = Elements.AddLabel

        --[
        --AddButton
        --]

        function Elements:AddButton(options)
            local ButtonName = (options.Name or options.Text or options.Title or options.ButtonName or options.ButtonText or options.ButtonName) or "New Button"
            local Callback = (options.Callback or options.Function or options.Call) or function() end
            local Condition = (options.Cond or options.Condition) or nil
            local Locked = (options.Locked or options.Lock) or false

            local Presses = 0

            local Button = Instance.new("TextButton", Scroll)
            local ButtonCorner = Instance.new("UICorner", Button)

            Button.Name = "Button"
            Button.BackgroundColor3 = Color3.fromRGB(110, 120, 200)
            Button.Position = UDim2.new(0, 0, 0.581250012, 0)
            Button.Size = UDim2.new(0, 534, 0, 34)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.Gotham
            Button.Text = ButtonName
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14

            ButtonCorner.CornerRadius = UDim.new(0, 3)
            ButtonCorner.Name = "Button Corner"

            Button.MouseButton1Click:Connect(function()
                if Locked then
                    TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}):Play()

                    wait(0.08)

                    TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()

                    return
                end

                if options.Condition ~= nil and type(options.Condition) == "function" then
                    local v, e = pcall(options.Condition, Presses)

                    if e then
                        if not v then
                            warn(debug.traceback(string.format("Break-Skill Hub - V1 | Error in button %s's condition function: %s", ButtonName, e), 2))
                        end
                    else
                        return
                    end
                end

                Callback()

                TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(185, 200, 255)}):Play()

                wait(0.08)

                TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()
            end)

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(140, 150, 225)}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()
            end)

            local ButtonFunctions = {}

            --[
            --SetTitle
            --]

            function ButtonFunctions:SetTitle(title)
                Button.Text = title

                return title
            end

            ButtonFunctions.SetName = ButtonFunctions.SetTitle
            ButtonFunctions.SetText = ButtonFunctions.SetTitle
            ButtonFunctions.Name = ButtonFunctions.SetTitle
            ButtonFunctions.Text = ButtonFunctions.SetTitle
            ButtonFunctions.Title = ButtonFunctions.SetTitle

            --[
            --SetCallback
            --]

            function ButtonFunctions:SetCallback(call, callback)
                if type(call) ~= "table" and callback == nil then
                    callback = call
                end

                options.Callback = callback

                return callback
            end

            ButtonFunctions.SetCall = ButtonFunctions.SetCallback
            ButtonFunctions.NewCallback = ButtonFunctions.SetCallback
            ButtonFunctions.NewCall = ButtonFunctions.SetCallback

            --[
            --Press
            --]

            function ButtonFunctions:Press(...)
                if Locked then
                    return
                end

                if options.Condition ~= nil and type(options.Condition) == "function" then
                    local v, e = pcall(options.Condition, Presses)

                    if e then
                        if not v then
                            warn(debug.traceback(string.format("Break-Skill Hub - V1 | Error in button %s's condition function: %s", ButtonName, e), 2))
                        end
                    else
                        return
                    end
                end

                local Args = {...}
                local A1 = Args[1]

                if A1 and type(A1) == "table" then
                    table.remove(Args, 1)
                end

                Presses = 1 + Presses

                task.spawn(Callback, Presses, ...)

                return Presses
            end

            ButtonFunctions.Click = ButtonFunctions.Press

            --[
            --SetLocked
            --]

            function ButtonFunctions:SetLocked(t, state)
                if type(t) ~= "table" then
                    state = t
                end

                local Last = Locked

                if state == nil then
                    Locked = not Locked
                else
                    Locked = state
                end

                if Locked ~= Last then
                    Locked = Last
                end

                return Locked
            end

            ButtonFunctions.SetLock = ButtonFunctions.SetLocked

            --[
            --Lock
            --]

            function ButtonFunctions:Lock()
                if not Locked then
                    Locked = true
                end

                return Locked
            end

            ButtonFunctions.Locked = ButtonFunctions.Lock

            --[
            --Unlock
            --]

            function ButtonFunctions:Unlock()
                if Locked then
                    Locked = false
                end

                return Locked
            end

            ButtonFunctions.Unlock = ButtonFunctions.Unlocked

            --[
            --SetCondition
            --]

            function ButtonFunctions:SetCondition(t, condition)
                if type(t) ~= "table" and condition == nil then
                    condition = t
                end

                Condition = condition

                return condition
            end

            ButtonFunctions.SetCond = ButtonFunctions.SetCondition

            --[
            --Get
            --]

            function ButtonFunctions:Get()
                return Callback, Presses
            end

            return ButtonFunctions
        end

        Elements.CreateButton = Elements.AddButton
        Elements.Button = Elements.AddButton

        return Elements
    end

    Tabs.AddTab = Tabs.CreateTab
    Tabs.Tab = Tabs.CreateTab

    return Tabs
end

BreakSkill.AddWindow = BreakSkill.CreateWindow
BreakSkill.Window = BreakSkill.CreateWindow

return BreakSkill
