-- Place this in a LocalScript under StarterPlayerScripts for client-side UI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

-- Create RemoteEvent for client-server communication
local SpeedEvent = Instance.new("RemoteEvent")
SpeedEvent.Name = "SpeedEvent"
SpeedEvent.Parent = ReplicatedStorage

-- Create GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Create Frame for Menu
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Create Speed Up Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 10)
speedButton.Text = "Speed Up x2"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Parent = frame

-- Create Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 180, 0, 50)
closeButton.Position = UDim2.new(0, 10, 0, 70)
closeButton.Text = "Close Menu"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

-- Toggle Menu Visibility
local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
end

-- Bind menu toggle to a key (e.g., 'M')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
        toggleMenu()
    end
end)

-- Speed Up Button Functionality
speedButton.MouseButton1Click:Connect(function()
    SpeedEvent:FireServer(32) -- Request server to set speed to 32 (default is 16)
end)

-- Close Button Functionality
closeButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)
