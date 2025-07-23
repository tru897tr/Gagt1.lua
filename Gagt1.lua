-- Script chạy phía client, đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10) -- Chờ PlayerGui tải

-- Tạo ScreenGui cho menu
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "GrowAGardenMenu"
menuGui.Parent = playerGui
menuGui.ResetOnSpawn = false
menuGui.Enabled = true -- Menu hiển thị ngay khi bắt đầu
menuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tạo ScreenGui riêng cho nút bật/tắt
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleButtonGui"
toggleGui.Parent = playerGui
toggleGui.ResetOnSpawn = false
toggleGui.Enabled = true -- Nút bật/tắt luôn hiển thị
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Tạo Frame chính (menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150) -- Kích thước nhỏ gọn
frame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Căn giữa màn hình
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 2
frame.ZIndex = 10
frame.Parent = menuGui
frame.Active = true -- Cho phép tương tác kéo thả
frame.Draggable = false -- Sử dụng logic kéo thả tùy chỉnh

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
title.ZIndex = 11
title.Parent = frame

-- Tạo nút đóng (dấu X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 11
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false -- Chỉ ẩn frame
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
    button.ZIndex = 11
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

-- Tạo nút bật/tắt giao diện (hình vuông nhỏ)
local toggleButton = Instance.new("ImageButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50) -- Hình vuông nhỏ
toggleButton.Position = UDim2.new(0, 10, 0, 10) -- Góc trên bên trái
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.Image = "rbxassetid://10723433819" -- Asset ID mẫu
toggleButton.ZIndex = 10
toggleButton.Parent = toggleGui
toggleButton.Active = true -- Cho phép tương tác kéo thả
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 5)
toggleCorner.Parent = toggleButton
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible -- Chỉ bật/tắt frame
end)

-- Kéo thả cho Frame (menu)
local draggingFrame, dragInput, dragStart, startPos
local function updateFrame(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFrame = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFrame = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingFrame then
        updateFrame(input)
    end
end)

-- Kéo thả cho nút bật/tắt
local draggingToggle, toggleDragStart, toggleStartPos
local function updateToggle(input)
    local delta = input.Position - toggleDragStart
    toggleButton.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
end
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingToggle = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and draggingToggle then
        updateToggle(input)
    end
end)

-- Bật/tắt menu bằng phím Right Shift
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible -- Chỉ bật/tắt frame
    end
end)
