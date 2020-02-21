
PlayerInteractionsManager={}
PlayerInteractionsManager.__index = PlayerInteractionsManager


function PlayerInteractionsManager:new ()
    -- default constructor
    print("____________PLAYER INTERACTIONS MANAGER CREATED")

    local playerInteractionsManager_instance={}
    setmetatable(playerInteractionsManager_instance,PlayerInteractionsManager)
    self.INTERACTION_DEFINITIONS={interaction_0="ply-netcry_security_guy_1"}
    self.interaction_in_progress=nil
    return playerInteractionsManager_instance
  end


-- entity1 is player "ply"
function PlayerInteractionsManager:IsInteractionDefined(entity2_name)
    local expected_interaction_name="ply-"..entity2_name
    for k,v in pairs(self.INTERACTION_DEFINITIONS) do
        if v==expected_interaction_name then
            print("found interaction:"..v)
            -- if this interaction is already in progress, return false, to avoid processing it again
            if self.interaction_in_progress~=nil && self.interaction_in_progress.ID==v then
                print("this interaction is in progress. Skipping further processing.")
                return false
            else
                return true
            end

        end
    end
    return false
end

function PlayerInteractionsManager:LoadInteraction(interaction)
    -- create instance of interaction based on interaction config

    --assign to interaction_in_progress
    self.interaction_in_progress=INTERACTION:Start(interaction)

    print("interaction "..interaction.." loaded")
end



