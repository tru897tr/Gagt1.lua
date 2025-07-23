-- Place this in a LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.Text = "Speed Up x"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 180, 0, 50)
closeButton.Position = UDim2.new(0, 10, 0, 70)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

-- Toggle Visibility
local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end

-- Toggle with RightShift
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
        warn("Error executing Speed Hub X:", err)
    end
end)

-- Close Button Logic
closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)
