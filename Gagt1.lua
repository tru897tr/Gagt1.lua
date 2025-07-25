-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local SpeedUpButton = Instance.new("TextButton")
local NoLagButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

-- Thiết lập ScreenGui
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Thiết lập Frame
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Active = true
Frame.Draggable = true

-- Thiết lập Title
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold

-- Thiết lập Speed Up Button
SpeedUpButton.Parent = Frame
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedUpButton.Position = UDim2.new(0.1, 0, 0.3, 0)
SpeedUpButton.Size = UDim2.new(0.8, 0, 0, 40)
SpeedUpButton.Text = "Speed Up X"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextSize = 16
SpeedUpButton.Font = Enum.Font.SourceSans

-- Thiết lập No Lag Button
NoLagButton.Parent = Frame
NoLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
NoLagButton.Position = UDim2.new(0.1, 0, 0.6, 0)
NoLagButton.Size = UDim2.new(0.8, 0, 0, 40)
NoLagButton.Text = "No Lag"
NoLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoLagButton.TextSize = 16
NoLagButton.Font = Enum.Font.SourceSans

-- Chức năng khi nhấn nút Speed Up
SpeedUpButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)

-- Chức năng khi nhấn nút No Lag
NoLagButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
end)