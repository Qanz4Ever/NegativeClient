--[[
    Negative Client V-Beta
    Created By Mfsavana.
    Version: 3.0
]]

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Variables
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
local dragging = false
local minimizedDragging = false
local dragInput, dragStart, startPos
local minimized = false
local minimizedPos = nil
local espConnections = {}
local character = player.Character or player.CharacterAdded:Wait()

-- Setup GUI
gui.Name = "NegativeClientMenu"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = gui

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0, -20, 0, -20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://13160440458"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.3
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(20, 20, 20, 20)
shadow.Parent = mainFrame

-- Corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title Bar Corner
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Title Bar Gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 220, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Negative Client V-Beta"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = titleBar

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(0, 160, 1, 2)
subtitle.Position = UDim2.new(0, 240, 0, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Created By Mfsavana."
subtitle.TextColor3 = Color3.fromRGB(160, 160, 200)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.TextTransparency = 0.2
subtitle.Parent = titleBar

-- Window Buttons Frame
local windowButtons = Instance.new("Frame")
windowButtons.Name = "WindowButtons"
windowButtons.Size = UDim2.new(0, 70, 0, 30)
windowButtons.Position = UDim2.new(1, -80, 0.5, -15)
windowButtons.BackgroundTransparency = 1
windowButtons.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("ImageButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(0, 0, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
minimizeButton.BackgroundTransparency = 0.3
minimizeButton.BorderSizePixel = 0
minimizeButton.Image = "rbxassetid://6031094664"
minimizeButton.ImageColor3 = Color3.fromRGB(220, 220, 255)
minimizeButton.Parent = windowButtons

-- Close Button
local closeButton = Instance.new("ImageButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 40, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BackgroundTransparency = 0.2
closeButton.BorderSizePixel = 0
closeButton.Image = "rbxassetid://6031094678"
closeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = windowButtons

-- Button Corners
local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Side Menu
local sideMenu = Instance.new("Frame")
sideMenu.Name = "SideMenu"
sideMenu.Size = UDim2.new(0, 180, 1, -50)
sideMenu.Position = UDim2.new(0, 0, 0, 50)
sideMenu.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
sideMenu.BorderSizePixel = 0
sideMenu.Parent = mainFrame

-- Side Menu Corner
local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 0)
sideCorner.Parent = sideMenu

-- Side Menu Gradient
local sideGradient = Instance.new("UIGradient")
sideGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
})
sideGradient.Rotation = 0
sideGradient.Parent = sideMenu

-- Side Menu Content
local sideContent = Instance.new("ScrollingFrame")
sideContent.Name = "SideContent"
sideContent.Size = UDim2.new(1, -10, 1, -10)
sideContent.Position = UDim2.new(0, 5, 0, 5)
sideContent.BackgroundTransparency = 1
sideContent.BorderSizePixel = 0
sideContent.CanvasSize = UDim2.new(0, 0, 0, 120)
sideContent.ScrollBarThickness = 4
sideContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 140)
sideContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
sideContent.Parent = sideMenu

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -185, 1, -50)
contentArea.Position = UDim2.new(0, 185, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
contentArea.BorderSizePixel = 0
contentArea.Parent = mainFrame

-- Content Area Corner
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 0)
contentCorner.Parent = contentArea

-- Content Scrolling Frame
local contentScroll = Instance.new("ScrollingFrame")
contentScroll.Name = "ContentScroll"
contentScroll.Size = UDim2.new(1, -20, 1, -20)
contentScroll.Position = UDim2.new(0, 10, 0, 10)
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
contentScroll.ScrollBarThickness = 5
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 180)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.Parent = contentArea

-- Content Title
local contentTitle = Instance.new("TextLabel")
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(1, -20, 0, 40)
contentTitle.Position = UDim2.new(0, 10, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Player"
contentTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextSize = 24
contentTitle.Parent = contentScroll

-- Content Divider
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(1, -20, 0, 2)
divider.Position = UDim2.new(0, 10, 0, 50)
divider.BackgroundColor3 = Color3.fromRGB(80, 80, 140)
divider.BackgroundTransparency = 0.3
divider.BorderSizePixel = 0
divider.Parent = contentScroll

-- Content Container
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -20, 0, 0)
contentContainer.Position = UDim2.new(0, 10, 0, 60)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.AutomaticSize = Enum.AutomaticSize.Y
contentContainer.Parent = contentScroll

-- Animation Variables
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Minimized Frame (1:1 square) - FIXED
local minimizedFrame = Instance.new("Frame")
minimizedFrame.Name = "MinimizedFrame"
minimizedFrame.Size = UDim2.new(0, 70, 0, 70) -- Ukuran 70x70 untuk tampilan lebih baik
minimizedFrame.Position = UDim2.new(0, 20, 0, 20)
minimizedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
minimizedFrame.BorderSizePixel = 0
minimizedFrame.Visible = false
minimizedFrame.Active = true
minimizedFrame.Draggable = false
minimizedFrame.Parent = gui
minimizedFrame.ZIndex = 1000

-- Minimized Corner - FIXED (hanya satu corner)
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 12) -- Sudut tajam 12px
minCorner.Parent = minimizedFrame

-- Minimized Shadow - FIXED
local minShadow = Instance.new("ImageLabel")
minShadow.Name = "MinShadow"
minShadow.Size = UDim2.new(1, 20, 1, 20)
minShadow.Position = UDim2.new(0, -10, 0, -10)
minShadow.BackgroundTransparency = 1
minShadow.Image = "rbxassetid://13160440458"
minShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
minShadow.ImageTransparency = 0.4
minShadow.ScaleType = Enum.ScaleType.Slice
minShadow.SliceCenter = Rect.new(10, 10, 10, 10)
minShadow.Parent = minimizedFrame
minShadow.ZIndex = 999

-- Minimized Icon Background
local minIconBg = Instance.new("Frame")
minIconBg.Name = "MinIconBg"
minIconBg.Size = UDim2.new(0, 40, 0, 40)
minIconBg.Position = UDim2.new(0.5, -20, 0.5, -25)
minIconBg.BackgroundColor3 = Color3.fromRGB(40, 80, 140)
minIconBg.BackgroundTransparency = 0.2
minIconBg.BorderSizePixel = 0
minIconBg.Parent = minimizedFrame

-- Icon Background Corner
local iconBgCorner = Instance.new("UICorner")
iconBgCorner.CornerRadius = UDim.new(0, 10)
iconBgCorner.Parent = minIconBg

-- NC Text - FIXED: Huruf NC besar
local ncText = Instance.new("TextLabel")
ncText.Name = "NCText"
ncText.Size = UDim2.new(0, 40, 0, 40)
ncText.Position = UDim2.new(0.5, -20, 0.5, -25)
ncText.BackgroundTransparency = 1
ncText.Text = "NC"
ncText.TextColor3 = Color3.fromRGB(0, 200, 255)
ncText.Font = Enum.Font.GothamBold
ncText.TextSize = 24
ncText.TextScaled = true
ncText.TextWrapped = true
ncText.Parent = minimizedFrame

-- User Text - FIXED: Teks user di bawah
local userText = Instance.new("TextLabel")
userText.Name = "UserText"
userText.Size = UDim2.new(1, 0, 0, 15)
userText.Position = UDim2.new(0, 0, 1, -15)
userText.BackgroundTransparency = 1
userText.Text = player.Name
userText.TextColor3 = Color3.fromRGB(180, 180, 220)
userText.Font = Enum.Font.Gotham
userText.TextSize = 10
userText.TextScaled = true
userText.TextWrapped = true
userText.Parent = minimizedFrame

-- Minimized Frame Hover Effect
minimizedFrame.MouseEnter:Connect(function()
    TweenService:Create(minimizedFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
end)

minimizedFrame.MouseLeave:Connect(function()
    TweenService:Create(minimizedFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 38)}):Play()
end)

-- Confirmation Dialog
local confirmDialog = Instance.new("Frame")
confirmDialog.Name = "ConfirmDialog"
confirmDialog.Size = UDim2.new(0, 320, 0, 170)
confirmDialog.Position = UDim2.new(0.5, -160, 0.5, -85)
confirmDialog.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
confirmDialog.BorderSizePixel = 0
confirmDialog.Visible = false
confirmDialog.Active = true
confirmDialog.Parent = gui
confirmDialog.ZIndex = 2000

-- Dialog Corner
local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 12)
dialogCorner.Parent = confirmDialog

-- Dialog Shadow
local dialogShadow = Instance.new("ImageLabel")
dialogShadow.Name = "DialogShadow"
dialogShadow.Size = UDim2.new(1, 30, 1, 30)
dialogShadow.Position = UDim2.new(0, -15, 0, -15)
dialogShadow.BackgroundTransparency = 1
dialogShadow.Image = "rbxassetid://13160440458"
dialogShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
dialogShadow.ImageTransparency = 0.3
dialogShadow.ScaleType = Enum.ScaleType.Slice
dialogShadow.SliceCenter = Rect.new(15, 15, 15, 15)
dialogShadow.Parent = confirmDialog

-- Dialog Title
local dialogTitle = Instance.new("TextLabel")
dialogTitle.Name = "DialogTitle"
dialogTitle.Size = UDim2.new(1, -20, 0, 40)
dialogTitle.Position = UDim2.new(0, 10, 0, 15)
dialogTitle.BackgroundTransparency = 1
dialogTitle.Text = "Confirm Close"
dialogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextSize = 20
dialogTitle.Parent = confirmDialog

-- Dialog Text
local dialogText = Instance.new("TextLabel")
dialogText.Name = "DialogText"
dialogText.Size = UDim2.new(1, -20, 0, 40)
dialogText.Position = UDim2.new(0, 10, 0, 55)
dialogText.BackgroundTransparency = 1
dialogText.Text = "Are you sure you want to close?"
dialogText.TextColor3 = Color3.fromRGB(200, 200, 220)
dialogText.Font = Enum.Font.Gotham
dialogText.TextSize = 15
dialogText.Parent = confirmDialog

-- Dialog Buttons Frame
local dialogButtons = Instance.new("Frame")
dialogButtons.Name = "DialogButtons"
dialogButtons.Size = UDim2.new(1, -20, 0, 40)
dialogButtons.Position = UDim2.new(0, 10, 0, 110)
dialogButtons.BackgroundTransparency = 1
dialogButtons.Parent = confirmDialog

-- Yes Button
local confirmYes = Instance.new("TextButton")
confirmYes.Name = "ConfirmYes"
confirmYes.Size = UDim2.new(0.5, -5, 1, 0)
confirmYes.Position = UDim2.new(0, 0, 0, 0)
confirmYes.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
confirmYes.Text = "Yes"
confirmYes.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmYes.Font = Enum.Font.GothamBold
confirmYes.TextSize = 16
confirmYes.Parent = dialogButtons

-- No Button
local confirmNo = Instance.new("TextButton")
confirmNo.Name = "ConfirmNo"
confirmNo.Size = UDim2.new(0.5, -5, 1, 0)
confirmNo.Position = UDim2.new(0.5, 5, 0, 0)
confirmNo.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
confirmNo.Text = "No"
confirmNo.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmNo.Font = Enum.Font.GothamBold
confirmNo.TextSize = 16
confirmNo.Parent = dialogButtons

-- Button Corners
local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 8)
yesCorner.Parent = confirmYes

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 8)
noCorner.Parent = confirmNo

-- Button Hover Effects
confirmYes.MouseEnter:Connect(function() TweenService:Create(confirmYes, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 80, 80)}):Play() end)
confirmYes.MouseLeave:Connect(function() TweenService:Create(confirmYes, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play() end)
confirmNo.MouseEnter:Connect(function() TweenService:Create(confirmNo, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 120)}):Play() end)
confirmNo.MouseLeave:Connect(function() TweenService:Create(confirmNo, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 90)}):Play() end)

-- Side Menu Buttons
local function createSideButton(name, position, icon)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 55)
    button.Position = UDim2.new(0, 0, 0, (position - 1) * 60)
    button.BackgroundColor3 = position == 1 and Color3.fromRGB(50, 80, 140) or Color3.fromRGB(35, 35, 50)
    button.BackgroundTransparency = position == 1 and 0.1 or 0.4
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = sideContent
    
    -- Button Corner
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    -- Icon
    local btnIcon = Instance.new("ImageLabel")
    btnIcon.Name = "Icon"
    btnIcon.Size = UDim2.new(0, 28, 0, 28)
    btnIcon.Position = UDim2.new(0, 10, 0.5, -14)
    btnIcon.BackgroundTransparency = 1
    btnIcon.Image = icon or "rbxassetid://4483359753"
    btnIcon.ImageColor3 = position == 1 and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(150, 150, 220)
    btnIcon.Parent = button
    
    -- Text
    local btnText = Instance.new("TextLabel")
    btnText.Name = "Text"
    btnText.Size = UDim2.new(0, 100, 1, 0)
    btnText.Position = UDim2.new(0, 48, 0, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = name
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.Font = Enum.Font.GothamBold
    btnText.TextSize = 15
    btnText.Parent = button
    
    return button
end

local playerButton = createSideButton("Player", 1, "rbxassetid://4483362458")
local visualButton = createSideButton("Visual", 2, "rbxassetid://4483345523")

-- Tab switching with animation
local function switchTab(tabName)
    contentTitle.Text = tabName
    
    -- Clear content
    for _, child in pairs(contentContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Update side menu visuals
    for _, child in pairs(sideContent:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            child.BackgroundTransparency = 0.4
            if child:FindFirstChild("Icon") then
                child.Icon.ImageColor3 = Color3.fromRGB(150, 150, 220)
            end
        end
    end
    
    if tabName == "Player" then
        playerButton.BackgroundColor3 = Color3.fromRGB(50, 80, 140)
        playerButton.BackgroundTransparency = 0.1
        if playerButton:FindFirstChild("Icon") then
            playerButton.Icon.ImageColor3 = Color3.fromRGB(0, 200, 255)
        end
        createPlayerTab()
    elseif tabName == "Visual" then
        visualButton.BackgroundColor3 = Color3.fromRGB(50, 80, 140)
        visualButton.BackgroundTransparency = 0.1
        if visualButton:FindFirstChild("Icon") then
            visualButton.Icon.ImageColor3 = Color3.fromRGB(0, 200, 255)
        end
        createVisualTab()
    end
end

playerButton.MouseButton1Click:Connect(function() switchTab("Player") end)
visualButton.MouseButton1Click:Connect(function() switchTab("Visual") end)

-- Dragging functionality for main frame - FIXED
local function startDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

local function updateDrag(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

titleBar.InputBegan:Connect(startDrag)
UserInputService.InputChanged:Connect(updateDrag)

-- Minimized frame dragging - FIXED
local function startMinDrag(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and minimized then
        minimizedDragging = true
        dragStart = input.Position
        startPos = minimizedFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                minimizedDragging = false
                minimizedPos = minimizedFrame.Position
                if connection then
                    connection:Disconnect()
                end
            end
        end)
    end
end

local function updateMinDrag(input)
    if minimizedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        minimizedFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

minimizedFrame.InputBegan:Connect(startMinDrag)
UserInputService.InputChanged:Connect(updateMinDrag)

-- Minimize/Maximize with animation - FIXED
local function animateMinimize()
    if not minimized then
        -- Store position
        minimizedPos = mainFrame.Position
        
        -- Hide main frame
        mainFrame.Visible = false
        
        -- Show minimized frame with animation
        minimizedFrame.Position = UDim2.new(minimizedPos.X.Scale, minimizedPos.X.Offset, minimizedPos.Y.Scale, minimizedPos.Y.Offset)
        minimizedFrame.Visible = true
        minimizedFrame.Size = UDim2.new(0, 10, 0, 10)
        
        local showMin = TweenService:Create(minimizedFrame, tweenInfo, {Size = UDim2.new(0, 70, 0, 70)})
        showMin:Play()
        
        minimized = true
    else
        -- Show main frame with animation
        mainFrame.Position = minimizedFrame.Position
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 10, 0, 10)
        
        local showMain = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 700, 0, 500)})
        showMain:Play()
        
        -- Hide minimized frame
        local hideMin = TweenService:Create(minimizedFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
        hideMin:Play()
        
        hideMin.Completed:Connect(function()
            minimizedFrame.Visible = false
            minimizedFrame.Size = UDim2.new(0, 70, 0, 70)
        end)
        
        minimized = false
    end
end

-- FIXED: Minimize button click
minimizeButton.MouseButton1Click:Connect(function()
    animateMinimize()
end)

-- FIXED: Minimized frame click to maximize
minimizedFrame.MouseButton1Click:Connect(function()
    if minimized then
        animateMinimize()
    end
end)

-- FIXED: Close button with confirmation
closeButton.MouseButton1Click:Connect(function()
    confirmDialog.Visible = true
    confirmDialog.BackgroundTransparency = 0
    confirmDialog.Size = UDim2.new(0, 320, 0, 170)
    confirmDialog.Position = UDim2.new(0.5, -160, 0.5, -85)
end)

confirmYes.MouseButton1Click:Connect(function()
    confirmDialog.Visible = false
    gui:Destroy()
end)

confirmNo.MouseButton1Click:Connect(function()
    confirmDialog.Visible = false
end)

-- Helper functions for UI elements
function createOptionFrame(name, position)
    local frame = Instance.new("Frame")
    frame.Name = name:gsub(" ", "")
    frame.Size = UDim2.new(1, 0, 0, 90)
    frame.Position = UDim2.new(0, 0, 0, (position-1) * 100)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    frame.BorderSizePixel = 0
    frame.Parent = contentContainer
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame
    
    local frameGradient = Instance.new("UIGradient")
    frameGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 42)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 28))
    })
    frameGradient.Rotation = 90
    frameGradient.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 180, 0, 25)
    label.Position = UDim2.new(0, 15, 0, 10)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = frame
    
    return frame
end

function createToggle(defaultOn)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(0, 15, 0, 45)
    toggle.BackgroundColor3 = defaultOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = nil
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle
    
    -- Toggle indicator
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0.5, -10, 0.5, -10)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BackgroundTransparency = 0.5
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 6)
    indicatorCorner.Parent = indicator
    
    return toggle
end

function createSlider(defaultValue, min, max, parent)
    -- Slider background
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBg"
    sliderBg.Size = UDim2.new(0, 220, 0, 8)
    sliderBg.Position = UDim2.new(0, 60, 0, 55)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = parent
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 4)
    sliderBgCorner.Parent = sliderBg
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new((defaultValue-min)/(max-min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 4)
    sliderFillCorner.Parent = sliderFill
    
    -- Slider button
    local sliderButton = Instance.new("Frame")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 20, 0, 20)
    sliderButton.Position = UDim2.new((defaultValue-min)/(max-min), -10, 0.5, -10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Parent = sliderBg
    
    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton
    
    -- Input box
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 70, 0, 35)
    box.Position = UDim2.new(0, 300, 0, 42)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.PlaceholderText = "Value"
    box.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
    box.TextSize = 16
    box.Font = Enum.Font.GothamBold
    box.Parent = parent
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 8)
    boxCorner.Parent = box
    
    return sliderBg, box, sliderFill, sliderButton
end

-- Player tab content - FIXED
function createPlayerTab()
    -- Speed Modifier
    local speedFrame = createOptionFrame("Speed Modifier", 1)
    
    local speedToggle = createToggle(true)
    speedToggle.Parent = speedFrame
    
    local speedSlider, speedBox, speedFill, speedButton = createSlider(16, 1, 100, speedFrame)
    
    -- Jump Power Modifier
    local jumpFrame = createOptionFrame("Jump Power Modifier", 2)
    
    local jumpToggle = createToggle(true)
    jumpToggle.Parent = jumpFrame
    
    local jumpSlider, jumpBox, jumpFill, jumpButton = createSlider(50, 1, 100, jumpFrame)
    
    -- Speed functionality
    local speedEnabled = true
    local currentSpeed = 16
    
    local function updateSpeed()
        if speedEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = currentSpeed
        end
    end
    
    speedToggle.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        speedToggle.BackgroundColor3 = speedEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
        if not speedEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = 16
        elseif speedEnabled then
            updateSpeed()
        end
    end)
    
    -- Slider input for speed
    local speedDragging = false
    
    speedButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedDragging = true
        end
    end)
    
    speedButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = speedSlider.AbsolutePosition
            local absSize = speedSlider.AbsoluteSize
            local relativeX = math.clamp(mousePos.X - absPos.X, 0, absSize.X)
            local percent = relativeX / absSize.X
            
            speedFill.Size = UDim2.new(percent, 0, 1, 0)
            speedButton.Position = UDim2.new(percent, -10, 0.5, -10)
            
            currentSpeed = math.floor(1 + 99 * percent)
            speedBox.Text = tostring(currentSpeed)
            updateSpeed()
        end
    end)
    
    speedBox.FocusLost:Connect(function()
        local value = tonumber(speedBox.Text)
        if value then
            currentSpeed = math.clamp(value, 1, 100)
            speedBox.Text = tostring(currentSpeed)
            local percent = (currentSpeed - 1) / 99
            speedFill.Size = UDim2.new(percent, 0, 1, 0)
            speedButton.Position = UDim2.new(percent, -10, 0.5, -10)
            updateSpeed()
        else
            speedBox.Text = tostring(currentSpeed)
        end
    end)
    
    -- Jump functionality
    local jumpEnabled = true
    local currentJump = 50
    local jumpDragging = false
    
    local function updateJump()
        if jumpEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = currentJump
        end
    end
    
    jumpToggle.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        jumpToggle.BackgroundColor3 = jumpEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
        if not jumpEnabled and character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = 50
        elseif jumpEnabled then
            updateJump()
        end
    end)
    
    jumpButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            jumpDragging = true
        end
    end)
    
    jumpButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            jumpDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if jumpDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = jumpSlider.AbsolutePosition
            local absSize = jumpSlider.AbsoluteSize
            local relativeX = math.clamp(mousePos.X - absPos.X, 0, absSize.X)
            local percent = relativeX / absSize.X
            
            jumpFill.Size = UDim2.new(percent, 0, 1, 0)
            jumpButton.Position = UDim2.new(percent, -10, 0.5, -10)
            
            currentJump = math.floor(1 + 99 * percent)
            jumpBox.Text = tostring(currentJump)
            updateJump()
        end
    end)
    
    jumpBox.FocusLost:Connect(function()
        local value = tonumber(jumpBox.Text)
        if value then
            currentJump = math.clamp(value, 1, 100)
            jumpBox.Text = tostring(currentJump)
            local percent = (currentJump - 1) / 99
            jumpFill.Size = UDim2.new(percent, 0, 1, 0)
            jumpButton.Position = UDim2.new(percent, -10, 0.5, -10)
            updateJump()
        else
            jumpBox.Text = tostring(currentJump)
        end
    end)
    
    -- Character respawn handling
    player.CharacterAdded:Connect(function(newChar)
        character = newChar
        task.wait(0.5)
        updateSpeed()
        updateJump()
    end)
    
    -- Initial updates
    task.wait(0.5)
    updateSpeed()
    updateJump()
end

-- Visual tab content - FIXED
function createVisualTab()
    -- Player ESP
    local espFrame = createOptionFrame("Player ESP", 1)
    
    local espToggle = createToggle(false)
    espToggle.Parent = espFrame
    
    -- Color label
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(0, 60, 0, 30)
    colorLabel.Position = UDim2.new(0, 60, 0, 45)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = "Color:"
    colorLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    colorLabel.TextSize = 16
    colorLabel.Font = Enum.Font.Gotham
    colorLabel.Parent = espFrame
    
    -- Color preview
    local colorPreview = Instance.new("Frame")
    colorPreview.Name = "ColorPreview"
    colorPreview.Size = UDim2.new(0, 35, 0, 30)
    colorPreview.Position = UDim2.new(0, 120, 0, 45)
    colorPreview.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    colorPreview.BorderSizePixel = 0
    colorPreview.Parent = espFrame
    
    local previewCorner = Instance.new("UICorner")
    previewCorner.CornerRadius = UDim.new(0, 6)
    previewCorner.Parent = colorPreview
    
    -- Color input
    local colorInput = Instance.new("TextBox")
    colorInput.Size = UDim2.new(0, 90, 0, 30)
    colorInput.Position = UDim2.new(0, 165, 0, 45)
    colorInput.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    colorInput.Text = "255,255,255"
    colorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    colorInput.PlaceholderText = "R,G,B"
    colorInput.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
    colorInput.TextSize = 14
    colorInput.Font = Enum.Font.Gotham
    colorInput.Parent = espFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = colorInput
    
    -- Preset colors frame
    local presetFrame = Instance.new("Frame")
    presetFrame.Size = UDim2.new(0, 280, 0, 35)
    presetFrame.Position = UDim2.new(0, 270, 0, 42)
    presetFrame.BackgroundTransparency = 1
    presetFrame.Parent = espFrame
    
    local colors = {
        {"White", Color3.fromRGB(255, 255, 255)},
        {"Red", Color3.fromRGB(255, 60, 60)},
        {"Green", Color3.fromRGB(60, 255, 60)},
        {"Blue", Color3.fromRGB(60, 60, 255)},
        {"Yellow", Color3.fromRGB(255, 255, 60)},
        {"Purple", Color3.fromRGB(200, 60, 255)}
    }
    
    for i, colorData in ipairs(colors) do
        local btn = Instance.new("TextButton")
        btn.Name = colorData[1] .. "Btn"
        btn.Size = UDim2.new(0, 40, 0, 30)
        btn.Position = UDim2.new(0, (i-1) * 45, 0, 2.5)
        btn.BackgroundColor3 = colorData[2]
        btn.Text = ""
        btn.Parent = presetFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            colorPreview.BackgroundColor3 = colorData[2]
            colorInput.Text = string.format("%d,%d,%d", colorData[2].R * 255, colorData[2].G * 255, colorData[2].B * 255)
            if espEnabled then
                updateESP(colorData[2])
            end
        end)
    end
    
    -- ESP functionality
    local espEnabled = false
    local espColor = Color3.fromRGB(255, 255, 255)
    
    local function clearESP()
        for _, conn in ipairs(espConnections) do
            conn:Disconnect()
        end
        espConnections = {}
        
        for _, v in pairs(CoreGui:GetDescendants()) do
            if v.Name == "ESPHighlight" and v:IsA("Highlight") then
                v:Destroy()
            end
        end
    end
    
    local function updateESP(color)
        clearESP()
        
        if not espEnabled then return end
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Adornee = plr.Character
                highlight.FillTransparency = 1
                highlight.OutlineColor = color or espColor
                highlight.OutlineTransparency = 0
                highlight.Parent = CoreGui
                
                table.insert(espConnections, plr.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if plr.Character and espEnabled then
                        local newHighlight = Instance.new("Highlight")
                        newHighlight.Name = "ESPHighlight"
                        newHighlight.Adornee = plr.Character
                        newHighlight.FillTransparency = 1
                        newHighlight.OutlineColor = color or espColor
                        newHighlight.OutlineTransparency = 0
                        newHighlight.Parent = CoreGui
                    end
                end))
            end
        end
        
        table.insert(espConnections, Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                task.wait(0.5)
                if plr.Character and espEnabled then
                    local newHighlight = Instance.new("Highlight")
                    newHighlight.Name = "ESPHighlight"
                    newHighlight.Adornee = plr.Character
                    newHighlight.FillTransparency = 1
                    newHighlight.OutlineColor = color or espColor
                    newHighlight.OutlineTransparency = 0
                    newHighlight.Parent = CoreGui
                end
            end)
        end))
    end
    
    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        espToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 60, 60)
        updateESP()
    end)
    
    colorInput.FocusLost:Connect(function()
        local r, g, b = colorInput.Text:match("(%d+),(%d+),(%d+)")
        if r and g and b then
            espColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            colorPreview.BackgroundColor3 = espColor
            updateESP(espColor)
        end
    end)
end

-- Animation on startup
mainFrame.Size = UDim2.new(0, 10, 0, 10)
mainFrame.Position = UDim2.new(0.5, -5, 0.5, -5)

local openAnimation = TweenService:Create(mainFrame, tweenInfo, {
    Size = UDim2.new(0, 700, 0, 500),
    Position = UDim2.new(0.5, -350, 0.5, -250)
})
openAnimation:Play()

-- Initialize with Player tab
switchTab("Player")

-- Load saved position
if minimizedPos then
    mainFrame.Position = minimizedPos
end

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Negative Client V-Beta",
    Text = "Loaded successfully!",
    Duration = 3
})

print("Negative Client V-Beta Loaded Successfully!")
