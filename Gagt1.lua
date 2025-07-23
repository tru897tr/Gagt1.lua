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
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0.5, -125, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Parent = menuGui
frame.Active = true
frame.Visible = true

-- Bo góc cho Frame
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

-- Gradient cho Frame
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 30))
})
gradient.Rotation = 135
gradient.Parent = frame

-- Viền neon cho Frame
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Transparency = 0.3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = frame

-- Tạo tiêu đề "Grow A Garden"
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 0, 40)
title.Position = UDim2.new(0.5, -110, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Grow A Garden"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextSize = 24
title.Font = Enum.Font.GothamBlack
title.ZIndex = 11
title.Parent = frame

-- Tạo nút đóng (dấu X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.BackgroundTransparency = 0.2
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.ZIndex = 11
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton
closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)
closeButton.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -125, 0.7, -90),
        BackgroundTransparency = 0.8
    })
    tween:Play()
    tween.Completed:Connect(function()
        frame.Visible = false
        frame.BackgroundTransparency = 0.1
    end)
end)

-- Hàm tạo nút với hiệu ứng hover
local function createButton(name, positionY, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 45)
    button.Position = UDim2.new(0.5, -90, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 18
    button.Font = Enum.Font.GothamBold
    button.ZIndex = 11
    button.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button

    local btnGradient = Instance.new("UIGradient")
    btnGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 200))
    })
    btnGradient.Rotation = 90
    btnGradient.Parent = button

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 2
    btnStroke.Color = Color3.fromRGB(0, 255, 255)
    btnStroke.Transparency = 0.5
    btnStroke.Parent = button

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0, TextSize = 19}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2, TextSize = 18}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
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
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
toggleButton.BackgroundTransparency = 0.2
toggleButton.Image = "rbxassetid://10723433819" -- Asset ID mẫu
toggleButton.ZIndex = 15 -- ZIndex cao để đảm bảo tương tác
toggleButton.Parent = toggleGui
toggleButton.Active = true
toggleButton.Selectable = true
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton
local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 200))
})
toggleGradient.Rotation = 90
toggleGradient.Parent = toggleButton
local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 2
toggleStroke.Color = Color3.fromRGB(0, 255, 255)
toggleStroke.Transparency = 0.5
toggleStroke.Parent = toggleButton
toggleButton.MouseEnter:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
end)
toggleButton.MouseLeave:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
end)

-- Hiệu ứng bật/tắt menu
local function toggleMenu()
    if frame.Visible then
        local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -125, 0.7, -90),
            BackgroundTransparency = 0.8
        })
        tween:Play()
        tween.Completed:Connect(function()
            frame.Visible = false
            frame.BackgroundTransparency = 0.1
        end)
    else
        frame.Visible = true
        frame.Position = UDim2.new(0.5, -125, 0.7, -90)
        frame.BackgroundTransparency = 0.8
        local tween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -125, 0.5, -90),
            BackgroundTransparency = 0.1
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
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFrame = false
                connection:Disconnect()
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
        local connection
        connection = UserInputService.InputEnded:Connect(function(endInput)
            if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                draggingToggle = false
                connection:Disconnect()
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
