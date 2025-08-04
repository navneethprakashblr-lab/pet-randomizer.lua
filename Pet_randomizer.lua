-- Safe Grow a Garden Pet Randomizer for Delta
-- Does NOT modify server data. Just picks/randomizes from available pet names.

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Attempt to gather pet names dynamically if exposed (fallback to manual list)
local petList = {}

-- Example dynamic extraction (you may need to adjust paths based on actual game structure)
-- This tries to pull pet names from a hypothetical folder; if it fails, it uses defaults.
local success, err = pcall(function()
    -- Adjust this to match where pet definitions or owned pets live in Grow a Garden.
    -- Common candidates: workspace.Pets, player:WaitForChild("Inventory"), etc.
    -- Here’s a safe generic fallback attempt:
    if workspace:FindFirstChild("Pets") then
        for _, v in ipairs(workspace.Pets:GetChildren()) do
            if v.Name and not table.find(petList, v.Name) then
                table.insert(petList, v.Name)
            end
        end
    end
    -- Owned pets example (if client stores them under PlayerGui/Data/OwnedPets)
    local container = player:FindFirstChildWhichIsA("Folder") or player:FindFirstChild("Inventory") or player:FindFirstChild("Pets")
    if container then
        for _, v in ipairs(container:GetChildren()) do
            if v.Name and not table.find(petList, v.Name) then
                table.insert(petList, v.Name)
            end
        end
    end
end)

-- Fallback hardcoded list if dynamic failed or is empty
if #petList == 0 then
    petList = {
        "Kitsune",
        "Queen Bee",
        "Ember Lily",
        "Owl",
        "Giant Ant",
        "Red Fox",
        "Dragonfly",
        -- add or remove pet names you care about
    }
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "PetRandomizerSafe"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "GAG Pet Randomizer"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

local result = Instance.new("TextLabel")
result.Size = UDim2.new(1, -10, 0, 40)
result.Position = UDim2.new(0, 5, 0, 30)
result.BackgroundTransparency = 1
result.Text = "Click Randomize"
result.Font = Enum.Font.SourceSansSemibold
result.TextSize = 16
result.TextColor3 = Color3.fromRGB(180,220,255)
result.TextWrapped = true
result.Parent = frame

local randomBtn = Instance.new("TextButton")
randomBtn.Size = UDim2.new(0, 130, 0, 30)
randomBtn.Position = UDim2.new(0, 10, 0, 80)
randomBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
randomBtn.BorderSizePixel = 0
randomBtn.Text = "Randomize Pet"
randomBtn.Font = Enum.Font.Gotham
randomBtn.TextSize = 14
randomBtn.TextColor3 = Color3.fromRGB(255,255,255)
randomBtn.Parent = frame

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 130, 0, 30)
copyBtn.Position = UDim2.new(0, 140, 0, 80)
copyBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
copyBtn.BorderSizePixel = 0
copyBtn.Text = "Copy Name"
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 14
copyBtn.TextColor3 = Color3.fromRGB(255,255,255)
copyBtn.Parent = frame

local lastPick = nil
randomBtn.MouseButton1Click:Connect(function()
    if #petList == 0 then
        result.Text = "No pets available"
        return
    end
    lastPick = petList[math.random(1, #petList)]
    result.Text = "Random Pet: " .. lastPick
end)

copyBtn.MouseButton1Click:Connect(function()
    if lastPick then
        -- Copy to clipboard if executor supports it (some don't)
        pcall(function()
            setclipboard(lastPick)
        end)
        result.Text = "Copied: " .. lastPick
    else
        result.Text = "Nothing to copy"
    end
end)
