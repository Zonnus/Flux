--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

PLUGIN:SetAlias("flAreas")

util.Include("cl_plugin.lua")
util.Include("sv_plugin.lua")

if (!areas) then
	util.Include("libraries/sh_areas.lua")
end

flAreas.toolModes = {
	Add = function(list, data)
		local vars = data.ClientConVar or data.ConVars or data.ClientConVars or data.ConVar

		table.insert(list, {
			title = data.title or "Unknown Mode",
			areaType = data.areaType or "area",
			OnLeftClick = data.OnLeftClick,
			OnRightClick = data.OnRightClick,
			OnReload = data.OnReload or function(mode, tool, trace)
				local curTime = CurTime()

				for k, v in pairs(areas.GetAll()) do
					if (istable(v.polys) and isstring(v.type) and v.type == data.areaType) then
						for k2, v2 in ipairs(v.polys) do
							local pos = trace.HitPos
							local z = pos.z + 16

							if (z > v2[1].z and z < v.maxH) then
								if (util.VectorIsInPoly(pos, v2)) then
									areas.Remove(v.uniqueID)

									return true
								end
							end
						end
					end
				end
			end,
			BuildCPanel = data.BuildCPanel,
			ClientConVar = vars
		})

		local tool = fl.tool:Get("area")

		if (IsValid(tool) and istable(vars)) then
			table.Merge(tool.ClientConVar, vars)

			tool:CreateConVars()
		end
	end
}

function flAreas:OnSchemaLoaded()
	plugin.Call("AddAreaToolModes", self.toolModes)
end

function flAreas:AddAreaToolModes(modeList)
	local mode = {}
	mode.title = "Text Area"
	mode.areaType = "textarea"
	mode.ClientConVar = mode.ClientConVar or {}
	mode.ClientConVar["height"] = "512"
	mode.ClientConVar["text"] = "Sample Text"

	function mode:OnLeftClick(tool, trace)
		local text = tostring(tool:GetClientInfo("text"))
		local height = tonumber(tool:GetClientNumber("height"))
		local uniqueID = text:MakeID()

		if (!uniqueID or uniqueID == "") then return false end

		if (!tool.area) then
			tool.area = areas.Create(uniqueID, height, {type = self.areaType})
			tool.area.text = text
		end

		tool.area:AddVertex(trace.HitPos)

		return true
	end

	function mode:OnRightClick(tool, trace)
		if (tool.area) then
			tool.area:Register()
			tool.area = nil

			return true
		end
	end

	function mode:BuildCPanel(panel)
		panel:AddControl("Header", { Description = "#tool.area.desc" })
		panel:AddControl("TextBox", { Label = "#tool.area.text", Command = "area_text", MaxLenth = "256" })
		panel:AddControl("Slider", { Label = "#tool.area.height", Command = "area_height", Type = "Float", Min = -2048, Max = 2048 })
	end

	modeList:Add(mode)
end

areas.RegisterType("textarea", "Text Area", "Displays text whenever player enters the area.", Color(255, 0, 255), function(player, area, bHasEntered, pos, curTime)
	player.textAreas = player.textAreas or {}

	if (bHasEntered) then
		local textAreaData = player.textAreas[area.uniqueID]
		local areaData = player.textAreas[area.uniqueID]

		if (istable(areaData) and areaData.resetTime > curTime) then
			return
		end	

		player.textAreas[area.uniqueID] = {text = area.text, endTime = curTime + 10, resetTime = curTime + 20}
	end
end)