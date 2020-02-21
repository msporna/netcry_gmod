function sendMessageToGmod(message)
{
    //call lua code
    if(message=="GameWin")
    {
        console.log("RUNLUA:ClUiManager:ShowHackStage2()")
    }
    else if(message=="GameLost")
    {
        console.log("RUNLUA:ClUiManager:CloseHackPopup()")
    }
    
}

function handleMessageFromGmod(message)
{
    //when gmod calls some js function
}