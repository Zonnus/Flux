--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

if (netvars) then return end

library.New "netvars"

local stored = netvars.stored or {}
local globals = netvars.globals or {}
netvars.stored = stored
netvars.globals = globals

local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

-- A function to check if value's type cannot be serialized and print an error if it is so.
local function IsBadType(key, val)
	if (isfunction(val)) then
		ErrorNoHalt("[Flux] Cannot store functions as NetVars! ("..key..")\n")

		return true
	end

	return false
end

-- A function to get a networked global.
function netvars.GetNetVar(key, default)
	if (globals[key] != nil) then
		return globals[key]
	end

	return default
end

-- A function to set a networked global.
function netvars.SetNetVar(key, value, send)
	if (IsBadType(key, value)) then return end
	if (netvars.GetNetVar(key) == value) then return end

	globals[key] = value

	netstream.Start(send, "Flux::NetVars::SetGlobal", key, value)
end

-- A function to send entity's networked variables to a player (or players).
function entityMeta:SendNetVar(key, recv)
	netstream.Start(recv, "Flux::NetVars::SetVar", self:EntIndex(), key, (stored[self] and stored[self][key]))
end

-- A function to get entity's networked variable.
function entityMeta:GetNetVar(key, default)
	if (stored[self] and stored[self][key] != nil) then
		return stored[self][key]
	end

	return default
end

-- A function to flush all entity's networked variables.
function entityMeta:ClearNetVars(recv)
	stored[self] = nil
	netstream.Start(recv, "Flux::NetVars::Delete", self:EntIndex())
end

-- A function to set entity's networked variable.
function entityMeta:SetNetVar(key, value, send)
	if (IsBadType(key, value)) then return end
	if (!istable(value) and self:GetNetVar(key) == value) then return end

	stored[self] = stored[self] or {}
	stored[self][key] = value

	self:SendNetVar(key, send)
end

-- A function to send all current networked globals and entities' variables
-- to a player.
function playerMeta:SyncNetVars()
	for k, v in pairs(globals) do
		netstream.Start(self, "Flux::NetVars::SetGlobal", k, v)
	end

	for k, v in pairs(stored) do
		if (IsValid(k)) then
			for k2, v2 in pairs(v) do
				netstream.Start(self, "Flux::NetVars::SetVar", k:EntIndex(), k2, v2)
			end
		end
	end
end