include('external/data_dumper.lua')



GM.Name = "LIFO"
GM.Author = "Michal Sporna"
GM.Email = "N/A"
GM.Website = "N/A"

Shared={}
Shared.__index = Shared


function Shared:new ()
	print("_______Creating SHARED object")
    -- default constructor
    local Shared_instance={}
	setmetatable(Shared_instance,Shared)
	self.PlayerData={intro_passed=false,special_ability_1=-1}
	self.Interactions={}
	self.CONFIG_REPO_URL="http://localhost:1234"
	self.INTERACTIONS_MANIFEST_URL="/data/interactions_manifest.json"
	self.DIALOGUE_IN_PROGRESS=0 --not used?
	self.CURRENT_SCENE=0 --level is divided into scenes
	self.NPC_SCENE_MAP={scene_0={"netcry_security_guy_1","netcry_security_guy_2"}} --todo: get it from json
	self.CURRENT_MISSION_OBJECTIVE=0
	self.NPC_AVAILABLE_ACTIONS={} --load from file
	self.CAN_INTERACT_WITH_NPC=false
	self.NPC_INTERACTION_RANGE=nil --name of entity representing npc that player can interact with
	self.HACK_STARTED=false

	--load npc available actions
	self:LoadNpcAvailableActions()
    print("____________Shared object CREATED")
    return Shared_instance
  end



function Shared:GetNpcNamesForCurrentScene()
	if self.CURRENT_SCENE==0 then
		return self.NPC_SCENE_MAP.scene_0
	end
end


function GM:Initialize()
	print("Hello from SHARED")
	self.BaseClass.Initialize(self)

end

function Shared:LoadNpcAvailableActions()
	print("Loading npc available actions config...")
    --load config
    local fileContent=file.Read( "netcry/npcActionDefinition.json", "DATA" )
    if fileContent~=nil then
        self.NPC_AVAILABLE_ACTIONS=util.JSONToTable( fileContent )
    end
    print("**have npc available action definition:")
    -- PrintTable(self.NPC_AVAILABLE_ACTIONS)
end

function Shared:GetAvailableActionsForNpc(npc)
	--print("[Shared] looking for available actions for npc: "..npc)
	for k,v in pairs(self.NPC_AVAILABLE_ACTIONS) do 
		--PrintTable(v)
		for i,action_def in pairs(v) do 
			--PrintTable(action_def)
			if (action_def.npc==npc) then 
				return action_def.available_actions
			end 
		end
	end
	return nil
end

function dump(data)
    return DataDumper(data)
end


function GetSteamIDBase64()
	ply=player.GetAll()[1]
	return ply:SteamID64()
end



--enable some useful commandline commands
concommand.Add("Armor100",function(ply)
	ply:SetArmor(100)
	print("GOD:: gave armor 100")
end)

concommand.Add("give_glock",function(ply)
	ply:Give("weapon_pistol")
	print("GOD::gave glock")
end)

concommand.Add("give_crowbar",function(ply)
	ply:Give("weapon_crowbar")
	print("GOD::gave crowbar")
end)

concommand.Add("give_gravity",function(ply)
	ply:Give("weapon_physcannon")
	print("GOD::gave gravity gun")
end)

concommand.Add("give_physgun",function(ply)
	ply:Give("weapon_physgun")
	print("GOD::gave physgun")
end)

concommand.Add("give_frag",function(ply)
	ply:Give("weapon_frag")
	print("GOD::gave frag")
end)

concommand.Add("antiphysgun",function(ply)
	local trace = ply:GetEyeTrace()
	trace.Entity:SetSolid(SOLID_NONE)
	print("GOD::things you look at will be resistant to the physgun. Fires once.")
end)