--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

config.AddToMenu("character", "character_min_name_len", "Minimum Character Name Length", "The minimum amount of characters that player's name can be.", "number", {min = 1, max = 256, default = 4})
config.AddToMenu("character", "character_max_name_len", "Maximum Character Name Length", "The maximum amount of characters that player's name can be.", "number", {min = 1, max = 256, default = 32})
config.AddToMenu("character", "character_min_desc_len", "Minimum Character Description Length", "The maximum amount of characters that character's description can be.", "number", {min = 1, max = 1024, default = 32})
config.AddToMenu("character", "character_max_desc_len", "Maximum Character Description Length", "The maximum amount of characters that character's description can be.", "number", {min = 1, max = 1024, default = 256})