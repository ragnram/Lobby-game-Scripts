--!strict

local ShopModule = {}

--// Services
local Players = game:GetService('Players')


--// Varubles
local playerGui = Players.LocalPlayer.PlayerGui
local shopGui = playerGui:WaitForChild("Main").Shop
local tabs = shopGui.Tabs
local featuredTab = shopGui.FeaturedTab
local defaultShop = shopGui.DefaultShop

--// Local Functions
local function ChangeTab(CloseTab, OpenTab)
	for _, frame : Frame in CloseTab:GetChildren() do
		frame.Visible = false
	end
	for _, frame : Frame in OpenTab:GetChildren() do
		frame.Visible = true
	end
end

local function OpenAurasTab()
	ChangeTab(featuredTab, defaultShop)
end

local function OpenEmotesTab()
	ChangeTab(featuredTab, defaultShop)
end

local function OpenFeaturedTab()
	ChangeTab(defaultShop, featuredTab)
end

local function OpenMountsTab()
	ChangeTab(featuredTab, defaultShop)
end

local function Close()
	shopGui.Visible = false
	ChangeTab(defaultShop, featuredTab)
end

--// Events
shopGui.Exit.Activated:Connect(Close)
tabs.Auras.Activated:Connect(OpenAurasTab)
tabs.Emotes.Activated:Connect(OpenEmotesTab)
tabs.Featured.Activated:Connect(OpenFeaturedTab)
tabs.Mounts.Activated:Connect(OpenMountsTab)

return ShopModule
