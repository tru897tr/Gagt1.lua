-- LocalScript under StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Translations
local translations = {
    en = {
        title = "Grow a Garden",
        home = "Home",
        features = "Features",
        settings = "Settings",
        speed_title = "Walk Speed",
        speed_desc = "Set custom walking speed",
        jump_title = "Infinite Jump",
        jump_desc = "Jump without touching ground",
        theme_title = "Theme",
        theme_desc = "Change interface theme",
        lang_title = "Language",
        lang_desc = "Change interface language",
        speed_button = "Apply",
        jump_button = "Infinite Jump: %s",
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
        loading_error = "Loading failed!",
        init_error = "Initialization failed!"
    },
    vi = {
        title = "Trồng một khu vườn",
        home = "Trang chủ",
        features = "Tính năng",
        settings = "Cài đặt",
        speed_title = "Tốc độ chạy",
        speed_desc = "Đặt tốc độ chạy tùy chỉnh",
        jump_title = "Nhảy vô hạn",
        jump_desc = "Nhảy mà không cần chạm đất",
        theme_title = "Giao diện",
        theme_desc = "Thay đổi giao diện",
        lang_title = "Ngôn ngữ",
        lang_desc = "Thay đổi ngôn ngữ giao diện",
        speed_button = "Áp dụng",
        jump_button = "Nhảy vô hạn: %s",
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
        loading_error = "Tải thất bại!",
        init_error = "Khởi tạo thất bại!"
    }
}

-- GUI Setup
local player = Players.LocalPlayer
local playerGui = nil
local maxAttempts = 30
local attempts = 0

-- Chờ PlayerGui
while not playerGui and attempts < maxAttempts and player.Parent do
    local success, result = pcall(function()
        return player:WaitForChild("PlayerGui", 2)
    end)
    if success and result then
        playerGui = result
        print("PlayerGui found")
        break
    end
    attempts = attempts + 1
    warn("PlayerGui not found, attempt " .. attempts)
    task.wait(1)
end

if not playerGui then
    warn("Failed to find PlayerGui")
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

-- Loading Frame
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingFrame.BackgroundTransparency = 0.2
LoadingFrame.ZIndex = 20
LoadingFrame.Visible = true
LoadingFrame.Parent = screenGui

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

local ProgressBar = Instance.new("Frame")
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
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
    end)
    if not success then
        warn("Notification error: " .. tostring(err))
    end
end

-- Menu Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 240)
frame.Position = UDim2.new(0.5, -170, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Theme: Tối
frame.BackgroundTransparency = 0.5
frame.Visible = false
frame.ZIndex = 10
frame.Active = true
frame.Parent = screenGui
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 14)
frameCorner.Parent = frame

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
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -28, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BackgroundTransparency = 0.4
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 12
closeButton.ZIndex = 13
closeButton.Parent = frame
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 80, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

local featuresButton = Instance.new("TextButton")
featuresButton.Size = UDim2.new(1, -10, 0, 32)
featuresButton.Position = UDim2.new(0, 5, 0, 42)
featuresButton.Text = translations.en.features
featuresButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
featuresButton.BackgroundTransparency = 0.4
featuresButton.TextColor3 = Color3.fromRGB(255, 255, 255)
featuresButton.Font = Enum.Font.Gotham
featuresButton.TextSize = 14
featuresButton.ZIndex = 11
featuresButton.Parent = sidebar
local featuresCorner = Instance.new("UICorner")
featuresCorner.CornerRadius = UDim.new(0, 6)
featuresCorner.Parent = featuresButton

local settingsButton = Instance.new("TextButton")
settingsButton.Size = UDim2.new(1, -10, 0, 32)
settingsButton.Position = UDim2.new(0, 5, 0, 79)
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

-- Content: Home
local homeContent = Instance.new("Frame")
homeContent.Size = UDim2.new(1, 0, 1, 0)
homeContent.BackgroundTransparency = 1
homeContent.ZIndex = 10
homeContent.Parent = contentFrame
homeContent.Visible = true

-- Content: Features
local featuresContent = Instance.new("Frame")
featuresContent.Size = UDim2.new(1, 0, 1, 0)
featuresContent.BackgroundTransparency = 1
featuresContent.ZIndex = 10
featuresContent.Parent = contentFrame
featuresContent.Visible = false

local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(0, 190, 0, 80)
speedFrame.Position = UDim2.new(0, 25, 0, 20)
speedFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedFrame.BackgroundTransparency = 0.4
speedFrame.ZIndex = 11
speedFrame.Parent = featuresContent
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedFrame

local speedTitle = Instance.new("TextLabel")
speedTitle.Size = UDim2.new(0, 180, 0, 20)
speedTitle.Position = UDim2.new(0, 5, 0, 5)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = translations.en.speed_title
speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTitle.TextSize = 14
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextXAlignment = Enum.TextXAlignment.Left
speedTitle.ZIndex = 12
speedTitle.Parent = speedFrame

local speedDesc = Instance.new("TextLabel")
speedDesc.Size = UDim2.new(0, 180, 0, 20)
speedDesc.Position = UDim2.new(0, 5, 0, 25)
speedDesc.BackgroundTransparency = 1
speedDesc.Text = translations.en.speed_desc
speedDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
speedDesc.TextSize = 12
speedDesc.Font = Enum.Font.Gotham
speedDesc.TextXAlignment = Enum.TextXAlignment.Left
speedDesc.ZIndex = 12
speedDesc.Parent = speedFrame

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
speedInput.Parent = speedFrame
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
applySpeedButton.Parent = speedFrame
local applySpeedCorner = Instance.new("UICorner")
applySpeedCorner.CornerRadius = UDim.new(0, 6)
applySpeedCorner.Parent = applySpeedButton

local jumpFrame = Instance.new("Frame")
jumpFrame.Size = UDim2.new(0, 190, 0, 80)
jumpFrame.Position = UDim2.new(0, 25, 0, 110)
jumpFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
jumpFrame.BackgroundTransparency = 0.4
jumpFrame.ZIndex = 11
jumpFrame.Parent = featuresContent
local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 8)
jumpCorner.Parent = jumpFrame

local jumpTitle = Instance.new("TextLabel")
jumpTitle.Size = UDim2.new(0, 180, 0, 20)
jumpTitle.Position = UDim2.new(0, 5, 0, 5)
jumpTitle.BackgroundTransparency = 1
jumpTitle.Text = translations.en.jump_title
jumpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpTitle.TextSize = 14
jumpTitle.Font = Enum.Font.GothamBold
jumpTitle.TextXAlignment = Enum.TextXAlignment.Left
jumpTitle.ZIndex = 12
jumpTitle.Parent = jumpFrame

local jumpDesc = Instance.new("TextLabel")
jumpDesc.Size = UDim2.new(0, 180, 0, 20)
jumpDesc.Position = UDim2.new(0, 5, 0, 25)
jumpDesc.BackgroundTransparency = 1
jumpDesc.Text = translations.en.jump_desc
jumpDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
jumpDesc.TextSize = 12
jumpDesc.Font = Enum.Font.Gotham
jumpDesc.TextXAlignment = Enum.TextXAlignment.Left
jumpDesc.ZIndex = 12
jumpDesc.Parent = jumpFrame

local jumpButton = Instance.new("TextButton")
jumpButton.Size = UDim2.new(0, 180, 0, 25)
jumpButton.Position = UDim2.new(0, 5, 0, 50)
jumpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
jumpButton.BackgroundTransparency = 0.4
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.Font = Enum.Font.Gotham
jumpButton.TextSize = 14
jumpButton.ZIndex = 12
jumpButton.Parent = jumpFrame
local jumpButtonCorner = Instance.new("UICorner")
jumpButtonCorner.CornerRadius = UDim.new(0, 6)
jumpButtonCorner.Parent = jumpButton

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

local langFrame = Instance.new("Frame")
langFrame.Size = UDim2.new(0, 190, 0, 80)
langFrame.Position = UDim2.new(0, 25, 0, 110)
langFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
langFrame.BackgroundTransparency = 0.4
langFrame.ZIndex = 11
langFrame.Parent = settingsContent
local langCorner = Instance.new("UICorner")
langCorner.CornerRadius = UDim.new(0, 8)
langCorner.Parent = langFrame

local langTitle = Instance.new("TextLabel")
langTitle.Size = UDim2.new(0, 180, 0, 20)
langTitle.Position = UDim2.new(0, 5, 0, 5)
langTitle.BackgroundTransparency = 1
langTitle.Text = translations.en.lang_title
langTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
langTitle.TextSize = 14
langTitle.Font = Enum.Font.GothamBold
langTitle.TextXAlignment = Enum.TextXAlignment.Left
langTitle.ZIndex = 12
langTitle.Parent = langFrame

local langDesc = Instance.new("TextLabel")
langDesc.Size = UDim2.new(0, 180, 0, 20)
langDesc.Position = UDim2.new(0, 5, 0, 25)
langDesc.BackgroundTransparency = 1
langDesc.Text = translations.en.lang_desc
langDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
langDesc.TextSize = 12
langDesc.Font = Enum.Font.Gotham
langDesc.TextXAlignment = Enum.TextXAlignment.Left
langDesc.ZIndex = 12
langDesc.Parent = langFrame

local langButton = Instance.new("TextButton")
langButton.Size = UDim2.new(0, 180, 0, 25)
langButton.Position = UDim2.new(0, 5, 0, 50)
langButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
langButton.BackgroundTransparency = 0.4
langButton.TextColor3 = Color3.fromRGB(255, 255, 255)
langButton.Font = Enum.Font.Gotham
langButton.TextSize = 14
langButton.ZIndex = 12
langButton.Parent = langFrame
local langButtonCorner = Instance.new("UICorner")
langButtonCorner.CornerRadius = UDim.new(0, 6)
langButtonCorner.Parent = langButton

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

-- Theme and Language Settings
local currentTheme = "Tối"
local currentLanguage = "en"
local themes = {
    {Name = "Sáng", Color = Color3.fromRGB(220, 220, 220), TextColor = Color3.fromRGB(0, 0, 0)},
    {Name = "Tối", Color = Color3.fromRGB(20, 20, 20), TextColor = Color3.fromRGB(255, 255, 255)}
}
local languages = {
    {Name = "English", Code = "en"},
    {Name = "Tiếng Việt", Code = "vi"}
}

-- Update UI Text
local function updateUIText()
    local success, err = pcall(function()
        title.Text = translations[currentLanguage].title
        homeButton.Text = translations[currentLanguage].home
        featuresButton.Text = translations[currentLanguage].features
        settingsButton.Text = translations[currentLanguage].settings
        speedTitle.Text = translations[currentLanguage].speed_title
        speedDesc.Text = translations[currentLanguage].speed_desc
        jumpTitle.Text = translations[currentLanguage].jump_title
        jumpDesc.Text = translations[currentLanguage].jump_desc
        jumpButton.Text = string.format(translations[currentLanguage].jump_button, infiniteJumpEnabled and "On" or "Off")
        themeTitle.Text = translations[currentLanguage].theme_title
        themeDesc.Text = translations[currentLanguage].theme_desc
        themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
        langTitle.Text = translations[currentLanguage].lang_title
        langDesc.Text = translations[currentLanguage].lang_desc
        langButton.Text = string.format(translations[currentLanguage].lang_button, currentLanguage == "en" and "English" or "Tiếng Việt")
        applySpeedButton.Text = translations[currentLanguage].speed_button
        credit.Text = translations[currentLanguage].credit
    end)
    if not success then
        warn("Failed to update UI text: " .. tostring(err))
    end
end

themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
langButton.Text = string.format(translations[currentLanguage].lang_button, currentLanguage == "en" and "English" or "Tiếng Việt")
updateUIText()

-- Theme Logic
themeButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local currentIndex = 1
        for i, theme in ipairs(themes) do
            if theme.Name == currentTheme then
                currentIndex = i
                break
            end
        end
        local nextIndex = currentIndex % #themes + 1
        currentTheme = themes[nextIndex].Name
        frame.BackgroundColor3 = themes[nextIndex].Color
        sidebar.BackgroundColor3 = Color3.new(themes[nextIndex].Color.R * 1.1, themes[nextIndex].Color.G * 1.1, themes[nextIndex].Color.B * 1.1)
        title.TextColor3 = themes[nextIndex].TextColor
        themeButton.TextColor3 = themes[nextIndex].TextColor
        langButton.TextColor3 = themes[nextIndex].TextColor
        closeButton.TextColor3 = themes[nextIndex].TextColor
        credit.TextColor3 = themes[nextIndex].TextColor
        themeButton.Text = string.format(translations[currentLanguage].theme_button, currentTheme)
        showNotification(string.format(translations[currentLanguage].theme_notification, currentTheme), Color3.fromRGB(0, 200, 100))
    end)
    if not success then
        warn("Theme change failed: " .. tostring(err))
    end
end)

-- Language Logic
langButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local currentIndex = 1
        for i, lang in ipairs(languages) do
            if lang.Code == currentLanguage then
                currentIndex = i
                break
            end
        end
        local nextIndex = currentIndex % #languages + 1
        currentLanguage = languages[nextIndex].Code
        langButton.Text = string.format(translations[currentLanguage].lang_button, languages[nextIndex].Name)
        updateUIText()
        showNotification(string.format(translations[currentLanguage].lang_notification, languages[nextIndex].Name), Color3.fromRGB(0, 200, 100))
    end)
    if not success then
        warn("Language change failed: " .. tostring(err))
    end
end)

-- Menu Toggle
local menuVisible = true
local function toggleMenu()
    local success, err = pcall(function()
        if frame and frame.Parent then
            menuVisible = not menuVisible
            frame.Visible = menuVisible
            toggleButton.BackgroundColor3 = menuVisible and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 200, 200)
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
        homeContent.Visible = true
        featuresContent.Visible = false
        settingsContent.Visible = false
        homeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        homeButton.BackgroundTransparency = 0.3
        featuresButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        featuresButton.BackgroundTransparency = 0.4
        settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        settingsButton.BackgroundTransparency = 0.4
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

local function showFeatures()
    local success, err = pcall(function()
        homeContent.Visible = false
        featuresContent.Visible = true
        settingsContent.Visible = false
        homeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        homeButton.BackgroundTransparency = 0.4
        featuresButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        featuresButton.BackgroundTransparency = 0.3
        settingsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        settingsButton.BackgroundTransparency = 0.4
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

local function showSettings()
    local success, err = pcall(function()
        homeContent.Visible = false
        featuresContent.Visible = false
        settingsContent.Visible = true
        homeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        homeButton.BackgroundTransparency = 0.4
        featuresButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        featuresButton.BackgroundTransparency = 0.4
        settingsButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        settingsButton.BackgroundTransparency = 0.3
    end)
    if not success then
        warn("Navigation failed: " .. tostring(err))
    end
end

homeButton.MouseButton1Click:Connect(showHome)
featuresButton.MouseButton1Click:Connect(showFeatures)
settingsButton.MouseButton1Click:Connect(showSettings)

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

-- Speed Control
applySpeedButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        local speed = tonumber(speedInput.Text)
        if not speed or speed < 0 or speed > 1000 then
            error("Invalid speed input")
        end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            error("Humanoid not found")
        end
        humanoid.WalkSpeed = speed
        showNotification(string.format(translations[currentLanguage].speed_notification, speed), Color3.fromRGB(0, 200, 100))
    end)
    if not success then
        warn("Speed error: " .. tostring(err))
        showNotification(translations[currentLanguage].speed_error, Color3.fromRGB(255, 80, 80))
    end
end)

-- Infinite Jump
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
            end)
            table.insert(connections, jumpConnection)
        else
            infiniteJumpEnabled = false
            jumpButton.Text = string.format(translations[currentLanguage].jump_button, "Off")
            showNotification(translations[currentLanguage].jump_error, Color3.fromRGB(255, 80, 80))
        end
    end
end

jumpButton.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        infiniteJumpEnabled = not infiniteJumpEnabled
        jumpButton.Text = string.format(translations[currentLanguage].jump_button, infiniteJumpEnabled and "On" or "Off")
        if infiniteJumpEnabled then
            setupInfiniteJump()
            if jumpConnection then
                showNotification(translations[currentLanguage].jump_enabled, Color3.fromRGB(0, 200, 100))
            end
        else
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
            showNotification(translations[currentLanguage].jump_disabled, Color3.fromRGB(0, 200, 100))
        end
    end)
    if not success then
        warn("Infinite Jump error: " .. tostring(err))
        showNotification(translations[currentLanguage].jump_error, Color3.fromRGB(255, 80, 80))
        infiniteJumpEnabled = false
        jumpButton.Text = string.format(translations[currentLanguage].jump_button, "Off")
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
    end
end)

-- Character Respawn
table.insert(connections, player.CharacterAdded:Connect(function(character)
    if infiniteJumpEnabled then
        task.wait(0.1)
        setupInfiniteJump()
    end
end))

-- Input Handling (RightShift)
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end))

-- Close Button
closeButton.MouseButton1Click:Connect(toggleMenu)

-- Toggle Button
toggleButton.MouseButton1Click:Connect(toggleMenu)

-- Hover Effects
local function addHoverEffect(button)
    local success, err = pcall(function()
        local originalColor = button.BackgroundColor3
        local originalTransparency = button.BackgroundTransparency
        button.MouseEnter:Connect(function()
            if button and button.Parent then
                button.BackgroundColor3 = Color3.new(originalColor.R * 0.85, originalColor.G * 0.85, originalColor.B * 0.85)
                button.BackgroundTransparency = math.max(0, originalTransparency - 0.1)
            end
        end)
        button.MouseLeave:Connect(function()
            if button and button.Parent then
                button.BackgroundColor3 = originalColor
                button.BackgroundTransparency = originalTransparency
            end
        end)
    end)
    if not success then
        warn("Hover effect failed: " .. tostring(err))
    end
end

addHoverEffect(applySpeedButton)
addHoverEffect(jumpButton)
addHoverEffect(closeButton)
addHoverEffect(toggleButton)
addHoverEffect(homeButton)
addHoverEffect(featuresButton)
addHoverEffect(settingsButton)
addHoverEffect(themeButton)
addHoverEffect(langButton)

-- Loading Animation (Updated)
local function startLoading()
    local success, err = pcall(function()
        if not ProgressBar or not ProgressBar.Parent then
            error("ProgressBar missing")
        end
        if not LoadingFrame or not LoadingFrame.Parent then
            error("LoadingFrame missing")
        end
        if not frame or not frame.Parent then
            error("Main frame missing")
        end
        if not toggleButton or not toggleButton.Parent then
            error("ToggleButton missing")
        end

        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        LoadingFrame.Visible = true
        LoadingFrame.BackgroundTransparency = 0.2
        print("Starting loading animation at: " .. tostring(tick()))

        local startTime = tick()
        local duration = 5
        local connection

        connection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local progress = math.clamp(elapsed / duration, 0, 1)
            ProgressBar.Size = UDim2.new(progress, 0, 1, 0)

            if elapsed >= duration then
                connection:Disconnect()
                LoadingFrame.Visible = false
                frame.Visible = true
                toggleButton.Visible = true
                print("Loading completed at: " .. tostring(tick()))
            end
        end)
    end)
    if not success then
        warn("Loading error: " .. tostring(err))
        showNotification(translations[currentLanguage].loading_error, Color3.fromRGB(255, 80, 80))
        if LoadingFrame and LoadingFrame.Parent then
            LoadingFrame.Visible = false
        end
        if frame and frame.Parent then
            frame.Visible = true
        end
        if toggleButton and toggleButton.Parent then
            toggleButton.Visible = true
        end
    end
end

-- Cleanup
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
    end)
    if not success then
        warn("Cleanup failed: " .. tostring(err))
    end
end

game:BindToClose(cleanup)

-- Start Loading
local success, err = pcall(startLoading)
if not success then
    warn("Initialization failed: " .. tostring(err))
    showNotification(translations[currentLanguage].init_error, Color3.fromRGB(255, 80, 80))
    if LoadingFrame and LoadingFrame.Parent then
        LoadingFrame.Visible = false
    end
    if frame and frame.Parent then
        frame.Visible = true
    end
    if toggleButton and toggleButton.Parent then
        toggleButton.Visible = true
    end
end