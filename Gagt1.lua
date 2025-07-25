local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Check if PlayerGui is accessible
if not playerGui then
    warn("PlayerGui not found. Ensure this script runs in a valid Roblox environment.")
    return
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "HackHubGui"
gui.ResetOnSpawn = false -- Prevent GUI from resetting on player respawn
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true
gui.Parent = playerGui

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Create Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Grow a Garden Hack Hub"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Create Speed Up X Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0.9, 0, 0, 40)
speedButton.Position = UDim2.new(0.05, 0, 0.3, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Text = "Speed Up X"
speedButton.Font = Enum.Font.SourceSans
speedButton.TextSize = 16
speedButton.Parent = frame

-- Create No Lag Button
local noLagButton = Instance.new("TextButton")
noLagButton.Size = UDim2.new(0.9, 0, 0, 40)
noLagButton.Position = UDim2.new(0.05, 0, 0.6, 0)
noLagButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
noLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagButton.Text = "No Lag"
noLagButton.Font = Enum.Font.SourceSans
noLagButton.TextSize = 16
noLagButton.Parent = frame

-- Add UICorner to Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Add UICorner to Buttons
local buttonCorner1 = Instance.new("UICorner")
buttonCorner1.CornerRadius = UDim.new(0, 6)
buttonCorner1.Parent = speedButton

local buttonCorner2 = Instance.new("UICorner")
buttonCorner2.CornerRadius = UDim.new(0, 6)
buttonCorner2.Parent = noLagButton

-- Debug message to confirm GUI loaded
print("Hack Hub GUI loaded successfully!")

-- Speed Up X Button Functionality
speedButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if not success then
        warn("Error executing Speed Up X script: " .. tostring(err))
    else
        print("Speed Up X script executed successfully!")
    end
end)

-- No Lag Button Functionality
noLagButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
    end)
    if not success then
        warn("Error executing No Lag script: " .. tostring(err))
    else
        print("No Lag script executed successfully!")
    end
end)
