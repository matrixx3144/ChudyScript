-- ChudyHub: Dwa małe czerwone przyciski po prawej stronie ekranu na środku (Set Base, TP do Bazy)
local plr = game:GetService("Players").LocalPlayer
local basePosition = nil

-- Losowa nazwa GUI dla stealth
local guiName = "Chudy_" .. tostring(math.random(100000,999999))
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = plr:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = math.random(100,900)
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true

-- Rozmiar i pozycja dla mniejszych przycisków po prawej stronie na środku ekranu
local btnWidth, btnHeight, spacing = 90, 34, 14
local originX = 1 - (btnWidth+btnWidth+spacing)/ScreenGui.AbsoluteSize.X - 0.04 -- ok. 94% szerokości ekranu
local originY = 0.5

local function makeBtn(txt, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, btnWidth, 0, btnHeight)
    btn.Position = UDim2.new(1, -btnWidth*order-spacing*(order-1)-18, 0.5, btnHeight*(order-1)-btnHeight-2)
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

local setBaseBtn = makeBtn("Set Base",1)
local tpBaseBtn = makeBtn("TP do Bazy",2)

-- ANTI-ROLLBACK TP
local function antiRollbackTeleport(pos)
    local char = plr.Character
    if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid")) then return end
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")

    pcall(function() hrp:SetNetworkOwner(plr) end)
    pcall(function() hum:ChangeState(11) end) -- Physics
    hrp.Anchored = true
    for i=1,8 do
        hrp.CFrame = CFrame.new(pos)
        task.wait(0.03)
    end
    hrp.Anchored = false
    pcall(function()
        hum:MoveTo(pos)
        task.wait(0.05)
        hum:MoveTo(pos)
        task.wait(0.05)
    end)
    hrp.Velocity = Vector3.new(0,0,0)
    for _,obj in pairs(hrp:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") then
            obj:Destroy()
        end
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
        antiRollbackTeleport(basePosition)
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
