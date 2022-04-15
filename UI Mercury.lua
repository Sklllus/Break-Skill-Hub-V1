--[
--Modified Mercury Lib (By Abstract and Deity) Made By xS_Killus (xX_XSI)
--]

--Instances And Functions

local library = {
    Themes = {
        Legacy = {
            Main = Color3.fromHSV(262 / 360, 60 / 255, 34 / 255),
            Secondary = Color3.fromHSV(240 / 360, 40 / 255, 63 / 255),
            Tertiary = Color3.fromHSV(260 / 360, 60 / 255, 148 / 255),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 172 / 255)
        },
        Serika = {
            Main = Color3.fromRGB(50, 52, 55),
            Secondary = Color3.fromRGB(80, 82, 85),
            Tertiary = Color3.fromRGB(226, 183, 20),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 172 / 255)
        },
        Dark = {
            Main = Color3.fromRGB(30, 30, 35),
            Secondary = Color3.fromRGB(50, 50, 55),
            Tertiary = Color3.fromRGB(70, 130, 180),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 172 / 255)
        },
        Rust = {
            Main = Color3.fromRGB(37, 35, 33),
            Secondary = Color3.fromRGB(65, 63, 63),
            Tertiary = Color3.fromRGB(237, 94, 38),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 172 / 255)
        },
        Aqua = {
            Main = Color3.fromRGB(19, 21, 21),
            Secondary = Color3.fromRGB(65, 63, 63),
            Tertiary = Color3.fromRGB(51, 153, 137),
            StrongText = Color3.fromHSV(0, 0, 1),
            WeakText = Color3.fromHSV(0, 0, 172 / 255)
        }
    },
    ColorPickerStyles = {
        Legacy = 0,
        Modern = 1
    },
    ThemeObjects = {
        Main = {},
        Secondary = {},
        Tertiary = {},
        StrongText = {},
        WeakText = {}
    },
    Toggled = true,
    WelcomeText = nil,
    DisplayName = nil,
    DragSpeed = 0.06,
    LockDragging = false,
    ToggleKey = Enum.KeyCode.RightShift,
    URLLabel = nil,
    URL = nil
}

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()

library.__index = library

local SelectedTab

library._promptExists = false
library._colorPickerExists = false

local GlobalTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

function library:Set_Defaults(def, opt)
    def = def or {}
    opt = opt or {}

    for opt, v in next, opt do
        def[opt] = v
    end

    return def
end

function library:Change_Theme(toTheme)
    library.CurrentTheme = toTheme

    local c = self:Lighten(toTheme.Tertiary, 20)

    library.DisplayName.Text = "Welcome, <font color='rgb(" ..  math.floor(c.R * 255) .. "," .. math.floor(c.G * 255) .. "," .. math.floor(c.B * 255) .. ")'><b>" .. Client.DisplayName .. "</b></font>"

    for color, objects in next, library.ThemeObjects do
        local ThemeColor = library.CurrentTheme[color]

        for _, obj in next, objects do
            local Element, Property, Theme, ColorAlter = obj[1], obj[2], obj[3], obj[4] or 0

            ThemeColor = library.CurrentTheme[Theme]

            local ModifiedColor = ThemeColor

            if ColorAlter < 0 then
                ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
            elseif ColorAlter > 0 then
                ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
            end

            Element:Tween{[Property] = ModifiedColor}
        end
    end
end

function library:Object(class, prop)
    local LocalObject = Instance.new(class)

    local ForcedProps = {
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSansBold,
        Text = ""
    }

    for props, v in next, ForcedProps do
        pcall(function()
            LocalObject[props] = v
        end)
    end

    local Methods = {}

    Methods.AbsoluteObject = LocalObject

    function Methods:Tween(opt, callback)
        local opt = library:Set_Defaults({
            Length = 0.2,
            Style = Enum.EasingStyle.Linear,
            Direction = Enum.EasingDirection.InOut
        }, opt)

        callback = callback or function ()
            return
        end

        local ti = TweenInfo.new(opt.Length, opt.Style, opt.Direction)

        opt.Length = nil
        opt.Style = nil
        opt.Direction = nil

        local Tween = TweenService:Create(LocalObject, ti, opt)
        Tween:Play()

        Tween.Completed:Connect(function()
            callback()
        end)

        return Tween
    end

    function Methods:Round(radius)
        radius = radius or 6

        library:Object("UICorner", {
            Parent = LocalObject,
            CornerRadius = UDim.new(0, radius)
        })

        return Methods
    end

    function Methods:Object(class, props)
        local props = props or {}

        props.Parent = LocalObject

        return library:Object(class, props)
    end

    function Methods:CrossFade(p2, length)
        length = length or .2

        self:Tween({ImageTransparency = 1})

        p2:Tween({ImageTransparency = 0})
    end

    function Methods:Fade(state, colorOverride, length, instant)
        length = length or 0.2

        if not rawget(self, "fadeFrame") then
            local frame = self:Object("Frame", {
                BackgroundColor3 = colorOverride or self.BackgroundColor3,
                BackgroundTransparency = (state and 1) or 0,
                Size = UDim2.fromScale(1, 1),
                Centered = true,
                ZIndex = 999
            }):Round(self.AbsoluteObject:FindFirstChildOfClass("UICorner") and self.AbsoluteObject:FindFirstChildOfClass("UICorner").CornerRadius.Offset or 0)

            rawset(self, "fadeFrame", frame)
        else
            self.fadeFrame.BackgroundColor3 = colorOverride or self.BackgroundColor3
        end

        if instant then
            if state then
                self.fadeFrame.BackgroundTransparency = 0
                self.fadeFrame.Visible = true
            else
                self.fadeFrame.BackgroundTransparency = 1
                self.fadeFrame.Visible = false
            end
        else
            if state then
                self.fadeFrame.BackgroundTransparency = 1
                self.fadeFrame.Visible = true
                self.fadeFrame:Tween{BackgroundTransparency = 0, Length = length}
            else
                self.fadeFrame.BackgroundTransparency = 0
                self.fadeFrame:Tween({BackgroundTransparency = 1, Length = length}, function()
                    self.fadeFrame.Visible = false
                end)
            end
        end
    end

    function Methods:Stroke(color, thick, strokeMode)
        thick = thick or 1
        strokeMode = strokeMode or Enum.ApplyStrokeMode.Border

        local Stroke = self:Object("UIStroke", {
            ApplyStrokeMode = strokeMode,
            Thickness = thick
        })

        if type(color) == "table" then
            local Theme, ColorAlter = color[1], color[2] or 0
            local ThemeColor = library.CurrentTheme[Theme]
            local ModifiedColor = ThemeColor

            if ColorAlter < 0 then
                ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
            elseif ColorAlter > 0 then
                ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
            end

            Stroke.Color = ModifiedColor

            table.insert(library.ThemeObjects[Theme], {Stroke, "Color", Theme, ColorAlter})
        elseif type(color) == "string" then
            local ThemeColor = library.CurrentTheme[color]

            Stroke.Color = ThemeColor

            table.insert(library.ThemeObjects[color], {Stroke, "Color", color, 0})
        else
            Stroke.Color = color
        end

        return Methods
    end

    function Methods:ToolTip(text)
        local ToolTipContainer = Methods:Object("TextLabel", {
            Theme = {
                BackgroundColor3 = {"Main", 10},
                TextColor3 = {"WeakText"}
            },
            TextSize = 16,
            Text = text,
            Position = UDim2.new(0.5, 0, 0, -8),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            AnchorPoint = Vector2.new(0.5, 1),
            BackgroundTransparency = 1,
            TextTransparency = 1
        }):Round(5)

        ToolTipContainer.Size = UDim2.fromOffset(ToolTipContainer.TextBounds.X + 16, ToolTipContainer.TextBounds.Y + 8)

        local ToolTipArrow = ToolTipContainer:Object("ImageLabel", {
            Image = "rbxassetid://4292970642",
            Theme = {ImageColor3 = {"Main", 10}},
            AnchorPoint = Vector2.new(0.5, 0),
            Rotation = 180,
            Position = UDim2.fromScale(0.5, 1),
            Size = UDim2.fromOffset(10, 6),
            BackgroundTransparency = 1,
            ImageTransparency = 1
        })

        local Hovered = false

        Methods.MouseEnter:Connect(function()
            Hovered = true

            wait(0.2)

            if Hovered then
                ToolTipContainer:Tween{BackgroundTransparency = 0.2, TextTransparency = 0.2}
                ToolTipArrow:Tween{ImageTransparency = 0.2}
            end
        end)

        Methods.MouseLeave:Connect(function()
            Hovered = false

            ToolTipContainer:Tween{BackgroundTransparency = 1, TextTransparency = 1}
            ToolTipArrow:Tween{ImageTransparency = 1}
        end)

        return Methods
    end

    local CustomHandlers = {
        Centered = function(val)
            if val then
                LocalObject.AnchorPoint = Vector2.new(0.5, 0.5)
                LocalObject.Position = UDim2.fromScale(0.5, 0.5)
            end
        end,
        Theme = function(val)
            for props, obj in next, val do
                if type(obj) == "table" then
                    local Theme, ColorAlter = obj[1], obj[2] or 0
                    local ThemeColor = library.CurrentTheme[Theme]
                    local ModifiedColor = ThemeColor

                    if ColorAlter < 0 then
                        ModifiedColor = library:Darken(ThemeColor, -1 * ColorAlter)
                    elseif ColorAlter > 0 then
                        ModifiedColor = library:Lighten(ThemeColor, ColorAlter)
                    end

                    LocalObject[props] = ModifiedColor

                    table.insert(self.ThemeObjects[Theme], {Methods, props, Theme, ColorAlter})
                else
                    local ThemeColor = library.CurrentTheme[obj]

                    LocalObject[props] = ThemeColor

                    table.insert(self.ThemeObjects[obj], {Methods, props, obj, 0})
                end
            end
        end
    }

    for props, val in next, prop do
        if CustomHandlers[props] then
            CustomHandlers[props](val)
        else
            LocalObject[props] = val
        end
    end

    return setmetatable(Methods, {
        __index = function(_, props)
            return LocalObject[props]
        end,
        __newIndex = function(_, props, val)
            LocalObject[props] = val
        end
    })
end

function library:Show(state)
    self.Toggled = state
    self.MainFrame.ClipsDescendants = true

    if state then
        self.MainFrame:Tween({Size = self.MainFrame.OldSize, Length = 0.25}, function()
            rawset(self.MainFrame, "OldSize", (state and self.MainFrame.OldSize) or self.MainFrame.Size)

            self.MainFrame.ClipsDescendants = false
        end)

        wait(0.15)

        self.MainFrame:Fade(not state, self.MainFrame.BackgroundColor3, 0.15)
    else
        self.MainFrame:Fade(not state, self.MainFrame.BackgroundColor3, 0.15)

        wait(0.1)

        self.MainFrame:Tween{Size = UDim2.new(), Length = 0.25}
    end
end

function library:Darken(color, f)
    local h, s, v = Color3.toHSV(color)

    f = 1 - ((f or 15) / 80)

    return Color3.fromHSV(h, math.clamp(s / f, 0, 1), math.clamp(v * f, 0, 1))
end

function library:Lighten(color, f)
    local h, s, v = Color3.toHSV(color)

    f = 1 - ((f or 15) / 80)

    return Color3.fromHSV(h, math.clamp(s * f, 0, 1), math.clamp(v / f, 0, 1))
end

local UpdateSettings = function()
    
end

function library:Set_Status(text)
    self.StatusText.Text = text
end

--[
--UI Library Functions
--]

function library:CreateWindow(options)
    local Settings = {
        Theme = "Dark"
    }

    if readfile and writefile and isfile then
        if not isfile("Break-Skill Hub - V1/UI/UISettings.json") then
            writefile("Break-Skill Hub - V1/UI/UISettings.json", HttpService:JSONEncode(Settings))
        end

        Settings = HttpService:JSONDecode(readfile("Break-Skill Hub - V1/UI/UISettings.json"))

        library.CurrentTheme = library.Themes[Settings.Theme]

        UpdateSettings = function(prop, val)
            Settings[prop] = val

            writefile("Break-Skill Hub - V1/UI/UISettings.json", HttpService:JSONEncode(Settings))
        end
    end

    options = self:Set_Defaults({
        Name = "Break-Skill Hub - V1",
        Size = UDim2.fromOffset(600, 400),
        Theme = self.Themes[Settings.Theme]
    }, options)

    if getgenv() and getgenv().BreakSkillHubV1 then
        getgenv():BreakSkillHubV1()
        getgenv().BreakSkillHubV1 = nil
    end

    if options.Theme.Light then
        self.Darken, self.Lighten = self.Lighten, self.Darken
    end

    self.CurrentTheme = options.Theme

    local GUI = self:Object("ScreenGui", {
        Parent = (RunService:IsStudio() and Client.PlayerGui) or CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local NotificationHolder = GUI:Object("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 1, -30),
        Size = UDim2.new(0, 300, 1, -60)
    })

    local _NotificationHolderList = NotificationHolder:Object("UIListLayout", {
        Padding = UDim.new(0, 20),
        VerticalAlignment = Enum.VerticalAlignment.Bottom
    })

    local Core = GUI:Object("Frame", {
        Size = UDim2.new(),
        Theme = {BackgroundColor3 = "Main"},
        Centered = true,
        ClipsDescendants = true
    }):Round(10)

    Core:Fade(true, nil, 0.2, true)
    Core:Fade({Size = options.Size, Length = 0.3}, function()
        Core.ClipsDescendants = false
    end)

    do
        local S, Event = pcall(function()
            return Core.MouseEnter
        end)

        if S then
            Core.Active = true

            Event:Connect(function()
                local Input = Core.InputBegan:Connect(function(key)
                    if key.UserInputType == Enum.UserInputType.MouseButton1 then
                        local ObjectPosition = Vector2.new(Mouse.X - Core.AbsolutePosition.X, Mouse.Y - Core.AbsolutePosition.Y)

                        while RunService.RenderStepped:Wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            if library.LockDragging then
                                local FrameX, FrameY = math.clamp(Mouse.X - ObjectPosition.X, 0, GUI.AbsoluteSize.X - Core.AbsoluteSize.X), math.clamp(Mouse.Y - ObjectPosition.Y, 0, GUI.AbsoluteSize.Y - Core.AbsoluteSize.Y)

                                Core:Tween{Position = UDim2.fromOffset(FrameX + (Core.Size.X.Offset * Core.AnchorPoint.X), FrameY + (Core.Size.Y.Offset * Core.AnchorPoint.Y)), Length = library.DragSpeed}
                            else
                                Core:Tween{Position = UDim2.fromOffset(Mouse.X - ObjectPosition.X + (Core.Size.X.Offset * Core.AnchorPoint.X), Mouse.Y - ObjectPosition.Y + (Core.Size.Y.Offset * Core.AnchorPoint.Y)), Length = library.DragSpeed}
                            end
                        end
                    end
                end)

                local Leave

                Leave = Core.MouseLeave:Connect(function()
                    Input:Disconnect()
                    Leave:Disconnect()
                end)
            end)
        end
    end

    rawset(Core, "OldSize", options.Size)

    self.MainFrame = Core

    local TabButtons = Core:Object("ScrollingFrame", {
        Size = UDim2.new(1, -40, 0, 25),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        AutomaticCanvasSize = Enum.AutomaticSize.X
    })

    TabButtons:Object("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    })

    local CloseButton = Core:Object("ImageButton", {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(14, 14),
        Position = UDim2.new(1, -11, 0, 11),
        Theme = {ImageColor3 = "StrongText"},
        Image = "rbxassetid://8497487650",
        AnchorPoint = Vector2.new(1)
    })

    CloseButton.MouseEnter:Connect(function()
        CloseButton:Tween{ImageColor3 = Color3.fromRGB(255, 124, 142)}
    end)

    CloseButton.MouseLeave:Connect(function()
        CloseButton:Tween{ImageColor3 = library.CurrentTheme.StrongText}
    end)

    local function CloseUI()
        Core.ClipsDescendants = true

        Core:Fade(true)

        wait(0.1)

        Core:Tween({Size = UDim2.new()}, function()
            GUI.AbsoluteObject:Destroy()
        end)
    end

    if getgenv then
        getgenv().BreakSkillHubV1 = CloseUI
    end

    CloseButton.MouseButton1Click:Connect(function()
        CloseUI()
    end)

    local URLBar = Core:Object("Frame", {
        Size = UDim2.new(1, -10, 0, 25),
        Position = UDim2.new(0, 5, 0, 35),
        Theme = {BackgroundColor3 = "Secondary"}
    }):Round(5)

    local SearchIcon = URLBar:Object("ImageLabel", {
        AnchorPoint = Vector2.new(0, .5),
        Position = UDim2.new(0, 5, 0.5, 0),
        Theme = {ImageColor3 = "Tertiary"},
        Size = UDim2.fromOffset(16, 16),
        Image = "rbxassetid://8496489946",
        BackgroundTransparency = 1
    })

    local Link = URLBar:Object("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 26, 0.5, 0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -30, .6, 0),
        Text = options.Link,
        Theme = {TextColor3 = "WeakText"},
        TextSize = 14,
        TextScaled = false,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    library.URLLabel = Link
    library.URL = options.Link

    local ShadowHolder = Core:Object("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0
    })

    local Shadow = ShadowHolder:Object("ImageLabel", {
        Centered = true,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 47, 1, 47),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = .6,
        SliceCenter = Rect.new(47, 47, 450, 450),
        ScaleType = Enum.ScaleType.Slice,
        SliceScale = 1
    })

    local Content = Core:Object("Frame", {
        Theme = {BackgroundColor3 = {"Secondary", -10}},
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.new(0.5, 0, 1, -20),
        Size = UDim2.new(1, -10, 1, -86)
    }):Round(7)

    local Status = Core:Object("TextLabel", {
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 1, -6),
        Size = UDim2.new(0.2, 0, 0, 10),
        Font = Enum.Font.SourceSansBold,
        Text = "Status | Idle",
        Theme = {TextColor3 = "Tertiary"},
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local HomeButton = TabButtons:Object("TextButton", {
        Name = "Home",
        BackgroundTransparency = 0,
        Theme = {BackgroundColor3 = "Secondary"},
        Size = UDim2.new(0, 125, 0, 25)
    }):Round(5)

    local HomeButtonText = HomeButton:Object("TextLabel", {
        Theme = {TextColor3 = "StrongText"},
        AnchorPoint = Vector2.new(0, .5),
        BackgroundTransparency = 1,
        TextSize = 14,
        Text = options.Name,
        Position = UDim2.new(0, 25, 0.5, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -45, 0.5, 0),
        Font = Enum.Font.SourceSansBold,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local HomeButtonIcon = HomeButton:Object("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0.5, 0),
        Size = UDim2.new(0, 15, 0, 15),
        Image = "rbxassetid://8569322835",
        Theme = {ImageColor3 = "StrongText"}
    })

    local HomePage = Content:Object("Frame", {
        Size = UDim2.fromScale(1, 1),
        Centered = true,
        BackgroundTransparency = 1
    })

    local Tabs = {}

    SelectedTab = HomeButton

    Tabs[#Tabs + 1] = {HomePage, HomeButton}

    do
        local Down = false
        local Hovered = false

        HomeButton.MouseEnter:Connect(function()
            Hovered = true

            HomeButton:Tween{BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 0.3}
        end)

        HomeButton.MouseLeave:Connect(function()
            Hovered = false

            HomeButton:Tween{BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 1}
        end)

        HomeButton.MouseButton1Down:Connect(function()
            Down = true

            HomeButton:Tween{BackgroundTransparency = 0}
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Down = false

                HomeButton:Tween{BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or (Hovered and 0.3) or 1}
            end
        end)

        HomeButton.MouseButton1Click:Connect(function()
            for _, TabInfo in next, Tabs do
                local Page = TabInfo[1]
                local Button = TabInfo[2]

                Page.Visible = false
            end

            SelectedTab:Tween{BackgroundTransparency = ((SelectedTab == HomeButton) and 0.15) or 1}
            SelectedTab = HomeButton

            HomePage.Visible = true
            HomeButton.BackgroundTransparency = 0

            library.URLLabel.Text = library.URL .. "/home"
        end)
    end

    self.SelectedTabButton = HomeButton

    local HomePageLayout = HomePage:Object("UIListLayout", {
        Padding = UDim.new(0, 10),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

    local HomePagePadding = HomePage:Object("UIPadding", {
        PaddingTop = UDim.new(0, 10)
    })

    local Profile = HomePage:Object("Frame", {
        AnchorPoint = Vector2.new(0, .5),
        Theme = {BackgroundColor3 = "Secondary"},
        Size = UDim2.new(1, -20, 0, 100)
    }):Round(7)

    local ProfilePictureContainer = Profile:Object("ImageLabel", {
        Image = Players:GetUserThumbnailAsync(Client.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
        Theme = {BackgroundColor3 = {"Secondary", 10}},
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 10, 0, 0.5),
        Size = UDim2.fromOffset(80, 80)
    }):Round(100)

    local DisplayName

    do
        local h, s, v = Color3.toHSV(options.Theme.Tertiary)
        local c = self:Lighten(options.Theme.Tertiary, 20)

        DisplayName = Profile:Object("TextLabel", {
            RichText = true,
            Text = "Welcome, <font color='rgb(" ..  math.floor(c.R * 255) .. "," .. math.floor(c.G * 255) .. "," .. math.floor(c.B * 255) .. ")'> <b>" .. Client.DisplayName .. "</b> </font>",
            TextScaled = true,
            Position = UDim2.new(0, 105, 0, 10),
            Theme = {TextColor3 = {"Tertiary", 10}},
            Size = UDim2.new(0, 400, 0, 40),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        library.DisplayName = DisplayName
    end

    local ProfileName = Profile:Object("TextLabel", {
        Text = "@" .. Client.DisplayName,
        TextScaled = true,
        Position = UDim2.new(0, 105, 0, 47),
        Theme = {TextColor3 = "Tertiary"},
        Size = UDim2.new(0, 400, 0, 20),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TimeDisplay = Profile:Object("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 105, 1, -10),
        Size = UDim2.new(0, 400, 0, 20),
        AnchorPoint = Vector2.new(0, 1),
        Theme = {TextColor3 = {"WeakText", -20}},
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = tostring(os.date("%X")):sub(1, os.date("%X"):len() - 3)
    })

    do
        local DesiredInterval = 1
        local Counter = 0

        RunService.Heartbeat:Connect(function(step)
            Counter += step

            if Counter >= DesiredInterval then
                Counter -= DesiredInterval

                local Date = tostring(os.date("%X"))

                TimeDisplay.Text = Date:sub(1, Date:len() - 3)
            end
        end)
    end

    local SettingsTabIcon = Profile:Object("ImageButton", {
        BackgroundTransparency = 1,
        Theme = {ImageColor3 = "WeakText"},
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -10, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        Image = "rbxassetid://8559790237"
    }):ToolTip("settings")

    local CreditsTabIcon = Profile:Object("ImageButton", {
        BackgroundTransparency = 1,
        Theme = {ImageColor3 = "WeakText"},
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -44, 1, -10),
        AnchorPoint = Vector2.new(1, 1),
        Image = "rbxassetid://8577523456"
    }):ToolTip("credits")

    local QuickAccess = HomePage:Object("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 180)
    })

    QuickAccess:Object("UIGridLayout", {
        CellPadding = UDim2.fromOffset(10, 10),
        CellSize = UDim2.fromOffset(55, 55),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })

    QuickAccess:Object("UIPadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 70),
        PaddingRight = UDim.new(0, 70),
        PaddingTop = UDim.new(0, 5)
    })

    local mt = setmetatable({
        Core = Core,
        Notifs = NotificationHolder,
        StatusText = Status,
        Container = Content,
        Navigation = TabButtons,
        Theme = options.Theme,
        Tabs = Tabs,
        QuickAccess = QuickAccess,
        HomeButton = HomeButton,
        HomePage = HomePage,
        NilFolder = Core:Object("Folder")
    }, library)

    local SettingsTab = library:CreateTab(mt, {
        Name = "Settings",
        Internal = SettingsTabIcon,
        Icon = "rbxassetid://8559790237"
    })

    SettingsTab:_Theme_Selector()

    SettingsTab:AddKeybind{
        Name = "Toggle Key",
        Description = "Key to Show/Hide the UI",
        Keybind = Enum.KeyCode.RightShift,
        Callback = function()
            self.Toggled = not self.Toggled

            library:Show(self.Toggled)
        end
    }

    SettingsTab:AddToggle{
        Name = "Lock Dragging",
        Description = "Makes sure you can't drag the UI outside of the window",
        StartingState = true,
        Callback = function(state)
            library.LockDragging = state
        end
    }

    SettingsTab:AddSlider{
        Name = "UI Drag speed",
        Description = "How smooth the dragging looks",
        Max = 20,
        Default = 14,
        Callback = function(state)
            library.DragSpeed = (20 - state) / 100
        end
    }

    local CreditsTab = library:CreateTab(mt, {
        Name = "Credits",
        Internal = CreditsTabIcon,
        Icon = "rbxassetid://8577523456"
    })

    rawset(mt, "CreditsContainer", CreditsTab.Container)

    CreditsTab:Credit{Name = "Abstract", Description = "UI Library Developer", Discord = "Abstract#8007", V3RMillion = "AbstractPoo"}
    CreditsTab:Credit{Name = "Deity", Description = "UI Library Developer", Discord = "Deity#0228", V3RMillion = "0xDEITY"}

    return mt
end

function library:Notification(options)
    options = self:Set_Defaults({
        Title = "Notification",
        Text = "Your character has been reset.",
        Duration = 3,
        Callback = function() end
    }, options)

    local FadeOut

    local Noti = self.Notifs:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {BackgroundColor3 = "Main"},
        Size = UDim2.new(0, 300, 0, 0)
    }):Round(10)

    local _NotiPadding = Noti:Object("UIPadding", {
        PaddingBottom = UDim.new(0, 11),
        PaddingTop = UDim.new(0, 11),
        PaddingLeft = UDim.new(0, 11),
        PaddingRight = UDim.new(0, 11)
    })

    local DropShadow = Noti:Object("Frame", {
        ZIndex = 0,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    })

    local _Shadow = DropShadow:Object("ImageLabel", {
        Centered = true,
        Position = UDim2.fromScale(.5, .5),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 70, 1, 70),
        ZIndex = 0,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local DurationHolder = Noti:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {BackgroundColor3 = "Secondary"},
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, 4)
    }):Round(100)

    local Length = DurationHolder:Object("Frame", {
        BackgroundTransparency = 1,
        Theme = {BackgroundColor3 = "Tertiary"},
        Size = UDim2.fromScale(1, 1)
    }):Round(100)

    local Icon = Noti:Object("ImageLabel", {
        BackgroundTransparency = 1,
        ImageTransparency = 1,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.fromOffset(18, 18),
        Image = "rbxassetid://8628681683",
        Theme = {ImageColor3 = "Tertiary"}
    })

    local Exit = Noti:Object("ImageButton", {
        Image = "rbxassetid://8497487650",
        AnchorPoint = Vector2.new(1, 0),
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(1, -3, 0, 3),
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 1,
        ImageTransparency = 1
    })

    Exit.MouseButton1Click:Connect(function()
        FadeOut()
    end)

    local Text = Noti:Object("TextLabel", {
        BackgroundTransparency = 1,
        Text = options.Text,
        Position = UDim2.new(0, 0, 0, 23),
        Size = UDim2.new(1, 0, 100, 0),
        TextSize = 16,
        TextTransparency = 1,
        TextWrapped = true,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })

    Text:Tween({Size = UDim2.new(1, 0, 0, Text.TextBounds.Y)})

    local Title = Noti:Object("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(23, 0),
        Size = UDim2.new(1, -60, 0, 20),
        Font = Enum.Font.SourceSansBold,
        Text = options.Title,
        Theme = {TextColor3 = "Tertiary"},
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextTransparency = 1
    })

    FadeOut = function()
        task.delay(0.3, function()
            Noti.AbsoluteObject:Destroy()

            options.Callback()
        end)

        Icon:Tween({ImageTransparency = 1, Length = 0.2})
        Exit:Tween({ImageTransparency = 1, Length = 0.2})
        DurationHolder:Tween({BackgroundTransparency = 1, Length = 0.2})
        Length:Tween({BackgroundTransparency = 1, Length = 0.2})
        Text:Tween({TextTransparency = 1, Length = 0.2})

        Title:Tween({TextTransparency = 1, Length = 0.2}, function()
            _Shadow:Tween({ImageTransparency = 1, Length = 0.2})
            Noti:Tween({BackgroundTransparency = 1, Length = 0.2, Size = UDim2.fromOffset(300, 0)})
        end)
    end

    _Shadow:Tween({ImageTransparency = .6, Length = 0.2})

    Noti:Tween({BackgroundTransparency = 0, Length = 0.2, Size = UDim2.fromOffset(300, Text.TextBounds.Y + 63)}, function()
        Icon:Tween({ImageTransparency = 0, Length = 0.2})
        Exit:Tween({ImageTransparency = 0, Length = 0.2})
        DurationHolder:Tween({BackgroundTransparency = 0, Length = 0.2})
        Length:Tween({BackgroundTransparency = 0, Length = 0.2})
        Text:Tween({TextTransparency = 0, Length = 0.2})
        Title:Tween({TextTransparency = 0, Length = 0.2})
    end)

    Length:Tween({Size = UDim2.fromScale(0, 1), Length = options.Duration}, function()
        FadeOut()
    end)
end

function library:CreateTab(options)
    options = self:Set_Defaults({
        Name = "New Tab",
        Icon = "rbxassetid://8569322835"
    }, options)


end

return setmetatable(library, {
    __Index = function(_, i)
        return rawget(library, i:lower())
    end
})
