NpcController={}
NpcController.__index = NpcController
    

function NpcController:new ()
    -- default constructor
    local npcController_instance={}
    setmetatable(npcController_instance,NpcController)
    return npcController_instance
  end

function NpcController:SetNpcRelationshipTowardsPlayer(ply,entity_name,relationship)
    --find entity
    print("looking for npc entity named "..entity_name)
    entity=nil
    entity_table=ents.FindByName(entity_name) --why ents.find... and not ents:find... = ends.find because 'findbyname' is static and instance of self (ents) is not passed. if : is used like x:bar(1,2) then x is passed to 'bar' as self and it equals to x.bar(x,1,2)
    if entity_table ~= nil then
        print("entity table is not null")
        print("iterating for debugging purposes:")
        for k,v in pairs(entity_table) do
            print(k.."/"..tostring(v))
        end
        print("obtained entity:")
        entity=entity_table[1] --first element in the table is at 1 not 0; in this case I know there is only 1 entity with specified name,so even though table is returned I care only about 1st item
        print(entity)
    end
    if entity ~= nil then
        entity:AddEntityRelationship(ply, relationship, 99)
    else
        print("did not find specified npc entity.")
    end
end


