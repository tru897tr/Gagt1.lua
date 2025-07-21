-- Script Auto Buy Seeds/Gear với nút bật/tắt UI bằng icon trên điện thoại
-- Lưu ý: Sử dụng script này có thể vi phạm điều khoản của Roblox. Hãy sử dụng cẩn thận!

local RS = game:GetService("ReplicatedStorage")
local PLS = game:GetService("Players")
local LP = PLS.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Danh sách hạt giống và trang bị (cập nhật theo shop trong game)
local SeedList = {
    {Name = "Basic Seed", Price = 4000},
    {Name = "Golden Seed", Price = 10000},
    {Name = "Rare Seed", Price = 25000}
}
local GearList = {
    {Name = "Watering Can", Price = 5000},
    {Name = "Fertilizer", Price = 8000},
    {Name = "Super Shovel", Price = 15000}
}

-- Cấu hình
local _C = {
    Enabled = false, -- Trạng thái auto buy
    Category = "Seeds", -- Danh mục mặc định
    SelectedItem = SeedList[1], -- Mục mặc định
    DelayMin = 1.5, -- Độ trễ tối thiểu
    DelayMax = 2.5, -- Độ trễ tối đa
    AntiCheatCheck = true, -- Kiểm tra chống gian lận
    Client = "Unknown", -- Client đang sử dụng
    UIVisible = false -- UI ẩn mặc định
}

-- Hàm phát hiện client
local function detectClient()
    local clientName = "Unknown"
    local success, result = pcall(function()
        if syn then return "Synapse X"
        elseif Krnl then return "KRNL"
        elseif getgenv and getgenv().Fluxus then return "Fluxus"
        elseif getgenv and getgenv().Arceus then return "Arceus X"
        elseif getexecutorname then return getexecutorname()
        elseif identifyexecutor then return identifyexecutor()
        else return "Unknown"
        end
    end)
    if success then clientName = result end
    return clientName
end
_C.Client = detectClient()
print("Client phát hiện: " .. _C.Client)

-- Tìm remote mua hạt giống và trang bị
local function getRemotes()
    local success, result = pcall(function()
        local ge = RS:FindFirstChild("GameEvents")
        if ge then
            return {
                SeedRemote = ge:FindFirstChild("PurchaseSeed"),
                GearRemote = ge:FindFirstChild("PurchaseGear")
            }
        end
        return nil
    end)
    if not success or not result or not result.SeedRemote or not result.GearRemote then
        warn("Lỗi: Không tìm thấy remote (PurchaseSeed hoặc PurchaseGear). Kiểm tra ReplicatedStorage!")
        return nil
    end
    return result
end
local Remotes = getRemotes()

if not Remotes then
    warn("Script dừng do không tìm thấy remote!")
    return
end

-- Kiểm tra tiền tệ (giả định)
local function checkCurrency()
    local success, currency = pcall(function()
        return LP:FindFirstChild("leaderstats") and LP.leaderstats:FindFirstChild("Coins")
    end)
    if success and currency and currency.Value >= _C.SelectedItem.Price then
        return true
    end
    warn("Lỗi: Không đủ tiền để mua " .. _C.SelectedItem.Name .. " (" .. _C.SelectedItem.Price .. ")")
    return false
end

-- Tạo UI
local function initGui()
    local sg
    local success, err = pcall(function()
        sg = Instance.new("ScreenGui")
        sg.Name = "SG_" .. math.random(100000, 999999)
        -- Thử CoreGui trước, sau đó PlayerGui
        sg.Parent = game:GetService("CoreGui")
        if not sg.Parent then
            sg.Parent = LP:WaitForChild("PlayerGui", 5)
        end
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
        sg.Enabled = _C.UIVisible -- Ẩn mặc định
        print("UI được tạo tại: " .. (sg.Parent == game:GetService("CoreGui") and "CoreGui" or "PlayerGui"))
    end)
    if not success or not sg.Parent then
        warn("Lỗi khi tạo ScreenGui: " .. tostring(err))
        return nil
    end

    -- Tạo icon bật/tắt UI cho điện thoại
    local toggleIcon = Instance.new("ImageButton")
    toggleIcon.Size = UDim2.new(0, 50, 0, 50) -- Kích thước nhỏ vừa phải
    toggleIcon.Position = UDim2.new(1, -60, 0, 10) -- Góc trên bên phải
    toggleIcon.BackgroundTransparency = 1
    toggleIcon.Image = "rbxassetid://1234567890" -- Thay bằng ImageId của item
    toggleIcon.ZIndex = 200
    toggleIcon.Parent = sg
    print("Icon bật/tắt UI được tạo")

    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(0, 220, 0, 240)
    fr.Position = UDim2.new(0.5, -110, 0.1, 0)
    fr.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    fr.BorderSizePixel = 0
    fr.BackgroundTransparency = 0.1
    fr.ZIndex = 100
    fr.Parent = sg

    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 10)
    uic.Parent = fr

    local uig = Instance.new("UIGradient")
    uig.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
    }
    uig.Rotation = 45
    uig.Parent = fr

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 0, 30)
    title.Position = UDim2.new(0.5, -100, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Auto Buy System"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 101
    title.Parent = fr

    local clientLabel = Instance.new("TextLabel")
    clientLabel.Size = UDim2.new(0, 200, 0, 20)
    clientLabel.Position = UDim2.new(0.5, -100, 0, 40)
    clientLabel.BackgroundTransparency = 1
    clientLabel.Text = "Client: " .. _C.Client
    clientLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    clientLabel.Font = Enum.Font.Gotham
    clientLabel.TextSize = 14
    clientLabel.ZIndex = 101
    clientLabel.Parent = fr

    local categoryLabel = Instance.new("TextLabel")
    categoryLabel.Size = UDim2.new(0, 200, 0, 20)
    categoryLabel.Position = UDim2.new(0.5, -100, 0, 70)
    categoryLabel.BackgroundTransparency = 1
    categoryLabel.Text = "Category: " .. _C.Category
    categoryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    categoryLabel.Font = Enum.Font.Gotham
    categoryLabel.TextSize = 14
    categoryLabel.ZIndex = 101
    categoryLabel.Parent = fr

    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size = UDim2.new(0, 200, 0, 20)
    itemLabel.Position = UDim2.new(0.5, -100, 0, 100)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = "Item: " .. _C.SelectedItem.Name
    itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemLabel.Font = Enum.Font.Gotham
    itemLabel.TextSize = 14
    itemLabel.ZIndex = 101
    itemLabel.Parent = fr

    local categoryBtn = Instance.new("TextButton")
    categoryBtn.Size = UDim2.new(0, 180, 0, 30)
    categoryBtn.Position = UDim2.new(0.5, -90, 0, 130)
    categoryBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    categoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    categoryBtn.Text = "Select Category"
    categoryBtn.Font = Enum.Font.Gotham
    categoryBtn.TextSize = 16
    categoryBtn.ZIndex = 101
    categoryBtn.Parent = fr

    local categoryBtnCorner = Instance.new("UICorner")
    categoryBtnCorner.CornerRadius = UDim.new(0, 8)
    categoryBtnCorner.Parent = categoryBtn

    local selectBtn = Instance.new("TextButton")
    selectBtn.Size = UDim2.new(0, 180, 0, 30)
    selectBtn.Position = UDim2.new(0.5, -90, 0, 170)
    selectBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    selectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectBtn.Text = "Select Item"
    selectBtn.Font = Enum.Font.Gotham
    selectBtn.TextSize = 16
    selectBtn.ZIndex = 101
    selectBtn.Parent = fr

    local selectBtnCorner = Instance.new("UICorner")
    selectBtnCorner.CornerRadius = UDim.new(0, 8)
    selectBtnCorner.Parent = selectBtn

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 180, 0, 30)
    toggleBtn.Position = UDim2.new(0.5, -90, 0, 210)
    toggleBtn.BackgroundColor3 = _C.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Text = _C.Enabled and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.Gotham
    toggleBtn.TextSize = 16
    toggleBtn.ZIndex = 101
    toggleBtn.Parent = fr

    local toggleBtnCorner = Instance.new("UICorner")
    toggleBtnCorner.CornerRadius = UDim.new(0, 8)
    toggleBtnCorner.Parent = toggleBtn

    -- Hiệu ứng mờ dần
    local successTween, errTween = pcall(function()
        fr.BackgroundTransparency = 1
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(fr, tweenInfo, {BackgroundTransparency = 0.1})
        tween:Play()
    end)
    if not successTween then
        warn("Lỗi khi chạy hiệu ứng mờ dần: " .. tostring(errTween))
        fr.BackgroundTransparency = 0.1
    end

    -- Hiệu ứng hover
    local function applyHover(button)
        button.MouseEnter:Connect(function()
            if not _C.UIVisible then return end
            local successHover, errHover = pcall(function()
                local hoverTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)})
                hoverTween:Play()
            end)
            if not successHover then
                warn("Lỗi hiệu ứng hover: " .. tostring(errHover))
            end
        end)
        button.MouseLeave:Connect(function()
            if not _C.UIVisible then return end
            local successLeave, errLeave = pcall(function()
                local leaveTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {BackgroundColor3 = button == toggleBtn and (_C.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)) or Color3.fromRGB(80, 80, 80)})
                leaveTween:Play()
            end)
            if not successLeave then
                warn("Lỗi hiệu ứng leave: " .. tostring(errLeave))
            end
        end)
    end
    applyHover(categoryBtn)
    applyHover(selectBtn)
    applyHover(toggleBtn)

    -- Làm khung có thể kéo
    local dragging, dragInput, dragStart, startPos
    fr.InputBegan:Connect(function(input)
        if not _C.UIVisible then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = fr.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    fr.InputChanged:Connect(function(input)
        if not _C.UIVisible then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not _C.UIVisible then return end
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            fr.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Xử lý chọn danh mục
    categoryBtn.MouseButton1Click:Connect(function()
        if not _C.UIVisible then return end
        local selectFrame = Instance.new("Frame")
        selectFrame.Size = UDim2.new(0, 180, 0, 70)
        selectFrame.Position = UDim2.new(0.5, -90, 0, 160)
        selectFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        selectFrame.BorderSizePixel = 0
        selectFrame.ZIndex = 102
        selectFrame.Parent = fr

        local selectFrameCorner = Instance.new("UICorner")
        selectFrameCorner.CornerRadius = UDim.new(0, 8)
        selectFrameCorner.Parent = selectFrame

        local categories = {"Seeds", "Gear"}
        for i, cat in ipairs(categories) do
            local catBtn = Instance.new("TextButton")
            catBtn.Size = UDim2.new(0, 160, 0, 25)
            catBtn.Position = UDim2.new(0.5, -80, 0, (i-1) * 30 + 5)
            catBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            catBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            catBtn.Text = cat
            catBtn.Font = Enum.Font.Gotham
            catBtn.TextSize = 14
            catBtn.ZIndex = 103
            catBtn.Parent = selectFrame

            local catBtnCorner = Instance.new("UICorner")
            catBtnCorner.CornerRadius = UDim.new(0, 6)
            catBtnCorner.Parent = catBtn

            catBtn.MouseButton1Click:Connect(function()
                _C.Category = cat
                _C.SelectedItem = cat == "Seeds" and SeedList[1] or GearList[1]
                categoryLabel.Text = "Category: " .. _C.Category
                itemLabel.Text = "Item: " .. _C.SelectedItem.Name
                selectFrame:Destroy()
                print("Đã chọn danh mục: " .. cat)
            end)
        end
    end)

    -- Xử lý chọn mục
    selectBtn.MouseButton1Click:Connect(function()
        if not _C.UIVisible then return end
        local itemList = _C.Category == "Seeds" and SeedList or GearList
        local selectFrame = Instance.new("Frame")
        selectFrame.Size = UDim2.new(0, 180, 0, #itemList * 30 + 10)
        selectFrame.Position = UDim2.new(0.5, -90, 0, 200)
        selectFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        selectFrame.BorderSizePixel = 0
        selectFrame.ZIndex = 102
        selectFrame.Parent = fr

        local selectFrameCorner = Instance.new("UICorner")
        selectFrameCorner.CornerRadius = UDim.new(0, 8)
        selectFrameCorner.Parent = selectFrame

        for i, item in ipairs(itemList) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Size = UDim2.new(0, 160, 0, 25)
            itemBtn.Position = UDim2.new(0.5, -80, 0, (i-1) * 30 + 5)
            itemBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.Text = item.Name .. " (" .. item.Price .. ")"
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.TextSize = 14
            itemBtn.ZIndex = 103
            itemBtn.Parent = selectFrame

            local itemBtnCorner = Instance.new("UICorner")
            itemBtnCorner.CornerRadius = UDim.new(0, 6)
            itemBtnCorner.Parent = itemBtn

            itemBtn.MouseButton1Click:Connect(function()
                _C.SelectedItem = item
                itemLabel.Text = "Item: " .. item.Name
                selectFrame:Destroy()
                print("Đã chọn mục: " .. item.Name)
            end)
        end
    end)

    -- Xử lý nút bật/tắt auto buy
    toggleBtn.MouseButton1Click:Connect(function()
        if not _C.UIVisible then return end
        _C.Enabled = not _C.Enabled
        toggleBtn.Text = _C.Enabled and "ON" or "OFF"
        local successToggle, errToggle = pcall(function()
            local colorTween = TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {BackgroundColor3 = _C.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)})
            colorTween:Play()
        end)
        if not successToggle then
            warn("Lỗi hiệu ứng toggle: " .. tostring(errToggle))
            toggleBtn.BackgroundColor3 = _C.Enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        end
        print("Tính năng: " .. (_C.Enabled and "BẬT" or "TẮT"))
    end)

    -- Xử lý bật/tắt UI bằng icon (điện thoại)
    toggleIcon.MouseButton1Click:Connect(function()
        _C.UIVisible = not _C.UIVisible
        sg.Enabled = _C.UIVisible
        print("UI: " .. (_C.UIVisible and "Hiện" or "Ẩn"))
        if _C.UIVisible then
            local successTween, errTween = pcall(function()
                fr.BackgroundTransparency = 1
                local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local tween = TweenService:Create(fr, tweenInfo, {BackgroundTransparency = 0.1})
                tween:Play()
            end)
            if not successTween then
                warn("Lỗi khi chạy hiệu ứng mờ dần khi hiện UI: " .. tostring(errTween))
                fr.BackgroundTransparency = 0.1
            end
        end
    end)

    -- Bật/tắt UI bằng Right Shift (PC)
    UIS.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            _C.UIVisible = not _C.UIVisible
            sg.Enabled = _C.UIVisible
            print("UI: " .. (_C.UIVisible and "Hiện" or "Ẩn"))
            if _C.UIVisible then
                local successTween, errTween = pcall(function()
                    fr.BackgroundTransparency = 1
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(fr, tweenInfo, {BackgroundTransparency = 0.1})
                    tween:Play()
                end)
                if not successTween then
                    warn("Lỗi khi chạy hiệu ứng mờ dần khi hiện UI: " .. tostring(errTween))
                    fr.BackgroundTransparency = 0.1
                end
            end
        end
    end)

    return sg
end

-- Kiểm tra chống gian lận
local function checkAntiCheat()
    if _C.AntiCheatCheck then
        local success, result = pcall(function()
            return Remotes.SeedRemote:IsDescendantOf(RS) and Remotes.GearRemote:IsDescendantOf(RS)
        end)
        if not success or not result then
            warn("Phát hiện thay đổi remote! Tạm dừng script.")
            _C.Enabled = false
            return false
        end
        local callCount = 0
        local maxCalls = 50
        local startTime = tick()
        RunService.Heartbeat:Connect(function()
            if tick() - startTime > 60 then
                callCount = 0
                startTime = tick()
            end
        end)
        return function()
            if callCount >= maxCalls then
                warn("Giới hạn gọi remote đạt tới! Tạm dừng.")
                _C.Enabled = false
                return false
            end
            callCount = callCount + 1
            return true
        end
    end
    return function() return true end
end
local isSafe = checkAntiCheat()

-- Hàm auto mua
local function autoPurchase()
    while true do
        if _C.Enabled and isSafe() and checkCurrency() then
            local success, err = pcall(function()
                local remote = _C.Category == "Seeds" and Remotes.SeedRemote or Remotes.GearRemote
                remote:FireServer(_C.SelectedItem.Name, _C.SelectedItem.Price)
            end)
            if not success then
                warn("Lỗi khi gọi remote: " .. tostring(err))
                _C.Enabled = false
            end
            wait(math.random(_C.DelayMin * 100, _C.DelayMax * 100) / 100)
        end
        wait(0.2)
    end
end

-- Khởi chạy
local success, err = pcall(function()
    if LP.Parent and (LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")) then
        local gui = initGui()
        if not gui then
            error("Không thể tạo UI!")
        end
        spawn(autoPurchase)
        print("Script khởi chạy thành công trên client: " .. _C.Client)
    else
        error("Không tìm thấy PlayerGui hoặc CoreGui! Thử lại sau khi vào game.")
    end
end)
if not success then
    warn("Lỗi khi khởi chạy script: " .. tostring(err))
end
