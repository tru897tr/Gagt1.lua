-- LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Translations
local translations = {
    en = {
        title = "Grow a Garden",
        home = "Home",
        settings = "Settings",
        music = "Misic",
        speed_title = "Walk Speed",
        speed_desc = "Set custom walking speed",
        jump_title = "Infinite Jump",
        jump_desc = "Jump without touching ground",
        theme_title = "Theme",
        theme_desc = "Change interface theme",
        lang_title = "Language",
        lang_desc = "Change interface language",
        speed_button = "Apply",
        jump_button = "Infinite Jump (%s)",
        theme_button = "Theme: %s",
        lang_button = "Language: %s",
        credit = "By Nguyễn Thanh Trứ",
        speed_notification = "Speed set to %s!",
        speed_error = "Invalid speed!",
        jump_enabled = "Infinite Jump Enabled!",
        jump_disabled = "Infinite Jump Disabled!",
        jump_error = "Infinite Jump Error!",
        theme_notification = "Theme changed: %s",
        lang_notification = "Language changed to %s",
        speedx_notification = "Speed Up X Successful!",
        speedx_error = "Speed Up X Error: Check console",
        nolag_notification = "No Lag Successful!",
        nolag_error = "No Lag Error: Check console",
        client_error = "Client not supported!",
        loading_error = "Loading failed: Check console",
        init_error = "Initialization failed: Check console"
    },
    vi = {
        title = "Trồng một khu vườn",
        home = "Trang chủ",
        settings = "Cài đặt",
        music = "Tính năng",
        speed_title = "Tốc độ chạy",
        speed_desc = "Đặt tốc độ chạy tùy chỉnh",
        jump_title = "Nhảy vô hạn",
        jump_desc = "Nhảy mà không cần chạm đất",
        theme_title = "Giao diện",
        theme_desc = "Thay đổi giao diện",
        lang_title = "Ngôn ngữ",
        lang_desc = "Thay đổi ngôn ngữ giao diện",
        speed_button = "Áp dụng",
        jump_button = "Nhảy vô hạn (%s)",
        theme_button = "Giao diện: %s",
        lang_button = "Ngôn ngữ: %s",
        credit = "Bởi Nguyễn Thanh Trứ",
        speed_notification = "Tốc độ đặt thành %s!",
        speed_error = "Tốc độ không hợp lệ!",
        jump_enabled = "Nhảy vô hạn đã bật!",
        jump_disabled = "Nhảy vô hạn đã tắt!",
        jump_error = "Lỗi nhảy vô hạn!",
        theme_notification = "Giao diện đã đổi: %s",
        lang_notification = "Ngôn ngữ thay đổi thành %s",
        speedx_notification = "Speed Up X thành công!",
        speedx_error = "Lỗi Speed Up X: Xem console",
        nolag_notification = "No Lag thành công!",
        nolag_error = "Lỗi No Lag: Xem console",
        client_error = "Client không được hỗ trợ!",
        loading_error = "Tải thất bại: Xem console",
        init_error = "Khởi tạo thất bại: Xem console"
    }
}

-- GUI Setup
local player = Players.LocalPlayer
local playerGui = nil
local maxAttempts = 30
local attempts = 0

-- Chờ PlayerGui với timeout
while not playerGui and attempts < maxAttempts and player.Parent do
    local success, result = pcall(function()
        return player:WaitForChild("PlayerGui", 2)
    end)
    if success and result then
        playerGui = result
        print("PlayerGui found after " .. attempts .. " attempts")
        break
    end
    attempts = attempts + 1
    warn("PlayerGui not found, attempt " .. attempts .. "/" .. maxAttempts)
    task.wait(1)
end

if not playerGui then
    warn("Failed to find PlayerGui after " .. maxAttempts .. " attempts")
    return
end

-- Chờ Character
local character = player.Character
if not character then
    local success, err = pcall(function()
        character = player.CharacterAdded:Wait()
        print("Character loaded")
    end)
    if not success then
        warn("Character loading failed: " .. tostring(err))
        return
    end
end

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GrowGardenMenu"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
print("ScreenGui created")

-- Loading Frame
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.Position = UDim2.new(0, 0, 0, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.2
LoadingFrame.ZIndex = 20
LoadingFrame.Visible = true
LoadingFrame.Parent = screenGui
local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 10)
loadingCorner.Parent = LoadingFrame
local loadingStroke = Instance.new("UIStroke")
loadingStroke.Thickness = 2
loadingStroke.Color = Color3.fromRGB(255, 255, 255)
loadingStroke.Transparency = 0.5
loadingStroke.Parent = LoadingFrame

local ProgressBarFrame = Instance.new("Frame")
ProgressBarFrame.Size = UDim2.new(0, 200, 0, 20)
ProgressBarFrame.Position = UDim2.new(0.5, -100, 0.5, 0)
ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ProgressBarFrame.BackgroundTransparency = 0.4
ProgressBarFrame.ZIndex = 21
ProgressBarFrame.ClipsDescendants = true
ProgressBarFrame.Parent = LoadingFrame
local ProgressBarFrameCorner = Instance.new("UICorner")
ProgressBarFrameCorner.CornerRadius = UDim.new(0, 6)
ProgressBarFrameCorner.Parent = ProgressBarFrame
local ProgressBarFrameStroke = Instance.new("UIStroke")
ProgressBarFrameStroke.Thickness = 1
ProgressBarFrameStroke.Color = Color3.fromRGB(255, 255, 255)
ProgressBarFrameStroke.Transparency = 0.5
ProgressBarFrameStroke.Parent = ProgressBarFrame

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.Position = UDim2.new(0, 0, 0, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ProgressBar.ZIndex = 22
ProgressBar.Parent = ProgressBarFrame
local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(0, 6)
ProgressBarCorner.Parent = ProgressBar

local LoadingLabel = Instance.new("TextLabel")
LoadingLabel.Size = UDim2.new(0, 200, 0, 20)
LoadingLabel.Position = UDim2.new(0.5, -100, 0.5, -30)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Loading..."
LoadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingLabel.TextSize = 14
LoadingLabel.Font = Enum.Font.Gotham
LoadingLabel.ZIndex = 21
LoadingLabel.Parent = LoadingFrame

-- Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 190, 0, 20)
notificationFrame.Position = UDim2.new(1, -200, 1, -40)
notificationFrame.BackgroundTransparency = 1
notificationFrame.ZIndex = 15
notificationFrame.Parent = screenGui

local function showNotification(message, color)
    local success, err = pcall(function()
        local notificationLabel = Instance.new("TextLabel")
        notificationLabel.Size = UDim2.new(1, 0, 1, 0)
        notificationLabel.BackgroundTransparency = 1
        notificationLabel.Text = message
        notificationLabel.TextColor3 = color
        notificationLabel.TextSize = 12
        notificationLabel.Font = Enum.Font.Gotham
        notificationLabel.TextXAlignment = Enum.TextXAlignment.Right
        notificationLabel.ZIndex = 15
        notificationLabel.Parent = notificationFrame
        game:GetService("Debris"):AddItem(notificationLabel, 3)
        print("Notification: " .. message)
    end)
    if not success then
        warn("Notification error: " .. tostring(err))
    end
end

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 240)
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Default theme: Tối
frame.BackgroundTransparency = 1 -- Start hidden
frame.Visible = false
frame.ZIndex = 10
frame.Active = true
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 1.5
frameStroke.Color = Color3.fromRGB(255, 255, 255)
frameStroke.Transparency = 0.7
frameStroke.Parent = frame
print("Frame created at: " .. tostring(frame.Position))

-- Drag Area
local DragArea = Instance.new("Frame")
DragArea.Size = UDim2.new(1, 0, 0, 32)
DragArea.BackgroundTransparency = 1
DragArea.ZIndex = 12
DragArea.Parent = frame

-- Title Label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.9, -20, 0, 24)
title.Position = UDim2.new(0.05, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = translations.en.title
title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Default theme: Tối
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = frame

-- Close Button (X)
local closeXButton = Instance.new("TextButton")
closeXButton.Size = UDim2.new(0, 20, 0, 20)
closeXButton.Position = UDim2.new(1, -28, 0, 8)
closeXButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeXButton.BackgroundTransparency = 0.4
closeXButton.Text = "X"
closeXButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeXButton.Font = Enum.Font.GothamBold
closeXButton.TextSize = 12
closeXButton.ZIndex = 13
closeXButton.Parent = frame
local closeXCorner = Instance.new("UICorner")
closeXCorner.CornerRadius = UDim.new(0, 6)
closeXCorner.Parent = closeXButton

-- Sidebar Frame
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Default theme: Tối
sidebar.BackgroundTransparency = 0.6
sidebar.ZIndex = 10
sidebar.Parent = frame
local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 240, 1, -60)
contentFrame.Position = UDim2.new(0, 96, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 10
contentFrame.Parent = frame

-- Sidebar Buttons
local homeButton = Instance.new("TextButton")
homeButton.Size = UDim2.new(1, -10, 0, 32)
homeButton.Position = UDim2.new(0, 5, 0, 5)
homeButton.Text = translations.en.home
homeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
homeButton.BackgroundTransparency = 0.3
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.Font = Enum.Font.Gotham
homeButton.TextSize = 14
homeButton.ZIndex = 11
homeButton.Parent = sidebar
local homeCorner = Instance.new("UICorner")
homeCorner.CornerRadius = UDim.new(0, 6)
homeCorner.Parent = homeButton
local homeStroke = Instance.new("UIStroke")
homeStroke.Thickness = 1
homeStroke.Color = Color3.fromRGB(255, 255, 255)
homeStroke.Transparency = 0.5
homeStroke.Parent = homeButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(1, -10, 0, 32)
settingsButton.Position = UDim2.new(0, 5, 0, 42)
settingsButton.Text = translations.en.settings
settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsButton.BackgroundTransparency = 0.4
settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsButton.Font = Enum.Font.Gotham
settingsButton.TextSize = 14
settingsButton.ZIndex = 11
settingsButton.Parent = sidebar
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsButton
local settingsStroke = Instance.new("UIStroke")
settingsStroke.Thickness = 1
settingsStroke.Color = Color3.fromRGB(255, 255, 255)
settingsStroke.Transparency = 1
settingsStroke.Parent = settingsButton

local musicButton = Instance.new("TextButton")
musicButton.Size = UDim2.new(1, -10, 0, 32)
musicButton.Position = UDim2.new(0, 5, 0, 79)
musicButton.Text = translations.en.music
musicButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
musicButton.BackgroundTransparency = 0.4
musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
musicButton.Font = Enum.Font.Gotham
musicButton.TextSize = 14
musicButton.ZIndex = 11
musicButton.Parent = sidebar
local musicCorner = Instance.new("UICorner")
musicCorner.CornerRadius = UDim.new(0, 6)
musicCorner.Parent = musicButton
local musicStroke = Instance.new("UIStroke")
musicStroke.Thickness = 1
musicStroke.Color = Color3.fromRGB(255, 255, 255)
musicStroke.Transparency = 1
musicStroke.Parent = musicButton

-- Content: Home
local homeContent = Instance.new("Frame")
homeContent.Size = UDim2.new(1, 0, 1, 0)
homeContent.BackgroundTransparency = 1
homeContent.ZIndex = 10
homeContent.Parent = contentFrame
homeContent.Visible = true

local speedXFrame = Instance.new("Frame")
speedXFrame.Size = UDim2.new(0, 190, 0, 80)
speedXFrame.Position = UDim2.new(0, 25, 0, 20)
speedXFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedXFrame.BackgroundTransparency = 0.4
speedXFrame.ZIndex = 11
speedXFrame.Parent = homeContent
local speedXCorner = Instance.new("UICorner")
speedXCorner.CornerRadius = UDim.new(0, 8)
speedXCorner.Parent = speedXFrame
local speedXStroke = Instance.new("UIStroke")
speedXStroke.Thickness = 1
speedXStroke.Color = Color3.fromRGB(255, 255, 255)
speedXStroke.Transparency = 0.5
speedXStroke.Parent = speedXFrame

local speedXTitle = Instance.new("TextLabel")
speedXTitle.Size = UDim2.new(0, 180, 0, 20)
speedXTitle.Position = UDim2.new(0, 5, 0, 5)
speedXTitle.BackgroundTransparency = 1
speedXTitle.Text = "Speed Up X"
speedXTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedXTitle.TextSize = 14
speedXTitle.Font = Enum.Font.GothamBold
speedXTitle.TextXAlignment = Enum.TextXAlignment.Left
speedXTitle.ZIndex = 12
speedXTitle.Parent = speedXFrame

local speedXDesc = Instance.new("TextLabel")
speedXDesc.Size = UDim2.new(0, 180, 0, 20)
speedXDesc.Position = UDim2.new(0, 5, 0, 25)
speedXDesc.BackgroundTransparency = 1
speedXDesc.Text = "Boost game performance"
speedXDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
speedXDesc.TextSize = 12
speedXDesc.Font = Enum.Font.Gotham
speedXDesc.TextXAlignment = Enum.TextXAlignment.Left
speedXDesc.ZIndex = 12
speedXDesc.Parent = speedXFrame

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 180, 0, 25)
speedButton.Position = UDim2.new(0, 5, 0, 50)
speedButton.Text = "Execute"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
speedButton.BackgroundTransparency = 0.4
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Gotham
speedButton.TextSize = 14
speedButton.ZIndex = 12
speedButton.Parent = speedXFrame
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

local noLagFrame = Instance.new("Frame")
noLagFrame.Size = UDim2.new(0, 190, 0, 80)
noLagFrame.Position = UDim2.new(0, 25, 0, 110)
noLagFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
noLagFrame.BackgroundTransparency = 0.4
noLagFrame.ZIndex = 11
noLagFrame.Parent = homeContent
local noLagCorner = Instance.new("UICorner")
noLagCorner.CornerRadius = UDim.new(0, 8)
noLagCorner.Parent = noLagFrame
local noLagStroke = Instance.new("UIStroke")
noLagStroke.Thickness = 1
noLagStroke.Color = Color3.fromRGB(255, 255, 255)
noLagStroke.Transparency = 0.5
noLagStroke.Parent = noLagFrame

local noLagTitle = Instance.new("TextLabel")
noLagTitle.Size = UDim2.new(0, 180, 0, 20)
noLagTitle.Position = UDim2.new(0, 5, 0, 5)
noLagTitle.BackgroundTransparency = 1
noLagTitle.Text = "No Lag"
noLagTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagTitle.TextSize = 14
noLagTitle.Font = Enum.Font.GothamBold
noLagTitle.TextXAlignment = Enum.TextXAlignment.Left
noLagTitle.ZIndex = 12
noLagTitle.Parent = noLagFrame

local noLagDesc = Instance.new("TextLabel")
noLagDesc.Size = UDim2.new(0, 180, 0, 20)
noLagDesc.Position = UDim2.new(0, 5, 0, 25)
noLagDesc.BackgroundTransparency = 1
noLagDesc.Text = "Reduce game lag"
noLagDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
noLagDesc.TextSize = 12
noLagDesc.Font = Enum.Font.Gotham
noLagDesc.TextXAlignment = Enum.TextXAlignment.Left
noLagDesc.ZIndex = 12
noLagDesc.Parent = noLagFrame

local noLagButton = Instance.new("TextButton")
noLagButton.Size = UDim2.new(0, 180, 0, 25)
noLagButton.Position = UDim2.new(0, 5, 0, 50)
noLagButton.Text = "Execute"
noLagButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
noLagButton.BackgroundTransparency = 0.4
noLagButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noLagButton.Font = Enum.Font.Gotham
noLagButton.TextSize = 14
noLagButton.ZIndex = 12
noLagButton.Parent = noLagFrame
local noLagCorner = Instance.new("UICorner")
noLagCorner.CornerRadius = UDim.new(0, 6)
noLagCorner.Parent = noLagButton

-- Content: Settings
local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.ZIndex = 10
settingsContent.Parent = contentFrame
settingsContent.Visible = false

local themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(0, 190, 0, 80)
themeFrame.Position = UDim2.new(0, 25, 0, 20)
themeFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
themeFrame.BackgroundTransparency = 0.4
themeFrame.ZIndex = 11
themeFrame.Parent = settingsContent
local themeCorner = Instance.new("UICorner")
themeCorner.CornerRadius = UDim.new(0, 8)
themeCorner.Parent = themeFrame
local themeStroke = Instance.new("UIStroke")
themeStroke.Thickness = 1
themeStroke.Color = Color3.fromRGB(255, 255, 255)
themeStroke.Transparency = 0.5
themeStroke.Parent = themeFrame

local themeTitle = Instance.new("TextLabel")
themeTitle.Size = UDim2.new(0, 180, 0, 20)
themeTitle.Position = UDim2.new(0, 5, 0, 5)
themeTitle.BackgroundTransparency = 1
themeTitle.Text = translations.en.theme_title
themeTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
themeTitle.TextSize = 14
themeTitle.Font = Enum.Font.GothamBold
themeTitle.TextXAlignment = Enum.TextXAlignment.Left
themeTitle.ZIndex = 12
themeTitle.Parent = themeFrame

local themeDesc = Instance.new("TextLabel")
themeDesc.Size = UDim2.new(0, 180, 0, 20)
themeDesc.Position = UDim2.new(0, 5, 0, 25)
themeDesc.BackgroundTransparency = 1
themeDesc.Text = translations.en.theme_desc
themeDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
themeDesc.TextSize = 12
themeDesc.Font = Enum.Font.Gotham
themeDesc.TextXAlignment = Enum.TextXAlignment.Left
themeDesc.ZIndex = 12
themeDesc.Parent = themeFrame

local themeButton = Instance.new("TextButton")
themeButton.Size = UDim2.new(0, 180, 0, 25)
themeButton.Position = UDim2.new(0, 5, 0, 50)
themeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
themeButton.BackgroundTransparency = 0.4
themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
themeButton.Font = Enum.Font.Gotham
themeButton.TextSize = 14
themeButton.ZIndex = 12
themeButton.Parent = themeFrame
local themeButtonCorner = Instance.new("UICorner")
themeButtonCorner.CornerRadius = UDim.new(0, 6)
themeButtonCorner.Parent = themeButton

local languageFrame = Instance.new("Frame")
languageFrame.Size = UDim2.new(0, 190, 0, 80)
languageFrame.Position = UDim2.new(0, 25, 0, 110)
languageFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
languageFrame.BackgroundTransparency = 0.4
languageFrame.ZIndex = 11
languageFrame.Parent = settingsContent
local languageCorner = Instance.new("UICorner")
languageCorner.CornerRadius = UDim.new(0, 8)
languageCorner.Parent = languageFrame
local languageStroke = Instance.new("UIStroke")
languageStroke.Thickness = 1
languageStroke.Color = Color3.fromRGB(255, 255, 255)
languageStroke.Transparency = 0.5
languageStroke.Parent = languageFrame

local languageTitle = Instance.new("TextLabel")
languageTitle.Size = UDim2.new(0, 180, 0, 20)
languageTitle.Position = UDim2.new(0, 5, 0, 5)
languageTitle.BackgroundTransparency = 1
languageTitle.Text = translations.en.lang_title
languageTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
languageTitle.TextSize = 14
languageTitle.Font = Enum.Font.GothamBold
languageTitle.TextXAlignment = Enum.TextXAlignment.Left
languageTitle.ZIndex = 12
languageTitle.Parent = languageFrame

local languageDesc = Instance.new("TextLabel")
languageDesc.Size = UDim2.new(0, 180, 0, 20)
languageDesc.Position = UDim2.new(0, 5, 0, 25)
languageDesc.BackgroundTransparency = 1
languageDesc.Text = translations.en.lang_desc
languageDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
languageDesc.TextSize = 12
languageDesc.Font = Enum.Font.Gotham
languageDesc.TextXAlignment = Enum.TextXAlignment.Left
languageDesc.ZIndex = 12
languageDesc.Parent = languageFrame

local languageButton = Instance.new("TextButton")
languageButton.Size = UDim2.new(0, 180, 0, 25)
languageButton.Position = UDim2.new(0, 5, 0, 50)
languageButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
languageButton.BackgroundTransparency = 0.4
languageButton.TextColor3 = Color3.fromRGB(255, 255, 255)
languageButton.Font = Enum.Font.Gotham
languageButton.TextSize = 14
languageButton.ZIndex = 12
languageButton.Parent = languageFrame
local languageButtonCorner = Instance.new("UICorner")
languageButtonCorner.CornerRadius = UDim.new(0, 6)
languageButtonCorner.Parent = languageButton

-- Content: Misic
local musicContent = Instance.new("Frame")
musicContent.Size = UDim2.new(1, 0, 1, 0)
musicContent.BackgroundTransparency = 1
musicContent.ZIndex = 10
musicContent.Parent = contentFrame
musicContent.Visible = false

local speedControlFrame = Instance.new("Frame")
speedControlFrame.Size = UDim2.new(0, 190, 0, 80)
speedControlFrame.Position = UDim2.new(0, 25, 0, 20)
speedControlFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedControlFrame.BackgroundTransparency = 0.4
speedControlFrame.ZIndex = 11
speedControlFrame.Parent = musicContent
local speedControlCorner = Instance.new("UICorner")
speedControlCorner.CornerRadius = UDim.new(0, 8)
speedControlCorner.Parent = speedControlFrame
local speedControlStroke = Instance.new("UIStroke")
speedControlStroke.Thickness = 1
speedControlStroke.Color = Color3.fromRGB(255, 255, 255)
speedControlStroke.Transparency = 0.5
speedControlStroke.Parent = speedControlFrame

local speedControlTitle = Instance.new("TextLabel")
speedControlTitle.Size = UDim2.new(0, 180, 0, 20)
speedControlTitle.Position = UDim2.new(0, 5, 0, 5)
speedControlTitle.BackgroundTransparency = 1
speedControlTitle.Text = translations.en.speed_title
speedControlTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedControlTitle.TextSize = 14
speedControlTitle.Font = Enum.Font.GothamBold
speedControlTitle.TextXAlignment = Enum.TextXAlignment.Left
speedControlTitle.ZIndex = 12
speedControlTitle.Parent = speedControlFrame

local speedControlDesc = Instance.new("TextLabel")
speedControlDesc.Size = UDim2.new(0, 180, 0, 20)
speedControlDesc.Position = UDim2.new(0, 5, 0, 25)
speedControlDesc.BackgroundTransparency = 1
speedControlDesc.Text = translations.en.speed_desc
speedControlDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
speedControlDesc.TextSize = 12
speedControlDesc.Font = Enum.Font.Gotham
speedControlDesc.TextXAlignment = Enum.TextXAlignment.Left
speedControlDesc.ZIndex = 12
speedControlDesc.Parent = speedControlFrame

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 100, 0, 25)
speedInput.Position = UDim2.new(0, 5, 0, 50)
speedInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedInput.BackgroundTransparency = 0.4
speedInput.Text = "16"
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.PlaceholderText = "Enter speed"
speedInput.ZIndex = 12
speedInput.Parent = speedControlFrame
local speedInputCorner = Instance.new("UICorner")
speedInputCorner.CornerRadius = UDim.new(0, 6)
speedInputCorner.Parent = speedInput

local applySpeedButton = Instance.new("TextButton")
applySpeedButton.Size = UDim2.new(0, 70, 0, 25)
applySpeedButton.Position = UDim2.new(0, 110, 0, 50)
applySpeedButton.Text = translations.en.speed_button
applySpeedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
applySpeedButton.BackgroundTransparency = 0.4
applySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedButton.Font = Enum.Font.Gotham
applySpeedButton.TextSize = 14
applySpeedButton.ZIndex = 12
applySpeedButton.Parent = speedControlFrame
local applySpeedCorner = Instance.new("UICorner")
applySpeedCorner.CornerRadius = UDim.new(0, 6)
applySpeedCorner.Parent = applySpeedButton

local infiniteJumpFrame = Instance.new("Frame")
infiniteJumpFrame.Size = UDim2.new(0, 190, 0, 80)
infiniteJumpFrame.Position = UDim2.new(0, 25, 0, 110)
infiniteJumpFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
infiniteJumpFrame.BackgroundTransparency = 0.4
infiniteJumpFrame.ZIndex = 11
infiniteJumpFrame.Parent = musicContent
local infiniteJumpCorner = Instance.new("UICorner")
infiniteJumpCorner.CornerRadius = UDim.new(0, 8)
infiniteJumpCorner.Parent = infiniteJumpFrame
local infiniteJumpStroke = Instance.new("UIStroke")
infiniteJumpStroke.Thickness = 1
infiniteJumpStroke.Color = Color3.fromRGB(255, 255, 255)
infiniteJumpStroke.Transparency = 0.5
infiniteJumpStroke.Parent = infiniteJumpFrame

local infiniteJumpTitle = Instance.new("TextLabel")
infiniteJumpTitle.Size = UDim2.new(0, 180, 0, 20)
infiniteJumpTitle.Position = UDim2.new(0, 5, 0, 5)
infiniteJumpTitle.BackgroundTransparency = 1
infiniteJumpTitle.Text = translations.en.jump_title
infiniteJumpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteJumpTitle.TextSize = 14
infiniteJumpTitle.Font = Enum.Font.GothamBold
infiniteJumpTitle.TextXAlignment = Enum.TextXAlignment.Left
infiniteJumpTitle.ZIndex = 12
infiniteJumpTitle.Parent = infiniteJumpFrame

local infiniteJumpDesc = Instance.new("TextLabel")
infiniteJumpDesc.Size = UDim2.new(0, 180, 0, 20)
infiniteJumpDesc.Position = UDim2.new(0, 5, 0, 25)
infiniteJumpDesc.BackgroundTransparency = 1
infiniteJumpDesc.Text = translations.en.jump_desc
infiniteJumpDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
infiniteJumpDesc.TextSize = 12
infiniteJumpDesc.Font = Enum.Font.Gotham
infiniteJumpDesc.TextXAlignment = Enum.TextXAlignment.Left
infiniteJumpDesc.ZIndex = 12
infiniteJumpDesc.Parent = infiniteJumpFrame

local infiniteJumpButton = Instance.new("TextButton")
infiniteJumpButton.Size = UDim2.new(0, 180, 0, 25)
infiniteJumpButton.Position = UDim2.new(0, 5, 0, 50)
infiniteJumpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
infiniteJumpButton.BackgroundTransparency = 0.4
infiniteJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infiniteJumpButton.Font = Enum.Font.Gotham
infiniteJumpButton.TextSize = 14
infiniteJumpButton.ZIndex = 12
infiniteJumpButton.Parent = infiniteJumpFrame
local infiniteJumpButtonCorner = Instance.new("UICorner")
infiniteJumpButtonCorner.CornerRadius = UDim.new(0, 6)
infiniteJumpButtonCorner.Parent = infiniteJumpButton

-- Theme and Language Settings
local currentTheme = "Tối" -- Default theme
local currentLanguage = "en" -- Default language
local themes = {
    {Name = "Sáng", Color = Color3.fromRGB(220, 220, 220), TextColor = Color3.fromRGB(0, 0, 0)},
    {Name = "Tối", Color = Color3.fromRGB(20, 20, 20), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Xanh", Color = Color3.fromRGB(0, 80, 120), TextColor = Color3.fromRGB(255, 255, 255)},
    {Name = "Tím", Color = Color3.fromRGB(80, 0, 120), TextColor = Color3.fromRGB(255, 255, 255)}
}
local languages = {
    {Name = "English", Code = "en"},
    {Name = "Tiếng Việt", Code = "vi"}
}

-- Update UI text based on language
local function updateUIText()
    local success, err = pcall(function()
        title.Text = translations[currentLanguage].title
        homeButton.Text = translations[currentLanguage].home
        settingsButton.Text = translations[currentLanguage].settings
        musicButton.Text = translations[currentLanguage].music
        speedControlTitle.Text = translations[currentLanguage].speed_title
        speedControlDesc.Text = translations[currentLanguage].speed_desc
        infiniteJumpTitle.Text = translations[currentLanguage].jump_title
        infiniteJumpDesc.Text = translations[currentLanguage].jump_desc
        infiniteJumpButton.Text = string.format(translations[currentLanguage].jump_button, infiniteJumpEnabled and "On" or "Off")
        themeTitle.Text = translations[currentLanguage].theme_title
        themeDesc.Text = translations[currentLanguage].theme_desc
        themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
        languageTitle.Text = translations[currentLanguage].lang_title
        languageDesc.Text = translations[currentLanguage].lang_desc
        languageButton.Text = string.format(translations[currentLanguage].lang_button, currentLanguage == "en" and "English" or "Tiếng Việt")
        applySpeedButton.Text = translations[currentLanguage].speed_button
        credit.Text = translations[currentLanguage].credit
        print("UI text updated for language: " .. currentLanguage)
    end)
    if not success then
        warn("Failed to update UI text: " .. tostring(err))
    end
end

-- Initialize UI text
themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
languageButton.Text = string.format(translations[currentLanguage].lang_button, currentLanguage == "en" and "English" or "Tiếng Việt")
updateUIText()

-- Theme Dropdown
local themeDropdown = Instance.new("Frame")
themeDropdown.Size = UDim2.new(0, 100, 0, 96)
themeDropdown.Position = UDim2.new(0, 5, 0, 80)
themeDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
themeDropdown.BackgroundTransparency = 0.5
themeDropdown.Visible = false
themeDropdown.ZIndex = 13
themeDropdown.Parent = themeFrame
local dropdownCorner = Instance.new("UICorner")
dropdownCorner.CornerRadius = UDim.new(0, 6)
dropdownCorner.Parent = themeDropdown

for i, theme in ipairs(themes) do
    local optionButton = Instance.new("TextButton")
    optionButton.Size = UDim2.new(1, -10, 0, 22)
    optionButton.Position = UDim2.new(0, 5, 0, 4 + (i-1)*24)
    optionButton.Text = theme.Name
    optionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    optionButton.BackgroundTransparency = 0.5
    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton.Font = Enum.Font.Gotham
    optionButton.TextSize = 12
    optionButton.ZIndex = 14
    optionButton.Parent = themeDropdown
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 4)
    optionCorner.Parent = optionButton

    optionButton.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            if frame and frame.Parent then
                currentTheme = theme.Name
                themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
                local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
                tween:Play()
                tween.Completed:Connect(function()
                    themeDropdown.Visible = false
                    themeDropdown.Size = UDim2.new(0, 100, 0, 96)
                end)
                frame.BackgroundColor3 = theme.Color
                sidebar.BackgroundColor3 = Color3.new(theme.Color.R * 1.1, theme.Color.G * 1.1, theme.Color.B * 1.1)
                title.TextColor3 = theme.TextColor
                themeButton.TextColor3 = theme.TextColor
                languageButton.TextColor3 = theme.TextColor
                closeXButton.TextColor3 = theme.TextColor
                credit.TextColor3 = theme.TextColor
                homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                print("Theme changed to: " .. theme.Name)
                showNotification(string.format(translations[currentLanguage].theme_notification, theme.Name), Color3.fromRGB(0, 200, 100))
            else
                error("Frame missing")
            end
        end)
        if not success then
            warn("Theme change failed: " .. tostring(err))
        end
    end)
end

themeButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if themeDropdown and themeDropdown.Parent then
            if themeDropdown.Visible then
                local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
                tween:Play()
                tween.Completed:Connect(function()
                    themeDropdown.Visible = false
                    themeDropdown.Size = UDim2.new(0, 100, 0, 96)
                end)
            else
                themeDropdown.Visible = true
                local tween = TweenService:Create(themeDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 96)})
                tween:Play()
            end
            print("Theme dropdown toggled: " .. tostring(themeDropdown.Visible))
        else
            error("Theme dropdown missing")
        end
    end)
    if not success then
        warn("Theme dropdown toggle failed: " .. tostring(err))
    end
end)

-- Language Dropdown
local languageDropdown = Instance.new("Frame")
languageDropdown.Size = UDim2.new(0, 100, 0, 48)
languageDropdown.Position = UDim2.new(0, 5, 0, 80)
languageDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
languageDropdown.BackgroundTransparency = 0.5
languageDropdown.Visible = false
languageDropdown.ZIndex = 13
languageDropdown.Parent = languageFrame
local langDropdownCorner = Instance.new("UICorner")
langDropdownCorner.CornerRadius = UDim.new(0, 6)
langDropdownCorner.Parent = languageDropdown

for i, lang in ipairs(languages) do
    local optionButton = Instance.new("TextButton")
    optionButton.Size = UDim2.new(1, -10, 0, 22)
    optionButton.Position = UDim2.new(0, 5, 0, 4 + (i-1)*24)
    optionButton.Text = lang.Name
    optionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    optionButton.BackgroundTransparency = 0.5
    optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionButton.Font = Enum.Font.Gotham
    optionButton.TextSize = 12
    optionButton.ZIndex = 14
    optionButton.Parent = languageDropdown
    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = UDim.new(0, 4)
    optionCorner.Parent = optionButton

    optionButton.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            currentLanguage = lang.Code
            languageButton.Text = string.format(translations[currentLanguage].lang_button, lang.Name)
            local tween = TweenService:Create(languageDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
            tween:Play()
            tween.Completed:Connect(function()
                languageDropdown.Visible = false
                languageDropdown.Size = UDim2.new(0, 100, 0, 48)
            end)
            updateUIText()
            print("Language changed to: " .. lang.Name)
            showNotification(string.format(translations[currentLanguage].lang_notification, lang.Name), Color3.fromRGB(0, 200, 100))
        end)
        if not success then
            warn("Language change failed: " .. tostring(err))
        end
    end)
end

languageButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        if languageDropdown and languageDropdown.Parent then
            if languageDropdown.Visible then
                local tween = TweenService:Create(languageDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 0)})
                tween:Play()
                tween.Completed:Connect(function()
                    languageDropdown.Visible = false
                    languageDropdown.Size = UDim2.new(0, 100, 0, 48)
                end)
            else
                languageDropdown.Visible = true
                local tween = TweenService:Create(languageDropdown, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 100, 0, 48)})
                tween:Play()
            end
            print("Language dropdown toggled: " .. tostring(languageDropdown.Visible))
        else
            error("Language dropdown missing")
        end
    end)
    if not success then
        warn("Language dropdown toggle failed: " .. tostring(err))
    end
end)

-- Credit Label
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 120, 0, 14)
credit.Position = UDim2.new(1, -128, 1, -18)
credit.BackgroundTransparency = 1
credit.Text = translations.en.credit
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.TextSize = 10
credit.Font = Enum.Font.Gotham
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.ZIndex = 11
credit.Parent = frame
print("Credit added at: " .. tostring(credit.Position))

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 26, 0, 26)
toggleButton.Position = UDim2.new(1, -36, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.BackgroundTransparency = 0.3
toggleButton.Text = ""
toggleButton.ZIndex = 11
toggleButton.Parent = screenGui
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 13)
toggleCorner.Parent = toggleButton

-- Menu Visibility
local menuVisible = true
local function toggleMenu()
    local success, err = pcall(function()
        if frame and frame.Parent then
            menuVisible = not menuVisible
            if menuVisible then
                frame.Visible = true
                local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.5})
                tween:Play()
            else
                local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 1})
                tween:Play()
                tween.Completed:Connect(function()
                    frame.Visible = false
                end)
            end
            toggleButton.BackgroundColor3 = menuVisible and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 200, 200)
            print("Menu toggled: " .. tostring(menuVisible))
        else
            error("Frame missing")
        end
    end)
    if not success then
        warn("Toggle menu failed: " .. tostring(err))
    end
end

-- Sidebar Navigation
local function showHome()
    local success, err = pcall(function()
        if homeContent and settingsContent and musicContent then
            homeContent.Visible = true
            settingsContent.Visible = false
            musicContent.Visible = false
            local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 0.3
            })
            local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
            local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            tween1:Play()
            tween2:Play()
            tween3:Play()
            strokeTween1:Play()
            strokeTween2:Play()
            strokeTween3:Play()
            homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            themeDropdown.Visible = false
            languageDropdown.Visible = false
            print("Home selected")
        else
            error("Content frames missing")
        end
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

local function showSettings()
    local success, err = pcall(function()
        if homeContent and settingsContent and musicContent then
            homeContent.Visible = false
            settingsContent.Visible = true
            musicContent.Visible = false
            local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 0.3
            })
            local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
            local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            tween1:Play()
            tween2:Play()
            tween3:Play()
            strokeTween1:Play()
            strokeTween2:Play()
            strokeTween3:Play()
            homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            themeDropdown.Visible = false
            languageDropdown.Visible = false
            print("Settings selected")
        else
            error("Content frames missing")
        end
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

local function showMusic()
    local success, err = pcall(function()
        if homeContent and settingsContent and musicContent then
            homeContent.Visible = false
            settingsContent.Visible = false
            musicContent.Visible = true
            local tween1 = TweenService:Create(homeButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local tween2 = TweenService:Create(settingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                BackgroundTransparency = 0.4
            })
            local tween3 = TweenService:Create(musicButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                BackgroundTransparency = 0.3
            })
            local strokeTween1 = TweenService:Create(homeStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            local strokeTween2 = TweenService:Create(settingsStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 1})
            local strokeTween3 = TweenService:Create(musicStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Transparency = 0.5})
            tween1:Play()
            tween2:Play()
            tween3:Play()
            strokeTween1:Play()
            strokeTween2:Play()
            strokeTween3:Play()
            homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            settingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            musicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            themeDropdown.Visible = false
            languageDropdown.Visible = false
            print("Misic selected")
        else
            error("Content frames missing")
        end
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

homeButton.MouseButton1Click:Connect(showHome)
settingsButton.MouseButton1Click:Connect(showSettings)
musicButton.MouseButton1Click:Connect(showMusic)

-- Dragging Logic
local isDragging = false
local offset = Vector2.new(0, 0)
local connections = {}

DragArea.InputBegan:Connect(function(input)
    local success, err = pcall(function()
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if frame and frame.Parent and frame.Visible then
                isDragging = true
                local mousePos = Vector2.new(input.Position.X, input.Position.Y)
                local framePos = frame.AbsolutePosition
                offset = mousePos - framePos
                print("Drag started at mouse: " .. tostring(mousePos) .. ", frame: " .. tostring(framePos) .. ", offset: " .. tostring(offset))
            else
                error("Frame not visible or missing")
            end
        end
    end)
    if not success then
        warn("Drag failed: " .. tostring(err))
    end
end)

DragArea.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        print("Drag ended")
    end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    local success, err = pcall(function()
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if frame and frame.Parent then
                local mousePos = Vector2.new(input.Position.X, input.Position.Y)
                local viewportSize = workspace.CurrentCamera.ViewportSize
                local frameSize = frame.AbsoluteSize
                local newPosX = math.clamp(mousePos.X - offset.X, 0, math.max(0, viewportSize.X - frameSize.X))
                local newPosY = math.clamp(mousePos.Y - offset.Y, 0, math.max(0, viewportSize.Y - frameSize.Y))
                frame.Position = UDim2.new(0, newPosX, 0, newPosY)
                print("Frame moved to: " .. tostring(frame.Position))
            else
                isDragging = false
                error("Frame missing")
            end
        end
    end)
    if not success then
        warn("Drag stopped: " .. tostring(err))
    end
end))

-- Speed Control Logic
applySpeedButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local speed = tonumber(speedInput.Text)
        if not speed or speed < 0 or speed > 1000 then
            error("Invalid speed input: " .. speedInput.Text)
        end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            error("Humanoid not found")
        end
        humanoid.WalkSpeed = speed
        print("Speed set to: " .. speed)
        showNotification(string.format(translations[currentLanguage].speed_notification, speed), Color3.fromRGB(0, 200, 100))
    end)
    if not success then
        warn("Speed error: " .. tostring(err))
        showNotification(translations[currentLanguage].speed_error, Color3.fromRGB(255, 80, 80))
    end
end)

-- Infinite Jump Logic
local infiniteJumpEnabled = false
local jumpConnection = nil

local function setupInfiniteJump()
    if jumpConnection then
        jumpConnection:Disconnect()
        jumpConnection = nil
    end
    if infiniteJumpEnabled then
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                humanoid.Jump = true
                print("Jump triggered")
            end)
            table.insert(connections, jumpConnection)
            print("Infinite Jump connection established")
        else
            warn("Cannot enable Infinite Jump: Humanoid not found")
            infiniteJumpEnabled = false
            infiniteJumpButton.Text = string.format(translations[currentLanguage].jump_button, "Off")
            showNotification(translations[currentLanguage].jump_error, Color3.fromRGB(255, 80, 80))
        end
    end
end

infiniteJumpButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        infiniteJumpButton.Text = string.format(translations[currentLanguage].jump_button, infiniteJumpEnabled and "On" or "Off")
        if infiniteJumpEnabled then
            setupInfiniteJump()
            if jumpConnection then
                showNotification(translations[currentLanguage].jump_enabled, Color3.fromRGB(0, 200, 100))
                print("Infinite Jump enabled")
            end
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            showNotification(translations[currentLanguage].jump_disabled, Color3.fromRGB(0, 200, 100))
            print("Infinite Jump disabled")
        end)
    end)
    if not success then
        warn("Infinite Jump error: " .. tostring(err))
        showNotification(translations[currentLanguage].jump_error, Color3.fromRGB(255, 80, 80))
        infiniteJumpEnabled = false
        infiniteJumpButton.Text = string.format(translations[currentLanguage].jump_button, "Off")
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)

-- Handle character respawn
table.insert(connections, player.CharacterAdded:Connect(function(character)
    print("Character respawned")
    if infiniteJumpEnabled then
        task.wait(0.1) -- Wait for Humanoid to load
        setupInfiniteJump()
    end
end))

-- Input Handling (RightShift)
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end))

-- Speed Up X Logic
speedButton.MouseButton1Click:Connect(function()
    local success, err
    local clientName = "Unknown"
    local loadstringSupported = false

    local successDetect, detectErr = pcall(function()
        if typeof(getgenv) == "function" then
            clientName = "KRNL/Fluxus/Synapse"
            loadstringSupported = true
        end
    end)
    if not successDetect then
        warn("Client detection failed: " .. tostring(detectErr))
    end
    print("Detected client: " .. clientName .. ", loadstring supported: " .. tostring(loadstringSupported))

    if not loadstringSupported then
        warn("Client does not support loadstring!")
        showNotification(translations[currentLanguage].client_error, Color3.fromRGB(255, 80, 80))
        return
    end

    success, err = pcall(function()
        local response = game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true)
        if response and response ~= "" then
            loadstring(response)()
            print("Executed Speed Up X script")
        else
            error("Failed to fetch Speed Up X script")
        end
    end)

    if success then
        showNotification(translations[currentLanguage].speedx_notification, Color3.fromRGB(0, 200, 100))
    else
        warn("Error executing Speed Up X: " .. tostring(err))
        showNotification(translations[currentLanguage].speedx_error, Color3.fromRGB(255, 80, 80))
    end
end)

-- No Lag Logic
noLagButton.MouseButton1Click:Connect(function()
    local success, err
    local clientName = "Unknown"
    local loadstringSupported = false

    local successDetect, detectErr = pcall(function()
        if typeof(getgenv) == "function" then
            clientName = "KRNL/Fluxus/Synapse"
            loadstringSupported = true
        end
    end)
    if not successDetect then
        warn("Client detection failed: " .. tostring(detectErr))
    end
    print("Detected client: " .. clientName .. ", loadstring supported: " .. tostring(loadstringSupported))

    if not loadstringSupported then
        warn("Client does not support loadstring!")
        showNotification(translations[currentLanguage].client_error, Color3.fromRGB(255, 80, 80))
        return
    end

    success, err = pcall(function()
        local response = game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua")
        if response and response ~= "" then
            loadstring(response)()
            print("Executed No Lag script")
        else
            error("Failed to fetch No Lag script")
        end
    end)

    if success then
        showNotification(translations[currentLanguage].nolag_notification, Color3.fromRGB(0, 200, 100))
    else
        warn("Error executing No Lag: " .. tostring(err))
        showNotification(translations[currentLanguage].nolag_error, Color3.fromRGB(255, 80, 80))
    end
end)

-- Close X Button Logic
closeXButton.MouseButton1Click:Connect(toggleMenu)

-- Toggle Button Logic
toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Hover Effects
local function addHoverEffect(button)
    local success, err = pcall(function()
        local originalColor = button.BackgroundColor3
        local originalTransparency = button.BackgroundTransparency
        button.MouseEnter:Connect(function()
            if button and button.Parent then
                local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.new(originalColor.R * 0.85, originalColor.G * 0.85, originalColor.B * 0.85),
                    BackgroundTransparency = math.max(0, originalTransparency - 0.1)
                })
                tween:Play()
            end
        end)
        button.MouseLeave:Connect(function()
            if button and button.Parent then
                local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = originalColor,
                    BackgroundTransparency = originalTransparency
                })
                tween:Play()
            end
        end)
    end)
    if not success then
        warn("Hover effect failed for button: " .. tostring(err))
    end
end

addHoverEffect(speedButton)
addHoverEffect(noLagButton)
addHoverEffect(applySpeedButton)
addHoverEffect(infiniteJumpButton)
addHoverEffect(closeXButton)
addHoverEffect(toggleButton)
addHoverEffect(homeButton)
addHoverEffect(settingsButton)
addHoverEffect(musicButton)
addHoverEffect(themeButton)
addHoverEffect(languageButton)
for _, button in ipairs(themeDropdown:GetChildren()) do
    if button:IsA("TextButton") then
        addHoverEffect(button)
    end
end
for _, button in ipairs(languageDropdown:GetChildren()) do
    if button:IsA("TextButton") then
        addHoverEffect(button)
    end
end

-- Loading Animation (Sử dụng RunService thay vì TweenService)
local function startLoading()
    local success, err = pcall(function()
        -- Kiểm tra instance
        if not ProgressBar or not ProgressBar.Parent then
            error("ProgressBar missing or destroyed")
        end
        if not LoadingFrame or not LoadingFrame.Parent then
            error("LoadingFrame missing or destroyed")
        end
        if not frame or not frame.Parent then
            error("Main frame missing or destroyed")
        end
        if not toggleButton or not toggleButton.Parent then
            error("ToggleButton missing or destroyed")
        end

        -- Đặt lại ProgressBar
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        LoadingFrame.Visible = true
        LoadingFrame.BackgroundTransparency = 0.2
        print("Starting loading animation at: " .. tostring(tick()))

        -- Thời gian chạy 5 giây
        local startTime = tick()
        local duration = 5
        local connection

        -- Cập nhật ProgressBar bằng RunService
        connection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / duration, 0, 1)
            ProgressBar.Size = UDim2.new(progress, 0, 1, 0)

            if elapsed >= duration then
                connection:Disconnect()
                print("Loading completed at: " .. tostring(tick()))

                -- Fade out LoadingFrame
                local fadeStart = tick()
                local fadeDuration = 0.5
                local fadeConnection = RunService.RenderStepped:Connect(function()
                    local fadeElapsed = tick() - fadeStart
                    local fadeProgress = math.clamp(fadeElapsed / fadeDuration, 0, 1)
                    LoadingFrame.BackgroundTransparency = 0.2 + (0.8 * fadeProgress)

                    if fadeElapsed >= fadeDuration then
                        fadeConnection:Disconnect()
                        LoadingFrame.Visible = false
                        print("LoadingFrame hidden")

                        -- Hiển thị frame chính
                        frame.Visible = true
                        frame.BackgroundTransparency = 0.5
                        toggleButton.Visible = true
                        print("Main frame and toggle button visible")
                    end
                end)
            end
        end)
    end)
    if not success then
        warn("Loading error: " .. tostring(err))
        showNotification(translations[currentLanguage].loading_error, Color3.fromRGB(255, 80, 80))
        -- Fallback: hiển thị giao diện chính
        if LoadingFrame and LoadingFrame.Parent then
            LoadingFrame.Visible = false
        end
        if frame and frame.Parent then
            frame.Visible = true
            frame.BackgroundTransparency = 0.5
        end
        if toggleButton and toggleButton.Parent then
            toggleButton.Visible = true
        end
    end
end

-- Cleanup on script end
local function cleanup()
    local success, err = pcall(function()
        for _, connection in ipairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        if jumpConnection then
            jumpConnection:Disconnect()
        end
        print("Script connections cleaned up")
    end)
    if not success then
        warn("Cleanup failed: " .. tostring(err))
    end
end

game:BindToClose(cleanup)

-- Start loading
local success, err = pcall(startLoading)
if not success then
    warn("Initialization failed: " .. tostring(err))
    showNotification(translations[currentLanguage].init_error, Color3.fromRGB(255, 80, 80))
    -- Fallback: hiển thị giao diện chính
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame.Visible = false
    end
    if frame and frame.Parent then
        frame.Visible = true
        frame.BackgroundTransparency = 0.5
    end
    if toggleButton and toggleButton.Parent then
        toggleButton.Visible = true
    end
end

-- Debug
print("GrowGardenMenu fully initialized at: " .. tostring(tick()))