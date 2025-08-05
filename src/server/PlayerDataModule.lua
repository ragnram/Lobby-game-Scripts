--!strict

--// Module
local playerDataModule = {}

--// Services
local players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

--// Varubles
local money = 1
local playTime = 2
local inventory = 3
local DataStore = DataStoreService:GetDataStore("PlayerData")
local playerData = {}

--// Local Functions
local function formatPlaytime(seconds: number): string
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

local function StartTimer(player: Player)
	while playerData[player] do
		task.wait(1)
		playerData[player.UserId][playTime] += 1
		((player:WaitForChild("leaderstats") :: Folder):WaitForChild("Play Time") :: StringValue).Value =
			formatPlaytime(playerData[player.UserId][playTime])
	end
end

local function newPlayer(player: Player)
	local leaderBoardFolder = Instance.new("Folder")
	leaderBoardFolder.Parent = player
	leaderBoardFolder.Name = "leaderstats"

	local moneyValue = Instance.new("IntValue")
	moneyValue.Parent = leaderBoardFolder
	moneyValue.Name = "Money"

	local stringTimeValue = Instance.new("StringValue")
	stringTimeValue.Parent = leaderBoardFolder
	stringTimeValue.Name = "Play Time"

	local success, playerTable = pcall(function()
		return DataStore:GetAsync(player.UserId)
	end)

	if success and playerTable then
		moneyValue.Value = playerTable[money]
		playerData[player.UserId] = playerTable
	end

	StartTimer(player)
end

local function removedPlayer(player)
	local succes, errorMessage = pcall(function()
		DataStore:SetAsync(player.UserId, {
			playerData[player.UserId],
		})
	end)

	if not succes then
		warn(errorMessage)
	end
end

--// Module Functions
playerDataModule.addToInventory = function(player: Player, item)
	table.insert(playerData[player.UserId][inventory], item)
end

playerDataModule.removeFromInventory = function(player: Player, item)
	for index in playerData[player.UserId][inventory] do
		if playerData[player.UserId][inventory][index] == item then
			playerData[player.UserId][inventory][index] = nil
			break
		end
	end
end

playerDataModule.startServer = function()
	players.PlayerAdded:Connect(newPlayer)
	players.PlayerRemoving:Connect(removedPlayer)
end

return playerDataModule
