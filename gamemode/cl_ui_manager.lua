ClUiManager={}
ClUiManager.__index = ClUiManager


function ClUiManager:new ()
    -- default constructor
    local ClUiManager_instance={}
    setmetatable(ClUiManager_instance,ClUiManager)
    print("____________UI MANAGER CREATED")
    self.dialogueLocked=false --set to true if user cannot choose any options anymore
    self.missionObjectivePanelInstance=nil
    self.hackPopupPanelInstance=nil
    self.availableActionsPanel=nil
    return ClUiManager_instance
end


-------------------------------------
-- FONT DECLARATIONS
-------------------------------------
surface.CreateFont("HudFontSmall", {
	font = "Default",
	size = 16,
	weight = 1000,
	antialias = true,
    shadow = false
} )
surface.CreateFont("HudFontRegular", {
	font = "Default",
	size = 45,
	weight = 100,
	antialias = true,
    shadow = false,
    additive = true
} )
surface.CreateFont("DialogueFont1", {
	font = "Default",
	size = 18,
	weight = 500,
	antialias = true,
    shadow = false
} )
surface.CreateFont("WelcomePopupLabelFont", {
	font = "Default",
	size = 20,
	weight = 500,
	antialias = true,
	shadow = false
} )
surface.CreateFont("WelcomePopupCheckboxFont", {
	font = "Default",
	size = 18,
	weight = 300,
	antialias = true,
    shadow = false,
    additive = true
} )

-------------------------------------
-- FUNCTIONS
-------------------------------------

--show HUD
function ClUiManager:ShowHUD()

    --stealth meter panel
    local stealthMeterPanel = vgui.Create( "DPanel" )
    stealthMeterPanel:SetPos( 610, ScrH()-75 ) -- Set the position of the panel
    stealthMeterPanel:SetSize( 150, 56 ) -- Set the size of the panel
    stealthMeterPanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
    end

    local stealthMeterLabel=vgui.Create("DLabel",stealthMeterPanel)
    stealthMeterLabel:SetFont("HudFontSmall")
    stealthMeterLabel:SetText("STEALTH")
    stealthMeterLabel:SetPos(10,26)
    stealthMeterLabel:SetColor(Color(255,244,62))

    local stealthMeterValueLabel=vgui.Create("DLabel",stealthMeterPanel)
    stealthMeterValueLabel:SetFont("HudFontRegular")
    stealthMeterValueLabel:SetText("100")
    stealthMeterValueLabel:SetPos(80,9)
    stealthMeterValueLabel:SetColor(Color(255,244,62))
    stealthMeterValueLabel:SizeToContents()

end


function ClUiManager:ShowInfectedHudElement()
    --infected computers panel
    local hudProgressPanel = vgui.Create( "DPanel" )
    hudProgressPanel:SetPos( 430, ScrH()-75 ) -- Set the position of the panel
    hudProgressPanel:SetSize( 150, 56 ) -- Set the size of the panel
    hudProgressPanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
    end

    local hudProgressLabel=vgui.Create("DLabel",hudProgressPanel)
    hudProgressLabel:SetFont("HudFontSmall")
    hudProgressLabel:SetText("INFECTED")
    hudProgressLabel:SetPos(10,26)
    hudProgressLabel:SetColor(Color(255,244,62))

    local hudProgressValueLabel=vgui.Create("DLabel",hudProgressPanel)
    hudProgressValueLabel:SetFont("HudFontRegular")
    hudProgressValueLabel:SetText("0/3")
    hudProgressValueLabel:SetPos(80,9)
    hudProgressValueLabel:SetColor(Color(255,244,62))
    hudProgressValueLabel:SizeToContents()


end


--test,remove when not needed anymore
function ClUiManager:X()
    local DermaPanel = vgui.Create( "DFrame" )
    DermaPanel:SetPos( 100, 100 )
    DermaPanel:SetSize( 300, 200 )
    DermaPanel:SetTitle( "My new Derma frame" )
    DermaPanel:SetDraggable( false )
    DermaPanel:SetScreenLock(true)
    DermaPanel:SetBackgroundBlur( true )
    DermaPanel:MakePopup()
    DermaPanel.OnClose=function()
        gui.EnableScreenClicker(false)
    end
    gui.EnableScreenClicker(true)
end


-- this is a screen shown on first mod run
-- select special ability etc.
function ClUiManager:ShowWelcomeScreen()

    local backgroundPanel = vgui.Create( "DPanel" )
    backgroundPanel:SetPos(ScrW()/2-410,ScrH()/2-310)
    backgroundPanel:SetSize( 820, 620 )
    backgroundPanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(255,0,180,100))
    end


    local welcomePanel = vgui.Create( "DFrame" ,backgroundPanel)
    welcomePanel:SetPos(ScrW()/2-400,ScrH()/2-300)
    welcomePanel:SetSize( 800, 600 )
    welcomePanel:SetTitle( "WELCOME!" )
    welcomePanel:SetDraggable( false )
    welcomePanel:SetScreenLock(true)
    welcomePanel:SetBackgroundBlur(true)
    welcomePanel:MakePopup()
    welcomePanel.OnClose=function()
        gui.EnableScreenClicker(false)
        backgroundPanel:Remove()
    end
    welcomePanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
    end
    gui.EnableScreenClicker(true)
    welcomePanel:ShowCloseButton( false )

    --labels
    introTextLabel=vgui.Create("DLabel",welcomePanel)
    --introTextLabel:SetFont("HudFontSmall")
    introTextLabel:SetFont("WelcomePopupLabelFont")
    introTextLabel:SetText("As everyone on this planet, you are also entitled to 1 special ability. The difference is, you can choose \nwhat it will be. Choose wisely - it affects gameplay, certain abilities open certain ways of doing things. \nYou will be able to select another special abilities later, as game progresses and end up with 3.")
    introTextLabel:SetPos(10,30)
    introTextLabel:SizeToContents()
    introTextLabel:SetColor(Color(102,255,125))


    --checkboxes init
    ability1Checkbox = vgui.Create( "DCheckBoxLabel",welcomePanel )
    ability2Checkbox = vgui.Create( "DCheckBoxLabel",welcomePanel)
    ability3Checkbox = vgui.Create( "DCheckBoxLabel",welcomePanel )
    ability4Checkbox = vgui.Create( "DCheckBoxLabel", welcomePanel)
    --button init
    closeButton = vgui.Create( "DButton", welcomePanel )



    --DermaCheckbox:SetParent( DermaPanel )
    ability1Checkbox:SetPos( 10, 120 )
    ability1Checkbox:SetText( "Smooth Talker [+extra options in dialogues]" )
    ability1Checkbox:SetValue( 0 )
    ability1Checkbox:SetFont("WelcomePopupCheckboxFont")
    ability1Checkbox:SetTextColor(Color(102,255,125))
    ability1Checkbox.OnChange=function(parent,val)
        if val then
            print("ability 1 checked")
            --uncheck others
            ability2Checkbox:SetChecked(false)
            ability3Checkbox:SetChecked(false)
            ability4Checkbox:SetChecked(false)

            --set selected color:
            ability1Checkbox:SetTextColor(Color(255,0,180))
            closeButton:SetColor( Color(255,0,180))
            --back to regular color:
            ability2Checkbox:SetTextColor(Color(102,255,125))
            ability3Checkbox:SetTextColor(Color(102,255,125))
            ability4Checkbox:SetTextColor(Color(102,255,125))

        else
            print("ability 1 unchecked")
            ability1Checkbox:SetTextColor(Color(102,255,125))
            closeButton:SetColor( Color(0,0,0))
        end
    end




    --DermaCheckbox:SetParent( DermaPanel )
    ability2Checkbox:SetPos( 10, 150 )
    ability2Checkbox:SetText( "Monkey Monk [+extra jumping ability]" )
    ability2Checkbox:SetValue( 0 )
    ability2Checkbox:SetFont("WelcomePopupCheckboxFont")
    ability2Checkbox:SetTextColor(Color(102,255,125))
    ability2Checkbox.OnChange=function(parent,val)
        if val then
            print("ability 2 checked")
              --uncheck others
              ability1Checkbox:SetChecked(false)
              ability3Checkbox:SetChecked(false)
              ability4Checkbox:SetChecked(false)

               --set selected color:
            ability2Checkbox:SetTextColor(Color(255,0,180))
            closeButton:SetColor( Color(255,0,180))
            --back to regular color:
            ability1Checkbox:SetTextColor(Color(102,255,125))
            ability3Checkbox:SetTextColor(Color(102,255,125))
            ability4Checkbox:SetTextColor(Color(102,255,125))

        else
            print("ability 2 unchecked")
            ability2Checkbox:SetTextColor(Color(102,255,125))
            closeButton:SetColor( Color(0,0,0))
        end
    end


    --DermaCheckbox:SetParent( DermaPanel )
    ability3Checkbox:SetPos( 10, 180 )
    ability3Checkbox:SetText( "2nd Amendment Practicioner [+can pickup and use guns]" )
    ability3Checkbox:SetValue(0 )
    ability3Checkbox:SetFont("WelcomePopupCheckboxFont")
    ability3Checkbox:SetTextColor(Color(102,255,125))
    ability3Checkbox.OnChange=function(parent,val)
        if val then
            print("ability 3 checked")
              --uncheck others
              ability1Checkbox:SetChecked(false)
              ability2Checkbox:SetChecked(false)
              ability4Checkbox:SetChecked(false)

               --set selected color:
            ability3Checkbox:SetTextColor(Color(255,0,180))
            closeButton:SetColor( Color(255,0,180))
            --back to regular color:
            ability1Checkbox:SetTextColor(Color(102,255,125))
            ability2Checkbox:SetTextColor(Color(102,255,125))
            ability4Checkbox:SetTextColor(Color(102,255,125))

        else
            print("ability 3 unchecked")
            ability3Checkbox:SetTextColor(Color(102,255,125))
            closeButton:SetColor( Color(0,0,0))
        end
    end


    --DermaCheckbox:SetParent( DermaPanel )
    ability4Checkbox:SetPos( 10, 210 )
    ability4Checkbox:SetText( "Capable Hacker [+pickpocketing becomes easier and faster]" )
    ability4Checkbox:SetValue( 0 )
    ability4Checkbox:SetFont("WelcomePopupCheckboxFont")
    ability4Checkbox:SetTextColor(Color(102,255,125))
    ability4Checkbox.OnChange=function(parent,val)
        if val then
            print("ability 4 checked")
              --uncheck others
              ability1Checkbox:SetChecked(false)
              ability2Checkbox:SetChecked(false)
              ability3Checkbox:SetChecked(false)

               --set selected color:
            ability4Checkbox:SetTextColor(Color(255,0,180))
            closeButton:SetColor( Color(255,0,180))
            --back to regular color:
            ability1Checkbox:SetTextColor(Color(102,255,125))
            ability2Checkbox:SetTextColor(Color(102,255,125))
            ability3Checkbox:SetTextColor(Color(102,255,125))

        else
            print("ability 4 unchecked")
            ability4Checkbox:SetTextColor(Color(102,255,125))
            closeButton:SetColor( Color(0,0,0))
        end
    end

    --add close button

    closeButton:SetText( "Let's play" )
    closeButton:SetPos( 700, 500 )
    closeButton:SetSize( 60, 30 )
    closeButton:SetColor( Color(0,0,0))
    closeButton.DoClick = function()

        --which special ability was selected?
        specialAbilityChosen=false
        if ability1Checkbox:GetChecked()==true then
            SHARED_INSTANCE.PlayerData.special_ability_1="0" --talker
            specialAbilityChosen=true
        elseif ability2Checkbox:GetChecked()==true then
            SHARED_INSTANCE.PlayerData.special_ability_1="1" --gun
            specialAbilityChosen=true
        elseif ability3Checkbox:GetChecked()==true then
            SHARED_INSTANCE.PlayerData.special_ability_1="2" --jumper
            specialAbilityChosen=true
        elseif ability4Checkbox:GetChecked()==true then
            SHARED_INSTANCE.PlayerData.special_ability_1="3" --extra hacker
            specialAbilityChosen=true
        end

        if specialAbilityChosen==false then
              print("[ERROR] special ability not chosen!")
              --show error message
              errorLabel=vgui.Create("DLabel",welcomePanel)
              --introTextLabel:SetFont("HudFontSmall")
              errorLabel:SetFont("WelcomePopupLabelFont")
              errorLabel:SetText("Select 1 special ability!")
              errorLabel:SetPos(10,300)
              errorLabel:SizeToContents()
              errorLabel:SetColor(Color(255,0,0))

       

              return false--cancel closing
        end

        welcomePanel:Close()
        SHARED_INSTANCE.PlayerData.intro_passed=true

        hook.Run("OnIntroPopupClosed") --continue initing after welcome popup was closed
    end

end


-- this shows a screen with current objectives, progress etc.
function ClUiManager:ShowLogScreen()
    print("todo - log screen")
end



function ClUiManager:ShowCurrentMissionObjective()
    
    -- read html with current objective content
    local messagehtml=file.Read( "netcry/html/mission"..tostring(SHARED_INSTANCE.CURRENT_MISSION_OBJECTIVE).."Objective.html", "DATA" )
    if messagehtml~=nil then
        self.missionObjectivePanelInstance = vgui.Create( "DFrame" )
        self.missionObjectivePanelInstance:SetPos( 50, 50 )
        self.missionObjectivePanelInstance:SetSize( 400, 300 )
        self.missionObjectivePanelInstance:SetTitle( "Mission Objective" )
        self.missionObjectivePanelInstance:SetDraggable( false )
        self.missionObjectivePanelInstance:SetScreenLock(false)
        self.missionObjectivePanelInstance:ShowCloseButton( false )
        --HTML
        local html = vgui.Create( "DHTML", self.missionObjectivePanelInstance )
        html:Dock( FILL )
        html:SetHTML( messagehtml )
        -- alternative:
        --html:OpenURL('https://www.goodboydigital.com/runpixierun/')
        --gui.EnableScreenClicker(true)
        --Enable the webpage to call lua code
        html:SetAllowLua( true )
        --HTML
    end
end


function ClUiManager:ShowHackStage1(config)
    self.hackPopupPanelInstance = vgui.Create( "DFrame" )
    self.hackPopupPanelInstance:SetPos( 10, 50 )
    self.hackPopupPanelInstance:SetSize( 610,450)
    self.hackPopupPanelInstance:SetTitle( "NeuronSystems_" )
    self.hackPopupPanelInstance:SetDraggable( false )
    self.hackPopupPanelInstance:SetScreenLock(false)
    self.hackPopupPanelInstance:ShowCloseButton( true )
    self.hackPopupPanelInstance.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
    end
    self.hackPopupPanelInstance.OnClose=function()
        UI_MANAGER.CloseHackPopup()
        gui.EnableScreenClicker(false)
    end
    --self.hackPopupPanelInstance:MakePopup()

        -- alternative:
    local html = vgui.Create( "DHTML", self.hackPopupPanelInstance )
    html:Dock( FILL )
    html:OpenURL('http://localhost:1234/')
    gui.EnableScreenClicker(true)
        --Enable the webpage to call lua code
    html:SetAllowLua( true )
        --HTML
    print("shown hack popup")

end

function ClUiManager:ShowHackStage2(config)
    self.hackPopupPanelInstance = vgui.Create( "DFrame" )
    self.hackPopupPanelInstance:SetPos( 10, 50 )
    self.hackPopupPanelInstance:SetSize( 610,450)
    self.hackPopupPanelInstance:SetTitle( "NeuronSystems_" )
    self.hackPopupPanelInstance:SetDraggable( false )
    self.hackPopupPanelInstance:SetScreenLock(false)
    self.hackPopupPanelInstance:ShowCloseButton( true )
    self.hackPopupPanelInstance.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
    end
    self.hackPopupPanelInstance.OnClose=function()
        UI_MANAGER.CloseHackPopup()
        gui.EnableScreenClicker(false)
    end
    --self.hackPopupPanelInstance:MakePopup()
    local html = vgui.Create( "DHTML", self.missionObjectivePanelInstance )
    html:Dock( FILL )
    html:SetHTML( "<p>TEST</p>")

end

function ClUiManager:CloseHackPopup()
    print("closing hack popup")
    UI_MANAGER.hackPopupPanelInstance:Remove()
    UI_MANAGER.hackPopupPanelInstance=nil
    SHARED_INSTANCE.HACK_STARTED=false
end


function ClUiManager:CloseCurrentMissionObjective()
    -- use UI_MANAGER instead of 'self' because it can be called from various context such as dhtml panel and self can be various things depending from context
    UI_MANAGER.missionObjectivePanelInstance:Remove()
    UI_MANAGER.missionObjectivePanelInstance=nil
end

-------------------------------------
-- Show dialogue popup for making a
-- conversation with npcs absed on
-- config
-------------------------------------
function ClUiManager:ShowDialogue(config_table)
    
    -- if some dialogue is in progress then return,don't load again
    if MOD_MANAGER.IsDialogueInProgress==1 then
        print("dialogue already in progress ,exiting")
        return
    else
        print("dialogue is not in progress,initilizing")
    end
    print("_____________________showing dialogue popup_"..CL_UTIL:GenerateUUID())
    local panel1 = vgui.Create( "DPanel" )
    panel1:SetPos( 0,ScrH()-200 )
    panel1:SetSize( ScrW(),200)
    gui.EnableScreenClicker(true)
    panel1.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(64,64,64))
    end
    panel1:MakePopup()

    --show npc name
    local npcNamePanel = vgui.Create( "DPanel" )
    npcNamePanel:SetPos( ScrW()-200, 100 )
    npcNamePanel:SetSize( 190, 20 )
    npcNamePanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
    end

    local npcNameLabel=vgui.Create("DLabel",npcNamePanel )
    npcNameLabel:SetFont("HudFontSmall")
    npcNameLabel:SetText(config_table.interaction_config.entity_2)
    npcNameLabel:AlignLeft()
    npcNameLabel:SetColor(Color(255,244,62))
    npcNameLabel:SizeToContents()
    npcNamePanel:SizeToChildren(true,true)


    --npc line space
    local npcLinePanel = vgui.Create( "DPanel" )
    npcLinePanel:SetPos( 0, ScrH()-225 ) -- Set the position of the panel
    npcLinePanel:SetSize( ScrW(),25 ) -- Set the size of the panel
    npcLinePanel.Paint=function(self,w,h)
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
    end
    local npcLineLabel=vgui.Create("DLabel",npcLinePanel)
    npcLineLabel:SetFont("DialogueFont1")
    npcLineLabel:SetPos(2,0)
    npcLineLabel:SetSize(ScrW(),25)
    npcLineLabel:SetColor(Color(255,244,62))
    npcLineLabel.AddID(npcLineLabel,"npcLineLabel_"..CL_UTIL:GenerateUUID())
    print("created npc label with id "..npcLineLabel.id)


    local npcParams={npcPanel=npcLinePanel,npcLabel=npcLineLabel,npcNamePanelInstance=npcNamePanel}


    -- add dialogue options
    local currentDialogue=0 --0 means first dialogue,initial
    self:LoadDialogueOptions(panel1,config_table,currentDialogue,npcParams)
end --show dialogue function end


-------------------------------------
-- RELATED TO: showDialogue
-- updates dialogue options by clearing existing one
-- getting dialogue config by specified id and
-- inserting it to parent panel
-------------------------------------
function ClUiManager:LoadDialogueOptions(panel1,config_table,dialogueID,npcElements)
    print("loading dialogue options for dialogue:"..tostring(dialogueID))
    print("got params:")
    print("npc line label:"..npcElements.npcLabel.id)

    --first,clear all existing children
    panel1:Clear()

    --add dialogue options
    for dialogueKey,dialogueValue in pairs(config_table.interaction_config.dialogues) do
        if (dialogueValue.id==dialogueID) then
            print("found requested dialogue in config. Loading..."..dialogueID)
            --show npc welcome line
            self:LoadDialogueNpcLine(npcElements,dialogueValue.npc_start_line,nil,dialogueValue.dialogue_lines)
            optionsCount=table.Count(dialogueValue.dialogue_options) --how many options are defined?
            yValue=25 --starting y value
            for i=0,optionsCount do
                for dOptionKey,dOptionValue in pairs(dialogueValue.dialogue_options) do
                    if (i==dOptionValue.order) then

                        local optionPanel = vgui.Create("DPanel",panel1 )
                        optionPanel:SetPos( 0, yValue ) -- Set the position of the panel
                        optionPanel:SetSize( ScrW(),20 ) -- Set the size of the panel
                        optionPanel.Paint=function(self,w,h)
                            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
                        end

                        local optionLabel=vgui.Create("DLabel",optionPanel)
                        optionLabel:SetFont("DialogueFont1")
                        optionLabel:SetText(dOptionValue.option)
                        optionLabel:SizeToContents()
                        optionLabel:SetPos(5,0)
                        optionLabel:SetColor(Color(35,206,55))
                        optionLabel:SetMouseInputEnabled( true ) -- We must accept mouse input
                        optionLabel:SetSize(ScrW()-5,20)
                        optionLabel.AddID(optionLabel,"dialogueOptionLabel_"..CL_UTIL:GenerateUUID())


                        function optionLabel:DoClick() -- Defines what should happen when the label is clicked
                            if UI_MANAGER.dialogueLocked then
                                print("option clicked,but dialogue is locked!")
                                return
                            end
                            print( "option clicked: "..dOptionValue.option.." for label id: "..optionLabel.id )
                            CL_UTIL:PlayCustomClientSound("select_sound_1")

                            --does it have action related?
                            if (dOptionValue.action~="nil") then
                                print("Triggering action:"..dOptionValue.action)
                                if (dOptionValue.action=="exit") then
                                    UI_MANAGER:CloseDialoguePopup(panel1,npcElements.npcPanel,npcElements.npcNamePanelInstance)

                                elseif (dOptionValue.action=="go_to_dialogue") then
                                    --I cannot use 'self:' in below case because this is DoClick event for label and 'self' in this case is 'label' not 'uiManager'
                                    UI_MANAGER:LoadDialogueOptions(panel1,config_table,dOptionValue.action_param,npcElements)
                                elseif (dOptionValue.action=="agressive_mode_on") then
                                    -- set all npcs in current scene to be aggressive
                                    UI_MANAGER.dialogueLocked=true
                                    UI_MANAGER:LoadDialogueNpcLine(npcElements,nil,dOptionValue.response_id,dialogueValue.dialogue_lines)
                                    -- wait x seconds with repsonse displayed, then make the npc aggresive towards player
                                    timer.Simple( 3, function()
                                        if dOptionValue.action_param=="all" then
                                            -- all npcs in current scene are aggressive towards player
                                            CL_UTIL:SendMessageToServer("set_all_npc_in_scene_relationship",{relationship="hate",npc_name=config_table.interaction_config.entity_2})
                                        elseif dOptionValue.action_param=="one" then
                                            -- only 1 specific npc in current scene is aggressive towards player
                                            CL_UTIL:SendMessageToServer("set_npc_relationship",{relationship="hate",npc_name=config_table.interaction_config.entity_2})
                                        end
                                            --close dialogue
                                        UI_MANAGER:CloseDialoguePopup(panel1,npcElements.npcPanel,npcElements.npcNamePanelInstance)
                                    end )

                                end

                            else
                                print("showing response")
                                UI_MANAGER:LoadDialogueNpcLine(npcElements,nil,dOptionValue.response_id,dialogueValue.dialogue_lines)
                            end
                        end
                        yValue=yValue+30
                    end --if this item should be added now or later depending on order defined
                end --foreach dialogue option
            end --for 0-len(options) loop

            --now need to assign highlight events to all dialogue options (after were added to parent panel)
            --somehow it doesn't work if I did that at the time of creating label above, at the time of adding...
            local options=panel1:GetChildren() --get all children of dialogue options panel
            for dialogueOptionPanelKey,dialogueOptionPanelValue in pairs(options) do
                for dialogueOptionLabelKey,dialogueOptionLabelValue in pairs(dialogueOptionPanelValue:GetChildren()) do
                    --highlight event
                    dialogueOptionLabelValue.OnCursorEntered=function()
                        dialogueOptionPanelValue.Paint=function(self,w,h)
                            draw.RoundedBox(0,0,0,w,h,Color(35,206,55,30))
                        end
                        dialogueOptionLabelValue:SetCursor("hand")
                    end
                    dialogueOptionLabelValue.OnCursorExited=function()
                        dialogueOptionPanelValue.Paint=function(self,w,h)
                            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
                        end
                        dialogueOptionLabelValue:SetCursor("arrow")
                    end

                end
            end
            break --found,so break the
        end --check if this dialogue should be processed now
    end --foreach dialogue loop

end

function ClUiManager:CloseDialoguePopup(panel1,npcPanel,npcNamePanel)
    panel1:Remove()
    npcPanel:Remove()
    npcNamePanel:Remove()
    gui.EnableScreenClicker(false) --restore ability to move mouse around
    MOD_MANAGER.IsDialogueInProgress=0 --(in shared.lua)
    self.dialogueLocked=false
end

-------------------------------------
-- RELATED TO: showDialogue
-- updates text line 'spoken' by npc
-------------------------------------
function ClUiManager:LoadDialogueNpcLine(npcComponents,line_text,line_id,lines_config)
    print("loading npc line. Current:"..npcComponents.npcLabel:GetText().." for label "..npcComponents.npcLabel.id)
    npcComponents.npcLabel:SetText("")--clear existing text




    --if line text is not nil , just show it - most likely a start line
    if line_text~=nil then
        print("--line text is "..line_text)
        npcComponents.npcLabel:SetText(line_text) --init to empty line
        print(npcComponents.npcLabel.id)
    else
        -- get line by line_id
        print("---line id is "..line_id.." and config "..dump(lines_config))
        for configLineKey,configLineValue in pairs(lines_config) do
            if configLineValue.id==line_id then
                npcComponents.npcLabel:SetText(configLineValue.line)
                print("set text:"..configLineValue.line)
                print(npcComponents.npcLabel.id)
                break
            end
        end
    end

    print("label text is "..npcComponents.npcLabel:GetText())

end

function ClUiManager:ShowAvailableActionsHUD(actions)
    if(availableActionsPanel~=nil) then
        return 
    end 
     --available actions panel
     availableActionsPanel = vgui.Create( "DPanel" )
     availableActionsPanel:SetPos( 800, ScrH()-75 ) -- Set the position of the panel
     availableActionsPanel:SetSize( 140, 56 ) -- Set the size of the panel
     availableActionsPanel.Paint=function(self,w,h)
         draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
     end
     
     local x=10
     for i in pairs(actions) do 
        local availableActionsLabel=vgui.Create("DLabel",availableActionsPanel)
        availableActionsLabel:SetFont("HudFontSmall")
        availableActionsLabel:SetText(actions[i])
        availableActionsLabel:SetPos(x,15)
        availableActionsLabel:SetColor(Color(255,244,62))
        x=x+70
     end 
     
end 

function ClUiManager:HideAvailableActionsHUD()
    if(availableActionsPanel==nil) then 
        return 
    end 

    availableActionsPanel:Remove()
    availableActionsPanel=nil
end