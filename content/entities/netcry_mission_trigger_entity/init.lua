AddCSLuaFile("entities/netcry_mission_trigger_entity/cl_init.lua")
AddCSLuaFile("entities/netcry_mission_trigger_entity/shared.lua")
include("entities/netcry_mission_trigger_entity/shared.lua")


function ENT:Initialize()
    print("___MISSION entity INITILIZED!__")
    self:SetTrigger(true)
    
	
end

function ENT:StartTouch(entity)
    if entity:IsPlayer() then
        print("Mission objective trigger TOUCHED BY player")
        UTIL:SendMessageToClient("OnMissionPopupTriggered",nil)
    end
end