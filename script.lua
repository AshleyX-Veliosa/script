repeat task.wait() until game:GetService("Players").LocalPlayer
repeat task.wait() until game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main")
repeat task.wait() until (game.Players.LocalPlayer.Neutral == false) == true

local pbag = ({...})[1]
local host = pbag[1]
local key = pbag[2]
local machine = pbag[3]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MeleeRequestList = {
    ["Death Step"] = "BuyDeathStep",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman",
    ["Super human"] = "BuySuperhuman",
    ["Sanguine Art"] = "BuySanguineArt"
}

function getLevel()
    return LocalPlayer.Data.Level.Value
end

function getWorld() 
	local placeId = game.PlaceId
	if placeId == 2753915549 then
		return 1
	elseif placeId == 4442272183 then
		return 2
	elseif placeId == 7449423635 then
		return 3
	end
end

function getItem(itemName) 
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v) == "table" then
            if v.Type == "Material" then
                if v.Name == itemName then
                    return true
                end
            end
        end
    end
    return false
end

function getFruitMastery()
    if game:GetService("Players").LocalPlayer.Data.DevilFruit.Value == '' then return 0 end
    if LocalPlayer:FindFirstChild("Backpack") then 
        for i,v in pairs(LocalPlayer:FindFirstChild("Backpack"):GetChildren()) do 
            if v.ToolTip == "Blox Fruit" then 
                if v:FindFirstChild("Level") then 
                    return v.Level.Value
                end
            end
        end
    end
    repeat wait() until LocalPlayer.Character
    if LocalPlayer.Character:FindFirstChildOfClass("Tool") then 
        local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool.ToolTip == "Blox Fruit" then
            if Tool:FindFirstChild("Level") then 
                return Tool.Level.Value
            end
        end
    end
    return 0
end

function getFruitName()
    return string.split(game:GetService("Players").LocalPlayer.Data.DevilFruit.Value,"-")[2] or "None"
end

function getAwakend()
    local SkillAWakenedList = {}
    local getAwakenedAbilitiesRequests = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getAwakenedAbilities")
    if getAwakenedAbilitiesRequests then
    for i, v in pairs(getAwakenedAbilitiesRequests) do
        if v["Awakened"] then 
                table.insert(SkillAWakenedList, i)
            end
        end
    end
    return SkillAWakenedList;
end

function getMeele()
    local MeleeName, RequestMeleeName = {}, nil;
    for i, v in pairs(MeleeRequestList) do 
        RequestMeleeName =  game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(v, true)
        if tonumber(RequestMeleeName) == 1 then 
            table.insert(MeleeName, i)
        end
    end
    return MeleeName
end

function getSword()
    local SwordList, RequestGetInvertory = {}, nil
    RequestGetInvertory = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventory")
    for i , v in pairs(RequestGetInvertory) do 
        if v['Type'] == "Sword" then 
            if v['Rarity'] >= 3 then
                table.insert(SwordList, v['Name'])
            end
        end
    end
    return SwordList
end

function GetFruitInU()
    local ReturnText = {}
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
        if type(v) == "table" then
            if v ~= nil then
                if v.Price >= 2300000  then
                    table.insert(ReturnText,string.split(v.Name,"-")[2])
                end
            end
        end
    end
    return ReturnText
end

function len(x)
    local q = 0
    for i, v in pairs(x) do
        q = q + 1
    end
    return q
end

function findItem(item) 
    local RequestgetInventory;
    RequestgetInventory = game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")
    for i, __ in pairs(RequestgetInventory) do
        if __["Name"] == item then
            return true
        end
    end
    return false
end

function getType()
    local ReturnText = {}
    if findItem("Cursed Dual Katana") then 
        table.insert(ReturnText, "CDK")
    end
    if findItem("Shark Anchor") then 
        table.insert(ReturnText, "SA")
    end
    if findItem("Soul Guitar") then
        table.insert(ReturnText, "SG")
    end
    local GodHuman = tonumber(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman",true))
    if GodHuman then
            if GodHuman == 1 then
                table.insert(ReturnText, "GOD")
            end
    end
    if len(ReturnText) == 0 then
        table.insert(ReturnText, "NOOB")
    end
    return table.concat(ReturnText, " ")
end

function getVK()
	for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventoryWeapons")) do
            for i1,v1 in pairs(v) do
                if v1 == 'Valkyrie Helm' then
                    return true
                end
            end
        end
     if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild('Valkyrie Helm') or game:GetService("Players").LocalPlayer.Character:FindFirstChild('Valkyrie Helm') then
           return true
        end
    return false
end

function getEvoTier()
    local CheckAlchemist = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    if CheckAlchemist == -2 then
        local CheckWenlocktoad = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        if CheckWenlocktoad == -2 then
            if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
                return 4
            end
            return 3
        end
        return 2
    end
    return 1
end

function getAwakendTier()
    local q, _ = pcall(function()
        return tonumber(game:GetService("Players").LocalPlayer.Data.Race.C.Value)
    end)
    if q then return _ end 
    return 0
end

function checkDoor()
    return game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor")
end

function sendRequest()
    local res = request({
        Url = host,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = key,
        },
        Body = HttpService:JSONEncode({
            ["Account"] = LocalPlayer.DisplayName,
            ["Type"] = getType(),
            ["Level"] = getLevel(),
            ["World"] = getWorld(),
            ["MR"] = getItem("Mirror Fractal"),
            ["VK"] = getVK(),
            ["FruitMastery"] = getFruitMastery(),
            ["Fruit"] = getFruitName() or "None",
            ["Awakend"] = getAwakend(),
            ["Melee"] = getMeele(),
            ["Beli"] = LocalPlayer.Data.Beli.Value,
            ["Fragment"] = LocalPlayer.Data.Fragments.Value,
            ["Machine"] = machine,
            ["Inventory"] = getSword(),
            ["FruitInventory"] = GetFruitInU(),
            ["Race"] = game:GetService("Players").LocalPlayer.Data.Race.Value,
            ["RaceV"] = getEvoTier(),
            ["Tier"] = getAwakendTier(),
            ["Pulled"] = checkDoor()
        })
    })
   warn(res.Body)
end

task.spawn(function()
    while true do
        local x, p = pcall(function()
            sendRequest()
        end)
        if not x then warn(p) end
        task.wait(10)
    end
end)