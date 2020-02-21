ClStateManager={}
ClStateManager.__index = ClStateManager


function ClStateManager:new ()
    -- default constructor
    local ClStateManager_instance={}
    setmetatable(ClStateManager_instance,ClStateManager)
    print("____________CL STATE MANAGER CREATED")
    return ClStateManager_instance
end


function ClStateManager:SavePlayerData(steamID64)
    print("SAVING PLAYER DATA for steam id:"..steamID64)
    local jsonTable = util.TableToJSON( SHARED_INSTANCE.PlayerData )
    PrintTable(SHARED_INSTANCE.PlayerData)
    print("**json:**")
    print(jsonTable)
    file.CreateDir("netcry")
    file.Write("netcry/netcry_"..steamID64..".txt",jsonTable)
    print("SAVED")
end


function ClStateManager:LoadPlayerData(steamID64)
    print("LOADING PLAYER DATA")
    local fileContent=file.Read( "netcry/netcry_"..steamID64..".txt", "DATA" )
    if fileContent~=nil then
        SHARED_INSTANCE.PlayerData=util.JSONToTable( fileContent )
    end
    print("PLAYER DATA LOADED:")
    PrintTable(SHARED_INSTANCE.PlayerData)
end


