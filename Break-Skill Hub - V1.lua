--[
--Script Made By xS_Killus
--]

--[
--Game Loading
--]

repeat
    wait()
until game:IsLoaded() and game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local Start = tick()

--Notification Library

getgenv()["IrisAd"] = true

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

--While Loading Script

if getgenv()["BreakSkill_Loaded"] == true then
    Notification.Notify(
        "Break-Skill Hub - V1",
		"<b><font color=\"rgb(255, 30, 30)\">Break-Skill Hub - V1 already executed!</font></b>",
		"rbxassetid://7771536804",
		{
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		}
	)

    return
end

--Instances and Functions

local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Client = Players.LocalPlayer

getgenv()["MurderMystery2"] = true
getgenv()["DaHood"] = true
getgenv()["Arsenal"] = true
getgenv()["PetSimulatorX"] = true

RunService.RenderStepped:Connect(function()
	for i, v in pairs(CoreGui:GetChildren()) do
		if v:FindFirstChild("PropertiesFrame") then
			if v:FindFirstChild("ExplorerPanel") then
				if v:FindFirstChild("SideMenu") then
					Client:Kick("\n[Break-Skill Hub - V1]:\n[Script Error]:\nDark Dex Detected!\nIf you keep trying to use Dark Dex while the script is running your whitelist may be blocked!\ndiscord.gg/BtXYGMeTs")

					return
				end
			end
		end
	end
end)

getgenv()["exploit_type"] = nil

if syn and not is_sirthurt_closure and not pebc_execute then
    getgenv()["exploit_type"] = "Synapse X"
elseif getexecutorname then
    getgenv()["exploit_type"] = "Script-Ware V2"
elseif KRNL_LOADED then
	getgenv()["exploit_type"] = "KRNL"
elseif FLUXUS_LOADED then
	getgenv()["exploit_type"] = "Fluxus"
elseif identifyexecutor() == "Comet" then
	getgenv()["exploit_type"] = "Comet"
elseif identifyexecutor() == "OxygenU" then
	getgenv()["exploit_type"] = "Oxygen U"
elseif identifyexecutor() == "Furk" then
	getgenv()["exploit_type"] = "Furk"
elseif identifyexecutor() == "WRD-API" then
	getgenv()["exploit_type"] = "Unspecified (WRD API)"
else
    Client:Kick("\n[Break-Skill Hub - V1]:\n[Executor Error]:\nYour executor is not supported!\nYou can find supported executors on our discord:\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

    return
end

--AntiAFK

Client.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)

    wait(1)

    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

--[
--Game Script Loading
--]

if game.PlaceId == 142823291 and getgenv()["MurderMystery2"] == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Murder%20Mystery%202.lua"))()

	if getgenv()["BreakSkill_MM2_Loaded"] == true then
		local End = (tick() - Start)

		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end

	if getgenv()["BreakSkill_Loaded"] == true then
		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end
elseif game.PlaceId == 2788229376 and getgenv()["DaHood"] == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Da%20Hood.lua"))()

	if getgenv()["BreakSkill_DH_Loaded"] == true then
		local End = (tick() - Start)

		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end

	if getgenv()["BreakSkill_Loaded"] == true then
		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end
elseif game.PlaceId == 286090429 and getgenv()["Arsenal"] == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Arsenal.lua"))()

	if getgenv()["BreakSkill_A_Loaded"] == true then
		local End = (tick() - Start)

		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end

	if getgenv()["BreakSkill_Loaded"] == true then
		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end
elseif game.PlaceId == 6284583030 and getgenv()["PetSimulatorX"] == true then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/Break-Skill-Hub-V1/main/Pet%20Simulator%20X.lua"))()

	if getgenv()["BreakSkill_PSX_Loaded"] == true then
		local End = (tick() - Start)

		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Loading script time: </font><font color=\"rgb(30, 255, 30)\">" .. End .. " </font><font color=\"rgb(255, 30, 30)\">ms.</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end

	if getgenv()["BreakSkill_Loaded"] == true then
		Notification.Notify("Break-Skill Hub - V1", "<b><font color=\"rgb(255, 30, 30)\">Successfully loaded script for</font> <font color=\"rgb(30, 255, 30)\">" .. MarketplaceService:GetProductInfo(game.PlaceId).Name .. "</font><font color=\"rgb(255, 30, 30)\">!</font></b>", "rbxassetid://7771536804", {
			Duration = 10,
			TitleSettings = {
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = Enum.Font.SourceSansBold
			},
			GradientSettings = {
				GradientEnabled = false,
				SolidColorEnabled = true,
				SolidColor = Color3.fromRGB(255, 30, 30),
				Retract = true
			}
		})
	end
elseif game.PlaceId == 142823291 and getgenv()["MurderMystery2"] == false then
	Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame Disabled!\nYou can find enabled games on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

	return
elseif game.PlaceId == 2788229376 and getgenv()["DaHood"] == false then
	Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame Disabled!\nYou can find enabled games on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

	return
elseif game.PlaceId == 2756405205 and getgenv()["Arsenal"] == false then
	Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame Disabled!\nYou can find enabled games on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

	return
elseif game.PlaceId == 6284583030 and getgenv()["PetSimulatorX"] == false then
	Client:Kick("\n⁣[Break-Skill Hub - V1]:\n[Game Error]:\nGame Disabled!\nYou can find enabled games on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

	return
else
	Client:Kick("\n[Break-Skill Hub - V1]:\n[Game Error]:\nGame not supported!\nYou can find supported games on our discord!\ndiscord.gg/BtXYGMemTs (Copied)")

	setclipboard("discord.gg/BtXYGMemTs")

	return
end
