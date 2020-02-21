## RULES

1. there are server side and client side scripts
2. GMOD API has many items and some are only for client, some only for server and some for both
3. server script cannot call client api items
4. server script cannot call client functions and vice versa - client script can be referenced and used by other client scripts, server ones by other server script
5. that is why scripts are with "cl\_" (client) and without (server)
6. client side scripts can be downloaded via AddCSLuaFile statement from init.lua
7. circular includes cause crash (if you include(A) in script B and include(B) in script A, then it will crash and it's a good reaction to bad design)

## DEPLOYMENT
1. copy map from content/map to gmod/maps
2. copy entities from entities to gmod/lua/entities
3. copy contents of /content/deploy/data/ to gmod/data

## HOW TO's

1. if you need communication server->client or client->server, use networking (util.AddNetworking and net.):https://www.youtube.com/watch?v=jREbAopWqKU
2. If want to detect if some entity was touched by player and entity is a trigger brush entity in hammer do:
-create brush in hammer with texture trigger
-create custom entity (example: entities/netcry_mission_trigger_entity)
-folder name is entity class name
-in hammer, in object properties set class to entity name for example: netcry_mission_trigger_entity - class is where for example func_door or trigger_once is selected from dropdown
-apply
-implement ENT:TOUCH in init.lua of custom entity
-that's it!
-custom entity can use instances and scripts from init.lua of gamemod server and server side scripts 

## WHAT'S IMPLEMENTED

what I implemented before abandoning the project:
1. dialogue system - see video: https://msporna.github.io/netcry_gmod/videos/gmod_dialogue_1.mp4
2. mission objective dialog (javascript based, displayed in game) - see video: https://msporna.github.io/netcry_gmod/videos/gmod_objective_popup_1.mp4
3. hacking minigame (pixi.js based, planned to display it in game just as objective) - play it right in your browser: https://msporna.github.io/netcry_gmod/minigame/index.html
4. created map in Valve hammer 3d - see video: https://msporna.github.io/netcry_gmod/videos/gmod_map_scene0.mp4

## resources

- gmod wiki
  https://wiki.garrysmod.com/page

- list of entities
  https://developer.valvesoftware.com/wiki/List_of_entities

- lua guide
  http://lua-users.org/wiki/LuaStyleGuide

- sounds
  http://www.wavsource.com/people

  --model list
  https://csite.io/tools/gmod-universal-mdl

### Attributions

1. Data-Dumper (lua) by Olivetti-Engineering SA
2. hacker css:https://github.com/brobin/hacker-bootstrap/
3. https://typeitjs.com/#license

### LUA HINTS

1. if calling function contained within object, call it with : also to pass 'self': self:Initilize() and not self.Initilize()
2. if want to call self functions from event definition like: function label.DoClick() self:doSomething() ->then need to do INSTANCE_NAME.doSomething() because self is label and label does not have 'doSomething' and this will cause error and is not INSTANCE in this case, have to watch out where using 'self' and what self is in this context.
