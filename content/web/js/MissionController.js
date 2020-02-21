function ShowMessageContent(message) {
    var messager = document.getElementById('messageContainer');

    new TypeIt(messager, {
            speed: 30,
            cursor: true,
            cursorSpeed: 100,
            afterComplete: function (instance) {
                console.log("typing is complete.")
                console.log("RUNLUA:print( \"This is called in Lua context\" )") //--> this calls lua code
                console.log("RUNLUA:ClUiManager:CloseCurrentMissionObjective()")
                console.log("lua code should have been executed.")
            }
        }).type("Incoming Message...")
        .pause(3000)
        .delete()
        .pause(500)
        .type(message)
}