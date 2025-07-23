-- LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- GUI Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowGardenMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Menu Frame (Larger Rectangle)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300) -- Larger rectangle
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Default: Dark theme
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -40)
sidebar.Position = UDim2.new(0, 10, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebar.BorderSizePixel = 0
sidebar.Parent = frame
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Grow a Garden"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Content Frame (Main Area)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 270, 1, -70)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Sidebar Buttons
local homeButton = Instance.new("TextButton")
homeButton.Size = UDim2.new(1, -10, 0, 40)
homeButton.Position = UDim2.new(0, 5, 0, 5)
homeButton.Text = "Trang chủ"
homeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.Font = Enum.Font.Gotham
homeButton.TextSize = 14
homeButton.Parent = sidebar
local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 6)
homeCorner.Parent = homeButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(1, -10, 0, 40)
settingsButton.Position = UDim2.new(0, 5, 0, 50)
settingsButton.Text = "Cài đặt"
settingsButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.Font = Enum.Font.Gotham
settingsButton.TextSize = 14
settingsButton.Parent = sidebar
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsButton

-- Content: Home (Main Page)
local homeContent = Instance.new("Frame")
homeContent.Size = UDim2.new(1, 0, 1, 0)
homeContent.BackgroundTransparency = 1
homeContent.Parent = contentFrame
homeContent.Visible = true

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 220, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.Text = "Speed Up"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 16
speedButton.Parent = homeContent
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 220, 0, 40)
closeButton.Position = UDim2.new(0, 10, 0, 60)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 16
closeButton.Parent = homeContent
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Content: Settings
local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.Parent = contentFrame
settingsContent.Visible = false

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(0, 220, 0, 30)
themeLabel.Position = UDim2.new(0, 10, 0, 10)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Chọn chủ đề:"
themeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
themeLabel.TextScaled = true
themeLabel.Font = Enum.Font.Gotham
themeLabel.Parent = settingsContent

local themes = {
    {Name = "Sáng", Color = Color3.fromRGB(200, 200, 200), TextColor = Color3.fromRGB(0, 0, 0)},
    {Name = "Tối", Color = Color3.fromRGB(30, 30, 30), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Đỏ", Color = Color3.fromRGB(100, 0, 0), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Vàng", Color = Color3.fromRGB(200, 200, 0), TextColor = Color3.fromRGB(0, 0, 0)}
}

for i, theme in ipairs(themes) do
    local themeButton = Instance.new("TextButton")
    themeButton.Size = UDim2.new(0, 220, 0, 30)
    themeButton.Position = UDim2.new(0, 10, 0, 40 + (i-1)*35)
    themeButton.Text = theme.Name
    themeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeButton.Font = Enum.Font.Gotham
    themeButton.TextSize = 14
    themeButton.Parent = settingsContent
    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0, 6)
    themeCorner.Parent = themeButton

    themeButton.MouseButton1Click:Connect(function()
        frame.BackgroundColor3 = theme.Color
        sidebar.BackgroundColor3 = Color3.new(theme.Color.R * 1.2, theme.Color.G * 1.2, theme.Color.B * 1.2)
        title.TextColor3 = theme.TextColor
        themeLabel.TextColor3 = theme.TextColor
    end)
end

-- Credit Label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 1, -30)
credit.BackgroundTransparency = 1
credit.Text = "Credit: Nguyễn Thanh Trứ"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.TextScaled = true
credit.Font = Enum.Font.Gotham
credit.TextSize = 14
credit.Parent = frame

-- Toggle Button (Checkbox) outside Frame
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = ""
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton

-- Menu Visibility
local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    toggleButton.BackgroundColor3 = menuVisible and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
end

-- Sidebar Navigation
local function showHome()
    homeContent.Visible = true
    settingsContent.Visible = false
    homeButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    settingsButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end

local function showSettings()
    homeContent.Visible = false
    settingsContent.Visible = true
    homeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    settingsButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
end

homeButton.MouseButton1Click:Connect(showHome)
settingsButton.MouseButton1Click:Connect(showSettings)

-- Input Handling (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- Speed Button Logic
speedButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if not success then
        warn("Error executing Speed Hub X: ", err)
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(0, 220, 0, 30)
        errorLabel.Position = UDim2.new(0, 10, 0, 110)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Error: Check console"
        errorLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
        errorLabel.TextScaled = true
        errorLabel.Parent = homeContent
        game:GetService("Debris"):AddItem(errorLabel, 3)
    end
end)

-- Close Button Logic
closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- Toggle Button Logic
toggleButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- Hover Effects for Buttons
local function addHoverEffect(button)
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.new(
            originalColor.R * 0.8,
            originalColor.G * 0.8,
            originalColor.B * 0.8
        )
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end

addHoverEffect(speedButton)
addHoverEffect(closeButton)
addHoverEffect(toggleButton)
addHoverEffect(homeButton)
addHoverEffect(settingsButton)
for _, button in ipairs(settingsContent:GetChildren()) do
    if button:IsA("TextButton") then
        addHoverEffect(button)
    end
end
