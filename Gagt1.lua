-- LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- GUI Setup
local player = Players.LocalPlayer
local playerGui
local attempts = 0
local maxAttempts = 30
while not playerGui and attempts < maxAttempts do
    playerGui = player:WaitForChild("PlayerGui", 2)
    attempts = attempts + 1
    if not playerGui then
        warn("PlayerGui not found, attempt " .. attempts .. "/" .. maxAttempts)
        task.wait(1)
    end
end
if not playerGui then
    warn("Failed to find PlayerGui after " .. maxAttempts .. " attempts")
    return
end
print("PlayerGui found after " .. attempts .. " attempts")

if not player.Character then
    player.CharacterAdded:Wait()
    print("Character loaded")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowGardenMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
print("ScreenGui created")

-- Loading Frame (Black Screen with Progress Bar)
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.2
LoadingFrame.ZIndex = 20
LoadingFrame.Parent = screenGui
local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = LoadingFrame
local loadingStroke = Instance.new("UIStroke")
loadingStroke.Thickness = 2
loadingStroke.Color = Color3.fromRGB(255, 255, 255)
loadingStroke.Transparency = 0.5
loadingStroke.Parent = LoadingFrame

local ProgressBarFrame = Instance.new("Frame")
ProgressBarFrame.Size = UDim2.new(0, 200, 0, 20)
ProgressBarFrame.Position = UDim2.new(0.5, -100, 0.5, 0)
ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBarFrame.BackgroundTransparency = 0.4
ProgressBarFrame.ZIndex = 21
ProgressBarFrame.Parent = LoadingFrame
local ProgressBarFrameCorner = Instance.new("UICorner")
ProgressBarFrameCorner.CornerRadius = UDim.new(0, 6)
ProgressBarFrameCorner.Parent = ProgressBarFrame
local ProgressBarFrameStroke = Instance.new("UIStroke")
ProgressBarFrameStroke.Thickness = 1
ProgressBarFrameStroke.Color = Color3.fromRGB(255, 255, 255)
ProgressBarFrameStroke.Transparency = 0.5
ProgressBarFrameStroke.Parent = ProgressBarFrame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ProgressBar.ZIndex = 22
ProgressBar.Parent = ProgressBarFrame
local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(0, 6)
ProgressBarCorner.Parent = ProgressBar

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(0, 200, 0, 20)
LoadingLabel.Position = UDim2.new(0.5, -100, 0.5, -30)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Loading..."
LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingLabel.TextSize = 14
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.ZIndex = 21
LoadingLabel.Parent = LoadingFrame

-- Notification Frame (Bottom-Right)
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 190, 0, 20)
notificationFrame.Position = UDim2.new(1, -200, 1, -40)
notificationFrame.BackgroundTransparency = 1
notificationFrame.ZIndex = 15
notificationFrame.Parent = screenGui

local function showNotification(message, color)
    local notificationLabel = Instance.new("TextLabel")
    notificationLabel.Size = UDim2.new(1, 0, 1, 0)
    notificationLabel.BackgroundTransparency = 1
    notificationLabel.Text = message
    notificationLabel.TextColor3 = color
    notificationLabel.TextSize = 12
    notificationLabel.Font = Enum.Font.Gotham
    notificationLabel.TextXAlignment = Enum.TextXAlignment.Right
    notificationLabel.ZIndex = 15
    notificationLabel.Parent = notificationFrame
    game:GetService("Debris"):AddItem(notificationLabel, 3)
    print("Notification: " .. message)
end

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 240)
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 1
frame.Visible = false
frame.ZIndex = 10
frame.Active = true
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 1.5
frameStroke.Color = Color3.fromRGB(255, 255, 255)
frameStroke.Transparency = 0.7
frameStroke.Parent = frame
print("Frame created at: " .. tostring(frame.Position))

-- Drag Area
local DragArea = Instance.new("Frame")
DragArea.Size = UDim2.new(1, 0, 1, 0)
DragArea.BackgroundTransparency = 1
DragArea.ZIndex = 9 -- Below other elements
DragArea.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.9, -20, 0, 24)
title.Position = UDim2.new(0.05, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Grow a Garden"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = frame

-- Close Button (X)
local closeXButton = Instance.new("TextButton")
closeXButton.Size = UDim2.new(0, 20, 0, 20)
closeXButton.Position = UDim2.new(1, -28, 0, 8)
closeXButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeXButton.BackgroundTransparency = 0.4
closeXButton.Text = "X"
closeXButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeXButton.Font = Enum.Font.GothamBold
closeXButton.TextSize = 12
closeXButton.ZIndex = 13
closeXButton.Parent = frame
local closeXCorner = Instance.new("UICorner")
closeXCorner.CornerRadius = UDim.new(0, 6)
closeXCorner.Parent = closeXButton

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BackgroundTransparency = 0.6
sidebar.ZIndex = 10
sidebar.Parent = frame
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 240, 1, -60)
contentFrame.Position = UDim2.new(0, 96, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 10
contentFrame.Parent = frame

-- Sidebar Buttons
local homeButton = Instance.new("TextButton")
homeButton.Size = UDim2.new(1, -10, 0, 32)
homeButton.Position = UDim2.new(0, 5, 0, 5)
homeButton.Text = "Home"
homeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
homeButton.BackgroundTransparency = 0.3
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.Font = Enum.Font.Gotham
homeButton.TextSize = 14
homeButton.ZIndex = 11
homeButton.Parent = sidebar
local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 6)
homeCorner.Parent = homeButton
local homeStroke = Instance.new("UIStroke")
homeStroke.Thickness = 1
homeStroke.Color = Color3.fromRGB(255, 255, 255)
homeStroke.Transparency = 0.5
homeStroke.Parent = homeButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(1, -10, 0, 32)
settingsButton.Position = UDim2.new(0, 5, 0, 42)
settingsButton.Text = "Settings"
settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsButton.BackgroundTransparency = 0.4
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.Font = Enum.Font.Gotham
settingsButton.TextSize = 14
settingsButton.ZIndex = 11
settingsButton.Parent = sidebar
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsButton
local settingsStroke = Instance.new("UIStroke")
settingsStroke.Thickness = 1
settingsStroke.Color = Color3.fromRGB(255, 255, 255)
settingsStroke.Transparency = 1
settingsStroke.Parent = settingsButton

local musicButton = Instance.new("TextButton")
musicButton.Size = UDim2.new(1, -10, 0, 32)
musicButton.Position = UDim2.new(0, 5, 0, 79)
musicButton.Text = "Misic"
musicButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
musicButton.BackgroundTransparency = 0.4
musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
musicButton.Font = Enum.Font.Gotham
musicButton.TextSize = 14
musicButton.ZIndex = 11
musicButton.Parent = sidebar
local musicCorner = Instance.new("UICorner")
musicCorner.CornerRadius = UDim.new(0, 6)
musicCorner.Parent = musicButton
local musicStroke = Instance.new("UIStroke")
musicStroke.Thickness = 1
musicStroke.Color = Color3.fromRGB(255, 255, 255)
musicStroke.Transparency = 1
musicStroke.Parent = musicButton

-- Content: Home
local homeContent = Instance.new("Frame")
homeContent.Size = UDim2.new(1, 0, 1, 0)
homeContent.BackgroundTransparency = 1
homeContent.ZIndex = 10
homeContent.Parent = contentFrame
homeContent.Visible = true

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 190, 0, 32)
speedButton.Position = UDim2.new(0, 25, 0, 20)
speedButton.Text = "Speed Up X"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
speedButton.BackgroundTransparency = 0.4
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 14
speedButton.ZIndex = 11
speedButton.Parent = homeContent
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

local noLagButton = Instance.new("TextButton")
noLagButton.Size = UDim2.new(0, 190, 0, 32)
noLagButton.Position = UDim2.new(0, 25, 0, 58)
noLagButton.Text = "No Lag"
noLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
noLagButton.BackgroundTransparency = 0.4
noLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagButton.Font = Enum.Font.Gotham
noLagButton.TextSize = 14
noLagButton.ZIndex = 11
noLagButton.Parent = homeContent
local noLagCorner = Instance.new("UICorner")
noLagCorner.CornerRadius = UDim.new(0, 8)
noLagCorner.Parent = noLagButton

-- Content: Settings
local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.ZIndex = 10
settingsContent.Parent = contentFrame
settingsContent.Visible = false

-- Content: Misic (Speed Control)
local musicContent = Instance.new("Frame")
musicContent.Size = UDim2.new(1, 0, 1, 0)
musicContent.BackgroundTransparency = 1
musicContent.ZIndex = 10
musicContent.Parent = contentFrame
musicContent.Visible = false

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 30)
speedInput.Position = UDim2.new(0, 25, 0, 20)
speedInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedInput.BackgroundTransparency = 0.4
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.PlaceholderText = "Enter speed (16-100)"
speedInput.ZIndex = 11
speedInput.Parent = musicContent
local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 6)
speedInputCorner.Parent = speedInput

local applySpeedButton = Instance.new("TextButton")
applySpeedButton.Size = UDim2.new(0, 80, 0, 30)
applySpeedButton.Position = UDim2.new(0, 135, 0, 20)
applySpeedButton.Text = "Apply"
applySpeedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
applySpeedButton.BackgroundTransparency = 0.4
applySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedButton.Font = Enum.Font.Gotham
applySpeedButton.TextSize = 14
applySpeedButton.ZIndex = 11
applySpeedButton.Parent = musicContent
local applySpeedCorner = Instance.new("UICorner")
applySpeedCorner.CornerRadius = UDim.new(0, 6)
applySpeedCorner.Parent = applySpeedButton

-- Theme Selection
local currentTheme = "Tối"
local themes = {
    {Name = "Sáng", Color = Color3.fromRGB(220, 220, 220), TextColor = Color3.fromRGB(0, 0, 0)},
    {Name = "Tối", Color = Color3.fromRGB(20, 20, 20), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Xanh", Color = Color3.fromRGB(0, 80, 120), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Tím", Color = Color3.fromRGB(80, 0, 120), TextColor = Color3.fromRGB(255, 255, 255)}
}

-- Load saved theme from gag.js
local function loadTheme()
    if isfile and isfile("gag.js") then
        local success, result = pcall(function()
            local loaded = loadfile("gag.js")
            if loaded then
                local data = loaded()
                return data and data.theme
            end
        end)
        if success and result then
            for _, theme in ipairs(themes) do
                if theme.Name == result then
                    currentTheme = theme.Name
                    frame.BackgroundColor3 = theme.Color
                    sidebar.BackgroundColor3 = Color3.new(theme.Color.R * 1.1, theme.Color.G * 1.1, theme.Color.B * 1.1)
                    title.TextColor3 = theme.TextColor
                    closeXButton.TextColor3 = theme.TextColor
                    credit.TextColor3 = theme.TextColor
                    print("Loaded theme from gag.js: " .. result)
                    return
                end
            end
            warn("Invalid theme in gag.js: " .. tostring(result))
        else
            warn("Failed to load gag.js: " .. tostring(result))
        end
    else
        print("No gag.js found, using default theme: Tối")
    end
end

-- Save theme to gag.js
local function saveTheme()
    if writefile then
        local success, err = pcall(function()
            writefile("gag.js", "return { theme = \"" .. currentTheme .. "\" }")
        end)
        if success then
            print("Saved theme to gag.js: " .. currentTheme)
        else
            warn("Failed to save gag.js: " .. tostring(err))
            showNotification("Failed to save theme!", Color3.fromRGB(255, 80, 80))
        end
    else
        warn("Executor does not support writefile")
        showNotification("Theme saving not supported!", Color3.fromRGB(255, 80, 80))
    end
end

-- Load theme on startup
loadTheme()

local themeButton = Instance.new("TextButton")
themeButton.Size = UDim2.new(0, 190, 0, 30)
themeButton.Position = UDim2.new(0, 25, 0, 20)
themeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
themeButton.BackgroundTransparency = 0.4
themeButton.Text = "Theme: " .. currentTheme
themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
themeButton.Font = Enum.Font.Gotham
themeButton.TextSize = 14
themeButton.ZIndex = 11
themeButton.Parent = settingsContent
local themeButtonCorner = Instance.new("UICorner")
themeButtonCorner.CornerRadius = UDim.new(0, 6)
themeButtonCorner.Parent = themeButton

-- Theme Dropdown
local themeDropdown = Instance.new("Frame")
themeDropdown.Size = UDim2.new(0, 100, 0, 96)
themeDropdown.Position = UDim2.new(0, 25, 0, 54)
themeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
themeDropdown.BackgroundTransparency = 0.5
themeDropdown.Visible = false
themeDropdown.ZIndex = 12
themeDropdown.Parent = settingsContent
local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = themeDropdown

for i, theme in ipairs(themes) do
    local optionButton = Instance.new("TextButton")
    optionButton.Size = UDim2.new(1, -10, 0, 22)
    optionButton.Position = UDim2.new(0, 5, 0, 4 + (i-1)*24)
    optionButton.Text = theme.Name
    optionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    optionButton.BackgroundTransparency = 0.5
    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton.Font = Enum.Font.Gotham
    optionButton.TextSize = 12
    optionButton.ZIndex = 13
    optionButton.Parent = themeDropdown
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 4)
    optionCorner.Parent = optionButton

    optionButton.MouseButton1Click:Connect(function()
        currentTheme = theme.Name
        themeButton.Text = "Theme: " .. currentTheme
        local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            themeDropdown.Visible = false
            themeDropdown.Size = UDim2.new(0, 100, 0, 96)
        end)
        frame.BackgroundColor3 = theme.Color
        sidebar.BackgroundColor3 = Color3.new(theme.Color.R * 1.1, theme.Color.G * 1.1, theme.Color.B * 1.1)
        title.TextColor3 = theme.TextColor
        themeButton.TextColor3 = theme.TextColor
        closeXButton.TextColor3 = theme.TextColor
        credit.TextColor3 = theme.TextColor
        homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        print("Theme changed to: " .. theme.Name)
        saveTheme()
        showNotification("Theme saved: " .. theme.Name, Color3.fromRGB(0, 200, 100))
    end)
end

themeButton.MouseButton1Click:Connect(function()
    if themeDropdown.Visible then
        local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            themeDropdown.Visible = false
            themeDropdown.Size = UDim2.new(0, 100, 0, 96)
        end)
    else
        themeDropdown.Visible = true
        local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 96)})
        tween:Play()
    end
    print("Theme dropdown toggled: " .. tostring(themeDropdown.Visible))
end)

-- Credit Label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 120, 0, 14)
credit.Position = UDim2.new(1, -128, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "By Nguyễn Thanh Trứ"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.TextSize = 10
credit.Font = Enum.Font.Gotham
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.ZIndex = 11
credit.Parent = frame
print("Credit added at: " .. tostring(credit.Position))

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 26, 0, 26)
toggleButton.Position = UDim2.new(1, -36, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.BackgroundTransparency = 0.3
toggleButton.Text = ""
toggleButton.ZIndex = 11
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 13)
toggleCorner.Parent = toggleButton

-- Menu Visibility
local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    if menuVisible then
        frame.Visible = true
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
        tween:Play()
    else
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function()
            frame.Visible = false
        end)
    end
    toggleButton.BackgroundColor3 = menuVisible and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 200, 200)
    print("Menu toggled: " .. tostring(menuVisible))
end

-- Sidebar Navigation
local function showHome()
    homeContent.Visible = true
    settingsContent.Visible = false
    musicContent.Visible = false
    local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 0.3
    })
    local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
    local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    tween1:Play()
    tween2:Play()
    tween3:Play()
    strokeTween1:Play()
    strokeTween2:Play()
    strokeTween3:Play()
    homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeDropdown.Visible = false
    print("Home selected")
end

local function showSettings()
    homeContent.Visible = false
    settingsContent.Visible = true
    musicContent.Visible = false
    local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 0.3
    })
    local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
    local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    tween1:Play()
    tween2:Play()
    tween3:Play()
    strokeTween1:Play()
    strokeTween2:Play()
    strokeTween3:Play()
    homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeDropdown.Visible = false
    print("Settings selected")
end

local function showMusic()
    homeContent.Visible = false
    settingsContent.Visible = false
    musicContent.Visible = true
    local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BackgroundTransparency = 0.4
    })
    local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 0.3
    })
    local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
    local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
    tween1:Play()
    tween2:Play()
    tween3:Play()
    strokeTween1:Play()
    strokeTween2:Play()
    strokeTween3:Play()
    homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    themeDropdown.Visible = false
    print("Misic selected")
end

homeButton.MouseButton1Click:Connect(showHome)
settingsButton.MouseButton1Click:Connect(showSettings)
musicButton.MouseButton1Click:Connect(showMusic)

-- Dragging Logic (Only on DragArea)
local isDragging = false
local offset = Vector2.new(0, 0)

DragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if frame.Visible and frame.Parent then
            isDragging = true
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local framePos = frame.AbsolutePosition
            offset = mousePos - framePos
            print("Drag started at mouse: " .. tostring(mousePos) .. ", frame: " .. tostring(framePos) .. ", offset: " .. tostring(offset))
        else
            warn("Drag failed: Frame not visible or missing")
        end
    end
end)

DragArea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        print("Drag ended")
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        if frame and frame.Parent then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local viewportSize = workspace.CurrentCamera.ViewportSize
            local frameSize = frame.AbsoluteSize
            local newPosX = math.clamp(mousePos.X - offset.X, 0, math.max(0, viewportSize.X - frameSize.X))
            local newPosY = math.clamp(mousePos.Y - offset.Y, 0, math.max(0, viewportSize.Y - frameSize.Y))
            frame.Position = UDim2.new(0, newPosX, 0, newPosY)
            print("Frame moved to: " .. tostring(frame.Position) .. ", mouse: " .. tostring(mousePos) .. ", viewport: " .. tostring(viewportSize) .. ", frameSize: " .. tostring(frameSize))
        else
            isDragging = false
            warn("Drag stopped: Frame missing")
        end
    end
end)

-- Speed Control Logic
applySpeedButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local speed = tonumber(speedInput.Text)
        if not speed then
            error("Invalid speed input: " .. speedInput.Text)
        end
        if speed < 16 or speed > 100 then
            error("Speed must be between 16 and 100")
        end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            error("Humanoid not found")
        end
        humanoid.WalkSpeed = speed
        print("Speed set to: " .. speed)
        showNotification("Speed set to " .. speed .. "!", Color3.fromRGB(0, 200, 100))
    end)
    if not success then
        warn("Speed error: " .. tostring(err))
        showNotification("Invalid speed! (16-100)", Color3.fromRGB(255, 80, 80))
    end
end)

-- Input Handling (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- Speed Up X Logic
speedButton.MouseButton1Click:Connect(function()
    local success, err
    local clientName = "Unknown"
    local loadstringSupported = false

    if typeof(is_sirhurt_closure) == "function" then
        clientName = "Sirhurt"
        loadstringSupported = true
    elseif typeof(is_synapse_function) == "function" then
        clientName = "Synapse X"
        loadstringSupported = true
    elseif typeof(getgenv) == "function" then
        clientName = "KRNL/Fluxus"
        loadstringSupported = true
    end

    print("Detected client: " .. clientName .. ", loadstring supported: " .. tostring(loadstringSupported))

    if not loadstringSupported then
        warn("Client does not support loadstring!")
        showNotification("Client not supported!", Color3.fromRGB(255, 80, 80))
        return
    end

    success, err = pcall(function()
        local response = game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true)
        if response then
            loadstring(response)()
            print("Executed Speed Up X script")
        else
            error("Failed to fetch Speed Up X script")
        end
    end)

    if success then
        showNotification("Speed Up X Successful!", Color3.fromRGB(0, 200, 100))
    else
        warn("Error executing Speed Up X: " .. tostring(err))
        showNotification("Speed Up X Error: Check console", Color3.fromRGB(255, 80, 80))
    end
end)

-- No Lag Logic
noLagButton.MouseButton1Click:Connect(function()
    local success, err
    local clientName = "Unknown"
    local loadstringSupported = false

    if typeof(is_sirhurt_closure) == "function" then
        clientName = "Sirhurt"
        loadstringSupported = true
    elseif typeof(is_synapse_function) == "function" then
        clientName = "Synapse X"
        loadstringSupported = true
    elseif typeof(getgenv) == "function" then
        clientName = "KRNL/Fluxus"
        loadstringSupported = true
    end

    print("Detected client: " .. clientName .. ", loadstring supported: " .. tostring(loadstringSupported))

    if not loadstringSupported then
        warn("Client does not support loadstring!")
        showNotification("Client not supported!", Color3.fromRGB(255, 80, 80))
        return
    end

    success, err = pcall(function()
        local response = game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua")
        if response then
            loadstring(response)()
            print("Executed No Lag script")
        else
            error("Failed to fetch No Lag script")
        end
    end)

    if success then
        showNotification("No Lag Successful!", Color3.fromRGB(0, 200, 100))
    else
        warn("Error executing No Lag: " .. tostring(err))
        showNotification("No Lag Error: Check console", Color3.fromRGB(255, 80, 80))
    end
end)

-- Close X Button Logic
closeXButton.MouseButton1Click:Connect(toggleMenu)

-- Toggle Button Logic
toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Hover Effects
local function addHoverEffect(button)
    local originalColor = button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.new(originalColor.R * 0.85, originalColor.G * 0.85, originalColor.B * 0.85),
            BackgroundTransparency = math.max(0, originalTransparency - 0.1)
        })
        tween:Play()
    end)
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        })
        tween:Play()
    end)
end

addHoverEffect(speedButton)
addHoverEffect(noLagButton)
addHoverEffect(applySpeedButton)
addHoverEffect(closeXButton)
addHoverEffect(toggleButton)
addHoverEffect(homeButton)
addHoverEffect(settingsButton)
addHoverEffect(musicButton)
addHoverEffect(themeButton)
for _, button in ipairs(themeDropdown:GetChildren()) do
    if button:IsA("TextButton") then
        addHoverEffect(button)
    end
end

-- Loading Animation
local function startLoading()
    local tween = TweenService:Create(ProgressBar, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Connect(function()
        local fadeOut = TweenService:Create(LoadingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            LoadingFrame.Visible = false
            frame.Visible = true
            local fadeIn = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
            fadeIn:Play()
            print("Loading completed, showing main frame")
        end)
    end)
end

startLoading()

-- Debug
print("GrowGardenMenu fully initialized")