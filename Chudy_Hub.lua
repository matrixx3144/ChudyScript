print("ChudyHub startuje!") -- Debug start

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Ikonka do pokazywania/ukrywania huba
local iconBtn = Instance.new("TextButton")
iconBtn.Parent = LocalPlayer:WaitForChild("PlayerGui")
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.Size = UDim2.new(0, 62, 0, 62)
iconBtn.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
iconBtn.Text = "☰"
iconBtn.TextSize = 38
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextColor3 = Color3.fromRGB(255,255,255)
iconBtn.BorderSizePixel = 0
print("Ikonka utworzona") -- Debug

iconBtn.MouseEnter:Connect(function()
    iconBtn.BackgroundColor3 = Color3.fromRGB(135, 50, 255)
end)
iconBtn.MouseLeave:Connect(function()
    iconBtn.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
end)

-- Tworzenie GUI huba
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChudyHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 280)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local gradientFrame = Instance.new("Frame", MainFrame)
gradientFrame.Size = UDim2.new(1,0,1,0)
gradientFrame.Position = UDim2.new(0,0,0,0)
gradientFrame.BackgroundTransparency = 0.5
gradientFrame.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
gradientFrame.ZIndex = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ChudyHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 32
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 56)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.ZIndex = 2

local SideMenu = Instance.new("Frame", MainFrame)
SideMenu.Size = UDim2.new(0, 130, 1, -56)
SideMenu.Position = UDim2.new(0, 0, 0, 56)
SideMenu.BackgroundTransparency = 0.45
SideMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
SideMenu.BorderSizePixel = 0
SideMenu.ZIndex = 2

local buttons = {
    {Name = "Set Base", Desc = "Ustaw swoją bazę"},
    {Name = "Brainrot TP", Desc = "Automatyczny teleport do bazy"},
    {Name = "Exit", Desc = "Zamknij HUB"}
}

local basePosition = nil

for i, btn in ipairs(buttons) do
    local Button = Instance.new("TextButton", SideMenu)
    Button.Size = UDim2.new(1, -16, 0, 46)
    Button.Position = UDim2.new(0, 8, 0, (i-1)*52 + 10)
    Button.Text = btn.Name
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 21
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(75, 75, 135)
    Button.BorderSizePixel = 0
    Button.BackgroundTransparency = 0.18
    Button.ZIndex = 3

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
        Button.TextColor3 = Color3.fromRGB(25, 25, 40)
    end)
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(75, 75, 135)
        Button.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    Button.MouseButton1Click:Connect(function()
        print("Kliknięto: "..btn.Name) -- Debug
        if btn.Name == "Set Base" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                basePosition = LocalPlayer.Character.HumanoidRootPart.Position
                Title.Text = "Baza ustawiona!"
            else
                Title.Text = "Brak postaci!"
            end
        elseif btn.Name == "Brainrot TP" then
            if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
                Title.Text = "Teleport do bazy!"
                print("TP do bazy!") -- Debug
            else
                Title.Text = "Najpierw ustaw bazę!"
            end
        elseif btn.Name == "Exit" then
            ScreenGui.Enabled = false
            print("Hub zamknięty!") -- Debug
        end
    end)
end

-- Animacja otwierania okna (uproszczona)
MainFrame.Size = UDim2.new(0, 0, 0, 0)
gradientFrame.Size = UDim2.new(0, 0, 0, 0)
iconBtn.MouseButton1Click:Connect(function()
    if not ScreenGui.Enabled then
        ScreenGui.Enabled = true
        -- Delta: uproszczona animacja
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 420, 0, 280)}):Play()
        TweenService:Create(gradientFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(1,0,1,0)}):Play()
        print("Hub otwarty!") -- Debug
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(gradientFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        wait(0.32)
        ScreenGui.Enabled = false
        print("Hub zamknięty!") -- Debug
    end
end)

-- Listener na zdobycie brainrota
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child.Name:lower():find("brainrot") then
        if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
            Title.Text = "Brainrot: Teleportacja!"
            print("Automatyczny TP do bazy!") -- Debug
        else
            Title.Text = "Brainrot: Najpierw ustaw bazę!"
        end
    end
end)

-- Brainrot ESP: BillboardGui nad brainrotem z największą wartością
local espColor = Color3.fromRGB(255, 255, 0)
local espObjects = {}

local function createESP(part, value)
    if espObjects[part] then return end
    local bill = Instance.new("BillboardGui", part)
    bill.Size = UDim2.new(0, 110, 0, 34)
    bill.StudsOffset = Vector3.new(0, part.Size.Y/2 + 1.5, 0)
    bill.Adornee = part
    bill.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = espColor
    label.Font = Enum.Font.GothamBold
    label.TextSize = 19
    label.Text = "Brainrot: $"..value
    espObjects[part] = bill
end

local function clearESP()
    for _,v in pairs(espObjects) do
        if v and v.Parent then v:Destroy() end
    end
    espObjects = {}
end

RunService.RenderStepped:Connect(function()
    clearESP()
    local maxValue = 0
    local bestBrainrot = nil
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brainrot") then
            local value = 0
            if v:FindFirstChild("Value") and v.Value:IsA("NumberValue") then
                value = v.Value.Value
            elseif v:GetAttribute("Value") then
                value = v:GetAttribute("Value")
            end
            if value > maxValue then
                maxValue = value
                bestBrainrot = v
            end
            createESP(v, value)
        end
    end

    if bestBrainrot and espObjects[bestBrainrot] then
        local label = espObjects[bestBrainrot]:FindFirstChildOfClass("TextLabel")
        if label then
            label.TextColor3 = Color3.fromRGB(72, 195, 255)
            label.Text = "NAJ Brainrot: $"..maxValue
        end
    end
end)

print("ChudyHub załadowany!") -- Debug koniec
