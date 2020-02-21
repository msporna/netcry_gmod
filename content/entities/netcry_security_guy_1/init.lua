AddCSLuaFile("entities/netcry_security_guy_1/cl_init.lua")
AddCSLuaFile("entities/netcry_security_guy_1/shared.lua")
include("entities/netcry_security_guy_1/shared.lua")


function ENT:Initialize()
    print("___security_guy_1 entity INITILIZED!__")
    --self:SetTrigger(true)
    self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
    self:SetModel( "models/combine_soldier.mdl" )
    
end


-- S
function ENT:BehaveStart()
	-- You really shouldn't override this method.
	
	print( self, "BehaveStart" )
	
	-- Below is the default code used in BehaveStart.
	
	self.BehaveThread = coroutine.create( function() self:RunBehaviour() end )
end




-- S
function ENT:RunBehaviour()
	print( self, "RunBehaviour" )
	
	coroutine.wait( 2 )
	
	self:StartActivity( ACT_IDLE )
end

