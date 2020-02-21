Util = {}
Util.__index = Util
    

function Util:new ()
    -- default constructor
    local util_instance={}
    setmetatable(util_instance,Util)
    return util_instance
  end


function Util:IsItemInArray(array,item_name)
    for k,v in pairs(array) do
        if item_name==v then
            print("--found item: "..item_name .." in array: " .. dump(array))
            return true
        end
    end
    print("item not found in array: "..item_name)
    return false
end





function Util:PlayServerSoundAtPlayerPos(ply,sound)
    if ply==nil then
        -- if ply instance is null, find it
        ply=player.GetByID( 1 )
    end
    sound.Play( sound, ply:GetPos())
end


-------------------------------------
-- send message to client to make it do something
-- @message_type- message type that client will understand (defined in cl_init.lua)
-- @param_table - table with params to send. it can contain anything- strings,entities etc.
-------------------------------------
function Util:SendMessageToClient(message_type,param_table)

    
    ply=player.GetByID( 1 ) -- need to know to which client send the message (in my case there is only 1)
    net.Start("server_message")
    net.WriteString(message_type)
    net.WriteEntity(ply)
    if param_table~=nil then
        net.WriteTable(param_table)
        --print("wrote param tables of the request to client")
    else
        -- write empty table
        net.WriteTable({})
    end
    net.Send(ply)
end