-- Script chạy phía client, đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10) -- Chờ PlayerGui tải

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowAGardenMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = false -- Tắt menu ban đầu, bật bằng Right Shift

-- Tạo Frame chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150) -- Kích thước nhỏ gọn
frame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Căn giữa màn hình
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.Parent = screenGui

-- Bo góc cho Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Tạo tiêu đề "Grow A Garden"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 180, 0, 40)
title.Position = UDim2.new(0.5, -90, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Grow A Garden"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Tạo nút đóng (dấu X) ở góc trên bên phải
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Hàm tạo nút
local function createButton(name, positionY, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0.5, -75, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.SourceSansBold
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(callback)
end

-- Tạo nút "Speed Up X"
createButton("SpeedUpButton", 60, "Speed Up X", function()
    print("Attempting to execute Speed Up X script...")
    local success, errorMsg = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if success then
        print("Script executed successfully!")
    else
        warn("Error executing script: " .. tostring(errorMsg))
    end
end)

-- Tạo nút bật/tắt giao diện (hình vuông nhỏ với hình ảnh)
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50) -- Hình vuông nhỏ
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Góc trên bên trái màn hình
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.Image = "rbxassetid://YOUR_ASSET_ID" -- Thay YOUR_ASSET_ID bằng Asset ID hình ảnh
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton
toggleButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled
end)

-- Bật/tắt menu bằng phím Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
