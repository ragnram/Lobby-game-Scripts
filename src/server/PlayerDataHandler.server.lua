--!strict

--// Module
local module = {}

--// Services
local players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

--// Varubles
local money = 1
local playTime = 2
local DataStore = DataStoreService:GetDataStore("PlayerData")

--// Local Functions
local function formatPlaytime(seconds : number) : string
	if seconds then
		local minutes = math.floor(seconds / 60)
		if minutes < 60 then
			return tostring(minutes) .. "m"
		else
			local hours = math.floor(minutes / 60)
			return tostring(hours) .. "h"
		end
	end
	return tostring(0)
end


local function addPlayTime(timeValue : IntValue)
	task.wait(1)
	local num = tonumber(timeValue.Value) :: number

	timeValue.Value += 1
	(timeValue.Parent :: StringValue ).Value = formatPlaytime(num) 

	addPlayTime(timeValue)
end

local function added(char : Player) 

	local leaderBoardFolder = Instance.new("Folder", char)
	leaderBoardFolder.Name = "leaderstats"

	local moneyValue = Instance.new("IntValue", leaderBoardFolder)
	moneyValue.Name = "Money"

	local stringTimeValue = Instance.new("StringValue", leaderBoardFolder)
	stringTimeValue.Name = "Play Time"

	local timeValue = Instance.new("IntValue", stringTimeValue)
	timeValue.Name = "PlayTimeInt"

	local success, playerTable = pcall(function()
		return DataStore:GetAsync(char.UserId)
	end)

	if success and playerTable then
		moneyValue.Value = playerTable[money]
		timeValue.Value = playerTable[playTime]
	end

	addPlayTime(timeValue)
end

local function removed(char)
	local succes, errorMessage = pcall(function()
		DataStore:SetAsync(
			char.UserId,
			{
				char.leaderstats.Money.Value, 
				char.leaderstats["Play Time"].PlayTimeInt.Value,
			}
		)
	end)

	if not succes then
		warn(errorMessage)
	end
end

--// Events
players.PlayerAdded:Connect(added)
players.PlayerRemoving:Connect(removed)

return module
