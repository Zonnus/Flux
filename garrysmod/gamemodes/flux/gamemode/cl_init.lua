--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

fl = fl or {}
fl.startTime = os.clock()

-- Include pON, Netstream and UTF-8 library
if (!string.utf8len or !pon or !netstream) then
	include("thirdparty/utf8.lua")
	include("thirdparty/pon.lua")
	include("thirdparty/netstream.lua")
end

if (fl.initialized) then
	MsgC(Color(0, 255, 100, 255), "[Flux] Lua auto-reload in progress...\n")
else
	MsgC(Color(0, 255, 100, 255), "[Flux] Initializing...\n")
end

-- Initiate shared boot.
include("shared.lua")

font.CreateFonts()

if (fl.initialized) then
	MsgC(Color(0, 255, 100, 255), "[Flux] Auto-reloaded in "..math.Round(os.clock() - fl.startTime, 3).. " second(s)\n")
else
	MsgC(Color(0, 255, 100, 255), "[Flux] Flux v"..GM.Version.." has finished loading in "..math.Round(os.clock() - fl.startTime, 3).. " second(s)\n")

	fl.initialized = true
end