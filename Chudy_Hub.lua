-- Zmienna do przechowywania pozycji bazy
local basePosition = nil

-- Funkcja ustawiająca bazę
function setBase()
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        basePosition = lp.Character.HumanoidRootPart.Position
        print("Baza ustawiona na: ", basePosition)
    else
        print("Brak postaci!")
    end
end

-- Funkcja teleportująca do bazy
function teleportToBase()
    local lp = game.Players.LocalPlayer
    if basePosition and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = CFrame.new(basePosition)
        print("Teleportowano do bazy!")
    else
        print("Nie ustawiono bazy!")
    end
end

-- Przycisk Set Base w PlayerGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "ChudyHubDelta"

local setBaseButton = Instance.new("TextButton")
setBaseButton.Text = "Set Base"
setBaseButton.Size = UDim2.new(0, 140, 0, 44)
setBaseButton.Position = UDim2.new(0, 25, 0, 25)
setBaseButton.Font = Enum.Font.GothamBold
setBaseButton.TextSize = 21
setBaseButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
setBaseButton.TextColor3 = Color3.fromRGB(25,25,40)
setBaseButton.Parent = ScreenGui

setBaseButton.MouseButton1Click:Connect(setBase)

-- Przycisk TP do bazy
local tpButton = Instance.new("TextButton")
tpButton.Text = "TP do Bazy"
tpButton.Size = UDim2.new(0, 140, 0, 44)
tpButton.Position = UDim2.new(0, 25, 0, 80)
tpButton.Font = Enum.Font.GothamBold
tpButton.TextSize = 21
tpButton.BackgroundColor3 = Color3.fromRGB(72, 195, 255)
tpButton.TextColor3 = Color3.fromRGB(25,25,40)
tpButton.Parent = ScreenGui

tpButton.MouseButton1Click:Connect(teleportToBase)

-- Listener na zdobycie brainrota
game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child.Name:lower():find("brainrot") then
        teleportToBase()
    end
end)

-- KOLORY ESP
local brainrotESPColor = Color3.fromRGB(255, 255, 0) -- Złoty/żółty
local playerESPColor = Color3.fromRGB(72, 195, 255)  -- Jasnoniebieski

-- ESP dla brainrotów (największa wartość zarabiania)
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local brainrotESPObjects = {}

local function clearBrainrotESP()
    for _,v in pairs(brainrotESPObjects) do
        if v and v.Parent then v:Destroy() end
    end
    brainrotESPObjects = {}
end

local function createBrainrotESP(part, value, isBest)
    if brainrotESPObjects[part] then return end
    local bill = Instance.new("BillboardGui", part)
    bill.Size = UDim2.new(0, 120, 0, 36)
    bill.StudsOffset = Vector3.new(0, part.Size.Y/2 + 1.5, 0)
    bill.Adornee = part
    bill.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bill)
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.Text = (isBest and "NAJ Brainrot: $" or "Brainrot: $") .. tostring(value)
    label.TextColor3 = isBest and Color3.fromRGB(0,255,0) or brainrotESPColor -- Najlepszy brainrot świeci się na zielono
    brainrotESPObjects[part] = bill
end

-- ESP dla graczy
local playerESPObjects = {}

local function clearPlayerESP()
    for _,v in pairs(playerESPObjects) do
        if v and v.Parent then v:Destroy() end
    end
    playerESPObjects = {}
end

local function createPlayerESP(char, name)
    if playerESPObjects[char] then return end
    if char:FindFirstChild("Head") then
        local bill = Instance.new("BillboardGui", char.Head)
        bill.Size = UDim2.new(0, 120, 0, 24)
        bill.StudsOffset = Vector3.new(0, 2.6, 0)
        bill.Adornee = char.Head
        bill.AlwaysOnTop = true
        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = name
        label.TextColor3 = playerESPColor
        playerESPObjects[char] = bill
    end
end

-- Główna pętla ESP
RunService.RenderStepped:Connect(function()
    -- Brainrot ESP
    clearBrainrotESP()
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
        end
    end
    -- Najpierw dodaj wszystkie brainroty, potem podświetl najlepszy na zielono
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("brainrot") then
            local value = 0
            if v:FindFirstChild("Value") and v.Value:IsA("NumberValue") then
                value = v.Value.Value
            elseif v:GetAttribute("Value") then
                value = v:GetAttribute("Value")
            end
            createBrainrotESP(v, value, v == bestBrainrot)
        end
    end

    -- Player ESP
    clearPlayerESP()
    for _,plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            createPlayerESP(plr.Character, plr.Name)
        end
    end
end)
