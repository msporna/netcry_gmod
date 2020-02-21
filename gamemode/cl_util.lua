ClUtil={}
ClUtil.__index = ClUtil


function ClUtil:new ()
    -- default constructor
    local ClUtil_instance={}
    setmetatable(ClUtil_instance,ClUtil)
    -------------------------------------
    -- PRECACHE SOUNDS
    -------------------------------------
    self.custom_sounds={npc_welcome_1=Sound("npc/letsplay.wav"),
    select_sound_1=Sound("common/wpn_select.wav"),
    deny_sound_1=Sound("common/wpn_denyselect.wav")}

    print("____________CL UTIL CREATED")
    return ClUtil_instance
end


-------------------------------------
-- get sound from custom_sounds by specified name
-------------------------------------
function ClUtil:GetCustomSound(sound_name)
    for k,v in pairs(self.custom_sounds) do
        if k==sound_name then
            return v
        end
    end
    return nil
 end

function ClUtil:PlayClientSound(sound)
    print("playing sound "..sound)
    surface.PlaySound( sound )
end

function ClUtil:PlayCustomClientSound(sound)
    local soundToPlay=self:GetCustomSound(sound)
    print("playing sound "..soundToPlay)
    surface.PlaySound( soundToPlay )
end

function ClUtil:SendMessageToServer(message_type,param_table)
    net.Start("client_message")
    net.WriteString(message_type)
    if param_table~=nil then
        net.WriteTable(param_table)
    end
    net.SendToServer()

end



-- source:https://gist.github.com/jrus/3197011
function ClUtil:GenerateUUID()
    local random = math.random
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


