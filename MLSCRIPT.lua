local REQUIRED_PLACE_ID = 138805779586842

if game.PlaceId ~= REQUIRED_PLACE_ID then
    return
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ClientPackets = ReplicatedStorage
    :WaitForChild("NetworkRemotes")
    :WaitForChild("ClientPackets")

local autohatch = false
local selectedEgg = nil

local autoMerchant = true
local autoGifts = true
local autoSpinWheel = false

local eggList = {
    "Release Egg",
    "Mushroom Egg",
    "Deep Sea Egg",
}

local function hatchEgg()
    local args = {
        [1] = "HatchEgg",
        [2] = {
            ["EggName"] = selectedEgg,
            ["Multi"] = true
        }
    }

    ClientPackets:FireServer(unpack(args))
end

local function merchantPurchase(index)
    local args = {
        [1] = "MerchantPurchase",
        [2] = {
            ["MerchantName"] = "Merchant",
            ["index"] = index
        }
    }

    ClientPackets:FireServer(unpack(args))
end

local function claimPlaytimeGift()
    local args = {
        [1] = "ClaimPlaytimeGift",
        [2] = 1
    }

    ClientPackets:FireServer(unpack(args))
end

local function spinWheel()
    local args = {
        [1] = "SpinWheel",
        [2] = {}
    }

    ClientPackets:FireServer(unpack(args))
end

local hatchLoopRunning = false

local function startHatchLoop()
    if hatchLoopRunning then return end
    hatchLoopRunning = true

    task.spawn(function()
        while autohatch and selectedEgg do
            hatchEgg()
            task.wait(0.1)
        end

        hatchLoopRunning = false
    end)
end

local merchantLoopRunning = false

local function startMerchantLoop()
    if merchantLoopRunning then return end
    merchantLoopRunning = true

    task.spawn(function()
        while autoMerchant do
            for index = 1, 6 do
                if not autoMerchant then break end

                merchantPurchase(index)
                task.wait(5)
            end
        end

        merchantLoopRunning = false
    end)
end

local giftsLoopRunning = false

local function startGiftsLoop()
    if giftsLoopRunning then return end
    giftsLoopRunning = true

    task.spawn(function()
        while autoGifts do
            claimPlaytimeGift()
            task.wait(1)
        end

        giftsLoopRunning = false
    end)
end

local spinWheelLoopRunning = false

local function startSpinWheelLoop()
    if spinWheelLoopRunning then return end
    spinWheelLoopRunning = true

    task.spawn(function()
        while autoSpinWheel do
            spinWheel()
            task.wait(1)
        end

        spinWheelLoopRunning = false
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggHatcherGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local FULL_HEIGHT = 450
local MIN_HEIGHT = 34

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 240, 0, FULL_HEIGHT)
main.Position = UDim2.new(0.5, -120, 0.5, -FULL_HEIGHT / 2)
main.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 70)
mainStroke.Thickness = 1
mainStroke.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -84, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.Text = "Egg Hatcher"
titleLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = titleBar

local stopBtn = Instance.new("TextButton")
stopBtn.Name = "StopBtn"
stopBtn.Size = UDim2.new(0, 26, 0, 26)
stopBtn.Position = UDim2.new(1, -64, 0, 4)
stopBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
stopBtn.AutoButtonColor = false
stopBtn.Text = "X"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16
stopBtn.TextColor3 = Color3.fromRGB(220, 120, 120)
stopBtn.Parent = titleBar

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 6)
stopCorner.Parent = stopBtn

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -32, 0, 4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
minimizeBtn.AutoButtonColor = false
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
minimizeBtn.Parent = titleBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 6)
minimizeCorner.Parent = minimizeBtn

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -46)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = content

local eggLabel = Instance.new("TextLabel")
eggLabel.LayoutOrder = 1
eggLabel.BackgroundTransparency = 1
eggLabel.Size = UDim2.new(1, 0, 0, 16)
eggLabel.Text = "Select Egg"
eggLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
eggLabel.Font = Enum.Font.Gotham
eggLabel.TextSize = 12
eggLabel.TextXAlignment = Enum.TextXAlignment.Left
eggLabel.Parent = content

local eggListFrame = Instance.new("Frame")
eggListFrame.LayoutOrder = 2
eggListFrame.BackgroundTransparency = 1
eggListFrame.Size = UDim2.new(
    1,
    0,
    0,
    #eggList * 34 + (#eggList - 1) * 6
)
eggListFrame.Parent = content

local eggListLayout = Instance.new("UIListLayout")
eggListLayout.SortOrder = Enum.SortOrder.LayoutOrder
eggListLayout.Padding = UDim.new(0, 6)
eggListLayout.Parent = eggListFrame

local eggButtons = {}
local updateToggleVisual

local function refreshEggButtons()
    for _, btn in pairs(eggButtons) do
        local isSelected = btn.Name == selectedEgg

        btn.BackgroundColor3 = isSelected
            and Color3.fromRGB(90, 130, 240)
            or Color3.fromRGB(40, 40, 48)

        btn.TextColor3 = isSelected
            and Color3.fromRGB(255, 255, 255)
            or Color3.fromRGB(200, 200, 205)
    end
end

for i, eggName in ipairs(eggList) do
    local btn = Instance.new("TextButton")

    btn.Name = eggName
    btn.LayoutOrder = i
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.AutoButtonColor = false
    btn.Text = eggName
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(200, 200, 205)
    btn.Parent = eggListFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        selectedEgg = eggName

        refreshEggButtons()
        updateToggleVisual()

        if autohatch then
            startHatchLoop()
        end
    end)

    eggButtons[eggName] = btn
end

refreshEggButtons()

local toggleBtn = Instance.new("TextButton")
toggleBtn.LayoutOrder = 3
toggleBtn.Size = UDim2.new(1, 0, 0, 38)
toggleBtn.AutoButtonColor = false
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleBtn

updateToggleVisual = function()
    if autohatch and selectedEgg then
        toggleBtn.Text = "AUTOHATCH: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)

    elseif autohatch and not selectedEgg then
        toggleBtn.Text = "AUTOHATCH: ON (select an egg)"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 50)

    else
        toggleBtn.Text = "AUTOHATCH: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    end
end

updateToggleVisual()

toggleBtn.MouseButton1Click:Connect(function()
    autohatch = not autohatch

    updateToggleVisual()

    if autohatch and selectedEgg then
        startHatchLoop()
    end
end)

local divider = Instance.new("Frame")
divider.LayoutOrder = 4
divider.Size = UDim2.new(1, 0, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
divider.BorderSizePixel = 0
divider.Parent = content

local featuresLabel = Instance.new("TextLabel")
featuresLabel.LayoutOrder = 5
featuresLabel.BackgroundTransparency = 1
featuresLabel.Size = UDim2.new(1, 0, 0, 16)
featuresLabel.Text = "Other Features"
featuresLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
featuresLabel.Font = Enum.Font.Gotham
featuresLabel.TextSize = 12
featuresLabel.TextXAlignment = Enum.TextXAlignment.Left
featuresLabel.Parent = content

local featureToggleRefreshers = {}

local function createFeatureToggle(
    layoutOrder,
    labelOn,
    labelOff,
    getState,
    setState,
    onEnabled
)
    local btn = Instance.new("TextButton")

    btn.LayoutOrder = layoutOrder
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local function refresh()
        if getState() then
            btn.Text = labelOn
            btn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
        else
            btn.Text = labelOff
            btn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
        end
    end

    btn.MouseButton1Click:Connect(function()
        setState(not getState())
        refresh()

        if getState() then
            onEnabled()
        end
    end)

    refresh()
    table.insert(featureToggleRefreshers, refresh)

    return btn
end

createFeatureToggle(
    6,
    "AUTO MERCHANT: ON",
    "AUTO MERCHANT: OFF",
    function()
        return autoMerchant
    end,
    function(v)
        autoMerchant = v
    end,
    startMerchantLoop
)

createFeatureToggle(
    7,
    "AUTO PLAYTIME GIFTS: ON",
    "AUTO PLAYTIME GIFTS: OFF",
    function()
        return autoGifts
    end,
    function(v)
        autoGifts = v
    end,
    startGiftsLoop
)

createFeatureToggle(
    8,
    "AUTO SPIN WHEEL: ON",
    "AUTO SPIN WHEEL: OFF",
    function()
        return autoSpinWheel
    end,
    function(v)
        autoSpinWheel = v
    end,
    startSpinWheelLoop
)

local minimized = false

minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized

    local targetHeight = minimized
        and MIN_HEIGHT
        or FULL_HEIGHT

    local targetSize = UDim2.new(
        main.Size.X.Scale,
        main.Size.X.Offset,
        0,
        targetHeight
    )

    minimizeBtn.Text = minimized and "+" or "-"
    content.Visible = not minimized

    TweenService:Create(
        main,
        TweenInfo.new(
            0.18,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        {
            Size = targetSize
        }
    ):Play()
end)

local awaitingStopConfirm = false
local stopConfirmToken = 0

local function resetStopButton()
    stopBtn.Text = "X"
    stopBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
    stopBtn.TextColor3 = Color3.fromRGB(220, 120, 120)
    awaitingStopConfirm = false
end

local function killEverything()
    autohatch = false
    autoMerchant = false
    autoGifts = false
    autoSpinWheel = false
    selectedEgg = nil

    for _, refresh in ipairs(featureToggleRefreshers) do
        refresh()
    end

    updateToggleVisual()
    refreshEggButtons()

    task.wait(0.05)
    screenGui:Destroy()
end

stopBtn.MouseButton1Click:Connect(function()
    if not awaitingStopConfirm then
        awaitingStopConfirm = true
        stopConfirmToken = stopConfirmToken + 1

        local myToken = stopConfirmToken

        stopBtn.Text = "!"
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        task.delay(3, function()
            if stopConfirmToken == myToken and awaitingStopConfirm then
                resetStopButton()
            end
        end)
    else
        killEverything()
    end
end)

local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging
        and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
