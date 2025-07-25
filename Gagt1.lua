-- Dịch vụ
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tạo Frame chính (bảng chọn hack)
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.BackgroundTransparency = 0.05
Frame.Active = true
Frame.Draggable = true
Frame.Visible = false -- Ẩn ban đầu, chờ loading

-- Bo góc Frame
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = Frame

-- Viền Frame
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 1
FrameStroke.Color = Color3.fromRGB(100, 100, 255)
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FrameStroke.Parent = Frame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.BackgroundTransparency = 0.3
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Hack Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextStrokeTransparency = 0.8
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Container cho các nút
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Parent = Frame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 0, 0, 45)
ButtonContainer.Size = UDim2.new(1, 0, 1, -45)
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Nút Speed Up
local SpeedUpButton = Instance.new("TextButton")
SpeedUpButton.Parent = ButtonContainer
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedUpButton.Size = UDim2.new(0.9, 0, 0, 45)
SpeedUpButton.Text = "Speed Up X"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextSize = 16
SpeedUpButton.Font = Enum.Font.Gotham
SpeedUpButton.BackgroundTransparency = 0.1
local SpeedUpCorner = Instance.new("UICorner")
SpeedUpCorner.CornerRadius = UDim.new(0, 8)
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
NoLagButton.Size = UDim2.new(0.9, 0, 0, 45)
NoLagButton.Text = "No Lag"
NoLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoLagButton.TextSize = 16
NoLagButton.Font = Enum.Font.Gotham
NoLagButton.BackgroundTransparency = 0.1
local NoLagCorner = Instance.new("UICorner")
NoLagCorner.CornerRadius = UDim.new(0, 8)
NoLagCorner.Parent = NoLagButton
local NoLagStroke = Instance.new("UIStroke")
NoLagStroke.Thickness = 1
NoLagStroke.Color = Color3.fromRGB(255, 255, 255)
NoLagStroke.Transparency = 0.8
NoLagStroke.Parent = NoLagButton

-- Nút bật/tắt (sát góc trên bên phải)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.Size = UDim2.new(0, 35, 0, 35)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Visible = false -- Ẩn ban đầu
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0)
ToggleCorner.Parent = ToggleButton
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Transparency = 0.8
ToggleStroke.Parent = ToggleButton

-- Frame loading (che toàn màn hình)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Parent = ScreenGui
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.3
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Visible = true
local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 0)
LoadingCorner.Parent = LoadingFrame
local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Thickness = 1
LoadingStroke.Color = Color3.fromRGB(100, 100, 255)
LoadingStroke.Transparency = 0.8
LoadingStroke.Parent = LoadingFrame

-- Loading Text
local LoadingText = Instance.new("TextLabel")
LoadingText.Parent = LoadingFrame
LoadingText.BackgroundTransparency = 1
LoadingText.Position = UDim2.new(0.5, -100, 0.4, 0)
LoadingText.Size = UDim2.new(0, 200, 0, 30)
LoadingText.Text = "Loading Hack Hub..."
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 18
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextWrapped = true

-- Progress Bar
local ProgressBarFrame = Instance.new("Frame")
ProgressBarFrame.Parent = LoadingFrame
ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBarFrame.Position = UDim2.new(0.5, -100, 0.5, 0)
ProgressBarFrame.Size = UDim2.new(0, 200, 0, 20)
local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(0, 5)
ProgressBarCorner.Parent = ProgressBarFrame
local ProgressBar = Instance.new("Frame")
ProgressBar.Parent = ProgressBarFrame
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
local ProgressBarCornerInner = Instance.new("UICorner")
ProgressBarCornerInner.CornerRadius = UDim.new(0, 5)
ProgressBarCornerInner.Parent = ProgressBar

-- Frame thông báo
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Parent = ScreenGui
NotificationFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NotificationFrame.Position = UDim2.new(0.5, -100, 0.85, 0)
NotificationFrame.Size = UDim2.new(0, 200, 0, 40)
NotificationFrame.BackgroundTransparency = 0.1
NotificationFrame.Visible = false
local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame
local NotificationText = Instance.new("TextLabel")
NotificationText.Parent = NotificationFrame
NotificationText.BackgroundTransparency = 1
NotificationText.Size = UDim2.new(1, 0, 1, 0)
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 12
NotificationText.Font = Enum.Font.Gotham
NotificationText.Text = ""
NotificationText.TextWrapped = true
local NotificationStroke = Instance.new("UIStroke")
NotificationStroke.Thickness = 1
NotificationStroke.Color = Color3.fromRGB(100, 100, 255)
NotificationStroke.Transparency = 0.8
NotificationStroke.Parent = NotificationFrame

-- Quản lý hàng đợi thông báo
local notificationQueue = {}
local isShowingNotification = false

local function showNotification(message, duration)
    table.insert(notificationQueue, {text = message, duration = duration or 2})
    if not isShowingNotification then
        isShowingNotification = true
        local function processQueue()
            while #notificationQueue > 0 do
                local notif = notificationQueue[1]
                NotificationText.Text = notif.text
                NotificationFrame.Visible = true
                local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.75, 0)})
                tweenIn:Play()
                tweenIn.Completed:Wait()
                wait(notif.duration)
                local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -100, 0.85, 0)})
                tweenOut:Play()
                tweenOut.Completed:Wait()
                NotificationFrame.Visible = false
                table.remove(notificationQueue, 1)
            end
            isShowingNotification = false
        end
        spawn(processQueue)
    end
end

-- Hiệu ứng hover cho nút
local function applyHoverEffect(button)
    local hoverTween, leaveTween
    button.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        if leaveTween then leaveTween:Cancel() end
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        hoverTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(0, 150, 255)})
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0}):Play()
        hoverTween:Play()
    end)
    button.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        if leaveTween then leaveTween:Cancel() end
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        leaveTween = TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(0, 120, 215)})
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0.8}):Play()
        leaveTween:Play()
    end)
end

applyHoverEffect(SpeedUpButton)
applyHoverEffect(NoLagButton)
applyHoverEffect(ToggleButton)

-- Hiệu ứng bật/tắt Frame
local currentTween = nil
local isToggling = false

local function toggleFrame()
    if isToggling then return end
    isToggling = true
    if currentTween then currentTween:Cancel() end
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if Frame.Visible then
        currentTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -1000)})
        currentTween:Play()
        currentTween.Completed:Connect(function()
            Frame.Visible = false
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            ToggleButton.Text = "O"
            showNotification("Hack Hub Hidden", 1.5)
            isToggling = false
        end)
    else
        Frame.Visible = true
        currentTween = TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -100)})
        currentTween:Play()
        currentTween.Completed:Connect(function()
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.Text = "X"
            showNotification("Hack Hub Shown", 1.5)
            isToggling = false
        end)
    end
end

-- Chức năng nút Toggle
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Hàm chạy progress bar
local function runProgressBar()
    local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
    local tween = TweenService:Create(ProgressBar, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    return tween
end

-- Hàm hiển thị và chạy loading
local function showLoading()
    LoadingFrame.Visible = true
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenIn = TweenService:Create(LoadingFrame, tweenInfo, {BackgroundTransparency = 0.3})
    tweenIn:Play()
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
        local openTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -100)})
        openTween:Play()
        showNotification("Welcome to Hack Hub!", 2)
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