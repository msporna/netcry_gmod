------------------------------------
-- include all client side scripts
------------------------------------

include("cl_manager.lua")
include("shared.lua")
include("cl_ui_manager.lua")
include("cl_state_manager.lua" )
include("cl_util.lua")


-----------------------------------------
	-- LOCAL ****************************
-----------------------------------------
local screen_color_shader_modifications_table = {
	[ "$pp_colour_addr" ] = 0.04,
	[ "$pp_colour_addg" ] = 0.05,
	[ "$pp_colour_addb" ] = 0.07,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 3,
	[ "$pp_colour_mulr" ] = 0.3,
	[ "$pp_colour_mulg" ] = 0.2,
	[ "$pp_colour_mulb" ] = 0.3
}





-------------------------------------
-- put init code that should run on client side here
-------------------------------------
function GM:Initialize()
	print("Hello from client init!")

 end

function handle_OnPassWelcomeScreen()
	MOD_MANAGER:OnPassWelcomeScreen()
end

-- modify screen colors (effect)
function GM:RenderScreenspaceEffects()
	DrawColorModify( screen_color_shader_modifications_table )
end

function setupReferences()
	-----------------------------------------
	-- GLOBAL ****************************
	-----------------------------------------
	MOD_MANAGER=CLManager:new()
	UI_MANAGER=ClUiManager:new()
	STATE_MANAGER=ClStateManager:new()
	CL_UTIL=ClUtil:new ()
	SHARED_INSTANCE=Shared:new ()
	-------------------------------------
	-- HOOKS ****************************
	-------------------------------------
	hook.Add( "OnIntroPopupClosed", "Happens when intro popup has been closed", handle_OnPassWelcomeScreen )
end


net.Receive("server_message",function(len)
	--print("**Received Networking**")
	--interesting info: when reading, must read in the same order as writing (sending from server)
	local type=net.ReadString()
	local player=net.ReadEntity()
	local params=net.ReadTable() --example: {sound_to_pay="sound1"} and to access 'sound1' to play it, do params.sound_to_play
	
	if type=="play_sound" then
		print("Requested sound to be played:"..params.sound_to_play..".Attempting to play...")
		CL_UTIL:PlayCustomClientSound(params.sound_to_play)
	elseif type=="show_dialogue" then
		print("showing dialogue")
		if params.sound ~= nil then
			CL_UTIL:PlayCustomClientSound(params.sound_to_play)
		end
		UI_MANAGER:ShowDialogue(params)
		MOD_MANAGER.IsDialogueInProgress=1
	elseif type=="load_local_game" then
		print("loading game")
		setupReferences()
		--STATE_MANAGER:LoadPlayerData(player:SteamID64())
		MOD_MANAGER:WelcomePlayer()
	elseif type=="OnMissionPopupTriggered" then 
		--increase
		SHARED_INSTANCE.CURRENT_MISSION_OBJECTIVE=SHARED_INSTANCE.CURRENT_MISSION_OBJECTIVE+1
		--show mission objective popup
		UI_MANAGER:ShowCurrentMissionObjective()
	elseif type=="show_hack_popup" then 
		--load config and pass below: --todo
		UI_MANAGER:ShowHackStage1({})
	elseif type=="show_available_actions" then 
		UI_MANAGER:ShowAvailableActionsHUD(params.availableActions)
	elseif type=="hide_available_actions" then 
	    UI_MANAGER:HideAvailableActionsHUD()
	end

	--print("++Finished processing message from server: "..type)
end)



	-------------------------------------
	-- MISC ****************************
	-------------------------------------
---------------------------------
-- extend dLabel to have ID value
---------------------------------
function DLabel:AddID(v)
    self.id=v
end

