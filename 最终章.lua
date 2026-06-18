local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/whenheet/dasimaui/refs/heads/main/%E4%BB%98%E8%B4%B9%E7%89%88ui(2).lua"))()

local Window = WindUI:CreateWindow({
    Title = "91vs78脚本",
    Icon = "rbxassetid://4483362748",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:是鹤不是轩",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Light",
    User = { Enabled = true, Callback = function() print("clicked") end, Anonymous = false },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
    Background = "rbxassetid://111122821357551"
})

Window:EditOpenButton({
    Title = "91vs78脚本", Icon = "monitor",
    CornerRadius = UDim.new(0, 16), StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
        ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
        ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
    }),
    Draggable = true,
})

Window:Tag({ Title = "91vs78脚本", Color = Color3.fromHex("#30ff6a") })
Window:Tag({ Title = "91vs78", Color = Color3.fromHex("#315dff") })
Window:Tag({ Title = "传送脚本", Color = Color3.fromHex("#000000") })

local Tabs = {
    Main = Window:Section({ Title = "坐标传送", Opened = true }),
    General = Window:Section({ Title = "通用功能", Opened = false }), 
    Aimbot = Window:Section({ Title = "Aimbot", Opened = false }),
    ESP = Window:Section({ Title = "人物透视", Opened = false }),
}

local TabHandles = {
    Q = Tabs.Main:Tab({ Title = "传送", Icon = "map-pin" }),
    General = Tabs.General:Tab({ Title = "角色控制", Icon = "settings" }),
    Aimbot = Tabs.Aimbot:Tab({ Title = "自瞄设置", Icon = "crosshair" }),
    ESP = Tabs.ESP:Tab({ Title = "透视功能", Icon = "eye" }),
}

local SavedPosition = nil

TabHandles.Q:Button({
    Title = "保存当前坐标", Desc = "记录你当前所在的位置", Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            SavedPosition = char.HumanoidRootPart.Position
            local posStr = string.format("X: %.1f, Y: %.1f, Z: %.1f", SavedPosition.X, SavedPosition.Y, SavedPosition.Z)
            WindUI:Notify({ Title = "保存成功", Content = "已保存坐标: " .. posStr, Duration = 2, Icon = "save" })
        else
            WindUI:Notify({ Title = "错误", Content = "角色未加载，无法保存", Duration = 2, Icon = "alert-triangle" })
        end
    end
})

TabHandles.Q:Button({
    Title = "传送到保存的坐标", Desc = "回到你上一次保存的位置", Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if SavedPosition then
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(SavedPosition)
                WindUI:Notify({ Title = "传送成功", Content = "已返回保存的坐标!", Duration = 1, Icon = "map-pin" })
            else
                WindUI:Notify({ Title = "错误", Content = "角色未加载", Duration = 2, Icon = "alert-triangle" })
            end
        else
            WindUI:Notify({ Title = "提示", Content = "你还没有保存过坐标！", Duration = 2, Icon = "alert-circle" })
        end
    end
})

TabHandles.General:Slider({
    Title = "修改玩家移速 (滑块)", Desc = "拖动快速调整行走速度", Min = 16, Max = 200, Default = 16,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = value end end
    end
})

TabHandles.General:Textbox({
    Title = "修改玩家移速 (精准)", Desc = "输入任意数字精准修改移速", Placeholder = "例如: 500",
    Callback = function(value)
        local num = tonumber(value)
        if num then
                    local char = game.Players.LocalPlayer.Character
            if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.WalkSpeed = num end end
            WindUI:Notify({ Title = "修改成功", Content = "移速已设置为: " .. num, Duration = 1.5, Icon = "zap" })
        else WindUI:Notify({ Title = "输入错误", Content = "请输入有效的数字！", Duration = 1.5, Icon = "alert-circle" }) end
    end
})

TabHandles.General:Slider({
    Title = "修改跳跃高度 (滑块)", Desc = "拖动快速调整跳跃力度", Min = 0, Max = 200, Default = 50,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = value end end
    end
})

TabHandles.General:Textbox({
    Title = "修改跳跃高度 (精准)", Desc = "输入任意数字精准修改跳跃高度", Placeholder = "例如: 300",
    Callback = function(value)
        local num = tonumber(value)
        if num then
            local char = game.Players.LocalPlayer.Character
            if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.JumpPower = num end end
            WindUI:Notify({ Title = "修改成功", Content = "跳跃高度已设置为: " .. num, Duration = 1.5, Icon = "arrow-up-circle" })
        else WindUI:Notify({ Title = "输入错误", Content = "请输入有效的数字！", Duration = 1.5, Icon = "alert-circle" }) end
    end
})

local infiniteJumpEnabled = false
TabHandles.General:Toggle({
    Title = "无限跳跃", Desc = "开启后可以在空中连续跳跃", Default = false,
    Callback = function(value)
        infiniteJumpEnabled = value
        WindUI:Notify({ Title = "功能提示", Content = infiniteJumpEnabled and "无限跳跃已开启!" or "无限跳跃已关闭!", Duration = 1.5, Icon = infiniteJumpEnabled and "arrow-up-circle" or "arrow-down-circle" })
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end
end)

TabHandles.General:Button({
    Title = "重置人物（自杀）", Desc = "立即重置当前角色", Locked = false,
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then local h = char:FindFirstChildOfClass("Humanoid"); if h then h.Health = 0 end end
    end
})

local flyEnabled = false
local flySpeed = 50 
local flyBodyVelocity = nil
local moveUp = false
local moveDown = false

local FlyWindow = WindUI:CreateWindow({
    Title = "飞行控制台", Icon = "plane", Size = UDim2.fromOffset(250, 180),
    Draggable = true, CanDrag = true, CloseButton = true, Theme = "Light", Transparent = true,
    Background = "rbxassetid://111122821357551"
})

FlyWindow.OnClose = function()
    flyEnabled = false
    moveUp = false
    moveDown = false
    if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
    local char = game.Players.LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    WindUI:Notify({ Title = "飞行提示", Content = "悬浮窗已关闭，飞行已自动关闭!", Duration = 2, Icon = "alert-circle" })
end

local FlyTab = FlyWindow:Section({ Title = "飞行控制", Opened = true })
FlyTab:Slider({
    Title = "飞行速度", Desc = "调整悬浮时的飞行速度", Min = 10, Max = 300, Default = 50,
    Callback = function(value) flySpeed = value end
})

FlyTab:Toggle({
    Title = "开启/关闭飞行", Desc = "W键上升，S键下降，长按持续移动", Default = false,
    Callback = function(value)
        flyEnabled = value
        local char = game.Players.LocalPlayer.Character
        if flyEnabled then
            if char and char:FindFirstChild("HumanoidRootPart") then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.Parent = char.HumanoidRootPart
                WindUI:Notify({ Title = "飞行提示", Content = "飞行已开启! W/S键控制升降", Duration = 2, Icon = "plane" })
            end
        else
            if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
            moveUp = false; moveDown = false
            WindUI:Notify({ Title = "飞行提示", Content = "飞行已关闭!", Duration = 1.5, Icon = "plane" })
        end
    end
})

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flyEnabled then return end
    if input.KeyCode == Enum.KeyCode.W then moveUp = true end
    if input.KeyCode == Enum.KeyCode.S then moveDown = true end
end)

UIS.InputEnded:Connect(function(input, gameProcessed)
    if not flyEnabled then return end
    if input.KeyCode == Enum.KeyCode.W then moveUp = false end
    if input.KeyCode == Enum.KeyCode.S then moveDown = false end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flyEnabled and flyBodyVelocity and flyBodyVelocity.Parent then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = true end
            local moveDir = humanoid.MoveDirection
            local verticalY = 0
            if moveUp then verticalY = 1 end
            if moveDown then verticalY = -1 end
            flyBodyVelocity.Velocity = (moveDir * flySpeed) + Vector3.new(0, verticalY * flySpeed, 0)
        end
    else
        local char = game.Players.LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end)

local aimbotEnabled = false
local aimbotTargetPart = "Head"
local aimbotSmoothness = 10
local aimbotLockHeight = 0
local checkWalls = false
local checkTeam = false
local fovRadius = 150
local currentLockedTarget = nil 

TabHandles.Aimbot:Toggle({
    Title = "自瞄总开关", Desc = "开启后按住开火键自动瞄准附近敌人", Default = false,
    Callback = function(value)
        aimbotEnabled = value
        currentLockedTarget = nil
        WindUI:Notify({ Title = "自瞄提示", Content = aimbotEnabled and "自瞄已开启!" or "自瞄已关闭!", Duration = 1.5, Icon = "crosshair" })
    end
})

local AimbotFloatWindow = WindUI:CreateWindow({
    Title = "自瞄快捷开关", Icon = "crosshair", Size = UDim2.fromOffset(180, 100),
    Draggable = true, CanDrag = true, CloseButton = true, Theme = "Light", Transparent = true,
    Background = "rbxassetid://111122821357551"
})
local AimbotFloatTab = AimbotFloatWindow:Section({ Title = "快捷操作", Opened = true })
AimbotFloatTab:Toggle({
    Title = "自瞄开关", Desc = "点击切换自瞄状态", Default = false,
    Callback = function(value)
        aimbotEnabled = value
        currentLockedTarget = nil
        WindUI:Notify({ Title = "自瞄提示", Content = aimbotEnabled and "自瞄已开启!" or "自瞄已关闭!", Duration = 1.5, Icon = "crosshair" })
    end
})
AimbotFloatWindow.OnClose = function()
    aimbotEnabled = false
    currentLockedTarget = nil
    WindUI:Notify({ Title = "自瞄提示", Content = "悬浮窗已关闭，自瞄已自动关闭!", Duration = 2, Icon = "alert-circle" })
end

TabHandles.Aimbot:Dropdown({
    Title = "瞄准部位", Desc = "选择自瞄锁定的身体部位", Content = {"头部 (Head)", "胸部 (Torso)"}, Default = "头部 (Head)",
    Callback = function(value)
        if value == "头部 (Head)" then aimbotTargetPart = "Head"
        elseif value == "胸部 (Torso)" then aimbotTargetPart = "Torso" end
    end
})

TabHandles.Aimbot:Toggle({ Title = "掩体判断", Desc = "开启后不会瞄准被墙体遮挡的敌人", Default = false, Callback = function(value) checkWalls = value end })
TabHandles.Aimbot:Toggle({ Title = "队伍检测", Desc = "开启后不会自瞄同队伍的玩家", Default = true, Callback = function(value) checkTeam = value end })
TabHandles.Aimbot:Slider({ Title = "锁定高度", Desc = "微调瞄准时的垂直高度 (Y轴)", Min = -5, Max = 5, Default = 0, Callback = function(value) aimbotLockHeight = value end })
TabHandles.Aimbot:Slider({ Title = "自瞄平滑力度", Desc = "数值越大瞄准越平滑，越小锁定越瞬间", Min = 1, Max = 50, Default = 10, Callback = function(value) aimbotSmoothness = value end })

TabHandles.Aimbot:Slider({ 
    Title = "自瞄范围 (滑块)", Desc = "调整自瞄圈的大小", Min = 50, Max = 500, Default = 150, 
    Callback = function(value) fovRadius = value end 
})
TabHandles.Aimbot:Textbox({ 
    Title = "自瞄范围 (精准)", Desc = "输入数字精准调整自瞄圈", Placeholder = "例如: 200",
    Callback = function(value) 
        local num = tonumber(value)
        if num then fovRadius = num end
    end 
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "AimbotFOV"
FOVGui.Parent = game.CoreGui
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.Parent = FOVGui
local FOVCircleCorner = Instance.new("UICorner")
FOVCircleCorner.CornerRadius = UDim.new(1, 0)
FOVCircleCorner.Parent = FOVCircle
local FOVCircleStroke = Instance.new("UIStroke")
FOVCircleStroke.Color = Color3.fromRGB(255, 0, 0)
FOVCircleStroke.Thickness = 2
FOVCircleStroke.Parent = FOVCircle

local TargetNameGui = Instance.new("BillboardGui")
TargetNameGui.Name = "TargetNameTag"
TargetNameGui.Size = UDim2.new(0, 200, 0, 50)
TargetNameGui.StudsOffset = Vector3.new(0, 3, 0)
TargetNameGui.AlwaysOnTop = true
TargetNameGui.Adornee = nil
TargetNameGui.Enabled = false
TargetNameGui.Parent = game.CoreGui
local TargetNameLabel = Instance.new("TextLabel")
TargetNameLabel.Name = "TargetNameLabel"
TargetNameLabel.BackgroundTransparency = 1
TargetNameLabel.Size = UDim2.new(1, 0, 1, 0)
TargetNameLabel.Font = Enum.Font.GothamBold
TargetNameLabel.TextSize = 18
TargetNameLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TargetNameLabel.TextStrokeTransparency = 0
TargetNameLabel.Text = ""
TargetNameLabel.Parent = TargetNameGui

local isFiring = false
UIS.TouchTapInWorld:Connect(function(_, gameProcessed)
    if not gameProcessed then isFiring = true end
end)
UIS.TouchEnded:Connect(function() isFiring = false end)

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if checkTeam and player.TeamColor == Players.LocalPlayer.TeamColor then continue end
            local char = player.Character
            if char then
                local targetPart = char:FindFirstChild(aimbotTargetPart) or char:FindFirstChild("Head")
                if targetPart then
                    if checkWalls then
                        local origin = Camera.CFrame.Position
                        local direction = (targetPart.Position - origin).Unit * 1000
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {Players.LocalPlayer.Character, char}
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        local result = workspace:Raycast(origin, direction, raycastParams)
                        if result then continue end
                    end
                    
                    local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position + Vector3.new(0, aimbotLockHeight, 0))
                    if onScreen then
                        local mousePos = UIS:GetMouseLocation()
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < fovRadius and dist < shortestDistance then
                            shortestDistance = dist
                            closestPlayer = {Player = player, Part = targetPart}
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled then
        TargetNameGui.Enabled = false
        currentLockedTarget = nil
        return
    end

    if isFiring then
        local targetData = getClosestPlayer()
        if targetData and targetData.Part and targetData.Part.Parent then
            currentLockedTarget = targetData
            local targetPos = targetData.Part.Position + Vector3.new(0, aimbotLockHeight, 0)
            local currentCamCFrame = Camera.CFrame
            local targetCFrame = CFrame.lookAt(currentCamCFrame.Position, targetPos)
            local smoothedCFrame = currentCamCFrame:Lerp(targetCFrame, 1 / aimbotSmoothness)
            Camera.CFrame = smoothedCFrame
            
            TargetNameGui.Adornee = targetData.Part
            TargetNameGui.Enabled = true
            TargetNameLabel.Text = targetData.Player.Name
        else
            TargetNameGui.Enabled = false
            currentLockedTarget = nil
        end
    else
        TargetNameGui.Enabled = false
        currentLockedTarget = nil
    end
end)