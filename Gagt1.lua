-- Script chạy phía client, đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 10) -- Chờ PlayerGui tải
print("PlayerGui loaded") -- Debug

-- Tạo ScreenGui cho menu
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "GrowAGardenMenu"
menuGui.ResetOnSpawn = false
menuGui.Enabled = true
menuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
menuGui.Parent = playerGui
print("menuGui created and parented") -- Debug

-- Tạo ScreenGui cho nút bật/tắt
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "ToggleButtonGui"
toggleGui.ResetOnSpawn = false
toggleGui.Enabled = true
toggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
toggleGui.Parent = playerGui
print("toggleGui created and parented") -- Debug

-- Tạo Frame chính (menu)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(240, 245, 250) -- Xanh nhạt pastel
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Active = true
frame.Visible = true
frame.Parent = menuGui
print("Frame created") -- Debug

-- Bo góc cho Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Gradient nhẹ cho Frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 245, 250)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 230, 240))
})
gradient.Rotation = 90
gradient.Parent = frame

-- Viền mỏng
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(150, 180, 200)
stroke.Transparency = 0.5
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = frame

-- Tạo tiêu đề "Grow A Garden"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Grow A Garden"
title.TextColor3 = Color3.fromRGB(50, 70, 100)
title.TextSize = 22
title.Font = Enum.Font.SourceSansPro
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 11
title.Parent = frame
print("Title created") -- Debug

-- Tạo nút đóng (dấu X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 11
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton
closeButton.MouseButton1Click:Connect(function()
    frame.Visible = false
    print("Menu hidden via Close Button") -- Debug
end)
closeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        frame.Visible = false
        print("Menu hidden via Close Button (touch)") -- Debug
    end
end)
print("Close Button created") -- Debug

-- Tạo nút "Speed Up X"
local speedUpButton = Instance.new("TextButton")
speedUpButton.Name = "SpeedUpButton"
speedUpButton.Size = UDim2.new(0, 160, 0, 40)
speedUpButton.Position = UDim2.new(0.5, -80, 0, 60)
speedUpButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
speedUpButton.BackgroundTransparency = 0.3
speedUpButton.Text = "Speed Up X"
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextSize = 16
speedUpButton.Font = Enum.Font.SourceSansPro
speedUpButton.ZIndex = 11
speedUpButton.Parent = frame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = speedUpButton
local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 180))
})
btnGradient.Rotation = 90
btnGradient.Parent = speedUpButton
local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 1
btnStroke.Color = Color3.fromRGB(150, 180, 200)
btnStroke.Transparency = 0.5
btnStroke.Parent = speedUpButton
speedUpButton.MouseButton1Click:Connect(function()
    print("Speed Up X clicked") -- Debug
    local success, errorMsg = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if success then
        print("Script executed successfully!")
    else
        warn("Error executing script: " .. tostring(errorMsg))
    end
end)
speedUpButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        print("Speed Up X touched") -- Debug
        local success, errorMsg = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        end)
        if success then
            print("Script executed successfully!")
        else
            warn("Error executing script: " .. tostring(errorMsg))
        end
    end
end)
print("SpeedUpButton created") -- Debug

-- Tạo nút bật/tắt (hình vuông nhỏ, không dùng hình ảnh)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
toggleButton.BackgroundTransparency = 0.3
toggleButton.Text = ""
toggleButton.ZIndex = 20
toggleButton.Active = true
toggleButton.Selectable = true
toggleButton.Visible = true
toggleButton.Parent = toggleGui
print("ToggleButton created") -- Debug
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 150, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 120, 180))
})
toggleGradient.Rotation = 90
toggleGradient.Parent = toggleButton
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1
toggleStroke.Color = Color3.fromRGB(150, 180, 200)
toggleStroke.Transparency = 0.5
toggleStroke.Parent = toggleButton
toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    print("Menu toggled via ToggleButton: Visible = " .. tostring(frame.Visible)) -- Debug
end)
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        frame.Visible = not frame.Visible
        print("Menu toggled via ToggleButton (touch): Visible = " .. tostring(frame.Visible)) -- Debug
    end
end)

-- Kéo thả cho Frame (menu) - Hỗ trợ chuột và touch
local draggingFrame, dragStart, startPos
local function updateFrame(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    print("Frame moved to: X=" .. frame.Position.X.Offset .. ", Y=" .. frame.Position.Y.Offset) -- Debug
end
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStart = input.Position
        startPos = frame.Position
        print("Frame drag started") -- Debug
        local connection
        connection = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == input.UserInputType then
                draggingFrame = false
                connection:Disconnect()
                print("Frame drag ended") -- Debug
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingFrame then
            updateFrame(input)
        end
    end
end)

-- Kéo thả cho nút bật/tắt - Hỗ trợ chuột và touch
local draggingToggle, toggleDragStart, toggleStartPos
local function updateToggle(input)
    local delta = input.Position - toggleDragStart
    local newX = toggleStartPos.X.Offset + delta.X
    local newY = toggleStartPos.Y.Offset + delta.Y
    local screenSize = playerGui:GetService("GuiService"):GetScreenResolution()
    newX = math.clamp(newX, 0, screenSize.X - toggleButton.Size.X.Offset)
    newY = math.clamp(newY, 0, screenSize.Y - toggleButton.Size.Y.Offset)
    toggleButton.Position = UDim2.new(0, newX, 0, newY)
    print("Toggle moved to: X=" .. newX .. ", Y=" .. newY) -- Debug
end
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        print("Toggle drag started") -- Debug
        draggingToggle = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
        local connection
        connection = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == input.UserInputType then
                draggingToggle = false
                connection:Disconnect()
                print("Toggle drag ended") -- Debug
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingToggle then
            updateToggle(input)
        end
    end
end)

-- Bật/tắt menu bằng phím Right Shift (cho PC)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
        print("Menu toggled via Right Shift: Visible = " .. tostring(frame.Visible)) -- Debug
    end
end)

print("Script loaded successfully") -- Debug
