local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService") -- TextService để đo kích thước văn bản

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackHub"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Bỏ qua thanh công cụ Roblox
screenGui.DisplayOrder = 10000 -- Che phủ giao diện Roblox
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global -- Đảm bảo che phủ toàn cục

-- Danh sách lưu trữ thông báo
local notifications = {}

-- Hàm cập nhật vị trí các thông báo
local function updateNotificationPositions()
    for i, notif in ipairs(notifications) do
        local targetPosition = UDim2.new(0.5, -notif.Size.X.Offset / 2, 0, 10 + (i - 1) * 60) -- Căn giữa dựa trên chiều rộng động
        local tweenUpdate = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = targetPosition
        })
        tweenUpdate:Play()
    end
end

-- Hàm tạo thông báo với hiệu ứng
local function createNotification(message, isError)
    -- In thông báo vào debug
    if isError then
        print("[HackHub Error] " .. message)
    else
        print("[HackHub Success] " .. message)
    end

    -- Xóa thông báo cũ nếu vượt quá 3
    if #notifications >= 3 then
        local oldestNotification = table.remove(notifications, 1)
        if oldestNotification and oldestNotification.Parent then
            local tweenOut = TweenService:Create(oldestNotification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -oldestNotification.Size.X.Offset / 2, 0, oldestNotification.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(oldestNotification:FindFirstChildOfClass("TextLabel"), TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                oldestNotification:Destroy()
                updateNotificationPositions()
            end)
        end
    end

    -- Tạo khung thông báo
    local notificationFrame = Instance.new("Frame")
    local notificationText = Instance.new("TextLabel")
    
    -- Cấu hình TextLabel
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationText.TextSize = 16
    notificationText.Font = Enum.Font.SourceSans
    notificationText.ZIndex = 16
    notificationText.TextWrapped = true -- Cho phép xuống dòng
    notificationText.TextXAlignment = Enum.TextXAlignment.Center -- Căn giữa ngang
    notificationText.TextYAlignment = Enum.TextYAlignment.Center -- Căn giữa dọc
    notificationText.Parent = notificationFrame

    -- Thêm UIPadding để tạo khoảng cách đều
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = notificationText

    -- Đo kích thước văn bản
    local maxWidth = 400 -- Chiều rộng tối đa của thông báo
    local textSize = TextService:GetTextSize(
        message,
        16, -- Kích thước chữ
        Enum.Font.SourceSans,
        Vector2.new(maxWidth - 20, 1000) -- Chiều rộng tối đa trừ padding, chiều cao lớn để đo wrapping
    )
    local frameWidth = math.max(200, textSize.X + 20) -- Chiều rộng tối thiểu 200, cộng padding
    local frameHeight = math.max(50, textSize.Y + 10) -- Chiều cao tối thiểu 50, cộng padding

    -- Cấu hình Frame
    notificationFrame.Size = UDim2.new(0, frameWidth, 0, frameHeight)
    notificationFrame.Position = UDim2.new(0.5, -frameWidth / 2, 0, -frameHeight) -- Bắt đầu ngoài màn hình, căn giữa
    notificationFrame.BackgroundColor3 = isError and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(20, 20, 20)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.ZIndex = 15
    notificationFrame.Parent = screenGui

    -- Đặt kích thước TextLabel để khớp với Frame (trừ padding)
    notificationText.Size = UDim2.new(1, 0, 1, 0) -- Chiếm toàn bộ Frame, padding được xử lý bởi UIPadding

    -- Thêm sự kiện nhấn để tắt thông báo
    notificationFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -notificationFrame.Size.X.Offset / 2, 0, notificationFrame.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(notificationText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                for i, notif in ipairs(notifications) do
                    if notif == notificationFrame then
                        table.remove(notifications, i)
                        break
                    end
                end
                notificationFrame:Destroy()
                updateNotificationPositions()
            end)
        end
    end)

    -- Thêm vào danh sách thông báo
    table.insert(notifications, notificationFrame)

    -- Hiệu ứng di chuyển xuống vị trí chính xác
    local tweenIn = TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -frameWidth / 2, 0, 10 + (#notifications - 1) * 60)
    })
    tweenIn:Play()

    -- Hiệu ứng mờ dần và xóa sau 3 giây nếu không nhấn
    spawn(function()
        wait(3)
        if notificationFrame.Parent then
            local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -notificationFrame.Size.X.Offset / 2, 0, notificationFrame.Position.Y.Offset + 20)
            })
            local tweenTextOut = TweenService:Create(notificationText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1
            })
            tweenOut:Play()
            tweenTextOut:Play()
            tweenOut.Completed:Connect(function()
                for i, notif in ipairs(notifications) do
                    if notif == notificationFrame then
                        table.remove(notifications, i)
                        break
                    end
                end
                notificationFrame:Destroy()
                updateNotificationPositions()
            end)
        end
    end)
end

-- Tạo màn hình Loading
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.BackgroundTransparency = 0 -- Màu đen hoàn toàn
loadingFrame.ZIndex = 10000 -- Che phủ giao diện Roblox
loadingFrame.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 200, 0, 50)
loadingText.Position = UDim2.new(0.5, -100, 0.5, -50) -- Dịch lên để nhường chỗ cho progress bar
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading"
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextSize = 32
loadingText.Font = Enum.Font.SourceSansBold
loadingText.ZIndex = 10001
loadingText.Parent = loadingFrame

-- Tạo progress bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 200, 0, 20)
progressBar.Position = UDim2.new(0.5, -100, 0.5, 0) -- Đặt ngay dưới loadingText
progressBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu nền progress bar
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 10001
progressBar.Parent = loadingFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0) -- Bắt đầu với chiều rộng 0
progressFill.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Màu xanh lá cho fill
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 10002
progressFill.Parent = progressBar

-- Animate progress bar
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In) -- 5 giây, tuyến tính
local tween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(1, 0, 1, 0)}) -- Fill từ 0% đến 100%
tween:Play()

-- Animate loading text với dấu chấm
spawn(function()
    local dots = {".", "..", "..."}
    local index = 1
    while loadingFrame.Parent do
        loadingText.Text = "Loading" .. dots[index]
        index = (index % #dots) + 1
        wait(0.5) -- Cập nhật mỗi 0.5 giây
    end
end)

-- Tắt màn hình loading sau 5 giây và thông báo thành công + welcome
spawn(function()
    wait(5)
    loadingFrame:Destroy()
    createNotification("Script loaded successfully!", false)
    createNotification("🚀 Welcome to HackHub! Unleash Epic Adventures Await You! 🎮", false) -- Thông báo welcome cuốn hút
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

-- Tạo credit
local creditLabel = Instance.new("TextLabel")
creditLabel.Size = UDim2.new(1, 0, 0, 30)
creditLabel.Position = UDim2.new(0, 0, 0, 350) -- Đặt ở dưới cùng của mainFrame
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "Created by Nguyễn Trứ"
creditLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
creditLabel.TextSize = 16
creditLabel.Font = Enum.Font.SourceSans
creditLabel.ZIndex = 6
creditLabel.Parent = mainFrame

-- Tạo nút đóng (X) ở góc trên bên phải
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.ZIndex = 7
closeButton.Parent = mainFrame

-- Tạo nút Discord nhỏ ở góc trên bên phải (bên trái nút đóng)
local discordButton = Instance.new("TextButton")
discordButton.Size = UDim2.new(0, 20, 0, 20)
discordButton.Position = UDim2.new(1, -60, 0, 10)
discordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Màu xanh Discord
discordButton.Text = "D"
discordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
discordButton.TextSize = 12
discordButton.Font = Enum.Font.SourceSansBold
discordButton.ZIndex = 7
discordButton.Parent = mainFrame

-- Tạo khung xác nhận khi đóng
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0, 280, 0, 180)
confirmFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
confirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
confirmFrame.BorderSizePixel = 0
confirmFrame.ZIndex = 20
confirmFrame.Visible = false
confirmFrame.Parent = screenGui

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, -20, 0, 60)
confirmText.Position = UDim2.new(0, 10, 0, 20)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Are you sure you want to close the script?"
confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmText.TextSize = 18
confirmText.Font = Enum.Font.SourceSans
confirmText.TextWrapped = true
confirmText.ZIndex = 21
confirmText.Parent = confirmFrame

local confirmOkButton = Instance.new("TextButton")
confirmOkButton.Size = UDim2.new(0, 120, 0, 40)
confirmOkButton.Position = UDim2.new(0.1, 0, 0.65, 0)
confirmOkButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
confirmOkButton.Text = "OK"
confirmOkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmOkButton.TextSize = 16
confirmOkButton.Font = Enum.Font.SourceSansBold
confirmOkButton.ZIndex = 21
confirmOkButton.Parent = confirmFrame

local confirmCancelButton = Instance.new("TextButton")
confirmCancelButton.Size = UDim2.new(0, 120, 0, 40)
confirmCancelButton.Position = UDim2.new(0.54, 0, 0.65, 0)
confirmCancelButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
confirmCancelButton.Text = "Cancel"
confirmCancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmCancelButton.TextSize = 16
confirmCancelButton.Font = Enum.Font.SourceSansBold
confirmCancelButton.ZIndex = 21
confirmCancelButton.Parent = confirmFrame

-- Tạo nút Speed Up X
local speedUpButton = Instance.new("TextButton")
speedUpButton.Size = UDim2.new(0.8, 0, 0, 50)
speedUpButton.Position = UDim2.new(0.1, 0, 0.2, 0)
speedUpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedUpButton.Text = "Speed Up X"
speedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUpButton.TextSize = 20
speedUpButton.Font = Enum.Font.SourceSansBold
speedUpButton.ZIndex = 6
speedUpButton.Parent = mainFrame

-- Tạo nút No Lag
local noLagButton = Instance.new("TextButton")
noLagButton.Size = UDim2.new(0.8, 0, 0, 50)
noLagButton.Position = UDim2.new(0.1, 0, 0.35, 0)
noLagButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noLagButton.Text = "No Lag"
noLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagButton.TextSize = 20
noLagButton.Font = Enum.Font.SourceSansBold
noLagButton.ZIndex = 6
noLagButton.Parent = mainFrame

-- Tạo nút Limit Hub
local limitHubButton = Instance.new("TextButton")
limitHubButton.Size = UDim2.new(0.8, 0, 0, 50)
limitHubButton.Position = UDim2.new(0.1, 0, 0.5, 0)
limitHubButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
limitHubButton.Text = "Limit Hub"
limitHubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
limitHubButton.TextSize = 20
limitHubButton.Font = Enum.Font.SourceSansBold
limitHubButton.ZIndex = 6
limitHubButton.Parent = mainFrame

-- Tạo nút OMG Hub
local omgHubButton = Instance.new("TextButton")
omgHubButton.Size = UDim2.new(0.8, 0, 0, 50)
omgHubButton.Position = UDim2.new(0.1, 0, 0.65, 0)
omgHubButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
omgHubButton.Text = "OMG Hub"
omgHubButton.TextColor3 = Color3.fromRGB(255, 255, 255)
omgHubButton.TextSize = 20
omgHubButton.Font = Enum.Font.SourceSansBold
omgHubButton.ZIndex = 6
omgHubButton.Parent = mainFrame

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
local savedTogglePosition = toggleButton.Position

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
    createNotification(isVisible and "Interface shown!" or "Interface hidden!", false)
end

-- Xử lý nút ẩn/hiện
toggleButton.MouseButton1Click:Connect(toggleUI)

-- Xử lý nút đóng
closeButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
    createNotification("Close confirmation opened!", false)
end)

-- Xử lý nút OK trong xác nhận
confirmOkButton.MouseButton1Click:Connect(function()
    createNotification("Script closed successfully!", false)
    screenGui:Destroy() -- Tắt hoàn toàn script
end)

-- Xử lý nút Cancel trong xác nhận
confirmCancelButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
    createNotification("Close cancelled!", false)
end)

-- Xử lý nút Discord
discordButton.MouseButton1Click:Connect(function()
    createNotification("Discord link not set yet!", false)
end)

-- Xử lý nút Speed Up X
speedUpButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
    end)
    if success then
        createNotification("Speed Up X executed successfully!", false)
    else
        createNotification("Error executing Speed Up X: " .. tostring(err), true)
    end
end)

-- Xử lý nút No Lag
noLagButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
    end)
    if success then
        createNotification("No Lag executed successfully!", false)
    else
        createNotification("Error executing No Lag: " .. tostring(err), true)
    end
end)

-- Xử lý nút Limit Hub
limitHubButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeModz/LimitHub/refs/heads/main/LimitHub_Luarmor_E.lua"))()
    end)
    if success then
        createNotification("Limit Hub executed successfully!", false)
    else
        createNotification("Error executing Limit Hub: " .. tostring(err), true)
    end
end)

-- Xử lý nút OMG Hub với debug bổ sung
omgHubButton.MouseButton1Click:Connect(function()
    createNotification("Attempting to execute OMG Hub...", false) -- Thông báo bắt đầu thực thi
    local success, err = pcall(function()
        local scriptContent = game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua")
        print("[HackHub Debug] OMG Hub script fetched, length: " .. #scriptContent) -- Debug độ dài nội dung script
        loadstring(scriptContent)()
    end)
    if success then
        createNotification("OMG Hub executed successfully!", false)
    else
        createNotification("Error executing OMG Hub: " .. tostring(err), true)
        print("[HackHub Debug] OMG Hub error details: " .. tostring(err)) -- Debug chi tiết lỗi
    end
end)

-- Làm khung chính có thể kéo (hỗ trợ cả chuột và cảm ứng)
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

-- Làm nút ẩn/hiện có thể kéo (hỗ trợ cả chuột và cảm ứng)
local toggleDragging
local toggleDragInput
local toggleDragStart
local toggleStartPos

local function updateToggleInput(input)
    local delta = input.Position - toggleDragStart
    local newPosition = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
    toggleButton.Position = newPosition
    savedTogglePosition = newPosition -- Cập nhật vị trí đã lưu
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragging = true
        toggleDragStart = input.Position
        toggleStartPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                toggleDragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        toggleDragInput = input
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if toggleDragging and toggleDragInput then
        updateToggleInput(toggleDragInput)
    end
end)
