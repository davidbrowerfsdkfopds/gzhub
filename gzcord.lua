local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera


local player = Players.LocalPlayer
local Mouse = player:GetMouse()
local playerGui = player:WaitForChild("PlayerGui")


local aimbotEnabled = false
local aimbotSmoothness = 80
local aimbotPrediction = 10
local aimbotKeybind = "Right Click"
local aimbotToggleMode = false
local aimbotToggleActive = false
local aimbotConnection = nil
local currentTarget = nil


local fovEnabled = false
local fovSize = 100
local fovVisible = false
local fovCircle = nil


local whitelistedPlayers = {}
local viewedPlayers = {}
local playerPopups = {}
local priorityPlayers = {}



local speedEnabled = false
local flyEnabled = false
local speedValue = 16
local jumpValue = 50
local antiLockEnabled = false
local antiLockConnection = nil


local guiSettings = {
    theme = "dark",
    transparency = 0,
    scale = 1,
    animations = true,
    visible = true
}


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GZCORD"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.Enabled = false

-- === GUI BACKGROUND BLUR HELPERS ===
local Lighting = game:GetService("Lighting")
local BLUR_NAME = "GZHubBlur"
local BLUR_SIZE = 24

local function enableGUIBlur()
    -- Ensure only one blur exists
    local blur = Lighting:FindFirstChild(BLUR_NAME)
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = BLUR_NAME
        blur.Size = BLUR_SIZE
        blur.Parent = Lighting
    end
    blur.Enabled = true
end

local function disableGUIBlur()
    local blur = Lighting:FindFirstChild(BLUR_NAME)
    if blur then
        blur.Enabled = false
        blur:Destroy()
    end
end

-- Connect Blur to GUI visibility
screenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screenGui.Enabled then
        enableGUIBlur()
    else
        disableGUIBlur()
    end
end)

-- === GUI BACKGROUND BLUR HELPERS ===
local Lighting = game:GetService("Lighting")
local BLUR_NAME = "GZHubBlur"
local BLUR_SIZE = 24

local function enableGUIBlur()
    -- Ensure only one blur exists
    local blur = Lighting:FindFirstChild(BLUR_NAME)
    if not blur then
        blur = Instance.new("BlurEffect")
        blur.Name = BLUR_NAME
        blur.Size = BLUR_SIZE
        blur.Parent = Lighting
    end
    blur.Enabled = true
end

local function disableGUIBlur()
    local blur = Lighting:FindFirstChild(BLUR_NAME)
    if blur then
        blur.Enabled = false
        blur:Destroy()
    end
end

-- Connect Blur to GUI visibility
screenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screenGui.Enabled then
        enableGUIBlur()
    else
        disableGUIBlur()
    end
end)
            guiSettings.visible = false
        end)
    else
        screenGui.Enabled = false
        guiSettings.visible = false
    end
end)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if guiSettings.animations then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if minimized then
            TweenService:Create(windowFrame, tweenInfo, {
                Size = UDim2.new(0, 800, 0, 30)
            }):Play()
            minimizeButton.Text = "+"
        else
            TweenService:Create(windowFrame, tweenInfo, {
                Size = UDim2.new(0, 800, 0, 500)
            }):Play()
            minimizeButton.Text = "−"
        end
    else
        if minimized then
            windowFrame.Size = UDim2.new(0, 800, 0, 30)
            minimizeButton.Text = "+"
        else
            windowFrame.Size = UDim2.new(0, 800, 0, 500)
            minimizeButton.Text = "−"
        end
    end
end)


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        guiSettings.visible = not guiSettings.visible
        if guiSettings.animations then
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if guiSettings.visible then
                screenGui.Enabled = true
                windowFrame.Size = UDim2.new(0, 0, 0, 0)
                windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                TweenService:Create(windowFrame, tweenInfo, {
                    Size = UDim2.new(0, 800, 0, 500),
                    Position = UDim2.new(0.5, -400, 0.5, -250)
                }):Play()
            else
                local tween = TweenService:Create(windowFrame, tweenInfo, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                })
                tween:Play()
                tween.Completed:Connect(function()
                    screenGui.Enabled = false
                end)
            end
        else
            screenGui.Enabled = guiSettings.visible
        end
    end
end)


-- Loading Screen Overlay
local loadingOverlay = Instance.new("Frame")
loadingOverlay.Name = "LoadingOverlay"
loadingOverlay.BackgroundColor3 = Color3.fromRGB(32, 34, 37)
loadingOverlay.BackgroundTransparency = 0.1
loadingOverlay.BorderSizePixel = 0
loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
loadingOverlay.Position = UDim2.new(0, 0, 0, 0)
loadingOverlay.ZIndex = 1000
loadingOverlay.Parent = windowFrame

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingOverlay

-- Blur effect for loading screen
local loadingBlur = Instance.new("Frame")
loadingBlur.Name = "LoadingBlur"
loadingBlur.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
loadingBlur.BackgroundTransparency = 0.2
loadingBlur.BorderSizePixel = 0
loadingBlur.Size = UDim2.new(1, 0, 1, 0)
loadingBlur.Position = UDim2.new(0, 0, 0, 0)
loadingBlur.Parent = loadingOverlay

local blurCorner = Instance.new("UICorner")
blurCorner.CornerRadius = UDim.new(0, 12)
blurCorner.Parent = loadingBlur

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(0, 400, 0, 60)
loadingText.Position = UDim2.new(0.5, -200, 0.5, -30)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.Text = "🎯 Injecting u with gzness..."
loadingText.TextColor3 = Color3.fromRGB(114, 137, 218)
loadingText.TextSize = 24
loadingText.TextXAlignment = Enum.TextXAlignment.Center
loadingText.TextYAlignment = Enum.TextYAlignment.Center
loadingText.Parent = loadingOverlay

-- Loading dots animation
local loadingDots = Instance.new("TextLabel")
loadingDots.Name = "LoadingDots"
loadingDots.BackgroundTransparency = 1
loadingDots.Size = UDim2.new(0, 100, 0, 30)
loadingDots.Position = UDim2.new(0.5, -50, 0.5, 20)
loadingDots.Font = Enum.Font.SourceSansBold
loadingDots.Text = "..."
loadingDots.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingDots.TextSize = 18
loadingDots.TextXAlignment = Enum.TextXAlignment.Center
loadingDots.TextYAlignment = Enum.TextYAlignment.Center
loadingDots.Parent = loadingOverlay

-- Animate loading dots
spawn(function()
    local dots = {"", ".", "..", "..."}
    local index = 1
    while loadingOverlay.Parent do
        loadingDots.Text = dots[index]
        index = index + 1
        if index > #dots then index = 1 end
        wait(0.5)
    end
end)

-- Progress bar
local progressBarBG = Instance.new("Frame")
progressBarBG.Name = "ProgressBarBG"
progressBarBG.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
progressBarBG.BorderSizePixel = 0
progressBarBG.Size = UDim2.new(0, 300, 0, 6)
progressBarBG.Position = UDim2.new(0.5, -150, 0.5, 60)
progressBarBG.Parent = loadingOverlay

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 3)
progressBarCorner.Parent = progressBarBG

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
progressBar.BorderSizePixel = 0
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.Parent = progressBarBG

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 3)
progressCorner.Parent = progressBar

-- Animate progress bar
spawn(function()
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(progressBar, tweenInfo, {
        Size = UDim2.new(1, 0, 1, 0)
    })
    tween:Play()
    
    -- Remove loading screen after animation
    tween.Completed:Connect(function()
        wait(0.5)
        local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = TweenService:Create(loadingOverlay, fadeInfo, {
            BackgroundTransparency = 1
        })
        local fadeBlurTween = TweenService:Create(loadingBlur, fadeInfo, {
            BackgroundTransparency = 1
        })
        local fadeTextTween = TweenService:Create(loadingText, fadeInfo, {
            TextTransparency = 1
        })
        local fadeDotseTween = TweenService:Create(loadingDots, fadeInfo, {
            TextTransparency = 1
        })
        local fadeProgressBGTween = TweenService:Create(progressBarBG, fadeInfo, {
            BackgroundTransparency = 1
        })
        local fadeProgressTween = TweenService:Create(progressBar, fadeInfo, {
            BackgroundTransparency = 1
        })
        
        fadeTween:Play()
        fadeBlurTween:Play()
        fadeTextTween:Play()
        fadeDotseTween:Play()
        fadeProgressBGTween:Play()
        fadeProgressTween:Play()
        
        fadeTween.Completed:Connect(function()
            loadingOverlay:Destroy()
        end)
    end)
end)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundTransparency = 1
mainFrame.Size = UDim2.new(1, 0, 1, -30)
mainFrame.Position = UDim2.new(0, 0, 0, 30)
mainFrame.Parent = windowFrame




local function createFOVCircle()
    if fovCircle then
        fovCircle:Remove()
    end
    
    if Drawing then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = fovVisible
        fovCircle.Thickness = 2
        fovCircle.Color = Color3.fromRGB(255, 255, 255)
        fovCircle.Transparency = 0.8
        fovCircle.Filled = false
        fovCircle.Radius = fovSize
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end

local function updateFOVCircle()
    if fovCircle then
        fovCircle.Visible = fovVisible and fovEnabled
        fovCircle.Radius = fovSize
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end

local function isWithinFOV(targetPlayer)
    if not fovEnabled or not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        return true
    end
    
    local head = targetPlayer.Character.Head
    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
    
    if not onScreen then
        return false
    end
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local targetPosition = Vector2.new(screenPoint.X, screenPoint.Y)
    local distance = (targetPosition - screenCenter).Magnitude
    
    return distance <= fovSize
end


local function hasLineOfSight(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        return false
    end
    
    local head = targetPlayer.Character.Head
    local camera = workspace.CurrentCamera
    local rayOrigin = camera.CFrame.Position
    local rayDirection = (head.Position - rayOrigin).Unit * (head.Position - rayOrigin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character, targetPlayer.Character}
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    

    return raycastResult == nil
end

local function getClosestPlayer()
    -- Determine if there are any priority targets
    local hasPriority = false
    for plr, isPriority in pairs(priorityPlayers) do
        if isPriority then
            hasPriority = true
            break
        end
    end

    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player
            and not whitelistedPlayers[targetPlayer]
            and (not hasPriority or priorityPlayers[targetPlayer])
            and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            local head = targetPlayer.Character.Head
            local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen and hasLineOfSight(targetPlayer) and isWithinFOV(targetPlayer) then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = targetPlayer
                end
            end
        end
    end
    
    return closestPlayer
end

local function aimAt(targetPlayer)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
        return
    end
    
    local head = targetPlayer.Character.Head
    local targetPosition = head.Position
    
    if targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local velocity = targetPlayer.Character.HumanoidRootPart.Velocity
        targetPosition = targetPosition + (velocity * (aimbotPrediction / 100))
    end
    
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, targetPosition)

    local smoothness = aimbotSmoothness / 100
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, 1 - smoothness)

    -- AimeView logic: set camera to follow target's head
    if aimeViewEnabled and aimbotEnabled and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(targetPlayer.Character.Head.Position + Vector3.new(0, 1.5, 0), targetPlayer.Character.Head.Position + targetPlayer.Character.Head.CFrame.LookVector * 10)
    end
end

local function isTargetValid(target)
    return target and target.Character and target.Character:FindFirstChild("Head") and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") and target.Character:FindFirstChildOfClass("Humanoid").Health > 0 and hasLineOfSight(target)
end

local function isTargetValidForLock(target)
    return target and target.Character and target.Character:FindFirstChild("Head") and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChildOfClass("Humanoid") and target.Character:FindFirstChildOfClass("Humanoid").Health > 0
end

local function isAimbotKeyPressed()
    if aimbotToggleMode then
        return aimbotToggleActive
    else
        if aimbotKeybind == "Right Click" then
            return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        elseif aimbotKeybind == "Q" then
            return UserInputService:IsKeyDown(Enum.KeyCode.Q)
        elseif aimbotKeybind == "Ctrl" then
            return UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        end
        return false
    end
end

local function startAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
    end
    

    createFOVCircle()
    
    aimbotConnection = RunService.Heartbeat:Connect(function()
    
        updateFOVCircle()
        
if aimbotEnabled and isAimbotKeyPressed() then

            if not currentTarget or not isTargetValidForLock(currentTarget) or not isWithinFOV(currentTarget) then
                local newTarget = getClosestPlayer()
                if newTarget ~= currentTarget then
                    currentTarget = newTarget
                    targetLockTime = tick()
                end
            end
            
            if currentTarget then
                aimAt(currentTarget)
            end
        else

            if currentTarget then
                currentTarget = nil
                targetLockTime = 0
            end
        end
    end)
end

local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    currentTarget = nil
    

    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end
end

-- Toggle key detection for aimbot
local lastKeyState = {}
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not aimbotEnabled or not aimbotToggleMode then return end
    
    local keyPressed = false
    local keyName = ""
    
    if aimbotKeybind == "Right Click" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        keyPressed = true
        keyName = "RightClick"
    elseif aimbotKeybind == "Q" and input.KeyCode == Enum.KeyCode.Q then
        keyPressed = true
        keyName = "Q"
    elseif aimbotKeybind == "Ctrl" and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
        keyPressed = true
        keyName = "Ctrl"
    end
    
    if keyPressed and not lastKeyState[keyName] then
        aimbotToggleActive = not aimbotToggleActive
        lastKeyState[keyName] = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local keyName = ""
    
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        keyName = "RightClick"
    elseif input.KeyCode == Enum.KeyCode.Q then
        keyName = "Q"
    elseif input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        keyName = "Ctrl"
    end
    
    if keyName ~= "" then
        lastKeyState[keyName] = false
    end
end)


getgenv().esp = {
    players = {},
    enabled = false,
    fading = false,
    espfadespeed = 5,
    box = false,
    boxcolor = Color3.fromRGB(255,255,255),
    boxoutline = Color3.fromRGB(0,0,0),
    boxtransparency = 0,
    boxoutlinetransparency = 0,
    health = false,
    healthcolor = Color3.fromRGB(0,255,0),
    healthoutline = Color3.fromRGB(0,0,0),
    healthtransparency = 0,
    healthoutlinetransparency = 0,
    chams = false,
    chamscolor = Color3.fromRGB(255,255,255),
    chamsoutline = Color3.fromRGB(0,0,0),
    chamstransparencyinline = 0.5,
    chamstransparencyoutline = 0.5,
    name = false,
    namecolor = Color3.fromRGB(255,255,255),
    nameoutline = Color3.fromRGB(0,0,0),
    nametransparency = 0,
    healthbartext = false,
    healthbartextcolor = Color3.fromRGB(255,255,255),
    healthbartextoutline = Color3.fromRGB(0,0,0),
    healthbartexttransparency = 0,
    renderdistance = 10000
}


local draw = Drawing or {}
if not Drawing then
    warn("Drawing library not available - ESP will not work")
    draw.new = function() return {Visible = false} end
else
    draw.new = Drawing.new
end


local function createESPDrawings()
    local box = draw.new("Square")
    box.Visible = false
    box.Filled = false
    box.ZIndex = 999
    box.Thickness = 1
    box.Transparency = 1
    
    local boxOutline = draw.new("Square")
    boxOutline.Visible = false
    boxOutline.Filled = false
    boxOutline.ZIndex = 1
    boxOutline.Color = Color3.fromRGB(0,0,0)
    boxOutline.Thickness = 3
    boxOutline.Transparency = 1
    
    local health = draw.new("Line")
    health.Visible = false
    health.ZIndex = 999
    health.Thickness = 1
    health.Color = Color3.fromRGB(0,255,0)
    health.Transparency = 1
    
    local healthOutline = draw.new("Line")
    healthOutline.Visible = false
    healthOutline.ZIndex = 1
    healthOutline.Thickness = 3
    healthOutline.Color = Color3.fromRGB(0,0,0)
    healthOutline.Transparency = 1
    
    local name = draw.new("Text")
    name.Visible = false
    name.ZIndex = 999
    name.Color = Color3.fromRGB(255,255,255)
    name.Outline = true
    name.Size = 13
    name.Transparency = 1
    name.Center = true
    
    local healthText = draw.new("Text")
    healthText.Visible = false
    healthText.ZIndex = 999
    healthText.Color = Color3.fromRGB(255,255,255)
    healthText.Outline = true
    healthText.Size = 13
    healthText.Transparency = 1
    
    return {
        Box = box,
        BoxOutline = boxOutline,
        Health = health,
        HealthOutline = healthOutline,
        Name = name,
        HealthText = healthText
    }
end


local function isAlive(targetPlayer)
    return targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character:FindFirstChildOfClass("Humanoid") and targetPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0
end


local function calculateBoxSizeAndPosition(character)
    if not character then return nil, nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoidRootPart or not head then
        return nil, nil
    end
    
    local success, rootPos, rootOnScreen = pcall(function()
        return Camera:WorldToViewportPoint(humanoidRootPart.Position)
    end)
    if not success then return nil, nil end
    
    local success2, headPos, headOnScreen = pcall(function()
        return Camera:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y/2, 0))
    end)
    if not success2 then return nil, nil end
    
    local success3, legPos, legOnScreen = pcall(function()
        return Camera:WorldToViewportPoint(humanoidRootPart.Position - Vector3.new(0, humanoidRootPart.Size.Y/2 + 2, 0))
    end)
    if not success3 then return nil, nil end
    
    if not rootOnScreen or not headOnScreen or not legOnScreen then
        return nil, nil
    end
    
    local height = math.abs(headPos.Y - legPos.Y)
    local width = height * 0.6
    
    if height <= 0 or width <= 0 then
        return nil, nil
    end
    
    local boxSize = Vector2.new(width, height)
    local boxPosition = Vector2.new(rootPos.X - width/2, headPos.Y)
    
    return boxSize, boxPosition
end


spawn(function()
    while task.wait() do
        pcall(function()
            -- Determine if any priority players exist for ESP
            local priorityActiveESP = false
            for plr, flag in pairs(priorityPlayers) do
                if flag then priorityActiveESP = true break end
            end

            for i, v in next, Players:GetPlayers() do
                if v ~= player and not whitelistedPlayers[v] and (not priorityActiveESP or priorityPlayers[v]) then
                    local drawingInstances = esp.players[v]
                    if not drawingInstances then continue end


                if not isAlive(v) then
                    drawingInstances.Box.Visible = false
                    drawingInstances.BoxOutline.Visible = false
                    drawingInstances.Health.Visible = false
                    drawingInstances.HealthOutline.Visible = false
                    drawingInstances.Name.Visible = false
                    drawingInstances.HealthText.Visible = false
                    continue
                end

                if esp.enabled then
                    local character = v.Character
                    if not character or not character:FindFirstChild("HumanoidRootPart") then
                        drawingInstances.Box.Visible = false
                        drawingInstances.BoxOutline.Visible = false
                        drawingInstances.Health.Visible = false
                        drawingInstances.HealthOutline.Visible = false
                        drawingInstances.Name.Visible = false
                        drawingInstances.HealthText.Visible = false
                        continue
                    end
                    
                    local humanoidRootPart = character.HumanoidRootPart
                    local success, _, onscreen = pcall(function()
                        return Camera:WorldToViewportPoint(humanoidRootPart.Position)
                    end)
                    if not success then continue end
                    
                    local distfromchar = (Camera.CFrame.Position - humanoidRootPart.Position).Magnitude
                    if esp.renderdistance < distfromchar then 
                        drawingInstances.Box.Visible = false
                        drawingInstances.BoxOutline.Visible = false
                        drawingInstances.Health.Visible = false
                        drawingInstances.HealthOutline.Visible = false
                        drawingInstances.Name.Visible = false
                        drawingInstances.HealthText.Visible = false
                    else
                        if onscreen then
                            local boxSize, boxPosition = calculateBoxSizeAndPosition(character)
                            if boxSize and boxPosition then
                                if esp.box then
                                    drawingInstances.Box.Size = boxSize
                                    drawingInstances.Box.Position = boxPosition
                                    drawingInstances.Box.Visible = true
                                    drawingInstances.Box.Color = esp.boxcolor
                                    drawingInstances.BoxOutline.Size = boxSize
                                    drawingInstances.BoxOutline.Position = boxPosition
                                    drawingInstances.BoxOutline.Visible = true
                                    drawingInstances.BoxOutline.Color = esp.boxoutline
                                    if esp.fading then
                                        drawingInstances.Box.Transparency = 1 - (math.sin(tick() * esp.espfadespeed) + 1) / 2
                                        drawingInstances.BoxOutline.Transparency = 1 - (math.sin(tick() * esp.espfadespeed) + 1) / 2
                                    else
                                        drawingInstances.Box.Transparency = 1 - esp.boxtransparency
                                        drawingInstances.BoxOutline.Transparency = 1 - esp.boxoutlinetransparency
                                    end
                                else
                                    drawingInstances.Box.Visible = false
                                    drawingInstances.BoxOutline.Visible = false
                                end

                                if esp.health then
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                                    if humanoid and humanoid.Health and humanoid.MaxHealth and humanoid.MaxHealth > 0 then
                                        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                                        local healthBarHeight = boxSize.Y * healthPercent
                                        drawingInstances.Health.From = Vector2.new(boxPosition.X - 6, boxPosition.Y + boxSize.Y)
                                        drawingInstances.Health.To = Vector2.new(boxPosition.X - 6, boxPosition.Y + boxSize.Y - healthBarHeight)
                                        drawingInstances.Health.Visible = true
                                        drawingInstances.Health.Color = esp.healthcolor
                                        drawingInstances.HealthOutline.From = Vector2.new(boxPosition.X - 7, boxPosition.Y + boxSize.Y + 1)
                                        drawingInstances.HealthOutline.To = Vector2.new(boxPosition.X - 5, boxPosition.Y - 1)
                                        drawingInstances.HealthOutline.Visible = true
                                        drawingInstances.HealthOutline.Color = esp.healthoutline
                                        
                                        if esp.healthbartext then
                                            drawingInstances.HealthText.Text = math.floor(humanoid.Health)
                                            drawingInstances.HealthText.Position = Vector2.new(boxPosition.X - 20, boxPosition.Y + boxSize.Y/2)
                                            drawingInstances.HealthText.Visible = true
                                            drawingInstances.HealthText.Color = esp.healthbartextcolor
                                        else
                                            drawingInstances.HealthText.Visible = false
                                        end
                                    end
                                else
                                    drawingInstances.Health.Visible = false
                                    drawingInstances.HealthOutline.Visible = false
                                    drawingInstances.HealthText.Visible = false
                                end

                                if esp.name then
                                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                                    if humanoid and humanoid.DisplayName then
                                        drawingInstances.Name.Visible = true
                                        drawingInstances.Name.Text = string.format("<%s>", humanoid.DisplayName)
                                        drawingInstances.Name.Position = Vector2.new(boxSize.X/2 + boxPosition.X, boxPosition.Y - 16)
                                        drawingInstances.Name.Color = esp.namecolor
                                        if esp.fading then
                                            drawingInstances.Name.Transparency = 1 - (math.sin(tick() * esp.espfadespeed) + 1) / 2
                                        else
                                            drawingInstances.Name.Transparency = 1 - esp.nametransparency
                                        end
                                    else
                                        drawingInstances.Name.Visible = false
                                    end
                                else
                                    drawingInstances.Name.Visible = false
                                end
                            end
                        else
                            drawingInstances.Box.Visible = false
                            drawingInstances.BoxOutline.Visible = false
                            drawingInstances.Health.Visible = false
                            drawingInstances.HealthOutline.Visible = false
                            drawingInstances.Name.Visible = false
                            drawingInstances.HealthText.Visible = false
                        end
                    end
                else
                    drawingInstances.Box.Visible = false
                    drawingInstances.BoxOutline.Visible = false
                    drawingInstances.Health.Visible = false
                    drawingInstances.HealthOutline.Visible = false
                    drawingInstances.Name.Visible = false
                    drawingInstances.HealthText.Visible = false
                end
            end
        end
        end)
    end
end)


Players.PlayerAdded:Connect(function(targetPlayer)
    esp.players[targetPlayer] = createESPDrawings()
end)


for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        esp.players[targetPlayer] = createESPDrawings()
    end
end


Players.PlayerRemoving:Connect(function(targetPlayer)
    if esp.players[targetPlayer] then
        for _, drawingObject in pairs(esp.players[targetPlayer]) do
            if drawingObject and drawingObject.Remove then
                drawingObject:Remove()
            end
        end
        esp.players[targetPlayer] = nil
    end
end)


local function updateSpeed()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if speedEnabled then
            humanoid.WalkSpeed = speedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end

local function updateJump()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        humanoid.JumpPower = jumpValue
    end
end

local bodyVelocity = nil
local function updateFly()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local humanoidRootPart = player.Character.HumanoidRootPart
    
    if flyEnabled then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
            bodyVelocity.Parent = humanoidRootPart
        end
        
        local moveVector = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveVector * speedValue
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
    end
end

-- Anti-Lock: small random jitters in HumanoidRootPart each RenderStepped frame
local function startAntiLock()
    if antiLockConnection then return end
    antiLockConnection = RunService.RenderStepped:Connect(function()
        if not antiLockEnabled then return end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local offset = Vector3.new((math.random()-0.5)*0.4, (math.random()-0.5)*0.4, (math.random()-0.5)*0.4)
            hrp.CFrame = hrp.CFrame + offset
        end
    end)
end

local function stopAntiLock()
    if antiLockConnection then
        antiLockConnection:Disconnect()
        antiLockConnection = nil
    end
end


local function Create(instanceType, properties)
    local inst = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        inst[prop] = value
    end
    return inst
end


local tabColumn = Create("Frame", {
    Name = "TabColumn",
    Parent = mainFrame,
    BackgroundColor3 = Color3.fromRGB(32, 34, 37),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 72, 1, 0),
})
Create("UICorner", {Parent = tabColumn, CornerRadius = UDim.new(0, 8)})

local tabListLayout = Create("UIListLayout", {
    Parent = tabColumn,
    FillDirection = Enum.FillDirection.Vertical,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
})
Create("UIPadding", {Parent = tabColumn, PaddingTop = UDim.new(0, 12)})


local sectionColumn = Create("Frame", {
    Name = "SectionColumn",
    Parent = mainFrame,
    BackgroundColor3 = Color3.fromRGB(47, 49, 54),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 220, 1, 0),
    Position = UDim2.new(0, 72, 0, 0),
})

local sectionHeader = Create("TextLabel", {
    Name = "SectionHeader",
    Parent = sectionColumn,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 52),
    Font = Enum.Font.SourceSansBold,
    Text = "GZHub V1",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})
Create("UIPadding", {Parent = sectionHeader, PaddingLeft = UDim.new(0, 16)})
Create("Frame", {
    Parent = sectionHeader,
    BackgroundColor3 = Color3.fromRGB(32, 34, 37),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
})


local sectionList = Create("ScrollingFrame", {
    Name = "SectionList",
    Parent = sectionColumn,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, -52),
    Position = UDim2.new(0, 0, 0, 52),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = Color3.fromRGB(32, 34, 37),
})
local sectionListLayout = Create("UIListLayout", {
    Parent = sectionList,
    Padding = UDim.new(0, 2),
})
Create("UIPadding", {
    Parent = sectionList,
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 16),
})


sectionListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    sectionList.CanvasSize = UDim2.new(0, 0, 0, sectionListLayout.AbsoluteContentSize.Y + 16)
end)


local contentColumn = Create("Frame", {
    Name = "ContentColumn",
    Parent = mainFrame,
    BackgroundColor3 = Color3.fromRGB(54, 57, 63),
    BorderSizePixel = 0,
    Size = UDim2.new(1, -292 - 180, 1, 0),
    Position = UDim2.new(0, 292, 0, 0),
})
Create("UICorner", {Parent = contentColumn, CornerRadius = UDim.new(0, 8)})
contentColumn.ClipsDescendants = true

local contentHeader = Create("TextLabel", {
    Name = "ContentHeader",
    Parent = contentColumn,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 52),
    Font = Enum.Font.SourceSansBold,
    Text = "General",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
})
Create("UIPadding", {Parent = contentHeader, PaddingLeft = UDim.new(0, 20)})
Create("Frame", {
    Parent = contentHeader,
    BackgroundColor3 = Color3.fromRGB(32, 34, 37),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
})

local contentScroll = Create("ScrollingFrame", {
    Name = "ContentScroll",
    Parent = contentColumn,
    BackgroundColor3 = Color3.fromRGB(54, 57, 63),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, -52),
    Position = UDim2.new(0, 0, 0, 52),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarImageColor3 = Color3.fromRGB(32, 34, 37),
    ScrollBarThickness = 6,
})
local contentListLayout = Create("UIListLayout", {
    Parent = contentScroll,
    Padding = UDim.new(0, 15),
})
Create("UIPadding", {
    Parent = contentScroll,
    PaddingLeft = UDim.new(0, 20),
    PaddingRight = UDim.new(0, 20),
    PaddingTop = UDim.new(0, 20),
    PaddingBottom = UDim.new(0, 20),
})


local leaderboardColumn = Create("Frame", {
    Name = "LeaderboardColumn",
    Parent = mainFrame,
    BackgroundColor3 = Color3.fromRGB(47, 49, 54),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 180, 1, 0),
    Position = UDim2.new(1, -180, 0, 0),
})
Create("UICorner", {Parent = leaderboardColumn, CornerRadius = UDim.new(0, 8)})

local lbHeader = Create("TextLabel", {
    Name = "LBHeader",
    Parent = leaderboardColumn,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 52),
    Font = Enum.Font.SourceSansBold,
    Text = "Players",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Center,
})
Create("Frame", {
    Parent = lbHeader,
    BackgroundColor3 = Color3.fromRGB(32, 34, 37),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
})

local lbScroll = Create("ScrollingFrame", {
    Name = "LBScroll",
    Parent = leaderboardColumn,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, -52),
    Position = UDim2.new(0, 0, 0, 52),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 6,
})
local lbLayout = Create("UIListLayout", {
    Parent = lbScroll,
    Padding = UDim.new(0, 4),
})
Create("UIPadding", {
    Parent = lbScroll,
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
    PaddingTop = UDim.new(0, 8),
})


local activeTab = { button = nil, sections = {} }
local activeSection = { button = nil, content = nil }


local function createSectionHeader(parent, text)
    return Create("TextLabel", {
        Name = text .. "Header",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 24),
        Font = Enum.Font.SourceSansBold,
        Text = string.upper(text),
        TextColor3 = Color3.fromRGB(185, 187, 190),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
end

local function createToggle(parent, label, callback)
    local frame = Create("Frame", {
        Name = label .. "Toggle",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
    })
    Create("UIListLayout", {
        Parent = frame,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
    })
    Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = label,
        TextColor3 = Color3.fromRGB(220, 221, 222),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 1,
    })
    local switch = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(114, 118, 125),
        Size = UDim2.new(0, 50, 0, 26),
        AutoButtonColor = false,
        Text = "",
        LayoutOrder = 2,
    })
    Create("UICorner", { Parent = switch, CornerRadius = UDim.new(0.5, 0) })
    local knob = Create("Frame", {
        Parent = switch,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 3, 0.5, -10),
    })
    Create("UICorner", { Parent = knob, CornerRadius = UDim.new(0.5, 0) })
    local enabled = false
    attachClickSound(switch)
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if enabled then
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(0, 27, 0.5, -10),
            }):Play()
            TweenService:Create(switch, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(59, 165, 93),
            }):Play()
        else
            TweenService:Create(knob, tweenInfo, {
                Position = UDim2.new(0, 3, 0.5, -10),
            }):Play()
            TweenService:Create(switch, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(114, 118, 125),
            }):Play()
        end
        
        if callback then
            callback(enabled)
        end
    end)
    return frame
end


local function createDropdown(parent, label, options, default, callback)
    -- Validate inputs
    if not parent or not label or not options or #options == 0 then
        warn("createDropdown: Invalid parameters provided")
        return nil
    end
    
    local selectedValue = default or options[1]
    
    -- Main container frame
    local frame = Create("Frame", {
        Name = label .. "Dropdown",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
    })
    
    -- Layout for horizontal arrangement
    Create("UIListLayout", {
        Parent = frame,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
    })
    
    -- Label
    Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = label,
        TextColor3 = Color3.fromRGB(220, 221, 222),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 1,
    })
    
    -- Dropdown button
    local dropdown = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(54, 57, 63),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(72, 75, 81),
        Size = UDim2.new(0.5, -8, 0, 26),
        AutoButtonColor = false,
        Text = selectedValue,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2,
    })
    Create("UICorner", { Parent = dropdown, CornerRadius = UDim.new(0, 6) })
    Create("UIPadding", { Parent = dropdown, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 30) })
    attachClickSound(dropdown)
    -- Dropdown arrow
    local arrow = Create("TextLabel", {
        Parent = dropdown,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -25, 0, 0),
        Text = "▼",
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(185, 187, 190),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    ...
    -- Main dropdown click handler
    dropdown.MouseButton1Click:Connect(function()
        local isOpening = not dropdownList.Visible
        
        dropdownList.Visible = isOpening
        shadow.Visible = isOpening
        
        if isOpening then
            -- Opening dropdown
            dropdown.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
            dropdown.BorderColor3 = Color3.fromRGB(114, 137, 218)
            arrow.TextColor3 = Color3.fromRGB(114, 137, 218)
            arrow.Text = "▲"
            
            -- Ensure proper selection highlighting
            for option, button in pairs(optionButtons) do
                if option == selectedValue then
                    button.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                    button.TextColor3 = Color3.fromRGB(220, 221, 222)
                end
            end
        else
            -- Closing dropdown
            dropdown.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            dropdown.BorderColor3 = Color3.fromRGB(72, 75, 81)
            arrow.TextColor3 = Color3.fromRGB(185, 187, 190)
            arrow.Text = "▼"
        end
    end)
    ...
    return frame
end
        
        -- Hover effects
        optionButton.MouseEnter:Connect(function()
            if option ~= selectedValue then
                optionButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        optionButton.MouseLeave:Connect(function()
            if option ~= selectedValue then
                optionButton.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                optionButton.TextColor3 = Color3.fromRGB(220, 221, 222)
            end
        end)
        
        -- Click handler
        optionButton.MouseButton1Click:Connect(function()
            -- Update selection
            if selectedValue ~= option then
                -- Reset previous selection
                if optionButtons[selectedValue] then
                    optionButtons[selectedValue].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                    optionButtons[selectedValue].TextColor3 = Color3.fromRGB(220, 221, 222)
                end
                
                -- Set new selection
                selectedValue = option
                dropdown.Text = option
                optionButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
                optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                
                -- Call callback
                if callback then
                    pcall(callback, option)
                end
            end
            
            -- Close dropdown
            dropdownList.Visible = false
            shadow.Visible = false
            arrow.Text = "▼"
            arrow.TextColor3 = Color3.fromRGB(185, 187, 190)
            dropdown.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            dropdown.BorderColor3 = Color3.fromRGB(72, 75, 81)
        end)
    end
    
    -- Hover effects for main dropdown
    dropdown.MouseEnter:Connect(function()
        if not dropdownList.Visible then
            dropdown.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
            dropdown.BorderColor3 = Color3.fromRGB(114, 137, 218)
            arrow.TextColor3 = Color3.fromRGB(114, 137, 218)
        end
    end)
    
    dropdown.MouseLeave:Connect(function()
        if not dropdownList.Visible then
            dropdown.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            dropdown.BorderColor3 = Color3.fromRGB(72, 75, 81)
            arrow.TextColor3 = Color3.fromRGB(185, 187, 190)
        end
    end)
    
    -- Main dropdown click handler
    dropdown.MouseButton1Click:Connect(function()
        local isOpening = not dropdownList.Visible
        
        dropdownList.Visible = isOpening
        shadow.Visible = isOpening
        
        if isOpening then
            -- Opening dropdown
            dropdown.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
            dropdown.BorderColor3 = Color3.fromRGB(114, 137, 218)
            arrow.TextColor3 = Color3.fromRGB(114, 137, 218)
            arrow.Text = "▲"
            
            -- Ensure proper selection highlighting
            for option, button in pairs(optionButtons) do
                if option == selectedValue then
                    button.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
                    button.TextColor3 = Color3.fromRGB(255, 255, 255)
                else
                    button.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                    button.TextColor3 = Color3.fromRGB(220, 221, 222)
                end
            end
        else
            -- Closing dropdown
            dropdown.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            dropdown.BorderColor3 = Color3.fromRGB(72, 75, 81)
            arrow.TextColor3 = Color3.fromRGB(185, 187, 190)
            arrow.Text = "▼"
        end
    end)
    
    -- Close dropdown function
    local function closeDropdown()
        if dropdownList.Visible then
            dropdownList.Visible = false
            shadow.Visible = false
            dropdown.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            dropdown.BorderColor3 = Color3.fromRGB(72, 75, 81)
            arrow.TextColor3 = Color3.fromRGB(185, 187, 190)
            arrow.Text = "▼"
        end
    end
    
    -- Outside click detection
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdownList.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            
            -- Check if click is outside dropdown elements
            local function isPointInFrame(point, frame)
                local pos = frame.AbsolutePosition
                local size = frame.AbsoluteSize
                return point.X >= pos.X and point.X <= pos.X + size.X and
                       point.Y >= pos.Y and point.Y <= pos.Y + size.Y
            end
            
            if not isPointInFrame(mousePos, dropdown) and not isPointInFrame(mousePos, dropdownList) then
                closeDropdown()
            end
        end
    end)
    
    -- Clean up connection when frame is destroyed
    frame.AncestryChanged:Connect(function()
        if not frame.Parent then
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    return frame
end

local function createSlider(parent, label, min, max, default, callback)
    min = min or 0
    max = max or 100
    default = default or 50
    local value = default
    local frame = Create("Frame", {
        Name = label .. "Slider",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40),
    })


    local labelContainer = Create("Frame", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
    })
    Create("TextLabel", {
        Parent = labelContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = label,
        TextColor3 = Color3.fromRGB(220, 221, 222),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    local valueLabel = Create("TextLabel", {
        Parent = labelContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(185, 187, 190),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
    })


    local track = Create("Frame", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(32, 34, 37),
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 0, 22),
    })
    Create("UICorner", {
        Parent = track,
        CornerRadius = UDim.new(0.5, 0),
    })


    local progress = Create("Frame", {
        Parent = track,
        BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
    })
    Create("UICorner", {
        Parent = progress,
        CornerRadius = UDim.new(0.5, 0),
    })


    local knob = Create("Frame", {
        Parent = track,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(progress.Size.X.Scale, -9, 0.5, -9),
        ZIndex = 2,
        BorderSizePixel = 0,
    })
    Create("UICorner", {
        Parent = knob,
        CornerRadius = UDim.new(0.5, 0),
    })
    attachClickSound(track)

    local dragging = false

    local function startDrag()
        dragging = true
        windowFrame.Active = false
    end
    local function endDrag()
        dragging = false
        windowFrame.Active = true
    end


    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag()
        end
    end)
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag()
        end
    end)


    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            endDrag()
        end
    end)


    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local trackStart = track.AbsolutePosition.X
            local trackWidth = track.AbsoluteSize.X
            local percent = math.clamp((mouseX - trackStart) / trackWidth, 0, 1)
            value = math.floor((min + (max - min) * percent) + 0.5)
            valueLabel.Text = tostring(value)
            progress.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -9, 0.5, -9)
            
            if callback then
                callback(value)
            end
        end
    end)

    return frame
end


local function setActiveSection(sectionButton, contentFrame)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if activeSection.button then
        TweenService:Create(activeSection.button, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(47, 49, 54)
        }):Play()
        TweenService:Create(activeSection.button.NameLabel, tweenInfo, {
            TextColor3 = Color3.fromRGB(185, 187, 190)
        }):Play()
    end
    if activeSection.content then
        activeSection.content.Visible = false
    end
    
    TweenService:Create(sectionButton, tweenInfo, {
        BackgroundColor3 = Color3.fromRGB(63, 66, 72)
    }):Play()
    TweenService:Create(sectionButton.NameLabel, tweenInfo, {
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
    
    contentFrame.Visible = true
    
    activeSection.button = sectionButton
    activeSection.content = contentFrame
    contentHeader.Text = sectionButton.Name
    

    spawn(function()
        wait(0.1)
        if contentFrame:FindFirstChildOfClass("UIListLayout") then
            contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentFrame:FindFirstChildOfClass("UIListLayout").AbsoluteContentSize.Y + 40)
        end
    end)
end

local function createSection(tabData, name, icon)
    local button = Create("TextButton", {
        Name = name,
        Parent = sectionList,
        BackgroundColor3 = Color3.fromRGB(47, 49, 54),
        Size = UDim2.new(1, 0, 0, 34),
        AutoButtonColor = false,
        Text = "",
    })
    Create("UICorner", {Parent = button, CornerRadius = UDim.new(0, 4)})
    Create("UIListLayout", {
        Parent = button,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
    })
    Create("UIPadding", {Parent = button, PaddingLeft = UDim.new(0, 8)})
    Create("TextLabel", {
        Name = "IconLabel",
        Parent = button,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 1, 0),
        Font = Enum.Font.SourceSansBold,
        Text = icon,
        TextColor3 = Color3.fromRGB(142, 146, 151),
        TextSize = 20,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 1,
    })
    Create("TextLabel", {
        Name = "NameLabel",
        Parent = button,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -56, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = name,
        TextColor3 = Color3.fromRGB(185, 187, 190),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 2,
    })
    local contentFrame = Create("Frame", {
        Name = name .. "Content",
        Parent = contentScroll,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 0),
        Visible = false,
    })
    Create("UIListLayout", {Parent = contentFrame, Padding = UDim.new(0, 10)})
    table.insert(tabData.sections, {button = button, content = contentFrame})
    button.MouseButton1Click:Connect(function()
        setActiveSection(button, contentFrame)
    end)
    return contentFrame
end

local function setActiveTab(tabButton, tabData)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if activeTab.button then
        TweenService:Create(activeTab.button, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(47, 49, 54)
        }):Play()
        TweenService:Create(activeTab.button:FindFirstChildOfClass("UICorner"), tweenInfo, {
            CornerRadius = UDim.new(0.5, 0)
        }):Play()
    end
    

    for _, child in ipairs(sectionList:GetChildren()) do
        if child:IsA("TextButton") then
            child.Visible = false
        end
    end
    

    for _, child in ipairs(contentScroll:GetChildren()) do
        if child:IsA("Frame") and child.Name:find("Content") then
            child.Visible = false
        end
    end
    

    for _, section in ipairs(activeTab.sections) do
        section.button.Visible = false
        section.content.Visible = false
    end
    
    TweenService:Create(tabButton, tweenInfo, {
        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    }):Play()
    TweenService:Create(tabButton:FindFirstChildOfClass("UICorner"), tweenInfo, {
        CornerRadius = UDim.new(0, 12)
    }):Play()
    
    activeTab.button = tabButton
    activeTab.sections = tabData.sections
    

    for i, section in ipairs(tabData.sections) do
        section.button.Visible = true
        section.button.BackgroundTransparency = 1
        local fadeIn = TweenService:Create(section.button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0
        })
        fadeIn:Play()
    end
    
    if #tabData.sections > 0 then
        setActiveSection(tabData.sections[1].button, tabData.sections[1].content)
    else
        if activeSection.button then
            TweenService:Create(activeSection.button, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(47, 49, 54)
            }):Play()
            TweenService:Create(activeSection.button.NameLabel, tweenInfo, {
                TextColor3 = Color3.fromRGB(185, 187, 190)
            }):Play()
        end
        if activeSection.content then
            activeSection.content.Visible = false
        end
        contentHeader.Text = ""
    end
end


local mainTabData = { sections = {} }
local aimbotContent = createSection(mainTabData, "Aimbot", "🎯")
createToggle(aimbotContent, "Aimbot", function(enabled)
    aimbotEnabled = enabled
    if enabled then
        startAimbot()
    else
        stopAimbot()
    end
end)

-- AimeView toggle
local aimeViewEnabled = false
createToggle(aimbotContent, "AimeView", function(enabled)
    aimeViewEnabled = enabled
end)

local function createKeybindPicker(parent, label, default, callback)
    local selectedKey = default or "Right Click"
    local waitingForKey = false

    local frame = Create("Frame", {
        Name = label .. "KeybindPicker",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
    })
    Create("UIListLayout", {
        Parent = frame,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
    })
    Create("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = label,
        TextColor3 = Color3.fromRGB(220, 221, 222),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 1,
    })
    local keyButton = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(54, 57, 63),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(72, 75, 81),
        Size = UDim2.new(0.5, -38, 0, 26),
        AutoButtonColor = false,
        Text = selectedKey,
        Font = Enum.Font.SourceSansSemibold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = 2,
    })
    Create("UICorner", { Parent = keyButton, CornerRadius = UDim.new(0, 6) })
    Create("UIPadding", { Parent = keyButton, PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) })
    attachClickSound(keyButton)
    -- Quick Right Click button
    local rightClickButton = Create("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(114, 137, 218),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(114, 137, 218),
        Size = UDim2.new(0, 26, 0, 26),
        AutoButtonColor = false,
        Text = "🖱️",
        Font = Enum.Font.SourceSansBold,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        LayoutOrder = 3,
    })
    Create("UICorner", { Parent = rightClickButton, CornerRadius = UDim.new(0, 6) })
    attachClickSound(rightClickButton)
    -- Right click button functionality
    rightClickButton.MouseButton1Click:Connect(function()
        if not waitingForKey then
            selectedKey = "Right Click"
            keyButton.Text = "Right Click"
            keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            keyButton.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            if callback then
                callback("Right Click")
            end
        end
    end)
    
    -- Right click button hover effects
    rightClickButton.MouseEnter:Connect(function()
        rightClickButton.BackgroundColor3 = Color3.fromRGB(134, 157, 238)
        rightClickButton.BorderColor3 = Color3.fromRGB(134, 157, 238)
    end)
    
    rightClickButton.MouseLeave:Connect(function()
        rightClickButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
        rightClickButton.BorderColor3 = Color3.fromRGB(114, 137, 218)
    end)

    keyButton.MouseButton1Click:Connect(function()
        if not waitingForKey then
            waitingForKey = true
            keyButton.Text = "Press any key..."
            keyButton.TextColor3 = Color3.fromRGB(114, 137, 218)
            keyButton.BackgroundColor3 = Color3.fromRGB(64, 68, 75)
        end
    end)

    local inputConn
    inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey and not gameProcessed then
            local keyName = nil
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keyName = tostring(input.KeyCode.Name)
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                keyName = "Left Click"
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                keyName = "Right Click"
            elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                keyName = "Middle Click"
            end
            if keyName then
                selectedKey = keyName
                keyButton.Text = keyName
                keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                keyButton.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                waitingForKey = false
                if callback then
                    callback(keyName)
                end
            end
        end
    end)
    frame.AncestryChanged:Connect(function()
        if not frame.Parent and inputConn then
            inputConn:Disconnect()
        end
    end)
    return frame
end

createKeybindPicker(aimbotContent, "Keybind", aimbotKeybind, function(value)
    aimbotKeybind = value
end)
createToggle(aimbotContent, "Toggle Mode", function(enabled)
    aimbotToggleMode = enabled
    if not enabled then
        aimbotToggleActive = false
    end
end)
createSlider(aimbotContent, "Smoothness", 0, 100, 80, function(value)
    aimbotSmoothness = value
end)
createSlider(aimbotContent, "Prediction", 0, 50, 10, function(value)
    aimbotPrediction = value
end)

local fovContent = createSection(mainTabData, "FOV Settings", "⭕")
createToggle(fovContent, "FOV Enabled", function(enabled)
    fovEnabled = enabled
    updateFOVCircle()
end)
createToggle(fovContent, "Show FOV Circle", function(enabled)
    fovVisible = enabled
    updateFOVCircle()
end)
createSlider(fovContent, "FOV Size", 50, 300, 100, function(value)
    fovSize = value
    updateFOVCircle()
end)

local visualsContent = createSection(mainTabData, "Visuals", "#")
createToggle(visualsContent, "ESP", function(enabled)
    esp.enabled = enabled
end)
createToggle(visualsContent, "Boxes", function(enabled)
    esp.box = enabled
end)
createToggle(visualsContent, "Health Boxes", function(enabled)
    esp.health = enabled
end)
createToggle(visualsContent, "Names", function(enabled)
    esp.name = enabled
end)
Create("TextLabel", {
    Parent = visualsContent,
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(88, 101, 242),
    Text = "ESP Color Picker >",
    Size = UDim2.new(1,0,0,20),
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- SHADERS TAB START
local Lighting = game:GetService("Lighting")
local shaderState = { mode = "None" }

local function clearShaders()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
end

local function applyUltraShaders()
    clearShaders()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.1
    cc.Contrast = 0.25
    cc.Saturation = 0.2
    cc.TintColor = Color3.fromRGB(200, 220, 255)
    cc.Parent = Lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 1.2
    bloom.Size = 56
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    local dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.2
    dof.FocusDistance = 30
    dof.InFocusRadius = 20
    dof.NearIntensity = 0.3
    dof.Parent = Lighting
    local sun = Instance.new("SunRaysEffect")
    sun.Intensity = 0.15
    sun.Spread = 0.25
    sun.Parent = Lighting
    local blur = Instance.new("BlurEffect")
    blur.Size = 2
    blur.Parent = Lighting
end

local function applyMidShaders()
    clearShaders()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = 0.1
    cc.TintColor = Color3.fromRGB(180, 200, 230)
    cc.Parent = Lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.5
    bloom.Size = 32
    bloom.Threshold = 0.9
    bloom.Parent = Lighting
    local dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.1
    dof.FocusDistance = 100
    dof.InFocusRadius = 80
    dof.NearIntensity = 0.1
    dof.Parent = Lighting
end

local function setShaderMode(mode)
    shaderState.mode = mode
    if mode == "Ultra Shaders" then
        applyUltraShaders()
    elseif mode == "Mid Shaders" then
        applyMidShaders()
    else
        clearShaders()
    end
end

local shadersContent = createSection(mainTabData, "Shaders", "✨")
Create("TextLabel", {
    Parent = shadersContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 22),
    Font = Enum.Font.SourceSansSemibold,
    Text = "Shader Preset:",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local shaderDropdown = createDropdown(shadersContent, "Mode", {"None", "Ultra Shaders", "Mid Shaders"}, "None", function(option)
    setShaderMode(option)
end)

-- Add a description
Create("TextLabel", {
    Parent = shadersContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 18),
    Font = Enum.Font.SourceSans,
    Text = "Ultra = cinematic, Mid = performance, None = default",
    TextColor3 = Color3.fromRGB(185, 187, 190),
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
})
-- SHADERS TAB END

local movementContent = createSection(mainTabData, "Movement", "#")
createSlider(movementContent, "Speed", 16, 100, 16, function(value)
    speedValue = value
    updateSpeed()
end)
createToggle(movementContent, "Fly", function(enabled)
    flyEnabled = enabled
    updateFly()
end)
createSlider(movementContent, "Jump Speed", 50, 200, 50, function(value)
    jumpValue = value
    updateJump()
end)

createToggle(movementContent, "Anti-Lock", function(enabled)
    antiLockEnabled = enabled
    if enabled then
        startAntiLock()
    else
        stopAntiLock()
    end
end)


local settingsTabData = { sections = {} }


local guiCustomContent = createSection(settingsTabData, "GUI Settings", "🎨")


local themeFrame = Create("Frame", {
    Name = "ThemeFrame",
    Parent = guiCustomContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 50),
})
Create("TextLabel", {
    Parent = themeFrame,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSansSemibold,
    Text = "Theme",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local themeButtons = {}
local themes = {
    {name = "Dark",   colors = {Color3.fromRGB(24,24,32), Color3.fromRGB(36,36,54)}},
    {name = "Purple", colors = {Color3.fromRGB(58,24,86), Color3.fromRGB(120,66,138)}},
    {name = "Blue",   colors = {Color3.fromRGB(33,105,189), Color3.fromRGB(22, 62, 97)}},
    {name = "Green",  colors = {Color3.fromRGB(44, 98, 70), Color3.fromRGB(30, 51, 36)}},
    {name = "Neon",   colors = {Color3.fromRGB(0,255,255), Color3.fromRGB(255,0,255)}}
}

local themeContainer = Create("Frame", {
    Parent = themeFrame,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 0, 25),
})
Create("UIListLayout", {
    Parent = themeContainer,
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5),
})

for i, theme in ipairs(themes) do
    local themeBtn = Create("TextButton", {
        Parent = themeContainer,
        BackgroundColor3 = theme.colors[1],
        Size = UDim2.new(0, 60, 0, 25),
        Font = Enum.Font.SourceSans,
        Text = theme.name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        AutoButtonColor = false,
    })
    Create("UICorner", {Parent = themeBtn, CornerRadius = UDim.new(0, 4)})
    Create("UIGradient", {
        Parent = themeBtn,
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0, theme.colors[1]), ColorSequenceKeypoint.new(1, theme.colors[2])}
    })
    
    themeButtons[theme.name:lower()] = themeBtn
    
    themeBtn.MouseButton1Click:Connect(function()
        guiSettings.theme = theme.name:lower()
        
        if guiSettings.animations then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(windowFrame, tweenInfo, {BackgroundColor3 = theme.colors[1]}):Play()
            TweenService:Create(gradient, tweenInfo, {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0, theme.colors[1]), ColorSequenceKeypoint.new(1, theme.colors[2])}
            }):Play()
        else
            windowFrame.BackgroundColor3 = theme.colors[1]
            gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, theme.colors[1]), ColorSequenceKeypoint.new(1, theme.colors[2])}
        end
        
        
        for _, btn in pairs(themeButtons) do
            btn.BorderSizePixel = 0
        end
        themeBtn.BorderSizePixel = 2
        themeBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end)
end


themeButtons[guiSettings.theme].BorderSizePixel = 2
themeButtons[guiSettings.theme].BorderColor3 = Color3.fromRGB(255, 255, 255)


local function applyTransparencyToAll(parent, transparency)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
        
            if child.BackgroundTransparency ~= 1 then
                child.BackgroundTransparency = math.min(child.BackgroundTransparency + transparency, 1)
            end
            
        
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                child.TextTransparency = transparency
            end
            
        
            if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                child.ImageTransparency = transparency
            end
            
        
            applyTransparencyToAll(child, transparency)
        end
    end
end


local function scaleAllElements(parent, scale, originalSizes)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
    
            if not originalSizes[child] then
                originalSizes[child] = {
                    Size = child.Size,
                    Position = child.Position,
                    TextSize = child:IsA("TextLabel") and child.TextSize or child:IsA("TextButton") and child.TextSize or child:IsA("TextBox") and child.TextSize or nil
                }
            end
            
            local original = originalSizes[child]
            
    
            child.Size = UDim2.new(
                original.Size.X.Scale,
                original.Size.X.Offset * scale,
                original.Size.Y.Scale,
                original.Size.Y.Offset * scale
            )
            
    
            child.Position = UDim2.new(
                original.Position.X.Scale,
                original.Position.X.Offset * scale,
                original.Position.Y.Scale,
                original.Position.Y.Offset * scale
            )
            
    
            if original.TextSize then
                child.TextSize = math.max(1, original.TextSize * scale)
            end
            
    
            local uiCorner = child:FindFirstChild("UICorner")
            if uiCorner then
                if not originalSizes[uiCorner] then
                    originalSizes[uiCorner] = {CornerRadius = uiCorner.CornerRadius}
                end
                uiCorner.CornerRadius = UDim.new(
                    originalSizes[uiCorner].CornerRadius.Scale,
                    originalSizes[uiCorner].CornerRadius.Offset * scale
                )
            end
            
    
            scaleAllElements(child, scale, originalSizes)
        end
    end
end


local originalSizes = {}


createSlider(guiCustomContent, "Transparency", 0, 90, 0, function(value)
    guiSettings.transparency = value / 100
    

    local function resetTransparency(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child:IsA("GuiObject") then
                if child.Name ~= "GlowFrame" then
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        child.TextTransparency = 0
                    end
                    if child:IsA("ImageLabel") or child:IsA("ImageButton") then
                        child.ImageTransparency = 0
                    end
            
                    if child.BackgroundTransparency ~= 1 then
                        child.BackgroundTransparency = 0
                    end
                end
                resetTransparency(child)
            end
        end
    end
    
    resetTransparency(windowFrame)
    

    windowFrame.BackgroundTransparency = guiSettings.transparency
    applyTransparencyToAll(windowFrame, guiSettings.transparency)
end)


createSlider(guiCustomContent, "Scale", 50, 150, 100, function(value)
    guiSettings.scale = value / 100
    

    if not originalSizes[windowFrame] then
        originalSizes[windowFrame] = {
            Size = UDim2.new(0, 800, 0, 500),
            Position = UDim2.new(0.5, -400, 0.5, -250)
        }
    end
    
    if guiSettings.animations then
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(windowFrame, tweenInfo, {
            Size = UDim2.new(0, 800 * guiSettings.scale, 0, 500 * guiSettings.scale),
            Position = UDim2.new(0.5, -400 * guiSettings.scale, 0.5, -250 * guiSettings.scale)
        }):Play()
        

        task.wait(0.1)
        scaleAllElements(windowFrame, guiSettings.scale, originalSizes)
    else
        windowFrame.Size = UDim2.new(0, 800 * guiSettings.scale, 0, 500 * guiSettings.scale)
        windowFrame.Position = UDim2.new(0.5, -400 * guiSettings.scale, 0.5, -250 * guiSettings.scale)
        

        scaleAllElements(windowFrame, guiSettings.scale, originalSizes)
    end
end)


createToggle(guiCustomContent, "Animations", function(enabled)
    guiSettings.animations = enabled
end)


local keybindsContent = createSection(settingsTabData, "Keybinds", "⌨️")

Create("TextLabel", {
    Parent = keybindsContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSansSemibold,
    Text = "Toggle GUI: INSERT",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
    Parent = keybindsContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSansSemibold,
    Text = "Aimbot: Right Mouse Button (Hold)",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})


local aboutContent = createSection(settingsTabData, "About", "ℹ️")

Create("TextLabel", {
    Parent = aboutContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 25),
    Font = Enum.Font.SourceSansBold,
    Text = "GZHub V1",
    TextColor3 = Color3.fromRGB(114, 137, 218),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
    Parent = aboutContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSans,
    Text = "Version: 1.0",
    TextColor3 = Color3.fromRGB(185, 187, 190),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
    Parent = aboutContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSans,
    Text = "Features: Aimbot, ESP, Movement, GUI Customization",
    TextColor3 = Color3.fromRGB(185, 187, 190),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})

Create("TextLabel", {
    Parent = aboutContent,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 20),
    Font = Enum.Font.SourceSans,
    Text = "Status: ✅ Fully Operational",
    TextColor3 = Color3.fromRGB(67, 181, 129),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})


local function brightenColor(color3, amount)
    return Color3.new(
        math.clamp(color3.R + amount/255, 0, 1),
        math.clamp(color3.G + amount/255, 0, 1),
        math.clamp(color3.B + amount/255, 0, 1)
    )
end

local function applySidebarHoverAnim(button)
    local origSize = button.Size
    local hoverSize = UDim2.new(0, 54, 0, 54)
    local origBG = button.BackgroundColor3
    local hoverBG = brightenColor(origBG, 20)
    local origTrans = button.BackgroundTransparency or 0

    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = hoverSize,
            BackgroundColor3 = hoverBG,
            BackgroundTransparency = 0.09
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = origSize,
            BackgroundColor3 = origBG,
            BackgroundTransparency = origTrans
        }):Play()
    end)
end

local mainTabButton = Create("TextButton", {
    Name = "MainTab",
    Parent = tabColumn,
    BackgroundColor3 = Color3.fromRGB(47, 49, 54),
    Size = UDim2.new(0, 48, 0, 48),
    LayoutOrder = 1,
    Font = Enum.Font.SourceSansBold,
    Text = "🎮",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 24,
    AutoButtonColor = false,
})
Create("UICorner", {Parent = mainTabButton, CornerRadius = UDim.new(0.5, 0)})
local settingsTabButton = Create("TextButton", {
    Name = "SettingsTab",
    Parent = tabColumn,
    BackgroundColor3 = Color3.fromRGB(47, 49, 54),
    Size = UDim2.new(0, 48, 0, 48),
    LayoutOrder = 2,
    Font = Enum.Font.SourceSansBold,
    Text = "⚙️",
    TextColor3 = Color3.fromRGB(220, 221, 222),
    TextSize = 24,
    AutoButtonColor = false,
})
Create("UICorner", {Parent = settingsTabButton, CornerRadius = UDim.new(0.5, 0)})

-- Sidebar Tab Hover Animation (after sidebar buttons are created)
applySidebarHoverAnim(mainTabButton)
applySidebarHoverAnim(settingsTabButton)


-- === UI CLICK SOUND FEEDBACK ===
local UISound = Instance.new("Sound")
UISound.Name = "UISound"
UISound.SoundId = "rbxassetid://12222242"
UISound.Volume = 0.4
UISound.Parent = screenGui
UISound.Looped = false

local function attachClickSound(button)
    if button:FindFirstChild("_soundAttached") then return end
    local flag = Instance.new("BoolValue")
    flag.Name = "_soundAttached"
    flag.Parent = button
    button.MouseButton1Click:Connect(function()
        if UISound.IsLoaded or UISound.TimeLength > 0 then
            UISound:Play()
        end
    end)
end

attachClickSound(mainTabButton)
attachClickSound(settingsTabButton)
attachClickSound(shadersTabButton)

mainTabButton.MouseButton1Click:Connect(function()
    setActiveTab(mainTabButton, mainTabData)
end)
settingsTabButton.MouseButton1Click:Connect(function()
    setActiveTab(settingsTabButton, settingsTabData)
end)


setActiveTab(mainTabButton, mainTabData)


local function createPlayerPopup(targetPlayer, parentFrame)

    for player, popup in pairs(playerPopups) do
        if popup and popup.Parent then
            popup:Destroy()
        end
        playerPopups[player] = nil
    end
    
    local popup = Create("Frame", {
        Name = "PlayerPopup",
        Parent = screenGui,
        BackgroundColor3 = Color3.fromRGB(32, 34, 37),
        BorderSizePixel = 1,
        BorderColor3 = Color3.fromRGB(20, 22, 25),
        Size = UDim2.new(0, 150, 0, 150),
        Position = UDim2.new(0, Mouse.X, 0, Mouse.Y),
        ZIndex = 1000,
    })
    Create("UICorner", {Parent = popup, CornerRadius = UDim.new(0, 6)})
    
    local layout = Create("UIListLayout", {
        Parent = popup,
        Padding = UDim.new(0, 2),
    })
    

    local whitelistBtn = Create("TextButton", {
        Parent = popup,
        BackgroundColor3 = whitelistedPlayers[targetPlayer] and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.SourceSans,
        Text = whitelistedPlayers[targetPlayer] and "Unwhitelist" or "Whitelist",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
    })
    Create("UICorner", {Parent = whitelistBtn, CornerRadius = UDim.new(0, 4)})
    

    -- Priority button
    local priorityBtn = Create("TextButton", {
        Parent = popup,
        BackgroundColor3 = priorityPlayers[targetPlayer] and Color3.fromRGB(240, 71, 71) or Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.SourceSans,
        Text = priorityPlayers[targetPlayer] and "Unpriority" or "Priority",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
    })
    Create("UICorner", {Parent = priorityBtn, CornerRadius = UDim.new(0, 4)})

    local viewBtn = Create("TextButton", {
        Parent = popup,
        BackgroundColor3 = Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.SourceSans,
        Text = viewedPlayers[targetPlayer] and "Unview" or "View",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
    })
    Create("UICorner", {Parent = viewBtn, CornerRadius = UDim.new(0, 4)})
    

    local teleportBtn = Create("TextButton", {
        Parent = popup,
        BackgroundColor3 = Color3.fromRGB(47, 49, 54),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.SourceSans,
        Text = "Teleport",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
    })
    Create("UICorner", {Parent = teleportBtn, CornerRadius = UDim.new(0, 4)})
    

    local closeBtn = Create("TextButton", {
        Parent = popup,
        BackgroundColor3 = Color3.fromRGB(220, 53, 69),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30),
        Font = Enum.Font.SourceSans,
        Text = "Close",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
    })
    Create("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 4)})
    

    whitelistBtn.MouseButton1Click:Connect(function()
        whitelistedPlayers[targetPlayer] = not whitelistedPlayers[targetPlayer]
        whitelistBtn.Text = whitelistedPlayers[targetPlayer] and "Unwhitelist" or "Whitelist"
        whitelistBtn.BackgroundColor3 = whitelistedPlayers[targetPlayer] and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(47, 49, 54)

        -- If player is whitelisted, remove priority status
        if whitelistedPlayers[targetPlayer] then
            priorityPlayers[targetPlayer] = nil
            if priorityBtn then
                priorityBtn.Text = "Priority"
                priorityBtn.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
            end
        end

        -- Hide ESP immediately if player is now whitelisted
        if whitelistedPlayers[targetPlayer] and esp.players[targetPlayer] then
            for _, drawing in pairs(esp.players[targetPlayer]) do
                if drawing and drawing.Visible ~= nil then
                    drawing.Visible = false
                end
            end
        end

        if statusFrames[targetPlayer] and statusFrames[targetPlayer].Parent then
            local nameLabel = statusFrames[targetPlayer].Parent:FindFirstChild("TextLabel")
            if nameLabel then
                if priorityPlayers[targetPlayer] then
                    nameLabel.TextColor3 = Color3.fromRGB(240, 71, 71)
                elseif whitelistedPlayers[targetPlayer] then
                    nameLabel.TextColor3 = Color3.fromRGB(128, 0, 128)
                else
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)
    
    priorityBtn.MouseButton1Click:Connect(function()
        priorityPlayers[targetPlayer] = not priorityPlayers[targetPlayer]
        priorityBtn.Text = priorityPlayers[targetPlayer] and "Unpriority" or "Priority"
        priorityBtn.BackgroundColor3 = priorityPlayers[targetPlayer] and Color3.fromRGB(240, 71, 71) or Color3.fromRGB(47, 49, 54)

        -- Remove from whitelist if now priority
        if priorityPlayers[targetPlayer] and whitelistedPlayers[targetPlayer] then
            whitelistedPlayers[targetPlayer] = nil
            whitelistBtn.Text = "Whitelist"
            whitelistBtn.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
        end

        if statusFrames[targetPlayer] and statusFrames[targetPlayer].Parent then
            local nameLabel = statusFrames[targetPlayer].Parent:FindFirstChild("TextLabel")
            if nameLabel then
                if priorityPlayers[targetPlayer] then
                    nameLabel.TextColor3 = Color3.fromRGB(240, 71, 71)
                elseif whitelistedPlayers[targetPlayer] then
                    nameLabel.TextColor3 = Color3.fromRGB(128, 0, 128)
                else
                    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end)
    
    viewBtn.MouseButton1Click:Connect(function()
        viewedPlayers[targetPlayer] = not viewedPlayers[targetPlayer]
        viewBtn.Text = viewedPlayers[targetPlayer] and "Unview" or "View"
        
        if viewedPlayers[targetPlayer] then

            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CameraSubject = targetPlayer.Character.Humanoid
            end
        else

            if player.Character and player.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = player.Character.Humanoid
            end
        end
    end)
    
    teleportBtn.MouseButton1Click:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
           targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -5)
        end
        popup:Destroy()
        playerPopups[targetPlayer] = nil
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
        playerPopups[targetPlayer] = nil
    end)
    

    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            local popupPos = popup.AbsolutePosition
            local popupSize = popup.AbsoluteSize
            
            if mousePos.X < popupPos.X or mousePos.X > popupPos.X + popupSize.X or
               mousePos.Y < popupPos.Y or mousePos.Y > popupPos.Y + popupSize.Y then
                popup:Destroy()
                playerPopups[targetPlayer] = nil
                connection:Disconnect()
            end
        end
    end)
    
    playerPopups[targetPlayer] = popup
end


local statusFrames = {}
local lastMove = {}


local function addPlayer(player)
    local entry = Create("Frame", {
        Parent = lbScroll,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
    })
    entry.Name = player.Name  -- for search convenience

    local headshot = Create("ImageLabel", {
        Parent = entry,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 0, 0.5, -12),
        Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=48&height=48&format=png", player.UserId),
    })

    local statusDot = Create("Frame", {
        Parent = entry,
        BackgroundColor3 = Color3.fromRGB(67, 181, 129), -- default green
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 28, 0.5, -6),
    })
    Create("UICorner", {Parent = statusDot, CornerRadius = UDim.new(0.5, 0)})

    local nameLabel = Create("TextLabel", {
        Parent = entry,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, 44, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = player.Name,
        TextColor3 = priorityPlayers[player] and Color3.fromRGB(240, 71, 71)
            or (whitelistedPlayers[player] and Color3.fromRGB(128, 0, 128) or Color3.fromRGB(255, 255, 255)),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    

    local clickButton = Create("TextButton", {
        Parent = entry,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 2,
    })
    
    clickButton.MouseButton1Click:Connect(function()
        createPlayerPopup(player, entry)
    end)
    

    clickButton.MouseEnter:Connect(function()
        entry.BackgroundTransparency = 0.9
        entry.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    end)
    
    clickButton.MouseLeave:Connect(function()
        entry.BackgroundTransparency = 1
    end)
    statusFrames[player] = statusDot
    lastMove[player] = os.clock()


    player.CharacterAdded:Connect(function(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid then
            humanoid.Running:Connect(function(speed)
                if speed > 0 then
                    lastMove[player] = os.clock()
                end
            end)
        end
    end)
end

local function removePlayer(player)
    if statusFrames[player] then
        statusFrames[player]:Destroy()
        statusFrames[player] = nil
    end
    lastMove[player] = nil
end


for _, plr in ipairs(Players:GetPlayers()) do
    addPlayer(plr)
end
Players.PlayerAdded:Connect(addPlayer)
Players.PlayerRemoving:Connect(removePlayer)


lbLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    lbScroll.CanvasSize = UDim2.new(0, 0, 0, lbLayout.AbsoluteContentSize.Y + 8)
end)


RunService.Heartbeat:Connect(function()

    local now = os.clock()
    for player, dot in pairs(statusFrames) do
        local last = lastMove[player] or 0
        local delta = now - last
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid.MoveDirection.Magnitude > 0 then

                dot.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
                lastMove[player] = now
            else
                if delta >= 10 then
                    dot.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
                else
                    dot.BackgroundColor3 = Color3.fromRGB(250, 166, 26)
                end
            end
        else
            dot.BackgroundColor3 = Color3.fromRGB(250, 166, 26)
        end
    end
    

    

    if flyEnabled then
        updateFly()
    end
end)


Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    updateSpeed()
    updateJump()
    if antiLockEnabled then
        startAntiLock()
    end
end)




print("gzcord - Functional Version Loaded!")
print("Aimbot: " .. aimbotKeybind .. " to activate")
print("ESP: Toggle in Visuals section")
print("Movement: Adjust speed, fly, and jump in Movement section")

-- SHADER LOGIC (keep these functions)
local Lighting = game:GetService("Lighting")
local function clearShaders()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
end
local function applyUltraShaders()
    clearShaders()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.1
    cc.Contrast = 0.25
    cc.Saturation = 0.2
    cc.TintColor = Color3.fromRGB(200, 220, 255)
    cc.Parent = Lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 1.2
    bloom.Size = 56
    bloom.Threshold = 0.8
    bloom.Parent = Lighting
    local dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.2
    dof.FocusDistance = 30
    dof.InFocusRadius = 20
    dof.NearIntensity = 0.3
    dof.Parent = Lighting
    local sun = Instance.new("SunRaysEffect")
    sun.Intensity = 0.15
    sun.Spread = 0.25
    sun.Parent = Lighting
    local blur = Instance.new("BlurEffect")
    blur.Size = 2
    blur.Parent = Lighting
end
local function applyMidShaders()
    clearShaders()
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = 0.05
    cc.Contrast = 0.1
    cc.Saturation = 0.1
    cc.TintColor = Color3.fromRGB(180, 200, 230)
    cc.Parent = Lighting
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0.5
    bloom.Size = 32
    bloom.Threshold = 0.9
    bloom.Parent = Lighting
    local dof = Instance.new("DepthOfFieldEffect")
    dof.FarIntensity = 0.1
    dof.FocusDistance = 100
    dof.InFocusRadius = 80
    dof.NearIntensity = 0.1
    dof.Parent = Lighting
end

-- Remove shaders section from mainTabData if present
-- Add a new shadersTabData for the shaders tab
local shadersTabData = { sections = {} }
local shadersSection = createSection(shadersTabData, "Shaders", "✨")

Create("TextLabel", {
    Parent = shadersSection,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 28),
    Font = Enum.Font.SourceSansBold,
    Text = "Shader Presets",
    TextColor3 = Color3.fromRGB(114, 137, 218),
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})

local shaderButtons = {}
local shaderModes = {
    {name = "Ultra Shaders", icon = "💎", func = applyUltraShaders, desc = "Cinematic, high-quality look."},
    {name = "Mid Shaders", icon = "✨", func = applyMidShaders, desc = "Performance-friendly, balanced look."},
    {name = "No Shaders", icon = "🚫", func = clearShaders, desc = "Default Roblox lighting."},
}
local activeShader = nil

for i, mode in ipairs(shaderModes) do
    local btn = Create("TextButton", {
        Parent = shadersSection,
        BackgroundColor3 = Color3.fromRGB(54, 57, 63),
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.SourceSansBold,
        Text = mode.icon .. "  " .. mode.name,
        TextColor3 = Color3.fromRGB(220, 221, 222),
        TextSize = 16,
        AutoButtonColor = true,
        LayoutOrder = i,
    })
    Create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 6)})
    Create("UIPadding", {Parent = btn, PaddingLeft = UDim.new(0, 10)})
    local desc = Create("TextLabel", {
        Parent = btn,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        Font = Enum.Font.SourceSans,
        Text = mode.desc,
        TextColor3 = Color3.fromRGB(185, 187, 190),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    })
    desc.ZIndex = btn.ZIndex + 1
    shaderButtons[mode.name] = btn
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(shaderButtons) do
            b.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            b.TextColor3 = Color3.fromRGB(220, 221, 222)
        end
        btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeShader = mode.name
        mode.func()
    end)
end
-- Set default active shader visually
shaderButtons["No Shaders"].BackgroundColor3 = Color3.fromRGB(88, 101, 242)
shaderButtons["No Shaders"].TextColor3 = Color3.fromRGB(255, 255, 255)
activeShader = "No Shaders"

-- Add a shaders tab button to the sidebar before settings
-- (already created above, hover animation attached)

-- Adjust layout orders for main/settings tabs
mainTabButton.LayoutOrder = 1
shadersTabButton.LayoutOrder = 4
settingsTabButton.LayoutOrder = 5

-- Remove any 'Shaders' section from mainTabData if present
for i = #mainTabData.sections, 1, -1 do
    if mainTabData.sections[i].button.Name == "Shaders" then
        mainTabData.sections[i].button:Destroy()
        if mainTabData.sections[i].content then
            mainTabData.sections[i].content:Destroy()
        end
        table.remove(mainTabData.sections, i)
    end
end

-- Search box for player list
local searchBox = Create("TextBox", {
    Name = "SearchBox",
    Parent = leaderboardColumn,
    BackgroundColor3 = Color3.fromRGB(54, 57, 63),
    BorderSizePixel = 0,
    Size = UDim2.new(1, -16, 0, 26),
    Position = UDim2.new(0, 8, 0, 56),
    ClearTextOnFocus = false,
    PlaceholderText = "Search...",
    PlaceholderColor3 = Color3.fromRGB(185, 187, 190),
    Font = Enum.Font.SourceSans,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
})
Create("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0, 6)})

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchBox.Text:lower()
    for _, entry in ipairs(lbScroll:GetChildren()) do
        if entry:IsA("Frame") then
            local nameLabel = entry:FindFirstChildWhichIsA("TextLabel")
            if nameLabel then
                entry.Visible = (q == "") or (nameLabel.Text:lower():find(q, 1, true) ~= nil)
            end
        end
    end
end)

-- Move leaderboard scroll below search box
lbScroll.Position = UDim2.new(0, 0, 0, 88)
lbScroll.Size = UDim2.new(1, 0, 1, -88)
