--[
--Script Made By xS_Killus
--]

--Instances and Functions

local library = {}
local Flags = {}

local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

function Dragify(frame)
    local dragToggle = nil
    local dragSpeed = .25
    local dragInput = nil
    local dragStart = nil
    local dragPos = nil

    local function UpdateInput(input)
        local Delta = input.Position - dragStart
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)

        game:GetService("TweenService"):Create(frame, TweenInfo.new(.25), {Position = Position}):Play()
    end

    frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    dragToggle = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if (input == dragInput and dragToggle) then
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
--UI Library Functions
--]

--[
--CreateWindow
--]

function library:CreateWindow(options)
    local Name = (options.Name or options.Title or options.Text) or "Break-Skill Hub - V1"

    local BreakSkillHub = Instance.new("ScreenGui")
    local BackFrame = Instance.new("Frame")
    local UICorner_1 = Instance.new("UICorner")
    local TopBar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Cover_1 = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local Game = Instance.new("TextLabel")
    local User = Instance.new("ImageLabel")
    local SideBar = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local Cover_2 = Instance.new("Frame")
    local AllTabs = Instance.new("Frame")
    local ScrollingFrame = Instance.new("ScrollingFrame")
    local UIListLayout = Instance.new("UIListLayout")
    local PagesFolder = Instance.new("Folder")

    BreakSkillHub.Name = "Break-Skill Hub - V1"
    BreakSkillHub.Parent = CoreGui
    BreakSkillHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    BackFrame.Name = "BackFrame"
    BackFrame.Parent = BreakSkillHub
    BackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    BackFrame.BorderSizePixel = 0
    BackFrame.Position = UDim2.new(0.0170925632, 0, 0.25677368, 0)
    BackFrame.Size = UDim2.new(0, 759, 0, 440)

    UICorner_1.Parent = BackFrame

    TopBar.Name = "TopBar"
    TopBar.Parent = BackFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(-0.000528850709, 0, -0.00112308154, 0)
    TopBar.Size = UDim2.new(0, 759, 0, 38)

    UICorner_2.Parent = TopBar

    Cover_1.Name = "Cover_1"
    Cover_1.Parent = TopBar
    Cover_1.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Cover_1.BorderSizePixel = 0
    Cover_1.Position = UDim2.new(0.000529453857, 0, 0.333095938, 0)
    Cover_1.Size = UDim2.new(0, 758, 0, 43)

    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.242099673, 0, 0.0526315793, 0)
    Title.Size = UDim2.new(0, 232, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Game.Name = "Game"
    Game.Parent = TopBar
    Game.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Game.BackgroundTransparency = 1
    Game.Position = UDim2.new(0.242099673, 0, 0.684210479, 0)
    Game.Size = UDim2.new(0, 232, 0, 27)
    Game.Font = Enum.Font.SourceSansBold
    Game.Text = MarketplaceService:GetProductInfo(game.PlaceId).Name
    Game.TextColor3 = Color3.fromRGB(255, 255, 255)
    Game.TextSize = 15
    Game.TextTransparency = 0.67
    Game.TextXAlignment = Enum.TextXAlignment.Left

    User.Name = "User"
    User.Parent = TopBar
    User.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    User.BackgroundTransparency = 1
    User.Position = UDim2.new(0.948616505, 0, 0.421052635, 0)
    User.Size = UDim2.new(0, 23, 0, 23)
    User.Image = "rbxassetid://7072724349"
    User.ImageTransparency = 0.8

    SideBar.Name = "SideBar"
    SideBar.Parent = BackFrame
    SideBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    SideBar.BorderSizePixel = 0
    SideBar.Position = UDim2.new(-0.000528147095, 0, -0.00112326827, 0)
    SideBar.Size = UDim2.new(0, 175, 0, 440)

    UICorner_3.Parent = SideBar

    Cover_2.Name = "Cover_2"
    Cover_2.Parent = SideBar
    Cover_2.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Cover_2.BorderSizePixel = 0
    Cover_2.Position = UDim2.new(0.422661394, 0, 0.00112179841, 0)
    Cover_2.Size = UDim2.new(0, 101, 0, 439)

    AllTabs.Name = "AllTabs"
    AllTabs.Parent = SideBar
    AllTabs.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    AllTabs.BorderSizePixel = 0
    AllTabs.Position = UDim2.new(0.0514285713, 0, 0.0189371984, 0)
    AllTabs.Size = UDim2.new(0, 159, 0, 423)

    ScrollingFrame.Parent = AllTabs
    ScrollingFrame.Active = true
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(0, 165, 0, 423)
    ScrollingFrame.ScrollBarThickness = 0

    UIListLayout.Parent = ScrollingFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 4)

    PagesFolder.Parent = BackFrame

    Dragify(BackFrame)

    local WindowFunctions = {}

    --[
    --CreateTab
    --]

    function WindowFunctions:CreateTab(options)
        local TabName = (options.Title or options.Name or options.Text) or "New Tab"
        local TabLogo = (options.TabLogo or options.Logo) or "rbxassetid://7429253275"

        local TabButton = Instance.new("TextButton")
        local Logo = Instance.new("ImageLabel")
        local NameTab = Instance.new("TextLabel")
        local ChosenFrame = Instance.new("Frame")
        local UICorner_4 = Instance.new("UICorner")
        local Tab = Instance.new("Frame")
        local ShadowPX = Instance.new("ImageLabel")
        local TabTitle = Instance.new("TextLabel")
        local UICorner_5 = Instance.new("UICorner")
        local Scroll = Instance.new("ScrollingFrame")
        local ElementList = Instance.new("UIListLayout")

        TabButton.Name = "TabButton"
        TabButton.Parent = ScrollingFrame
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        TabButton.BackgroundTransparency = 1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 159, 0, 41)
        TabButton.AutoButtonColor = false
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.TextSize = 14

        Logo.Name = "TabLogo"
        Logo.Parent = TabButton
        Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Logo.BackgroundTransparency = 1
        Logo.Position = UDim2.new(0.0691823959, 0, 0.24390243, 0)
        Logo.Size = UDim2.new(0, 20, 0, 20)
        Logo.Image = "rbxassetid://7072977617"
        Logo.ImageTransparency = 0.58

        NameTab.Parent = TabButton
        NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.BackgroundTransparency = 1
        NameTab.Position = UDim2.new(0.301886708, 0, -0.073170729, 0)
        NameTab.Size = UDim2.new(0, 117, 0, 47)
        NameTab.Font = Enum.Font.SourceSansBold
        NameTab.Text = TabName
        NameTab.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.TextSize = 14
        NameTab.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        NameTab.TextTransparency = 0.58
        NameTab.TextXAlignment = Enum.TextXAlignment.Left

        ChosenFrame.Name = "ChosenFrame"
        ChosenFrame.Parent = TabButton
        ChosenFrame.BackgroundColor3 = Color3.fromRGB(115, 125, 190)
        ChosenFrame.BackgroundTransparency = 1
        ChosenFrame.Position = UDim2.new(0.999999881, 0, 0.0567158014, 0)
        ChosenFrame.Size = UDim2.new(0, 23, 0, 34)
        ChosenFrame.ZIndex = 2

        UICorner_4.CornerRadius = UDim.new(0, 5)
        UICorner_4.Parent = ChosenFrame

        Tab.Name = "Tab"
        Tab.Parent = PagesFolder
        Tab.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.251118749, 0, 0.220086664, 0)
        Tab.Size = UDim2.new(0, 552, 0, 327)
        Tab.Visible = false

        ShadowPX.Name = "ShadowPX"
        ShadowPX.Parent = Tab
        ShadowPX.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ShadowPX.BackgroundTransparency = 1
        ShadowPX.Position = UDim2.new(-0.0561594181, 0, -0.0536723025, 0)
        ShadowPX.Size = UDim2.new(0, 613, 0, 362)
        ShadowPX.Image = TabLogo
        ShadowPX.ImageColor3 = Color3.fromRGB(0, 0, 0)
        ShadowPX.ImageTransparency = 0.8

        TabTitle.Name = "TabTitle"
        TabTitle.Parent = Tab
        TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Position = UDim2.new(0.00724637695, 0, -0.127445415, 0)
        TabTitle.Size = UDim2.new(0, 208, 0, 41)
        TabTitle.Font = Enum.Font.SourceSansBold
        TabTitle.Text = TabName
        TabTitle.TextColor3 = Color3.fromRGB(115, 125, 190)
        TabTitle.TextSize = 15
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left

        UICorner_5.CornerRadius = UDim.new(0, 6)
        UICorner_5.Parent = Tab

        Scroll.Name = "Scroll"
        Scroll.Parent = Tab
        Scroll.Active = true
        Scroll.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Scroll.BorderSizePixel = 0
        Scroll.Position = UDim2.new(0.0181159414, 0, 0.0214067269, 0)
        Scroll.Size = UDim2.new(0, 534, 0, 320)
        Scroll.ScrollBarThickness = 0

        ElementList.Name = "ElementList"
        ElementList.Parent = Scroll
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
                    TweenService:Create(v.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(v.ChosenFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                end
            end

            TweenService:Create(TabButton.TextLabel, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {TextTransparency = 0, TextStrokeTransparency = 0.88}):Play()
            TweenService:Create(TabButton.Logo, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {ImageTransparency = 0}):Play()
            TweenService:Create(ChosenFrame, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundTransparency = 0}):Play()
        end)

        local TabFunctions = {}

        --[
        --AddButton
        --]

        function TabFunctions:AddButton(options)
            local ButtonName = (options.Name or options.Text or options.Title) or "New Button"
            local Callback = options.Callback or function () end
            local Locked = (options.Locked or options.Lock) or false

            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")

            Button.Name = "Button"
            Button.Parent = Scroll
            Button.BackgroundColor3 = Color3.fromRGB(110, 120, 200)
            Button.Position = UDim2.new(0, 0, 0.581250012, 0)
            Button.Size = UDim2.new(0, 534, 0, 34)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.SourceSansBold
            Button.Text = ButtonName
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14

            ButtonCorner.CornerRadius = UDim.new(0, 3)
            ButtonCorner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                if Locked then
                    return
                end

                Callback()

                TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(185, 200, 255)}):Play()

                wait(0.08)

                TweenService:Create(Button, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()
            end)

            if Locked then
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()

                Button.Text = ButtonName .. " (Locked)"
            else
                TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()

                Button.Text = ButtonName
            end

            Button.MouseEnter:Connect(function()
                if Locked then
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(200, 110, 110)}):Play()
                else
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(140, 150, 225)}):Play()
                end
            end)

            Button.MouseLeave:Connect(function()
                if Locked then
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()
                else
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()
                end
            end)

            local ButtonFunctions = {}

            --[
            --SetLock
            --]

            function ButtonFunctions:SetLock(state)
                Locked = state

                if Locked == false then
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(110, 120, 200)}):Play()

                    Button.Text = ButtonName
                else
                    TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()

                    Button.Text = ButtonName .. " (Locked)"
                end

                return Locked
            end

            --[
            --Press
            --]

            function ButtonFunctions:Press()
                Callback()
            end

            --[
            --SetName
            --]

            function ButtonFunctions:SetName(newName)
                Button.Text = newName
            end

            --[
            --SetCallback
            --]

            function ButtonFunctions:SetCallback(new, call)
                call = new or function() end

                options.Callback = call

                Callback = options.Callback

                return Callback
            end

            return ButtonFunctions
        end

        return TabFunctions
    end

    return WindowFunctions
end

return library
