-- Dịch vụ
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tạo Frame chính
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.BackgroundTransparency = 0.05
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

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
ToggleButton.Position = UDim2.new(1, -45, 0, 5)
ToggleButton.Size = UDim2.new(0, 35, 0, 35)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0)
ToggleCorner.Parent = ToggleButton
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Thickness = 1
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Transparency = 0.8
ToggleStroke.Parent = ToggleButton

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

-- Hàm hiển thị thông báo
local function showNotification(message, duration)
    NotificationText.Text = message
    NotificationFrame.Visible = true
    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -100, 0.75, 0)})
    tweenIn:Play()
    wait(duration or 2)
    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -100, 0.85, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        NotificationFrame.Visible = false
    end)
end

-- Hiệu ứng hover cho nút
local function applyHoverEffect(button)
    button.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0}):Play()
    end)
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
        TweenService:Create(button:FindFirstChildOfClass("UIStroke"), tweenInfo, {Transparency = 0.8}):Play()
    end)
end

applyHoverEffect(SpeedUpButton)
applyHoverEffect(NoLagButton)
applyHoverEffect(ToggleButton)

-- Hiệu ứng bật/tắt Frame
local function toggleFrame()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if Frame.Visible then
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -1000)}):Play()
        wait(0.3)
        Frame.Visible = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        ToggleButton.Text = "O"
        showNotification("Hack Hub Hidden", 1.5)
    else
        Frame.Visible = true
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -100)}):Play()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "X"
        showNotification("Hack Hub Shown", 1.5)
    end
end

-- Chức năng nút Toggle
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Hàm chạy script với kiểm tra lỗi
local function runScript(url, scriptName)
    showNotification("Loading " .. scriptName .. "...", 2)
    local success, result = pcall(function()
        local scriptContent = game:HttpGet(url, true)
        if scriptContent then
            return loadstring(scriptContent)()
        else
            error("Failed to fetch script content")
        end
    end)
    if success then
        showNotification(scriptName .. " Loaded!", 2)
    else
        showNotification("Error: Failed to load " .. scriptName .. ": " .. tostring(result), 3)
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

-- Hiệu ứng mở Frame lần đầu
Frame.Position = UDim2.new(0.5, -150, 0.5, -1000)
Frame.Visible = true
local openTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -100)})
openTween:Play()
showNotification("Welcome to Hack Hub!", 2)