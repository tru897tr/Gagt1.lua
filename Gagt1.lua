-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local SpeedUpButton = Instance.new("TextButton")
local NoLagButton = Instance.new("TextButton")
local ToggleButton = Instance.new("TextButton")
local ToggleUICorner = Instance.new("UICorner")
local TweenService = game:GetService("TweenService")

-- Thiết lập ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Thiết lập Frame (bảng chính)
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.BackgroundTransparency = 0.1
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true

-- Thêm góc bo tròn cho Frame
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = Frame

-- Thêm hiệu ứng bóng
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(100, 100, 255)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame

-- Thiết lập Title
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.BackgroundTransparency = 0.5
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.TextStrokeTransparency = 0.8
Title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Thiết lập Speed Up Button
SpeedUpButton.Parent = Frame
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedUpButton.Position = UDim2.new(0.1, 0, 0.3, 0)
SpeedUpButton.Size = UDim2.new(0.8, 0, 0, 50)
SpeedUpButton.Text = "Speed Up X"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextSize = 18
SpeedUpButton.Font = Enum.Font.Gotham
SpeedUpButton.BackgroundTransparency = 0.2
local SpeedUpCorner = Instance.new("UICorner")
SpeedUpCorner.CornerRadius = UDim.new(0, 10)
SpeedUpCorner.Parent = SpeedUpButton

-- Thiết lập No Lag Button
NoLagButton.Parent = Frame
NoLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
NoLagButton.Position = UDim2.new(0.1, 0, 0.55, 0)
NoLagButton.Size = UDim2.new(0.8, 0, 0, 50)
NoLagButton.Text = "No Lag"
NoLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoLagButton.TextSize = 18
NoLagButton.Font = Enum.Font.Gotham
NoLagButton.BackgroundTransparency = 0.2
local NoLagCorner = Instance.new("UICorner")
NoLagCorner.CornerRadius = UDim.new(0, 10)
NoLagCorner.Parent = NoLagButton

-- Thiết lập Toggle Button (nút bật/tắt)
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.Position = UDim2.new(0.95, -30, 0.05, 0)
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleUICorner.CornerRadius = UDim.new(0.5, 0)
ToggleUICorner.Parent = ToggleButton

-- Hiệu ứng hover cho các nút
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

-- Hiệu ứng bật/tắt Frame
local function toggleFrame()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    if Frame.Visible then
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -1000)}):Play()
        wait(0.3)
        Frame.Visible = false
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        ToggleButton.Text = "O"
    else
        Frame.Visible = true
        TweenService:Create(Frame, tweenInfo, {Position = UDim2.new(0.5, -150, 0.5, -100)}):Play()
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ToggleButton.Text = "X"
    end
end

-- Chức năng khi nhấn nút Toggle
ToggleButton.MouseButton1Click:Connect(toggleFrame)

-- Chức năng khi nhấn nút Speed Up
SpeedUpButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

-- Chức năng khi nhấn nút No Lag
NoLagButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
end)

-- Hiệu ứng mở Frame lần đầu
Frame.Position = UDim2.new(0.5, -150, 0.5, -1000)
Frame.Visible = true
local openTween = TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -100)})
openTween:Play()