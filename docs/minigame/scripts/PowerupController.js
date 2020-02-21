
var slowdownPowerupSprite;
var wandPowerupSprite;

function showPowerups()
{
    //slowdown powerup
    slowdownPowerupSprite =new PIXI.Sprite(
        PIXI.loader.resources[SpriteDefinition["powerupSlowdownRegular"]].texture
      );
    
      slowdownPowerupSprite.x = detectionProgressBarSprite.x;
      slowdownPowerupSprite.y =detectionProgressBarSprite.y+10;
        slowdownPowerupSprite.width = 150;
        slowdownPowerupSprite.height = 100;
        slowdownPowerupSprite.interactive = true;
        slowdownPowerupSprite.buttonMode = true;
        slowdownPowerupSprite.on("mousedown", onSlowdownPowerupSelected);
        slowdownPowerupSprite.on("mouseover", onSlowdownMouseIn);
        slowdownPowerupSprite.on("mouseout", onSlowdownMouseOut);
    
      APP.stage.addChild(slowdownPowerupSprite);

      //wand powerup
      wandPowerupSprite =new PIXI.Sprite(
        PIXI.loader.resources[SpriteDefinition["powerupWand"]].texture
      );
    
      wandPowerupSprite.x = detectionProgressBarSprite.x+detectionProgressBarSprite.width-15;
      wandPowerupSprite.y =detectionProgressBarSprite.y+10;
      wandPowerupSprite.width = 150;
      wandPowerupSprite.height = 100;
      wandPowerupSprite.interactive = true;
      wandPowerupSprite.buttonMode = true;
      wandPowerupSprite.on("mousedown", onWandPowerupSelected);
      wandPowerupSprite.on("mouseover", onWandMouseIn);
      wandPowerupSprite.on("mouseout", onWandMouseOut);
    
      APP.stage.addChild(wandPowerupSprite);
     
}

function onSlowdownPowerupSelected()
{

}

function onSlowdownMouseOut()
{

}

function onSlowdownMouseIn()
{

}

function onWandPowerupSelected()
{

}

function onWandMouseIn()
{

}

function onWandMouseOut()
{

}