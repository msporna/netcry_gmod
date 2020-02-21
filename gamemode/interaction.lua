

INTERACTION={}
INTERACTION.__index = INTERACTION


-------------------------------------
-- new instance of interaction module
-- create each time a new interaction between capable entities happens like player with some npc

-- usage from other script
-- local interaction = INTERACTION.Start()

-------------------------------------
function INTERACTION:Start(id)
    print("starting new interaction "..id)
    local interaction_instance={}
    setmetatable(interaction_instance,INTERACTION)
    self.ID=id
    --load config
    local fileContent=file.Read( "netcry/"..id..".json", "DATA" )
    if fileContent~=nil then
        self.InteractionConfig=util.JSONToTable( fileContent )
    end
    print("**have interaction config:")
    PrintTable(self.InteractionConfig)

    --show dialog popup, if interaction is indeed dialogue
    if (self.InteractionConfig.action=="dialogue") then
        Util:SendMessageToClient("show_dialogue",{interaction_config=self.InteractionConfig})
    end

    print("NEW INTERACTION OBJECT CREATED")
    return interaction_instance
end