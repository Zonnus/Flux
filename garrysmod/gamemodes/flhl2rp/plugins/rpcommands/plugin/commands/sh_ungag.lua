--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

local COMMAND = Command("ungag")
COMMAND.Name = "Ungag"
COMMAND.Description = "Unmute player's OOC chats."
COMMAND.Syntax = "<name>"
COMMAND.Category = "administration"
COMMAND.Arguments = 1
COMMAND.Immunity = true
COMMAND.Aliases = {"unmuteooc", "oocunmute", "plyungag"}

function COMMAND:OnRun(player, targets)
	for k, v in ipairs(targets) do
		v:SetPlayerData("MuteOOC", nil)
	end

	fl.player:NotifyAll(L("OOCUnmuteMessage", (IsValid(player) and player:Name()) or "Console", util.PlayerListToString(targets)))
end

COMMAND:Register()