local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HackHubGui"
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "Grow a Garden Hack Hub"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0.9, 0, 0, 40)
speedButton.Position = UDim2.new(0.05, 0, 0.3, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Text = "Speed Up X"
speedButton.Font = Enum.Font.SourceSans
speedButton.TextSize = 16
speedButton.Parent = frame

local noLagButton = Instance.new("TextButton")
noLagButton.Size = UDim2.new(0.9, 0, 0, 40)
noLagButton.Position = UDim2.new(0.05, 0, 0.6, 0)
noLagButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
noLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagButton.Text = "No Lag"
noLagButton.Font = Enum.Font.SourceSans
noLagButton.TextSize = 16
noLagButton.Parent = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local buttonCorner1 = Instance.new("UICorner")
buttonCorner1.CornerRadius = UDim.new(0, 6)
buttonCorner1.Parent = speedButton

local buttonCorner2 = Instance.new("UICorner")
buttonCorner2.CornerRadius = UDim.new(0, 6)
buttonCorner2.Parent = noLagButton

speedButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

noLagButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
end)
