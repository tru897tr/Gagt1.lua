-- Script chạy phía client, đặt trong StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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
frame.Size = UDim2.new(0, 220, 0, 160) -- Kích thước lớn hơn một chút cho giao diện hiện đại
frame.Position = UDim2.new(0.5, -110, 0.5, -80) -- Căn giữa
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu nền tối
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = menuGui
frame.Active = true
frame.Visible = true -- Hiển thị ban đầu

-- Bo góc cho Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Gradient cho Frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
gradient.Rotation = 45
gradient.Parent = frame

-- Bóng đổ cho Frame
local shadow = Instance.new("UIStroke")
shadow.Thickness = 2
shadow.Color = Color3.fromRGB(0, 255, 0) -- Viền xanh neon cho vibe hiện đại
shadow.Transparency = 0.5
shadow.Parent = frame

-- Tạo tiêu đề "Grow A Garden"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 40)
title.Position = UDim2.new(0.5, -100, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Grow A Garden"
title.TextColor3 = Color3.fromRGB(0, 255, 0) -- Màu xanh neon
title.TextSize = 22
title.Font = Enum.Font.FredokaOne -- Font hiện đại
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
    -- Hiệu ứng trượt ra khi đóng
    local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -110, 0.6, -80),
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        frame.Visible = false
        frame.Transparency = 0
    end)
end)

-- Hàm tạo nút với hiệu ứng hover
local function createButton(name, positionY, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 160, 0, 40)
    button.Position = UDim2.new(0.5, -80, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Màu xanh hiện đại
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.FredokaOne
    button.ZIndex = 11
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
    })
    btnGradient.Parent = button

    -- Hiệu ứng hover
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)

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
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
toggleButton.Image = "rbxassetid://10723433819" -- Asset ID mẫu
toggleButton.ZIndex = 10
toggleButton.Parent = toggleGui
toggleButton.Active = true
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 200))
})
toggleGradient.Parent = toggleButton

-- Hiệu ứng bật/tắt menu
local function toggleMenu()
    if frame.Visible then
        -- Hiệu ứng trượt ra
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -110, 0.6, -80),
            Transparency = 1
        })
        tween:Play()
        tween.Completed:Connect(function()
            frame.Visible = false
            frame.Transparency = 0
        end)
    else
        -- Hiệu ứng trượt vào
        frame.Visible = true
        frame.Position = UDim2.new(0.5, -110, 0.6, -80)
        frame.Transparency = 1
        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -110, 0.5, -80),
            Transparency = 0
        })
        tween:Play()
    end
end
toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Kéo thả cho Frame (menu)
local draggingFrame, dragStart, startPos
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

-- Kéo thả cải tiến cho nút bật/tắt
local draggingToggle, toggleDragStart, toggleStartPos
local function updateToggle(input)
    local delta = input.Position - toggleDragStart
    local newX = toggleStartPos.X.Offset + delta.X
    local newY = toggleStartPos.Y.Offset + delta.Y
    -- Giới hạn để nút không vượt ra ngoài màn hình
    local screenSize = playerGui:GetService("GuiService"):GetScreenResolution()
    newX = math.clamp(newX, 0, screenSize.X - toggleButton.Size.X.Offset)
    newY = math.clamp(newY, 0, screenSize.Y - toggleButton.Size.Y.Offset)
    toggleButton.Position = UDim2.new(0, newX, 0, newY)
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
        toggleMenu()
    end
end)
