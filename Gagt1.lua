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

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 210) -- Increased height to accommodate credit
frame.Position = UDim2.new(0.5, -110, 0.5, -105)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui
-- Add corner rounding
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Grow a Garden"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 40)
speedButton.Position = UDim2.new(0, 20, 0, 50)
speedButton.Text = "Speed Up"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 16
speedButton.Parent = frame
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 180, 0, 40)
closeButton.Position = UDim2.new(0, 20, 0, 100)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 16
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Credit Label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(1, -20, 0, 20)
credit.Position = UDim2.new(0, 10, 0, 180) -- At bottom of frame
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
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Top-left corner
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = ""
toggleButton.Parent = screenGui -- Outside frame
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
        -- In-game feedback
        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(0, 180, 0, 30)
        errorLabel.Position = UDim2.new(0, 20, 0, 150)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Error: Check console"
        errorLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
        errorLabel.TextScaled = true
        errorLabel.Parent = frame
        game:GetService("Debris"):AddItem(errorLabel, 3) -- Remove after 3 seconds
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
