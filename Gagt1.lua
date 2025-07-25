-- Dịch vụ
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tạo Frame chính
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

-- Bo góc Frame
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 15)
FrameCorner.Parent = Frame

-- Viền Frame
local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 2
FrameStroke.Color = Color3.fromRGB(100, 100, 255)
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FrameStroke.Parent = Frame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.4
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28
Title.Font = Enum.Font.GothamBold
Title.TextStrokeTransparency = 0.7
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Container cho các nút
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Parent = Frame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 0, 0, 60)
ButtonContainer.Size = UDim2.new(1, 0, 1, -60)

-- Layout cho các nút
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- Nút Speed Up
local SpeedUpButton = Instance.new("TextButton")
SpeedUpButton.Parent = ButtonContainer
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedUpButton.Size = UDim2.new(0.85, 0, 0, 60)
SpeedUpButton.Text = "Speed Up X"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextSize = 20
SpeedUpButton.Font = Enum.Font.Gotham
SpeedUpButton.BackgroundTransparency = 0.2
local SpeedUpCorner = Instance.new("UICorner")
SpeedUpCorner.CornerRadius = UDim.new(0, 10)
SpeedUpCorner.Parent = SpeedUpButton

-- Nút No Lag
local NoLagButton = Instance.new("TextButton")
NoLagButton.Parent = ButtonContainer
NoLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
NoLagButton.Size = UDim2.new(0.85, 0, 0, 60)
NoLagButton.Text = "No Lag"
NoLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoLagButton.TextSize = 20
NoLagButton.Font = Enum.Font.Gotham
NoLagButton.BackgroundTransparency = 0.2
local NoLagCorner = Instance.new("UICorner")
NoLagCorner.CornerRadius = UDim.new(0, 10)
NoLagCorner.Parent = NoLagButton

-- Nút bật/tắt
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(0.95, -40, 0.05, 10)
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.GothamBold
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0.5, 0)
ToggleCorner.Parent = ToggleButton

-- Frame thông báo
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Parent = ScreenGui
NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NotificationFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
NotificationFrame.Size = UDim2.new(0, 300, 0, 60)
NotificationFrame.BackgroundTransparency = 0.2
NotificationFrame.Visible = false
local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 10)
NotificationCorner.Parent = NotificationFrame
local NotificationText = Instance.new("TextLabel")
NotificationText.Parent = NotificationFrame
NotificationText.BackgroundTransparency = 1
NotificationText.Size = UDim2.new(1, 0, 1, 0)
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 16
NotificationText.Font = Enum.Font.Gotham
NotificationText.Text = ""
NotificationText.TextWrapped = true

-- Hàm hiển thị thông báo
local function showNotification(message, duration)
    NotificationText.Text = message
    NotificationFrame.Visible = true
    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.7, 0)})
    tweenIn:Play()
    wait(duration or 2)
    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -150, 0.8, 0)})
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
    end)
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(button, tweenInfo, {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
    end)
end

applyHoverEffect(SpeedUpButton)
applyHoverEffect(NoLagButton)
applyHoverEffect(ToggleButton)

-- Hiệu ứng bật/tắt Frame
local function toggleFrame()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if Frame.Visible then
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, -1000)}):Play()
        wait(0.3)
        Frame.Visible = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        ToggleButton.Text = "O"
        showNotification("Interface Hidden", 1.5)
    else
        Frame.Visible = true
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -200, 0.5, -150)}):Play()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "X"
        showNotification("Interface Shown", 1.5)
    end
end

-- Chức năng nút Toggle
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Chức năng nút Speed Up
SpeedUpButton.MouseButton1Click:Connect(function()
    showNotification("Loading Speed Up X Script...", 2)
    local success, error = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if success then
        showNotification("Speed Up X Script Loaded!", 2)
    else
        showNotification("Error: Failed to load Speed Up X Script", 3)
    end
end)

-- Chức năng nút No Lag
NoLagButton.MouseButton1Click:Connect(function()
    showNotification("Loading No Lag Script...", 2)
    local success, error = pcall(function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
    end)
    if success then
        showNotification("No Lag Script Loaded!", 2)
    else
        showNotification("Error: Failed to load No Lag Script", 3)
    end
end)

-- Hiệu ứng mở Frame lần đầu
Frame.Position = UDim2.new(0.5, -200, 0.5, -1000)
Frame.Visible = true
local openTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -200, 0.5, -150)})
openTween:Play()
showNotification("Welcome to Script Hub!", 2)