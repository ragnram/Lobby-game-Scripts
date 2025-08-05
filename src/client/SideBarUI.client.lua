--!strict

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local screenGUI = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main")
local invitePanel = screenGUI:WaitForChild("Invite")
local shopPanel = screenGUI:WaitForChild("Shop")

local ui = screenGUI:WaitForChild("Sidebar")

-- Tween settings
local slideTime = 0.3
local easingStyle = Enum.EasingStyle.Quad
local easingOut = Enum.EasingDirection.Out
local easingIn = Enum.EasingDirection.In

-- Store original positions
local inviteVisiblePos = invitePanel.Position
local shopVisiblePos = shopPanel.Position

-- Calculate hidden position by offsetting to the left
local function getHiddenPos(panel)
	return UDim2.new(-1, 0, panel.Position.Y.Scale, panel.Position.Y.Offset)
end

-- Move panels off-screen initially
invitePanel.Position = getHiddenPos(invitePanel)
invitePanel.Visible = false

shopPanel.Position = getHiddenPos(shopPanel)
shopPanel.Visible = false

-- Tween helper
local function tweenPanel(panel, targetPos, easing, onComplete)
	local tween = TweenService:Create(panel, TweenInfo.new(slideTime, easingStyle, easing), { Position = targetPos })
	tween:Play()
	if onComplete then
		tween.Completed:Once(onComplete)
	end
end

local function open(panel, targetPos)
	panel.Visible = true
	tweenPanel(panel, targetPos, easingOut)
end

local function close(panel)
	tweenPanel(panel, getHiddenPos(panel), easingIn, function()
		panel.Visible = false
	end)
end

local function openInvitePanel()
	if invitePanel.Visible then
		close(invitePanel)
	else
		close(shopPanel)
		open(invitePanel, inviteVisiblePos)
	end
end

local function openShopPanel()
	if shopPanel.Visible then
		close(shopPanel)
	else
		close(invitePanel)
		open(shopPanel, shopVisiblePos)
	end
end

ui.Shop.Activated:Connect(openShopPanel)
ui.Invite.Activated:Connect(openInvitePanel)
