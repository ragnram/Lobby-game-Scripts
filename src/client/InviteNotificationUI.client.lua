--!strict

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Varubles
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local MainGUI = PlayerGui:WaitForChild("Main"):WaitForChild("Notifications")

--// Remotes
local inviteRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteEvents"):WaitForChild("Invite")
local addToPartyRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteEvents"):WaitForChild("AddToParty")

local inviteQue = {}
-- Store original position exactly as it was in Studio
local originalPosition = MainGUI.Position
local hiddenPosition = UDim2.new(2, 0, originalPosition.Y.Scale, originalPosition.Y.Offset)

-- Start hidden
MainGUI.Position = hiddenPosition
MainGUI.Visible = false

-- Tween helper
function tweenTo(position, direction, onComplete)
	local tween = TweenService:Create(MainGUI, TweenInfo.new(0.3, Enum.EasingStyle.Quad, direction), {
		Position = position
	})
	tween:Play()
	if onComplete then tween.Completed:Once(onComplete) end
end

-- Get player avatar
function getPlayerIcon(char)
	local userId = char.UserId
	return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end

-- Open invite
function open(player)
	if MainGUI.Visible == false then
		MainGUI.Visible = true
		MainGUI.ImageLabel.Image = getPlayerIcon(player)
		MainGUI.PlayerName.Text = "Invite from " .. player.Name
		tweenTo(originalPosition, Enum.EasingDirection.Out)
		task.wait(4)
		close()
	else
		table.insert(inviteQue,player)
	end
end

-- Close function
function close()
	tweenTo(hiddenPosition, Enum.EasingDirection.In, function()
		MainGUI.Visible = false
	end)
	if #inviteQue > 0 then
		task.wait(0.5)
		open(inviteQue[1])
		table.remove(inviteQue,1)
	end
end

-- Accept invite
function joinParty()
	local fullText = MainGUI.PlayerName.Text
	local playerName = string.sub(fullText, 13)
	addToPartyRemote:FireServer(playerName)
	close()
end

-- Button events
MainGUI.Accept.MouseButton1Up:Connect(joinParty)
MainGUI.Decline.MouseButton1Up:Connect(close)
inviteRemote.OnClientEvent:Connect(open)