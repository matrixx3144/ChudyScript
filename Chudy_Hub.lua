-- ChudyHub: Rozbudowany, trudny do wykrycia skrypt TP z dwoma czerwonymi przyciskami
local plr = game:GetService("Players").LocalPlayer
local basePosition = nil

-- Losowe nazwy dla GUI - anti-detection
local guiName = "Chudy_" .. tostring(math.random(100000,999999))
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.Parent = plr:WaitForChild("PlayerGui")

local function makeBtn(txt,pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 56)
    btn.Position = UDim2.new(0, 40 + (pos-1)*180, 0, 30)
    btn.Text = txt
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 28
    btn.BackgroundColor3 = Color3.fromRGB(255,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 0
    btn.Parent = ScreenGui
    btn.Active = true
    return btn
end

local setBaseBtn = makeBtn("Set Base",1)
local tpBaseBtn = makeBtn("TP do Bazy",2)

-- Anti-rollback / silent teleportation
local function robustTeleport(pos)
    local char = plr.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
    local hrp = char.HumanoidRootPart
    -- 1. Set position multiple times to bypass network rollback
    for i=1,6 do
        hrp.CFrame = CFrame.new(pos)
        task.wait(0.035)
    end
    -- 2. Patch velocity, if possible
    if hrp:FindFirstChild("RootRigAttachment") then
        hrp.Velocity = Vector3.new(0,0,0)
    end
    -- 3. Try to break server-side position sync
    if char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid"):ChangeState(11) -- Physically simulated
    end
    -- 4. Remove potential anti-cheat constraints
    for _,obj in pairs(hrp:GetChildren()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") then
            obj:Destroy()
        end
    end
    -- 5. Move Camera in sync (extra stealth)
    local cam = workspace.CurrentCamera
    if cam and cam.CameraSubject and cam.CameraSubject:IsDescendantOf(char) then
        cam.CFrame = hrp.CFrame
    end
end

setBaseBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        basePosition = plr.Character.HumanoidRootPart.Position
        setBaseBtn.Text = "Baza ustawiona!"
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
        robustTeleport(basePosition)
        tpBaseBtn.Text = "TP wykonany!"
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

-- Ukryj GUI dla innych skryptów (stealth)
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = math.random(100,900)
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = true
