-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Validate PlayerGui
if not playerGui then
    warn("PlayerGui not found. Ensure script runs in a valid Roblox environment.")
    return
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "HackHubGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true
gui.Parent = playerGui

-- Create Loading Screen
local function createLoadingScreen()
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.Position = UDim2.new(0, 0, 0, 0)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingFrame.BackgroundTransparency = 0
    loadingFrame.ZIndex = 10
    loadingFrame.Parent = gui

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    gradient.Rotation = 90
    gradient.Parent = loadingFrame

    -- Fade out animation
    local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    local tween = TweenService:Create(loadingFrame, tweenInfo, {BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function()
        loadingFrame:Destroy()
    end)
end

-- Create Main Frame
local function createFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 140)
    frame.Position = UDim2.new(0.5, -90, 0.5, -70)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.ZIndex = 2

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    }
    gradient.Rotation = 45
    gradient.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    return frame
end

-- Create Title
local function createTitle(parent)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Text = "Grow a Garden Hack Hub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = title
end

-- Create Button
local function createButton(name, position, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.ZIndex = 3
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end)

    button.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            warn("Error executing " .. name .. " script: " .. tostring(err))
        else
            print(name .. " script executed successfully!")
        end
    end)
end

-- Create Toggle Button
local function createToggleButton()
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 25, 0, 25)
    toggleButton.Position = UDim2.new(1, -35, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
    toggleButton.Text = ""
    toggleButton.ZIndex = 5
    toggleButton.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = toggleButton

    return toggleButton
end

-- Toggle GUI Visibility
local function toggleGui()
    frame.Visible = not frame.Visible
    toggleButton.BackgroundColor3 = frame.Visible and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
end

-- Initialize GUI
createLoadingScreen()
local frame = createFrame()
frame.Parent = gui
createTitle(frame)
createButton("Speed Up X", UDim2.new(0.05, 0, 0.3, 0), frame, function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
end)
createButton("No Lag", UDim2.new(0.05, 0, 0.6, 0), frame, function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/NoLag-id/No-Lag-HUB/refs/heads/main/Loader/LoaderV1.lua"))()
end)
local toggleButton = createToggleButton()

-- Bind Right Shift to Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

-- Bind Toggle Button Click
toggleButton.MouseButton1Click:Connect(toggleGui)

-- Debug
print("Hack Hub GUI loaded successfully!")
