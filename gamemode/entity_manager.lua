EntityManager={}
EntityManager.__index = EntityManager


function EntityManager:new ()
    -- default constructor
    -- below can be class name or entity name
    self.entities_not_compatible_with_physgun={"door_0","secret_door1","vent_1","door_0_button","secret_door1_button","netcry_security_guy_1","netcry_security_guy_2"}
    local entityManager_instance={}
    setmetatable(entityManager_instance,EntityManager)
    return entityManager_instance
  end


-------------------------------------
-- Disables physGun for entities that are on the 'entities_not_compatible_with_physgun' list
-- called by physgun entity pickup hook
-- NOTE: this is a hack, there is a property gmod_allowphysgun that can be set to false for entity in hammer editor, but it doesn't work
-------------------------------------
function EntityManager:AttemptToDisablePhysgun(ply,entity)
    local entity_class=entity:GetClass()
    if UTIL:IsItemInArray(self.entities_not_compatible_with_physgun,entity_class) then
        print("disabling physgun for this entity:"..entity_class)
        return false
    end
end



function EntityManager:OnEntityInteraction(activator,called)
    if IsValid(called) and IsFirstTimePredicted() then --IsFirstTimePredicted() prevents hook from being fired multiple times
        --print("is npc:"..tostring(called:IsNPC()))
        local called_name=called:GetName()
        print("[INTERACTION] ".. activator:GetName() .. " interacted with "..called_name)
        -- check if there is interaction between those 2 entities specified, and if yes, handle it
        if PLAYER_INTERACTIONS_MANAGER:IsInteractionDefined(called_name) and SHARED_INSTANCE.CAN_INTERACT_WITH_NPC then
            PLAYER_INTERACTIONS_MANAGER:LoadInteraction("interaction--player-"..called_name)
        end
    end
end





-------------------------------------
-- Disables physGun for specific entities
-- OBSOLETE :: left for reference
-------------------------------------
function EntityManager:DisablePhysGunForCertainItems()
    print("disabling physgun for number of entities")
    local all_entities=ents.GetAll()
    for k,v in pairs(all_entities) do
        for k1,v1 in pairs(self.entities_not_compatible_with_physgun) do
            local entity_class=v:GetClass()
            local entity_name=v:GetName()
            if entity_class==v1 then
                v:SetSolid(SOLID_NONE)
                print("--disabled physgun for entity with class: "..entity_class)
            elseif entity_name==v1 then
                v:SetSolid(SOLID_NONE)
                print("--disabled physgun for entity with id: "..entity_name)
            end

        end
    end
end

