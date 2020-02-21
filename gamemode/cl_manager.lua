
CLManager={}
CLManager.__index = CLManager


function CLManager:new ()
    -- default constructor
    local CLManager_instance={}
    setmetatable(CLManager_instance,CLManager)
    self.IsDialogueInProgress=0
    print("____________CL MANAGER CREATED")
    return CLManager_instance
  end



-------------------------------------
-- FUNCTIONS ****************************
-------------------------------------

--called after loading data
function CLManager:WelcomePlayer()
    --loadgame
    if not SHARED_INSTANCE.PlayerData.intro_passed then
        UI_MANAGER:ShowWelcomeScreen() --cl_ui_manager
    else
        self:DoInitilize() --cl_manager
        UI_MANAGER:ShowInfectedHudElement() --don't forget to show infected hud element (separated from showHud because on first run it's shown a bit later than the basic hud)
    end
end

--called on hook:OnIntroPopupClosed
--supposed to be called only once, after welcome screen is closed and never shown again unless you remove your save file
function CLManager:OnPassWelcomeScreen()
    notification.AddProgress( "introProgressBar", "Downloading software..." )
    timer.Simple( 4, function()
        notification.Kill( "introProgressBar" )
        --show notification
        notification.AddLegacy( "Virus Downloaded", NOTIFY_HINT, 3 )
        CL_UTIL:PlayClientSound("buttons/button15.wav")
        UI_MANAGER:ShowInfectedHudElement()
    end )
    --put things you want to be shown on first game run,past the welcome screen here:
    self:DoInitilize()
end



function CLManager:DoInitilize()
    print("initilizing")
    UI_MANAGER:ShowHUD()
   

    self:AttempToSavePlayerData()

end

function CLManager:AttempToSavePlayerData()
    STATE_MANAGER:SavePlayerData( GetSteamIDBase64() )
end









