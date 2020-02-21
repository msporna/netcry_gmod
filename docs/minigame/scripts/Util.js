console.log("hello from util");

var particle;
var particleStartTime;
var dissolveTween;
var flashingTween;

function generateRandomInt(min, max) {
    // min and max included
    return Math.floor(Math.random() * (max - min + 1) + min);
  }
  
  function canShowInjection() {
    if (injectionProgressBarAwaitingSelection) {
      return false;
    }
    return checkIfIndexOntheList(mainProgressBarFillFragmentsCount, injectionSpawnDefinition);
  }
  
  function canShowInjectionMark() {
    if(checkIfIndexOntheList(injectionFillElementsShownSoFar,destroyedInjectionMarks))
    {
      return false;
    }
    return checkIfIndexOntheList(injectionFillElementsShownSoFar, injectionMarkSpawnDefinition);
  }
  
  function canFreezeNow(index)
  {
    if(allowFreezes==false)
    {
      return false;
    }
    if(checkIfIndexOntheList(index,frozenFragments))
    {
      return false; //it was frozen already
    }

    if(checkIfIndexOntheList(index,freezeDefinition))
    {
      return true;
    }

    return false;
  }
  
  function generateSpawnDefinition(allCount, space, maxElements) {
    var definition = [];
    for (var i = 0; i < maxElements; i++) {
      var valid = false;
      while (!valid) {
        var index = generateRandomInt(0, allCount);
        var lastIndex = 0;
        if (definition.length > 0) {
          lastIndex = definition[definition.length - 1];
        }
        if(index==0)
        {
          continue; //skip 0
        }
  
        var spaceBetween = Math.abs(lastIndex - index);
        if (spaceBetween >= space) {
          valid = true; //this is a valid index
        }
  
      }
      //add index to definition list
      definition.push(index)
    }
    if(definition.length==maxElements)
    {
        return definition;
    }
    else
    {
        console.log("-___- something went wrong during definition generation. Retrying...");
        return generateSpawnDefinition(allCount,space,maxElements);
    }
  
    
  }
  
  function checkIfIndexOntheList(index, list) {
   for(var i=0;i<list.length;i++)
   {
     if(list[i]==index)
     {
       return true;
     }
   }
  
    return false;
  }


  function showShutterParticles(pos)
  {
    
    var particleContainer=new PIXI.Container();
    particleContainer.position=pos;
    particleContainer.width=100;
    particleContainer.height=100;
    APP.stage.addChild(particleContainer);

    var particleImage= PIXI.loader.resources[
      SpriteDefinition["shutterParticle"]
    ].texture

      // Emitter configuration, edit this to change the look
      // of the emitter
      var particleCfg={
        "alpha": {
          "start": 0.8,
          "end": 0.7
        },
        "scale": {
          "start": 1,
          "end": 0.3
        },
        "color": {
          "start": "FFFFFF",
          "end": "FFFFFF"
        },
        "speed": {
          "start": 400,
          "end": 400
        },
        "startRotation": {
          "min": 0.3,
          "max": 1
        },
        "rotationSpeed": {
          "min": 1,
          "max": 2
        },
        "lifetime": {
          "min": 0.4,
          "max": 0.4
        },
        "frequency": 0.3,
        "emitterLifetime": 0.41,
        "maxParticles": 1000,
        "pos": {
          "x": 0,
          "y": 0
        },
        "addAtBack": false,
        "spawnType": "burst",
        "particlesPerWave": 8,
        "particleSpacing": 45,
        "angleStart": 0
      };

      particle=new PIXI.particles.Emitter(particleContainer,particleImage,particleCfg);
      particle.playOnceAndDestroy(function(){
        particle=undefined;
        APP.stage.removeChild(particleContainer);
        console.log("cleaned particle___");
      })
      particleStartTime=Date.now();
    // Start the update
    particleUpdate();
  }


// Update function every frame
var particleUpdate = function(){

  // Update the next frame
  requestAnimationFrame(particleUpdate);

  var now = Date.now();

  // The emitter requires the elapsed
  // number of seconds since the last update
  if (particle!=undefined)
  {
    particle.update((now - particleStartTime) * 0.001);
    particleStartTime = now;

  }
 
};

//tweens alpha of sprite
function startDissolving(sprite,timeSeconds)
{
  //console.log("starting dissolving tween...");
  dissolvingTween = PIXI.tweenManager.createTween(sprite);
  dissolvingTween.from({ alpha: 1 }).to({ alpha: 0.1 });
  dissolvingTween.time = timeSeconds*1000; //convert seconds to ms
  dissolvingTween.repeat = 0
  //dissolvingTween.on('start', () => { console.log('fading out texture') });
  //dissolvingTween.on('stop', ()=>{console.log('tween stopped')});
  //dissolvingTween.on('end', ()=>{console.log('tween ended')});
  dissolvingTween.start();
}

function startFlashing(sprite,timeSeconds)
{
  //console.log("starting flashing tween...");
  flashingTween = PIXI.tweenManager.createTween(sprite);
  flashingTween.from({ alpha: 1 }).to({ alpha: 0.1 })
  flashingTween.time = timeSeconds*1000; //convert seconds to ms
  flashingTween.pingPong=true;
  //flashingTween.on('start', () => { console.log('fading out texture') });
  //flashingTween.on('stop', ()=>{console.log('tween stopped')});
  //flashingTween.on('end', ()=>{console.log('tween ended')});
  flashingTween.start();
}


function stopDissolvingTween(relatedObject,object)
{
  dissolvingTween.stop();
  dissolvingTween=undefined;

  if(relatedObject=="injectionBar")
  {
      object.alpha=1; //restore alpha
  }
  else if(relatedObject=="injectionRedMark")
  {
    object.alpha=1; //restore alpha
  }
}
