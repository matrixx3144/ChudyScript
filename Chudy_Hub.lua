-- ChudyHub: Nowoczesny skrypt Roblox GUI z Brainrot ESP, TP do bazy i chowanie pod ikonką

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Ikonka do pokazywania/ukrywania huba
local iconBtn = Instance.new("ImageButton")
iconBtn.Parent = game.CoreGui
iconBtn.Position = UDim2.new(0, 20, 0, 20)
iconBtn.Size = UDim2.new(0, 48, 0, 48)
iconBtn.BackgroundTransparency = 1
iconBtn.Image = "rbxassetid://14112183167" -- przykładowa nowoczesna ikona (możesz zmienić)

-- Tworzenie GUI huba
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ChudyHub"
ScreenGui.Enabled = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -130)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)

local UIGradient = Instance.new("UIGradient", MainFrame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(72, 195, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 50, 255))
}
UIGradient.Rotation = 45

MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 400, 0, 260)}):Play()

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "ChudyHub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)

local SideMenu = Instance.new("Frame", MainFrame)
SideMenu.Size = UDim2.new(0, 110, 1, -50)
SideMenu.Position = UDim2.new(0, 0, 0, 50)
SideMenu.BackgroundTransparency = 0.4
SideMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
SideMenu.BorderSizePixel = 0

local buttons = {
    {Name = "Set Base", Desc = "Ustaw swoją bazę"},
    {Name = "Brainrot TP", Desc = "Automatyczny teleport do bazy"},
    {Name = "Exit", Desc = "Zamknij HUB"}
}

local basePosition = nil

for i, btn in ipairs(buttons) do
    local Button = Instance.new("TextButton", SideMenu)
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Position = UDim2.new(0, 5, 0, (i-1)*45 + 10)
    Button.Text = btn.Name
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 18
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(75, 75, 135)
    Button.BorderSizePixel = 0
    Button.BackgroundTransparency = 0.2
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(72, 195, 255)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 75, 135)}):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        if btn.Name == "Set Base" then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                basePosition = LocalPlayer.Character.HumanoidRootPart.Position
                Title.Text = "Baza ustawiona!"
            end
        elseif btn.Name == "Brainrot TP" then
            if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
                Title.Text = "Teleport do bazy!"
            else
                Title.Text = "Najpierw ustaw bazę!"
            end
        elseif btn.Name == "Exit" then
            ScreenGui.Enabled = false
        end
    end)
end

-- Chowanie/pokazywanie huba pod ikonką
iconBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end)

-- Listener na zdobycie brainrota
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child.Name:lower():find("brainrot") then
        if basePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
            Title.Text = "Brainrot: Teleportacja!"
        else
            Title.Text = "Brainrot: Najpierw ustaw bazę!"
        end
    end
end)

-- Brainrot ESP: podświetlanie brainrotów i wyświetlanie największej wartości zarobku
local espColor = Color3.fromRGB(255, 255, 0) -- nowoczesny żółty
local espObjects = {}

local function createESP(part, value)
    if espObjects[part] then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part
    box.Size = part.Size + Vector3.new(0.5, 0.5, 0.5)
    box.Color3 = espColor
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = part
    espObjects[part] = box

    -- Etykieta z wartością brainrota
    local bill = Instance.new("BillboardGui", part)
    bill.Size = UDim2.new(0, 100, 0, 30)
    bill.StudsOffset = Vector3.new(0, part.Size.Y/2+1, 0)
    bill.Adornee = part
    bill.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 100)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = "Brainrot: $"..value
end

local function clearESP()
    for _,v in pairs(espObjects) do
        if v and v.Parent then v:Destroy() end
    end
    espObjects = {}
end

-- Automatyczne wyszukiwanie brainrotów w Workspace
RunService.RenderStepped:Connect(function()
    clearESP()
    local maxValue = 0
    local bestBrainrot = nil
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brainrot") then
            -- Przykładowo: wartość brainrota to atrybut "Value" albo dowolne inne pole
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

    -- Podświetl najlepszy brainrot na inny kolor
    if bestBrainrot and espObjects[bestBrainrot] then
        espObjects[bestBrainrot].Color3 = Color3.fromRGB(72, 195, 255)
        espObjects[bestBrainrot].Transparency = 0.2
        espObjects[bestBrainrot].ZIndex = 20
    end
end)
