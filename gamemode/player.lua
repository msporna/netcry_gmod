Player={}
Player.__index = Player
    

function Player:new ()
    -- default constructor
    local player_instance={}
    setmetatable(player_instance,Player)
    self.isInited=false
    return player_instance
  end


function Player:InitPlayer(ply)
    ply:SetArmor(5)
    -- if want some specific player mode (affects look of hands mostly, models are from 01-09)
    -- ply:SetModel("models/player/Group03m/Male_01.mdl")
	ply:SetupHands()
    UTIL:SendMessageToClient("load_local_game",{})
    self.instance=ply
    self.isInited=true
    print("PLAYER INITED")
end


