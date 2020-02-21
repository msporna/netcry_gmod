
--list of scripts to be downloaded to client--
AddCSLuaFile( "external/data_dumper.lua" )
AddCSLuaFile( "cl_init.lua" ) --AddCSLuaFile is used to force download of this script to client; it needs to be included if want to use it
AddCSLuaFile( "cl_manager.lua" )
AddCSLuaFile( "cl_ui_manager.lua" )
AddCSLuaFile("shared.lua")
AddCSLuaFile( "entity_manager.lua" )
AddCSLuaFile( "cl_util.lua" )
AddCSLuaFile( "cl_state_manager.lua" )

----------------------------------

--imports (server side scripts)--------------------------
include("shared.lua")
include( "player_interactions_manager.lua" )
include( "npc_controller.lua" )
include( "entity_manager.lua" )
include( "player.lua" )
include( "util.lua" )
include( "interaction.lua" )
include( "npc_controller.lua" )


-----------------------------------

--------------------------------------------------------------------------------
-- script level statics and  variables
--------------------------------------------------------------------------------
local AVAILABLE_RELATIONSHIPS={
    neutral=D_NU,
    hate=D_HT,
    fear=D_FR,
    like=D_LI
}

local NPCS_NEUTRAL_TO_PLAYER={
    "netcry_security_guy_1",
    "netcry_security_guy_2"
}

local PLAYER_CONNECTED=false


-------------------------------------
-- log when player connects
-- @name - player nickname
--@ip  - player's ip
-------------------------------------
function GM:PlayerConnect(name,ip)
    print("Player connected "..name.." from ip:"..ip)
    -------------------------------------
    -- GLOBALS
    -------------------------------------
    print("__creating globals...")
    UTIL=Util:new()
    PLAYER=Player:new()
    PLAYER_INTERACTIONS_MANAGER=PlayerInteractionsManager:new()
    NPC_CONTROLLER=NpcController:new()
    ENTITY_MANAGER=EntityManager:new()
    SHARED_INSTANCE=Shared:new ()

    print("__globals created")
    -------------------------------------
    -- REGISTER SERVER HOOKS
    -------------------------------------
    print("__registering hooks...")
    hook.Add( "PhysgunPickup", "Allow Pickup of Entity",handle_AttemptToDisablePhysgun )
    hook.Add( "PlayerUse", "On Player Pressed E", handle_OnEntityInteraction )
  

    print("__end creating hooks...")

    PLAYER_CONNECTED=true
end



function GM:PlayerInitialSpawn(ply)
    print("PLayer "..ply:Name().." has spawned")
end

-- Choose the model for hands according to their player model.
function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if ( info ) then
		ent:SetModel( info.model )
		ent:SetSkin( info.skin )
		ent:SetBodyGroups( info.body )
	end

end

function GM:PlayerSpawn(ply)
    PLAYER:InitPlayer(ply)
    for k,v in pairs(NPCS_NEUTRAL_TO_PLAYER) do
        NPC_CONTROLLER:SetNpcRelationshipTowardsPlayer(ply,v,AVAILABLE_RELATIONSHIPS.hate)
    end
end


function GM:PlayerButtonDown(p,key)
    if key==KEY_H and SHARED_INSTANCE.HACK_STARTED==false then 
        print("other hack started? "..tostring(SHARED_INSTANCE.HACK_STARTED))
        print("can interact with npc? "..tostring(SHARED_INSTANCE.CAN_INTERACT_WITH_NPC))
        if SHARED_INSTANCE.CAN_INTERACT_WITH_NPC then 
            UTIL:SendMessageToClient("show_hack_popup",{})
            SHARED_INSTANCE.HACK_STARTED=true
        end
    end
end

function GM:Tick()
    if(PLAYER_CONNECTED==false) then 
        return 
    end 
    
    if(PLAYER.isInited==false) then 
        return nil
    end

   checkIfNpcInInteractionRange()

end
-------------------------------------
-- HOOK HANDLERS
-------------------------------------
function handle_AttemptToDisablePhysgun(ply,entity)
    ENTITY_MANAGER:AttemptToDisablePhysgun(ply,entity)
end

function handle_OnEntityInteraction(activator,caller)
    ENTITY_MANAGER:OnEntityInteraction(activator,caller)

end



-------------------------------------
-- LOCAL FUNCTIONS
-------------------------------------

function getRelationship(relationship_name)
    if relationship_name=="neutral" then
        return AVAILABLE_RELATIONSHIPS.neutral
    elseif relationship_name=="hate" then
        return AVAILABLE_RELATIONSHIPS.hate
    elseif relationship_name=="fear" then
        return AVAILABLE_RELATIONSHIPS.fear
    elseif relationship_name=="like" then
        return AVAILABLE_RELATIONSHIPS.like
    end
end

function checkIfNpcInInteractionRange()
    
    local ent=PLAYER.instance:GetEyeTrace().Entity
    local entName=ent:GetName()
    if (ent~=nil) then 
       -- get aavailable actions for this entity 
       local availableActions=SHARED_INSTANCE:GetAvailableActionsForNpc(entName)
       if (availableActions~=nil) then
        -- print("***looking AT["..ent:GetName().."]")
            --print("(**)(**)")
            --print("distance:")
            local entPos=ent:GetPos()
            local distance=PLAYER.instance:GetPos():Distance(entPos)
            --print(distance)
            if(distance<80) then 
                --print("__close to npc!")
                SHARED_INSTANCE.CAN_INTERACT_WITH_NPC=true
                SHARED_INSTANCE.NPC_INTERACTION_RANGE=entName
                UTIL:SendMessageToClient("show_available_actions",{availableActions=availableActions}) --this should go from config (interactions)--todo
            else 
                SHARED_INSTANCE.CAN_INTERACT_WITH_NPC=false
                SHARED_INSTANCE.NPC_INTERACTION_RANGE=nil
                UTIL:SendMessageToClient("hide_available_actions",{})
            end 
        else 
            SHARED_INSTANCE.CAN_INTERACT_WITH_NPC=false
            SHARED_INSTANCE.NPC_INTERACTION_RANGE=nil
            UTIL:SendMessageToClient("hide_available_actions",{})
        end
    end

end

-------------------------------------
-- NETWORKING (client/server communication)
-------------------------------------

util.AddNetworkString("server_message")
util.AddNetworkString("client_message")

-------------------------------------
-- receive message from client
-------------------------------------
net.Receive("client_message",function(len,ply)
    local type=net.ReadString()
    local params=net.ReadTable()

	if params ~=nil then
        print("got the following params :" )
        PrintTable(params)
	end

    if type=="set_npc_relationship" then
        -- set given relationship to specified npc (by name)
		print("Setting relationship of npc to player to "..params.relationship)
        NPC_CONTROLLER:SetNpcRelationshipTowardsPlayer(ply,params.npc_name,getRelationship(params.relationship))
    elseif type=="set_all_npc_in_scene_relationship" then
        -- set given relationship to all npcs in current scene
        print("Setting relationship of each npc in scene to player to "..params.relationship)
        allNpcsInScene=SHARED_INSTANCE:GetNpcNamesForCurrentScene()
        print("got npc name list for current scene ("..tostring(SHARED_INSTANCE.CURRENT_SCENE).."):")
        PrintTable(allNpcsInScene)
        for _,npc_name in pairs(allNpcsInScene) do
            NPC_CONTROLLER:SetNpcRelationshipTowardsPlayer(ply,npc_name,getRelationship(params.relationship))
        end

	end

    print("++Received and processed message from client: "..type)

end)