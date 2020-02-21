AddCSLuaFile("entities/netcry_security_guy_2/cl_init.lua")
AddCSLuaFile("entities/netcry_security_guy_2/shared.lua")
include("entities/netcry_security_guy_2/shared.lua")


function ENT:Initialize()
    print( self, "Initialize" )
    print("___security_guy_2 entity INITILIZED!__")
    --self:SetTrigger(true)
    self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	self:SetModel( "models/combine_soldier.mdl" )
end

