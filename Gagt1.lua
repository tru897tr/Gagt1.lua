-- Dịch vụ
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Kiểm tra và chạy script với pcall
local success, errorMessage = pcall(function()
    -- Tạo ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 5)
    if not ScreenGui.Parent then error("Failed to parent ScreenGui to PlayerGui") end
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    print("ScreenGui created and parented to PlayerGui")

    -- Tạo Frame chính (bảng chọn hack)
    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -125)
    Frame.Size = UDim2.new(0, 350, 0, 250)
    Frame.BackgroundTransparency = 0.05
    Frame.Active = true
    Frame.Draggable = true
    Frame.Visible = false
    Frame.ZIndex = 200
    print("Frame created")

    -- Bo góc Frame
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 12)
    FrameCorner.Parent = Frame

    -- Viền Frame
    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Thickness = 1.5
    FrameStroke.Color = Color3.fromRGB(100, 100, 255)
    FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FrameStroke.Parent = Frame

    -- Padding cho Frame
    local FramePadding = Instance.new("UIPadding")
    FramePadding.PaddingTop = UDim.new(0, 10)
    FramePadding.PaddingLeft = UDim.new(0, 10)
    FramePadding.PaddingRight = UDim.new(0, 10)
    FramePadding.Parent = Frame

    -- Tiêu đề
    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.BackgroundTransparency = 0.2
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "Hack Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.SourceSansPro
    Title.TextStrokeTransparency = 0.7
    Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    Title.ZIndex = 201

    -- Credit
    local Credit = Instance.new("TextLabel")
    Credit.Parent = Frame
    Credit.BackgroundTransparency = 1
    Credit.Position = UDim2.new(0, 0, 0, 45)
    Credit.Size = UDim2.new(1, -20, 0, 25)
    Credit.Text = "Created by Nguyễn Trứ"
    Credit.TextColor3 = Color3.fromRGB(150, 150, 255)
    Credit.TextSize = 14
    Credit.Font = Enum.Font.SourceSansPro
    Credit.TextTransparency = 0.1
    Credit.ZIndex = 201

    -- Container cho các nút
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Parent = Frame
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(0, 0, 0, 75)
    ButtonContainer.Size = UDim2.new(1, -20, 1, -85)
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ButtonContainer
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    ButtonContainer.ZIndex = 201

    -- Nút Speed Up
    local SpeedUpButton = Instance.new("TextButton")
    SpeedUpButton.Parent = ButtonContainer
    SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    SpeedUpButton.Size = UDim2.new(0.9, 0, 0, 50)
    SpeedUpButton.Text = "Speed Up X"
    SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedUpButton.TextSize = 18
    SpeedUpButton.Font = Enum.Font.SourceSansPro
    SpeedUpButton.BackgroundTransparency = 0.1
    SpeedUpButton.ZIndex = 201
    local SpeedUpCorner = Instance.new("UICorner")
    SpeedUpCorner.CornerRadius = UDim.new(0, 10)
    SpeedUpCorner.Parent = SpeedUpButton
    local SpeedUpStroke = Instance.new("UIStroke")
    SpeedUpStroke.Thickness = 1
    SpeedUpStroke.Color = Color3.fromRGB(255, 255, 255)
    SpeedUpStroke.Transparency = 0.8
    SpeedUpStroke.Parent = SpeedUpButton

    -- Nút No Lag
    local NoLagButton = Instance.new("TextButton")
    NoLagButton.Parent = ButtonContainer
    NoLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    NoLagButton.Size = UDim2.new(0.9, 0, 0, 50)
    NoLagButton.Text = "No Lag"
    NoLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoLagButton.TextSize = 18
    NoLagButton.Font = Enum.Font.SourceSansPro
    NoLagButton.BackgroundTransparency = 0.1
    NoLagButton.ZIndex = 201
    local NoLagCorner = Instance.new("UICorner")
    NoLagCorner.CornerRadius = UDim.new(0, 10)
    NoLagCorner.Parent = NoLagButton
    local NoLagStroke = Instance.new("UIStroke")
    NoLagStroke.Thickness = 1
    NoLagStroke.Color = Color3.fromRGB(255, 255, 255)
    NoLagStroke.Transparency = 0.8
    NoLagStroke.Parent = NoLagButton

    -- Nút đóng nhỏ trên Frame
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Frame
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.SourceSansPro
    CloseButton.ZIndex = 202
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0.5, 0)
    CloseCorner.Parent = CloseButton
    local CloseStroke = Instance.new("UIStroke")
    CloseStroke.Thickness = 1
    CloseStroke.Color = Color3.fromRGB(255, 255, 255)
    CloseStroke.Transparency = 0.8
    CloseStroke.Parent = CloseButton

    -- Bảng xác nhận
    local ConfirmFrame = Instance.new("Frame")
    ConfirmFrame.Parent = ScreenGui
    ConfirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ConfirmFrame.Position = UDim2.new(0.5, -125, 0, 5 -90)
    ConfirmFrame.Size = UDim2.new(0, 250, 0, 180)
    ConfirmFrame.BackgroundTransparency = 0.05
    ConfirmFrame.Visible = false
    ConfirmFrame.ZIndex = 300
    local ConfirmCorner = Instance.new("UICorner")
    ConfirmCorner.CornerRadius = UDim.new(0, 12)
    ConfirmCorner.Parent = ConfirmFrame
    local ConfirmStroke = Instance.new("UIStroke")
    ConfirmStroke.Thickness = 1.5
    ConfirmStroke.Color = Color3.fromRGB(100, 100, 255)
    ConfirmStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ConfirmStroke.Parent = ConfirmFrame

    -- Padding cho ConfirmFrame
    local ConfirmPadding = Instance.new("UIPadding")
    ConfirmPadding.PaddingTop = UDim.new(0, 10)
    ConfirmPadding.PaddingLeft = UDim.new(0, 10)
    ConfirmPadding.PaddingRight = UDim.new(0, 10)
    ConfirmPadding.Parent = ConfirmFrame

    -- Tiêu đề xác nhận
    local ConfirmTitle = Instance.new("TextLabel")
    ConfirmTitle.Parent = ConfirmFrame
    ConfirmTitle.BackgroundTransparency = 1
    ConfirmTitle.Position = UDim2.new(0, 0, 0, 0, 10)
    ConfirmTitle.Size = UDim2.new(1, -20, 0, 50)
    ConfirmTitle.Text = "Bạn có chắc muốn tắt script không?"
    ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmTitle.TextSize = 16
    ConfirmTitle.Font = Enum.Font.SourceSansPro
    ConfirmTitle.TextWrapped = true
    ConfirmTitle.ZIndex = 301

    -- Container cho nút xác nhận
    local ConfirmButtonContainer = Instance.new("Frame")
    ConfirmButtonContainer.Parent = ConfirmFrame
    ConfirmButtonContainer.BackgroundTransparency = 1
    ConfirmButtonContainer.Position = UDim2.new(0, 0, 0, 70)
    ConfirmButtonContainer.Size = UDim2.new(1, -20, 0, 80)
    ConfirmButtonContainer.ZIndex = 301
    local ConfirmListLayout = Instance.new("UIListLayout")
    ConfirmListLayout.Parent = ConfirmButtonContainer
    ConfirmListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ConfirmListLayout.Padding = UDim.new(0, 10)
    ConfirmListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ConfirmListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Nút "Có" (tắt script)
    local YesButton = Instance.new("TextButton")
    YesButton.Parent = ConfirmButtonContainer
    YesButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    YesButton.Size = UDim2.new(0.45, 0, 0, 40)
    YesButton.Text = "Có"
    YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    YesButton.TextSize = 16
    YesButton.Font = Enum.Font.SourceSansPro
    YesButton.BackgroundTransparency = 0.1
    YesButton.ZIndex = 301
    local YesCorner = Instance.new("UICorner")
    YesCorner.CornerRadius = UDim.new(0, 8)
    YesCorner.Parent = YesButton
    local YesStroke = Instance.new("UIStroke")
    YesStroke.Thickness = 1
    YesStroke.Color = Color3.fromRGB(255, 255, 255)
    YesStroke.Transparency = 0.8
    YesStroke.Parent = YesButton

    -- Nút "Không" (quay lại)
    local NoButton = Instance.new("TextButton")
    NoButton.Parent = ConfirmButtonContainer
    NoButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    NoButton.Size = UDim2.new(0.45, 0, 0, 40)
    NoButton.Text = "Không"
    NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    NoButton.TextSize = 16
    NoButton.Font = Enum.Font.SourceSansPro
    NoButton.BackgroundTransparency = 0.1
    NoButton.ZIndex = 301
    local NoCorner = Instance.new("UICorner")
    NoCorner.CornerRadius = UDim.new(0, 8)
    NoCorner.Parent = NoButton
    local NoStroke = Instance.new("UIStroke")
    NoStroke.Thickness = 1
    NoStroke.Color = Color3.fromRGB(255, 255, 255)
    NoStroke.Transparency = 0.8
    NoStroke.Parent = NoButton

    -- Nút bật/tắt (góc trên bên phải màn hình)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    ToggleButton.Position = UDim2.new(1, -45, 0, 10)
    ToggleButton.Size = UDim2.new(0, 40, 0, 40)
    ToggleButton.Text = "X"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 16
    ToggleButton.Font = Enum.Font.SourceSansPro
    ToggleButton.Visible = false
    ToggleButton.ZIndex = 500
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0.5, 0)
    ToggleCorner.Parent = ToggleButton
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Thickness = 1
    ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
    ToggleStroke.Transparency = 0.8
    ToggleStroke.Parent = ToggleButton
    print("ToggleButton created")

    -- Frame loading (che toàn màn hình)
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LoadingFrame.BackgroundTransparency = 0
    LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.Visible = true
    LoadingFrame.ZIndex = 1000
    LoadingFrame.AnchorPoint = Vector2.new(0, 0)
    LoadingFrame.ClipsDescendants = false
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 0)
    LoadingCorner.Parent = LoadingFrame
    local LoadingStroke = Instance.new("UIStroke")
    LoadingStroke.Thickness = 1.5
    LoadingStroke.Color = Color3.fromRGB(100, 100, 255)
    LoadingStroke.Transparency = 0.8
    LoadingStroke.Parent = LoadingFrame
    print("LoadingFrame created")

    -- Loading Text
    local LoadingText = Instance.new("TextLabel")
    LoadingText.Parent = LoadingFrame
    LoadingText.BackgroundTransparency = 1
    LoadingText.Position = UDim2.new(0.5, -125, 0.4, 0)
    LoadingText.Size = UDim2.new(0, 250, 0, 40)
    LoadingText.Text = "Loading Hack Hub..."
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 20
    LoadingText.Font = Enum.Font.SourceSansPro
    LoadingText.TextWrapped = true
    LoadingText.ZIndex = 1001

    -- Progress Bar
    local ProgressBarFrame = Instance.new("Frame")
    ProgressBarFrame.Parent = LoadingFrame
    ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ProgressBarFrame.Position = UDim2.new(0.5, -125, 0.5, 0)
    ProgressBarFrame.Size = UDim2.new(0, 250, 0, 25)
    ProgressBarFrame.ZIndex = 1001
    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(0, 6)
    ProgressBarCorner.Parent = ProgressBarFrame
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Parent = ProgressBarFrame
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.ZIndex = 1002
    local ProgressBarCornerInner = Instance.new("UICorner")
    ProgressBarCornerInner.CornerRadius = UDim.new(0, 6)
    ProgressBarCornerInner.Parent = ProgressBar

    -- Frame thông báo
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Parent = ScreenGui
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    NotificationFrame.Position = UDim2.new(0.5, -125, 0.85, 0)
    NotificationFrame.Size = UDim2.new(0, 250, 0, 50)
    NotificationFrame.BackgroundTransparency = 0.1
    NotificationFrame.Visible = false
    NotificationFrame.ZIndex = 400
    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 10)
    NotificationCorner.Parent = NotificationFrame
    local NotificationStroke = Instance.new("UIStroke")
    NotificationStroke.Thickness = 1.5
    NotificationStroke.Color = Color3.fromRGB(100, 100, 255)
    NotificationStroke.Transparency = 0.8
    NotificationStroke.Parent = NotificationFrame
    local NotificationPadding = Instance.new("UIPadding")
    NotificationPadding.PaddingLeft = UDim.new(0, 10)
    NotificationPadding.PaddingRight = UDim.new(0, 10)
    NotificationPadding.Parent = NotificationFrame
    local NotificationText = Instance.new("TextLabel")
    NotificationText.Parent = NotificationFrame
    NotificationText.BackgroundTransparency = 1
    NotificationText.Size = UDim2.new(1, -20, 1, 0)
    NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotificationText.TextSize = 14
    NotificationText.Font = Enum.Font.SourceSansPro
    NotificationText.Text = ""
    NotificationText.TextWrapped = true
    NotificationText.ZIndex = 401

    -- Quản lý hàng đợi thông báo
    local notificationQueue = {}
    local isShowingNotification = false
    local lastNotification = nil

    local function showNotification(message, duration)
        if lastNotification == message then return end
        lastNotification = message
        if #notificationQueue >= 3 then
            table.remove(notificationQueue, 1)
        end
        table.insert(notificationQueue, {text = message, duration = duration or 2})
        if not isShowingNotification then
            isShowingNotification = true
            local function processQueue()
                while #notificationQueue > 0 do
                    local notif = notificationQueue[1]
                    NotificationText.Text = notif.text
                    NotificationFrame.Visible = true
                    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0.75, 0)})
                    tweenIn:Play()
                    tweenIn.Completed:Wait()
                    wait(notif.duration)
                    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0.85, 0)})
                    tweenOut:Play()
                    tweenOut.Completed:Wait()
                    NotificationFrame.Visible = false
                    table.remove(notificationQueue, 1)
                    lastNotification = nil
                end
                isShowingNotification = false
            end
            spawn(processQueue)
        end
    end

    -- Hiệu ứng hover cho nút
    local function applyHoverEffect(button)
        local isHovering = false
        button.MouseEnter:Connect(function()
            if isHovering then return end
            isHovering = true
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local hoverTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
            TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0}):Play()
            hoverTween:Play()
            hoverTween.Completed:Connect(function() isHovering = false end)
        end)
        button.MouseLeave:Connect(function()
            if isHovering then return end
            isHovering = true
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            local leaveTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(0, 120, 215)})
            TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0.8}):Play()
            leaveTween:Play()
            leaveTween.Completed:Connect(function() isHovering = false end)
        end)
    end

    applyHoverEffect(SpeedUpButton)
    applyHoverEffect(NoLagButton)
    applyHoverEffect(ToggleButton)
    applyHoverEffect(CloseButton)
    applyHoverEffect(YesButton)
    applyHoverEffect(NoButton)

    -- Hiệu ứng bật/tắt Frame
    local currentTween = nil
    local isToggling = false

    local function toggleFrame()
        if isToggling then return end
        isToggling = true
        if currentTween then currentTween:Cancel() end
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        if Frame.Visible then
            currentTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -175, 0.5, -1000)})
            currentTween:Play()
            currentTween.Completed:Connect(function()
                Frame.Visible = false
                ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                ToggleButton.Text = "O"
                showNotification("Hack Hub Hidden", 1.5)
                isToggling = false
                print("Frame hidden")
            end)
        else
            Frame.Visible = true
            Frame.Position = UDim2.new(0.5, -175, 0.5, -1000)
            currentTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -175, 0.5, -125)})
            currentTween:Play()
            currentTween.Completed:Connect(function()
                ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                ToggleButton.Text = "X"
                showNotification("Hack Hub Shown", 1.5)
                isToggling = false
                print("Frame shown")
            end)
        end
    end

    -- Chức năng nút Toggle
    ToggleButton.MouseButton1Click:Connect(toggleFrame)

    -- Chức năng nút Close (hiện bảng xác nhận)
    CloseButton.MouseButton1Click:Connect(function()
        ConfirmFrame.Visible = true
        Frame.Visible = false
        print("ConfirmFrame shown")
    end)

    -- Chức năng nút Yes (tắt script)
    YesButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        print("Script destroyed")
    end)

    -- Chức năng nút No (quay lại)
    NoButton.MouseButton1Click:Connect(function()
        ConfirmFrame.Visible = false
        Frame.Visible = true
        print("ConfirmFrame hidden, Frame shown")
    end)

    -- Hàm chạy progress bar
    local function runProgressBar()
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        local tween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
        tween:Play()
        return tween
    end

    -- Hàm hiển thị loading
    local function showLoading()
        LoadingFrame.Visible = true
        LoadingFrame.BackgroundTransparency = 0
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        print("LoadingFrame shown")
        return runProgressBar()
    end

    -- Hàm ẩn loading và hiện bảng hack
    local function hideLoading()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tweenOut = TweenService:Create(LoadingFrame, tweenInfo, {BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            LoadingFrame.Visible = false
            Frame.Visible = true
            ToggleButton.Visible = true
            Frame.Position = UDim2.new(0.5, -175, 0.5, -1000)
            local openTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -175, 0.5, -125)})
            openTween:Play()
            openTween.Completed:Connect(function()
                showNotification("Welcome to Hack Hub!", 2)
                print("LoadingFrame hidden, Frame and ToggleButton shown")
            end)
        end)
    end

    -- Hàm chạy script với kiểm tra lỗi và thử lại
    local function runScript(url, scriptName)
        showNotification("Loading " .. scriptName .. "...", 2)
        local maxRetries = 2
        local retryDelay = 1
        local success, result
        for attempt = 1, maxRetries do
            success, result = pcall(function()
                local scriptContent = game:HttpGet(url, true)
                if scriptContent and scriptContent ~= "" then
                    return loadstring(scriptContent)()
                else
                    error("Failed to fetch script content")
                end
            end)
            if success then
                break
            else
                showNotification("Retry " .. attempt .. ": Failed to load " .. scriptName .. ": " .. tostring(result), 2)
                wait(retryDelay)
            end
        end
        if success then
            showNotification(scriptName .. " Loaded!", 2)
        else
            showNotification("Error: Failed to load " .. scriptName .. " after " .. maxRetries .. " attempts: " .. tostring(result), 3)
        end
    end

    -- Chức năng nút Speed Up
    SpeedUpButton.MouseButton1Click:Connect(function()
        runScript("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", "Speed Up X Script")
    end)

    -- Chức năng nút No Lag
    NoLagButton.MouseButton1Click:Connect(function()
        runScript("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua", "No Lag Script")
    end)

    -- Khởi động loading
    showLoading()
    local progressTween = runProgressBar()
    wait(5)
    progressTween:Cancel()
    hideLoading()
end)

-- Kiểm tra lỗi khởi tạo
if not success then
    warn("Script failed to initialize: " .. tostring(errorMessage))
end