

var injectionsCountShownSoFar = 0;
var injectionLastRelatedFragment = 0; //last injection was shown for this fragment (index)
var injectionShowTime;
var injectionShowMarkTime = new Date();
var injectionProgressBarStarted;
var injectionProgressBarSprite;
var injectionProgressBarAwaitingSelection;
var injectionProgressBarMarkAwaitingSelection;
var injectionProgressBarFillElementHeight = -1;
var injectionMarkCountShownSoFar = 0;
var injectionFillElementsShownSoFar = 0;
var injectionMarkShowTime;
var injectionProgressBarFillMarkElement;
var addedInjectionProgressbarFillElements = [];
var injectionMarkLastRelatedFragment = 0;
var spaceBetweenInjectionMarks = 0;
var injectionFillsPassedSinceLastMark = 0;
var injectionMarkSpawnDefinition = [];
var injectionSpawnDefinition = [];
var spaceBetweenInjections = 0;
var destroyedInjectionMarks=[];
   
  ////////////////////////////////
  ////////////////////////////////
  ////////// F U N C T I O N S ///////////////////////////

function addInjectionProgressBarFillElement() {
    //console.log("injection marks count:" + injectionMarkCountShownSoFar);
    if (
      injectionFillElementsShownSoFar + 1 >
      INJECTION_PROGRESS_BAR_MAX_FRAGMENTS
    ) {
      console.log("INJECTION PROGRESS BAR FILLED!");
      injectionProgressBarStarted = false;
      mainProgressBarFillStarted = true;
      injectionFillElementsShownSoFar=0;
      return; //no more filling
    }
  
    if (canShowInjectionMark()) {
      addInjectionMarkProgressBarFillMarkElement();
      return;
    }
  
    var injectionProgressBarFillElement = new PIXI.Sprite(
      PIXI.loader.resources[
        SpriteDefinition["injectIndicatorFillElement"]
      ].texture
    );
  
    injectionProgressBarFillElement.x = injectionProgressBarSprite.x + 15;
    injectionProgressBarFillElement.y = ((injectionProgressBarSprite.y + injectionProgressBarSprite.height) * 0.96) + INJECTION_PROGRESS_BAR_FRAGMENT_Y_SPACE - (injectionProgressBarFillElement.height * injectionFillElementsShownSoFar);
  
    injectionProgressBarFillElement.name =
      "injectionProgressBarFillElement_" + injectionFillElementsShownSoFar;
  
    if (injectionProgressBarFillElementHeight == -1) {
      //set injection fill element high, but only once
      injectionProgressBarFillElementHeight = injectionProgressBarFillElement.height;
    }
    injectionProgressBarStarted = true;
    injectionFillElementsShownSoFar += 1;
    injectionFillsPassedSinceLastMark += 1;
    injectionShowMarkTime = new Date();
    APP.stage.addChild(injectionProgressBarFillElement);
    addedInjectionProgressbarFillElements.push(injectionProgressBarFillElement);
  }


  function addInjectionMarkProgressBarFillMarkElement() {
    console.log("added injection mark element!");
    injectionProgressBarFillMarkElement = new PIXI.Sprite(
      PIXI.loader.resources[
        SpriteDefinition["injectIndicatorRedMark"]
      ].texture
    );
  
    injectionProgressBarStarted = false; //pause main injection progress bar
    injectionProgressBarMarkAwaitingSelection = true;
    injectionMarkShowTime = new Date();
    injectionProgressBarFillMarkElement.interactive = true;
    injectionProgressBarFillMarkElement.buttonMode = true;
    injectionProgressBarFillMarkElement.on("mousedown", onInjectionProgressBarMarkSelected);
    injectionProgressBarFillMarkElement.on("mouseover", onInjectionProgressBarMarkHovered);
    injectionProgressBarFillMarkElement.on("mouseout", onInjectionProgressBarMarkOut);
    injectionProgressBarFillMarkElement.x = injectionProgressBarSprite.x + 15;
    injectionProgressBarFillMarkElement.y = ((injectionProgressBarSprite.y + injectionProgressBarSprite.height) * 0.93) + INJECTION_PROGRESS_BAR_FRAGMENT_Y_SPACE - (injectionProgressBarFillElementHeight * injectionFillElementsShownSoFar);
    injectionMarkCountShownSoFar += 1;
    injectionMarkLastRelatedFragment = injectionFillElementsShownSoFar;
    injectionFillsPassedSinceLastMark = 0;
    APP.stage.addChild(injectionProgressBarFillMarkElement);
    startDissolving(injectionProgressBarFillMarkElement,timeToSelectInjectionMark);
  }
  
  function clearAllInjectionProgressBarFillElements()
  {
    for(var i=0;i<addedInjectionProgressbarFillElements.length;i++)
    {
        APP.stage.removeChild(addedInjectionProgressbarFillElements[i]);
    }
    addedInjectionProgressbarFillElements=[];
  }
  
  ////////////////////////////////
  ////////////////////////////////
  ////////// E V E N T S ///////////////////////////

  function onInjectionProgressBarMarkSelected() {
    console.log("injection mark selected!");
    stopDissolvingTween("injectionRedMark",injectionProgressBarFillMarkElement);
    showShutterParticles(injectionProgressBarFillMarkElement.position);
    APP.stage.removeChild(injectionProgressBarFillMarkElement);
    destroyedInjectionMarks.push(injectionFillElementsShownSoFar); //so it's not added again
    injectionProgressBarMarkAwaitingSelection = false;
    injectionProgressBarStarted = true; //continue on injection bar filling

    
  
    //play sound
    //todo
  }
  

  function onInjectionProgressBarMarkNotSelected() {
    //start all over, must get all injection marks to unstuck!
    console.log("injection mark not selected!");
    APP.stage.removeChild(injectionProgressBarFillMarkElement);
    for (var i = 0; i < addedInjectionProgressbarFillElements.length; i++) {
      APP.stage.removeChild(addedInjectionProgressbarFillElements[i]);
    }
    injectionFillElementsShownSoFar = 0;
    injectionMarkLastRelatedFragment = 0;
    injectionMarkCountShownSoFar = 0;
    addedInjectionProgressbarFillElements = [];//clear array
    injectionProgressBarMarkAwaitingSelection = false;
    injectionSpawnDefinition = generateSpawnDefinition(MAIN_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenInjections, maxInjections); //reshuffle
    freezeDefinition=generateSpawnDefinition(MAIN_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenFreezes, maxFreezes); //reshuffle freezes too
    injectionProgressBarStarted = true;
    destroyedInjectionMarks=[];//clear already cleaned ones
  
  }
  
  function onInjectionProgressBarMarkHovered()
  {
    injectionProgressBarFillMarkElement.tint=0xE1A3FF;
  }

  function onInjectionProgressBarMarkOut()
  {
    injectionProgressBarFillMarkElement.tint=0xFFFFFF;
  }