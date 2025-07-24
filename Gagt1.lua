-- LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- GUI Setup
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("PlayerGui not found!")
    return
end

if not player.Character then
    player.CharacterAdded:Wait()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowGardenMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.IgnoreGuiInset = true

-- Menu Frame (Compact, Centered)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 240) -- Slightly smaller for elegance
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Darker, modern
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.5
frame.Visible = true
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14) -- Smoother corners
frameCorner.Parent = frame
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 1.5
frameStroke.Color = Color3.fromRGB(255, 255, 255)
frameStroke.Transparency = 0.7
frameStroke.Parent = frame

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
title.Parent = frame

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BackgroundTransparency = 0.6
sidebar.Parent = frame
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 240, 1, -60)
contentFrame.Position = UDim2.new(0, 96, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame

-- Sidebar Buttons
local homeButton = Instance.new("TextButton")
homeButton.Size = UDim2.new(1, -10, 0, 32)
homeButton.Position = UDim2.new(0, 5, 0, 5)
homeButton.Text = "Home"
homeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Selected
homeButton.BackgroundTransparency = 0.4
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.Font = Enum.Font.Gotham
homeButton.TextSize = 14
homeButton.Parent = sidebar
local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 6)
homeCorner.Parent = homeButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(1, -10, 0, 32)
settingsButton.Position = UDim2.new(0, 5, 0, 42)
settingsButton.Text = "Settings"
settingsButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Unselected
settingsButton.BackgroundTransparency = 0.4
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.Font = Enum.Font.Gotham
settingsButton.TextSize = 14
settingsButton.Parent = sidebar
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsButton

-- Content: Home
local homeContent = Instance.new("Frame")
homeContent.Size = UDim2.new(1, 0, 1, 0)
homeContent.BackgroundTransparency = 1
homeContent.Parent = contentFrame
homeContent.Visible = true

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 190, 0, 32)
speedButton.Position = UDim2.new(0, 25, 0, 20)
speedButton.Text = "Speed Up"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
speedButton.BackgroundTransparency = 0.4
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 14
speedButton.Parent = homeContent
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 190, 0, 32)
closeButton.Position = UDim2.new(0, 25, 0, 58)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BackgroundTransparency = 0.4
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 14
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

-- Theme Selection
local currentTheme = "Tối"
local themeButton = Instance.new("TextButton")
themeButton.Size = UDim2.new(0, 190, 0, 30)
themeButton.Position = UDim2.new(0, 25, 0, 20)
themeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
themeButton.BackgroundTransparency = 0.4
themeButton.Text = "Theme: " .. currentTheme
themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
themeButton.Font = Enum.Font.Gotham
themeButton.TextSize = 14
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
themeDropdown.Parent = settingsContent
local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = themeDropdown

local themes = {
    {Name = "Sáng", Color = Color3.fromRGB(220, 220, 220), TextColor = Color3.fromRGB(0, 0, 0)},
    {Name = "Tối", Color = Color3.fromRGB(20, 20, 20), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Xanh", Color = Color3.fromRGB(0, 80, 120), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Tím", Color = Color3.fromRGB(80, 0, 120), TextColor = Color3.fromRGB(255, 255, 255)}
}

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
        credit.TextColor3 = theme.TextColor
        print("Theme changed to: " .. theme.Name)
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

-- Credit Label (Ensured)
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 120, 0, 14)
credit.Position = UDim2.new(1, -128, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = "By Nguyễn Thanh Trứ"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.TextSize = 10
credit.Font = Enum.Font.Gotham
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = frame
print("Credit added at: " .. tostring(credit.Position))

-- Toggle Button (Circular, Top-Right)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 26, 0, 26)
toggleButton.Position = UDim2.new(1, -36, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.BackgroundTransparency = 0.3
toggleButton.Text = ""
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 13)
toggleCorner.Parent = toggleButton

-- Menu Visibility (Fade Effect)
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
    local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)})
    local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)})
    tween1:Play()
    tween2:Play()
    homeButton.BackgroundTransparency = 0.4
    settingsButton.BackgroundTransparency = 0.4
    themeDropdown.Visible = false
    print("Home selected, Home color: (0, 120, 255), Settings color: (0, 0, 0)")
end

local function showSettings()
    homeContent.Visible = false
    settingsContent.Visible = true
    local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)})
    local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(0, 120, 255)})
    tween1:Play()
    tween2:Play()
    homeButton.BackgroundTransparency = 0.4
    settingsButton.BackgroundTransparency = 0.4
    themeDropdown.Visible = false
    print("Settings selected, Home color: (0, 0, 0), Settings color: (0, 120, 255)")
end

homeButton.MouseButton1Click:Connect(showHome)
settingsButton.MouseButton1Click:Connect(showSettings)

-- Input Handling (RightShift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- Speed Up Logic (Client Hack Support)
speedButton.MouseButton1Click:Connect(function()
    local success, err
    local clientName = "Unknown"
    if is_sirhurt_closure then
        clientName = "Sirhurt"
    elseif is_synapse_function then
        clientName = "Synapse X"
    elseif getgenv then
        clientName = "KRNL/Fluxus"
    end

    print("Detected client: " .. clientName)

    success, err = pcall(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = humanoid.WalkSpeed + 16
            print("Speed increased to: " .. humanoid.WalkSpeed)
        else
            error("Humanoid not found")
        end
    end)

    if success then
        local successLabel = Instance.new("TextLabel")
        successLabel.Size = UDim2.new(0, 190, 0, 20)
        successLabel.Position = UDim2.new(0, 25, 0, 98)
        successLabel.BackgroundTransparency = 1
        successLabel.Text = "Speed Up Successful!"
        successLabel.TextColor3 = Color3.fromRGB(0, 200, 100)
        successLabel.TextSize = 12
        successLabel.Parent = homeContent
        game:GetService("Debris"):AddItem(successLabel, 3)
    else
        success, err = pcall(function()
            local scriptUrl = "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"
            local response = game:HttpGet(scriptUrl, true)
            local func = loadstring(response)
            if func then
                func()
                print("Executed external script via loadstring")
            else
                error("Failed to load script")
            end
        end)

        if not success then
            warn("Error executing Speed Up: " .. tostring(err))
            local errorLabel = Instance.new("TextLabel")
            errorLabel.Size = UDim2.new(0, 190, 0, 20)
            errorLabel.Position = UDim2.new(0, 25, 0, 98)
            errorLabel.BackgroundTransparency = 1
            errorLabel.Text = "Error: Check console"
            errorLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            errorLabel.TextSize = 12
            errorLabel.Parent = homeContent
            game:GetService("Debris"):AddItem(errorLabel, 3)
        end
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
        local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.new(originalColor.R * 0.85, originalColor.G * 0.85, originalColor.B * 0.85)
        })
        tween:Play()
    end)
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = originalColor})
        tween:Play()
    end)
end

addHoverEffect(speedButton)
addHoverEffect(closeButton)
addHoverEffect(toggleButton)
addHoverEffect(homeButton)
addHoverEffect(settingsButton)
addHoverEffect(themeButton)
for _, button in ipairs(themeDropdown:GetChildren()) do
    if button:IsA("TextButton") then
        addHoverEffect(button)
    end
end

-- Debug: Confirm GUI creation
print("GrowGardenMenu created and fixed at center: " .. tostring(frame.Position))
