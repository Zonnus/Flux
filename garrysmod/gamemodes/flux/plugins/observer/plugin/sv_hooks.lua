--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

function flObserver:ShouldObserverReset(player)
	return config.Get("observer_reset")
end

function flObserver:PlayerEnterNoclip(player)
	if (!player:HasPermission("noclip")) then
		fl.player:Notify(player, "You do not have permission to do this.")

		return false
	end

	player.observerData = {
		position = player:GetPos(),
		angles = player:EyeAngles(),
		color = player:GetColor(),
		moveType = player:GetMoveType(),
		shouldReset = (plugin.Call("ShouldObserverReset", player) != false)
	}

	player:SetMoveType(MOVETYPE_NOCLIP)
	player:DrawWorldModel(false)
	player:DrawShadow(false)
	player:SetNoDraw(true)
	player:SetNotSolid(true)
	player:SetColor(Color(0, 0, 0, 0))

	player:SetNetVar("Observer", true)

	return false
end

function flObserver:PlayerExitNoclip(player)
	local data = player.observerData

	if (data) then
		player:SetMoveType(data.moveType or MOVETYPE_WALK)
		player:DrawWorldModel(true)
		player:DrawShadow(true)
		player:SetNoDraw(false)
		player:SetNotSolid(false)
		player:SetColor(data.color)

		if (data.shouldReset) then
			timer.Simple(FrameTime(), function()
				if (IsValid(player)) then
					player:SetPos(data.position)
					player:SetEyeAngles(data.angles)
				end
			end)
		end
	end

	player.observerData = nil
	player:SetNetVar("Observer", false)

	return false
end