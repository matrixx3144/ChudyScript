-- ChudyHub: Ultra strong TP do bazy + przyciski po prawej na środku ekranu
local plr = game:GetService("Players").LocalPlayer
local basePosition = nil

local guiName = "Chudy_" .. tostring(math.random(100000,999999))
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = math.random(100,900)
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true

local btnWidth, btnHeight, spacing = 100, 38, 16
local centerY = 0.5
local offsetX = 24

local function makeBtn(txt, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btn.Position = UDim2.new(1, -btnWidth - offsetX, centerY, (order-1)*(btnHeight+spacing) - btnHeight - spacing/2)
    btn.AnchorPoint = Vector2.new(0,0.5)
    btn.Text = txt
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Parent = ScreenGui
    btn.Active = true
    btn.AutoButtonColor = true
    return btn
end

local setBaseBtn = makeBtn("Set Base", 1)
local tpBaseBtn = makeBtn("TP do Bazy", 2)

-- ULTRA STRONG TP
local function ultraStrongTP(pos)
    local char = plr.Character
    if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid")) then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    -- 1. Przejęcie NetworkOwnership + reset velocity
    pcall(function() hrp:SetNetworkOwner(plr) end)
    hrp.Velocity = Vector3.new(0,0,0)

    -- 2. Multi-step teleport (szybka seria TP)
    for i=1,16 do
        hrp.CFrame = CFrame.new(pos)
        hum:MoveTo(pos)
        task.wait(0.01)
    end

    -- 3. Anchoring trick
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(pos)
task.wait(0.06)
    hrp.Anchored = false

    -- 4. Wymuszenie FallingDown
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.FallingDown) end)

    -- 5. Fake seat trick
    pcall(function()
        local seat = Instance.new("Seat", workspace)
        seat.CFrame = CFrame.new(pos)
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        hrp.CFrame = seat.CFrame
        hum.Sit = true
        task.wait(0.17)
        seat:Destroy()
    end)

    -- 6. Respawn trick (jeśli można)
    if hum.Health > 0 then
        hum.Health = 0
        task.wait(0.9)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end

    -- 7. Wyczyszczenie constraints
    for _,obj in pairs(hrp:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") then
            obj:Destroy()
        end
    end

    -- 8. Finalne MoveTo
    pcall(function()
        hum:MoveTo(pos)
        hrp.CFrame = CFrame.new(pos)
        hrp.Velocity = Vector3.new(0,0,0)
    end)

    -- 9. Synchronizacja kamery
    local cam = workspace.CurrentCamera
    if cam and cam.CameraSubject and cam.CameraSubject:IsDescendantOf(char) then
        cam.CFrame = hrp.CFrame
        cam.CameraType = Enum.CameraType.Custom
    end
end

setBaseBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        basePosition = plr.Character.HumanoidRootPart.Position
        setBaseBtn.Text = "Baza ✔"
        setBaseBtn.BackgroundColor3 = Color3.fromRGB(40,255,40)
        task.wait(0.3)
        setBaseBtn.Text = "Set Base"
        setBaseBtn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    else
        setBaseBtn.Text = "Brak postaci!"
        setBaseBtn.BackgroundColor3 = Color3.fromRGB(255,150,40)
        task.wait(0.4)
        setBaseBtn.Text = "Set Base"
        setBaseBtn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    end
end)

tpBaseBtn.MouseButton1Click:Connect(function()
    if basePosition and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        ultraStrongTP(basePosition)
        tpBaseBtn.Text = "TP ✔"
        tpBaseBtn.BackgroundColor3 = Color3.fromRGB(40,255,40)
        task.wait(0.3)
        tpBaseBtn.Text = "TP do Bazy"
        tpBaseBtn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    else
        tpBaseBtn.Text = "Najpierw Set Base!"
        tpBaseBtn.BackgroundColor3 = Color3.fromRGB(255,150,40)
        task.wait(0.4)
        tpBaseBtn.Text = "TP do Bazy"
        tpBaseBtn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    end
end)

