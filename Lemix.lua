local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Linux = {}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then
        return
    end
    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 200 or 300
    local notificationHeight = config.SubContent and 80 or 60
    local startPosX = isMobile and 10 or 20

    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 10),
        ZIndex = 100
    })

    Linux.Instance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 5)
    })

    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.SourceSansBold,
        Text = config.Title or "Notification",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        Font = Enum.Font.SourceSans,
        Text = config.Content or "Content",
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    if config.SubContent then
        Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 45),
            Font = Enum.Font.SourceSans,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101
        })
    end

    local ProgressBar = Linux.Instance("Frame", {
        Parent = Notification,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(1, -10, 0, 4),
        Position = UDim2.new(0, 5, 1, -9),
        ZIndex = 101,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {
        Parent = ProgressBar,
        CornerRadius = UDim.new(0, 2)
    })

    local ProgressFill = Linux.Instance("Frame", {
        Parent = ProgressBar,
        BackgroundColor3 = Color3.fromRGB(0, 120, 255),
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 101,
        BorderSizePixel = 0
    })

    Linux.Instance("UICorner", {
        Parent = ProgressFill,
        CornerRadius = UDim.new(0, 2)
    })

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 10)}):Play()

    if config.Duration then
        local progressTweenInfo = TweenInfo.new(config.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        TweenService:Create(ProgressFill, progressTweenInfo, {Size = UDim2.new(1, 0, 1, 0)}):Play()

        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 10)}):Play()
            task.wait(0.5)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end

    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })

    ProtectGui(LinuxUI)

    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(300, 500)) or (config.SizePC or UDim2.fromOffset(550, 355))

    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1
    })

    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 5)
    })

    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(17, 17, 17),
        BorderColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 2,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 2
    })

    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 5)
    })

    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 2
    })

    local SubTitleLabel
    if config.SubTitle then
        SubTitleLabel = Linux.Instance("TextLabel", {
            Parent = TopBar,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            Position = UDim2.new(0, TitleLabel.TextBounds.X + 10, 0, 0),
            Font = Enum.Font.GothamMedium,
            Text = config.SubTitle,
            TextColor3 = Color3.fromRGB(170, 170, 170),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 2
        })
    end

    local BetaLabel
    if config.ShowBetaLabel ~= false then
        local betaPosX = SubTitleLabel and (TitleLabel.TextBounds.X + SubTitleLabel.TextBounds.X + 15) or (TitleLabel.TextBounds.X + 15)
        BetaLabel = Linux.Instance("Frame", {
            Parent = TopBar,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, 40, 0, 16),
            Position = UDim2.new(0, betaPosX, 0, 4),
            ZIndex = 2
        })

        Linux.Instance("UIGradient", {
            Parent = BetaLabel,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 139))
            }),
            Rotation = 45
        })

        Linux.Instance("UICorner", {
            Parent = BetaLabel,
            CornerRadius = UDim.new(0, 4)
        })

        Linux.Instance("TextLabel", {
            Parent = BetaLabel,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.SourceSansBold,
            Text = "BETA",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 2
        })
    end

    local CloseButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0, 2),
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
    })

    Linux.Instance("ImageLabel", {
        Parent = CloseButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3
    })

    local profileHeight = config.ShowIconProfile ~= false and 33 or 0
    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, config.TabWidth or 110, 1, -25 - profileHeight),
        ZIndex = 2,
        BorderSizePixel = 0
    })

    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255),
        ZIndex = 2,
        BorderSizePixel = 0
    })

    Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 3),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5)
    })

    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, config.TabWidth or 110, 0, 25),
        Size = UDim2.new(1, -(config.TabWidth or 110), 1, -25 - profileHeight),
        ZIndex = 1,
        BorderSizePixel = 2,
        BorderColor3 = Color3.fromRGB(50, 50, 50)
    })

    local ProfileFrame
    if config.ShowIconProfile ~= false then
        ProfileFrame = Linux.Instance("Frame", {
            Parent = Main,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 250, 0, 28),
            Position = UDim2.new(0, 5, 1, -33),
            ZIndex = 3
        })

        local ProfileIcon = Linux.Instance("ImageLabel", {
            Parent = ProfileFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, 0, 0, 0),
            Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100),
            ZIndex = 3
        })

        Linux.Instance("UICorner", {
            Parent = ProfileIcon,
            CornerRadius = UDim.new(1, 0)
        })

        local PlayerNameLabel = Linux.Instance("TextLabel", {
            Parent = ProfileFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 200, 0, 28),
            Position = UDim2.new(0, 30, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = LocalPlayer.Name,
            TextColor3 = Color3.fromRGB(100, 100, 100),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            ZIndex = 3
        })
    end

    local isHidden = false

    CloseButton.MouseButton1Click:Connect(function()
        LinuxUI:Destroy()
    end)

    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)

    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil
    local tabOrder = 0

    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder

        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Color3.fromRGB(19, 19, 19),
            BorderColor3 = Color3.fromRGB(255, 255, 255),
            BorderSizePixel = 2,
            Size = UDim2.new(1, -5, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Color3.fromRGB(180, 180, 180),
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })

        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 4)
        })

        local TabGradient
        local TabIcon
        if config.Icon and config.Icon.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 10, 0.5, -8),
                Image = config.Icon.Image or "rbxassetid://10747384394",
                ImageColor3 = Color3.fromRGB(100, 100, 100),
                ZIndex = 2
            })
        end

        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, config.Icon and config.Icon.Enabled and -31 or -15, 1, 0),
            Position = UDim2.new(0, config.Icon and config.Icon.Enabled and 31 or 10, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(100, 100, 100),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local TabContent = Linux.Instance("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Visible = false,
            ZIndex = 1,
            BorderSizePixel = 2,
            BorderColor3 = Color3.fromRGB(50, 50, 50)
        })

        local TitleFrame = Linux.Instance("Frame", {
            Parent = Content,
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
            BorderSizePixel = 0,
            Size = UDim2.new(1, -5, 0, 30),
            Position = UDim2.new(0, 5, 0, 0),
            Visible = false,
            ZIndex = 3
        })

        local TitleLabel = Linux.Instance("TextLabel", {
            Parent = TitleFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Font = Enum.Font.SourceSansBold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 26,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 4
        })

        local ElementContainer = Linux.Instance("Frame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            ZIndex = 1,
            BorderSizePixel = 2,
            BorderColor3 = Color3.fromRGB(50, 50, 50)
        })

        Linux.Instance("UIListLayout", {
            Parent = ElementContainer,
            Padding = UDim.new(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        Linux.Instance("UIPadding", {
            Parent = ElementContainer,
            PaddingLeft = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5)
        })

        local function SelectTab()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.TitleFrame.Visible = false
                tab.Text.TextColor3 = Color3.fromRGB(100, 100, 100)
                tab.Button.BackgroundColor3 = Color3.fromRGB(19, 19, 19)
                for _, child in pairs(tab.Button:GetChildren()) do
                    if child:IsA("UIGradient") then
                        child:Destroy()
                    end
                end
                if tab.Icon then
                    tab.Icon.ImageColor3 = Color3.fromRGB(100, 100, 100)
                end
            end
            TabContent.Visible = true
            TitleFrame.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabGradient = Linux.Instance("UIGradient", {
                Parent = TabBtn,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 139))
                }),
                Rotation = 45
            })
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            CurrentTab = tabIndex
        end

        TabBtn.MouseButton1Click:Connect(SelectTab)

        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent,
            TitleFrame = TitleFrame,
            Gradient = TabGradient
        }

        if tabOrder == 1 then
            SelectTab()
        end

        local TabElements = {}
        local elementOrder = 0

        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            local BtnFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = BtnFrame,
                CornerRadius = UDim.new(0, 4)
            })

            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 34),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1,
                AutoButtonColor = false
            })

            Linux.Instance("UIPadding", {
                Parent = Btn,
                PaddingLeft = UDim.new(0, 5)
            })

            Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -20, 0.5, -7),
                Image = "rbxassetid://10709791437",
                ImageColor3 = Color3.fromRGB(180, 180, 180),
                ZIndex = 1
            })

            local hoverColor = Color3.fromRGB(40, 40, 40)
            local clickColor = Color3.fromRGB(0, 120, 255)
            local originalColor = Color3.fromRGB(19, 19, 19)
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = hoverColor}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor}):Play()
            end)

            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = clickColor}):Play()
                end
            end)

            Btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(BtnFrame, tweenInfo, {BackgroundColor3 = originalColor}):Play()
                end
            end)

            Btn.MouseButton1Click:Connect(function()
                spawn(function() Linux:SafeCallback(config.Callback) end)
            end)

            return Btn
        end

        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            local Toggle = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 0, 34),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ToggleBox = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -45, 0, 7),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = ToggleBox,
                CornerRadius = UDim.new(1, 0)
            })

            local ToggleFill = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Color3.fromRGB(0, 120, 255),
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = ToggleFill,
                CornerRadius = UDim.new(1, 0)
            })

            local Knob = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0, 2),
                ZIndex = 2,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            local State = config.Default or false
            local isToggling = false

            local function UpdateToggle()
                if isToggling then return end
                isToggling = true
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                if State then
                    TweenService:Create(ToggleFill, tween, {Size = UDim2.new(1, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -18, 0, 2)}):Play()
                else
                    ToggleFill.Size = UDim2.new(0, 0, 1, 0)
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 2, 0, 2)}):Play()
                end
                task.wait(0.2)
                isToggling = false
            end

            UpdateToggle()

            ToggleBox.InputBegan:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not isToggling then
                    State = not State
                    UpdateToggle()
                    spawn(function() Linux:SafeCallback(config.Callback, State) end)
                end
            end)

            return Toggle
        end

        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            local Dropdown = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 4)
            })

            local DropdownButton = Linux.Instance("TextButton", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = "",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                ZIndex = 2,
                AutoButtonColor = false
            })

            Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = DropdownButton,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -20, 0.5, -7),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Color3.fromRGB(180, 180, 180),
                ZIndex = 2
            })

            local DropFrame = Linux.Instance("ScrollingFrame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(17, 17, 17),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("UIListLayout", {
                Parent = DropFrame,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            Linux.Instance("UIPadding", {
                Parent = DropFrame,
                PaddingLeft = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5)
            })

            local Options = config.Options or {}
            local IsOpen = false
            local SelectedValue = config.Default or (Options[1] or "None")

            local function UpdateDropSize()
                local optionHeight = 25
                local paddingBetween = 2
                local paddingTop = 5
                local maxHeight = 150
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions - 1) * paddingBetween + paddingTop
                local finalHeight = math.min(calculatedHeight, maxHeight)
                if finalHeight < 0 then finalHeight = 0 end

                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if IsOpen then
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -5, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -5, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                end
                task.wait(0.2)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ElementContainer.AbsoluteSize.Y + ElementContainer:GetChildren()[1].AbsoluteContentSize.Y)
            end

            local function PopulateOptions()
                for _, child in pairs(DropFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                if IsOpen then
                    for _, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = DropFrame,
                            BackgroundColor3 = Color3.fromRGB(21, 21, 21),
                            BorderColor3 = Color3.fromRGB(50, 50, 50),
                            BorderSizePixel = 2,
                            Size = UDim2.new(1, -5, 0, 25),
                            Font = Enum.Font.Gotham,
                            Text = tostring(opt),
                            TextColor3 = opt == SelectedValue and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180),
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            ZIndex = 3,
                            AutoButtonColor = false
                        })

                        Linux.Instance("UICorner", {
                            Parent = OptBtn,
                            CornerRadius = UDim.new(0, 4)
                        })

                        OptBtn.MouseButton1Click:Connect(function()
                            SelectedValue = opt
                            Selected.Text = tostring(opt)
                            for _, btn in pairs(DropFrame:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.TextColor3 = btn.Text == tostring(opt) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                                end
                            end
                            spawn(function() Linux:SafeCallback(config.Callback, opt) end)
                        end)
                    end
                end
                UpdateDropSize()
            end

            if #Options > 0 then
                PopulateOptions()
            end

            DropdownButton.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                PopulateOptions()
                if IsOpen then
                    elementOrder = elementOrder + 1
                end
            end)

            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValue = Options[1] or "None"
                Selected.Text = tostring(SelectedValue)
                PopulateOptions()
            end

            local function SetValue(value)
                if table.find(Options, value) then
                    SelectedValue = value
                    Selected.Text = tostring(value)
                    for _, btn in pairs(DropFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Text == tostring(value) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, value) end)
                end
            end

            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return SelectedValue end
            }
        end

        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            local Slider = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 1
            })

            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Size = UDim2.new(0, 100, 0, 6),
                Position = UDim2.new(1, -105, 0.5, -3),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })

            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 30, 1, 0),
                Position = UDim2.new(1, -145, 0, 0),
                Font = Enum.Font.Gotham,
                Text = "",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextYAlignment = Enum.TextYAlignment.Center,
                ZIndex = 1
            })

            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(0, 120, 255),
                Size = UDim2.new(0, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 1,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = FillBar,
                CornerRadius = UDim.new(1, 0)
            })

            local Knob = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 0, 0, -3),
                ZIndex = 2,
                BorderSizePixel = 0
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Value = Default

            local function AnimateValueLabel()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 16}):Play()
                task.wait(0.2)
                TweenService:Create(ValueLabel, tweenInfo, {TextSize = 14}):Play()
            end

            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                Value = Min + (Max - Min) * relativePos
                Value = math.floor(Value + 0.5)
                Knob.Position = UDim2.new(relativePos, -6, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                local percentage = math.floor((Value - Min) / (Max - Min) * 100 + 0.5)
                ValueLabel.Text = tostring(percentage) .. "%"
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            local draggingSlider = false

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)

            SliderBar.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)

            SliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)

            local function SetValue(newValue)
                newValue = math.clamp(newValue, Min, Max)
                Value = math.floor(newValue + 0.5)
                local relativePos = (Value - Min) / (Max - Min)
                Knob.Position = UDim2.new(relativePos, -6, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                local percentage = math.floor((Value - Min) / (Max - Min) * 100 + 0.5)
                ValueLabel.Text = tostring(percentage) .. "%"
                AnimateValueLabel()
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            SetValue(Default)

            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Value end
            }
        end

        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            local Input = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Input,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Size = UDim2.new(0.25, -10, 0, 24),
                Position = UDim2.new(1, -90, 0.5, -12),
                Font = Enum.Font.Gotham,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Text Here",
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = TextBox,
                CornerRadius = UDim.new(0, 4)
            })

            local MaxLength = 50

            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end

            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                CheckTextBounds()
            end)

            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    UpdateInput()
                end
            end)

            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                end
            end)

            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end

            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end

        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            local LabelFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = LabelFrame,
                CornerRadius = UDim.new(0, 4)
            })

            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Text or "Label",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            local UpdateConnection = nil
            local lastUpdate = 0
            local updateInterval = 0.1

            local function StartUpdateLoop()
                if UpdateConnection then
                    UpdateConnection:Disconnect()
                end
                if config.UpdateCallback then
                    UpdateConnection = RunService.Heartbeat:Connect(function()
                        if not LabelFrame:IsDescendantOf(game) then
                            UpdateConnection:Disconnect()
                            return
                        end
                        local currentTime = tick()
                        if currentTime - lastUpdate >= updateInterval then
                            local success, newText = pcall(config.UpdateCallback)
                            if success and newText ~= nil then
                                LabelText.Text = tostring(newText)
                            end
                            lastUpdate = currentTime
                        end
                    end)
                end
            end

            local function SetText(newText)
                if config.UpdateCallback then
                    config.Text = tostring(newText)
                else
                    LabelText.Text = tostring(newText)
                end
            end

            if config.UpdateCallback then
                StartUpdateLoop()
            end

            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end

        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            local Section = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -5, 0, 24),
                ZIndex = 1,
                LayoutOrder = elementOrder,
                BorderSizePixel = 0
            })

            Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSansBold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            return Section
        end

        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            local ParagraphFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = ParagraphFrame,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                Font = Enum.Font.GothamBold,
                Text = config.Title or "Paragraph",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Content = Linux.Instance("TextLabel", {
                Parent = ParagraphFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 0),
                Position = UDim2.new(0, 5, 0, 25),
                Font = Enum.Font.Gotham,
                Text = config.Content or "Content",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 1
            })

            Linux.Instance("UIPadding", {
                Parent = ParagraphFrame,
                PaddingBottom = UDim.new(0, 5)
            })

            local function SetTitle(newTitle)
                ParagraphFrame:GetChildren()[1].Text = tostring(newTitle)
            end

            local function SetContent(newContent)
                Content.Text = tostring(newContent)
            end

            return {
                Instance = ParagraphFrame,
                SetTitle = SetTitle,
                SetContent = SetContent
            }
        end

        function TabElements.Notification(config)
            elementOrder = elementOrder + 1
            local NotificationFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Color3.fromRGB(19, 19, 19),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 2,
                Size = UDim2.new(1, -5, 0, 34),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = NotificationFrame,
                CornerRadius = UDim.new(0, 4)
            })

            Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local NotificationText = Linux.Instance("TextLabel", {
                Parent = NotificationFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, -10, 1, 0),
                Position = UDim2.new(0.5, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Default or "Notification",
                TextColor3 = Color3.fromRGB(180, 180, 180),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            local function SetText(newText)
                NotificationText.Text = tostring(newText)
            end

            return {
                Instance = NotificationFrame,
                SetText = SetText,
                GetText = function() return NotificationText.Text end
            }
        end

        return TabElements
    end

    return LinuxLib
end

return Linux
