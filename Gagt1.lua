local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackHub"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Bỏ qua thanh công cụ Roblox
screenGui.DisplayOrder = 100 -- Đảm bảo hiển thị trên cùng

-- Tạo màn hình Loading
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0 -- Màu đen hoàn toàn
loadingFrame.ZIndex = 100 -- ZIndex cao
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 200, 0, 50)
loadingText.Position = UDim2.new(0.5, -100, 0.5, -25)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextSize = 32
loadingText.Font = Enum.Font.SourceSansBold
loadingText.ZIndex = 101 -- Cao hơn loadingFrame
loadingText.Parent = loadingFrame

-- Tắt màn hình loading sau 5 giây
spawn(function()
    wait(5)
    loadingFrame:Destroy()
end)

-- Tạo Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ZIndex = 5
mainFrame.Parent = screenGui

-- Tạo tiêu đề
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = "Hack Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.ZIndex = 6
titleLabel.Parent = mainFrame

-- Tạo nút ẩn/hiện hình tròn ở góc phải
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(1, -60, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = ">"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.ZIndex = 7
toggleButton.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.5, 0)
uiCorner.Parent = toggleButton

-- Biến trạng thái và lưu vị trí
local isVisible = true
local savedPosition = mainFrame.Position

-- Hàm chuyển đổi ẩn/hiện
local function toggleUI()
    isVisible = not isVisible
    local targetPosition
    if isVisible then
        targetPosition = savedPosition
    else
        targetPosition = UDim2.new(savedPosition.X.Scale, savedPosition.X.Offset, -1, -200)
    end
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(mainFrame, tweenInfo, {Position = targetPosition})
    tween:Play()
    toggleButton.Text = isVisible and ">" or "<"
end

-- Xử lý phím O
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.O then
        toggleUI()
    end
end)

-- Xử lý nút ẩn/hiện
toggleButton.MouseButton1Click:Connect(toggleUI)

-- Làm khung có thể kéo (hỗ trợ cả chuột và cảm ứng)
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = newPosition
    savedPosition = newPosition -- Cập nhật vị trí đã lưu
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if dragging and dragInput then
        updateInput(dragInput)
    end
end)
