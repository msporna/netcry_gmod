  
  ////////////////////////////////
  ////////////////////////////////
  ////////// V A R S ///////////////////////////

var mainProgressBarFillFragmentsCount = 0;
var mainProgressBarLastFillFragmentAppearTime;
var mainProgressBarFillStarted = false;
var mainProgressBarSprite;
var unblockedInjections=[];
var addedFillFragments=[];

   
  ////////////////////////////////
  ////////////////////////////////
  ////////// F U N C T I O N S ///////////////////////////


function addMainProgressBarFillElement() {
    var injectionElementYOffset=2;
    if (mainProgressBarFillFragmentsCount + 1 > MAIN_PROGRESS_BAR_MAX_FRAGMENTS) {
      console.log("MAIN PROGRESS BAR FILLED!");
      mainProgressBarFillStarted = false;
      onWin();
      return; //no more filling
    }
    //should freeze?
    if (canFreezeNow(mainProgressBarFillFragmentsCount)) {
      console.log("FREEZING!");
      lastFreezeTime = new Date();
      isFrozen=true;
      frozenFragments.push(mainProgressBarFillFragmentsCount);
      return; //cancel filling for now
    }

    var mainProgressBarFillFragment;
    var showInjection = canShowInjection();
    if (showInjection) {
      mainProgressBarFillFragment = new PIXI.Sprite(
        PIXI.loader.resources[
          SpriteDefinition["mainProgressBarInjectElement"]
        ].texture
      );
      //set some flags
      injectionProgressBarSprite = mainProgressBarFillFragment;
      injectionProgressBarAwaitingSelection = true;
      injectionsCountShownSoFar += 1;
      //injectionLastRelatedFragment = injectionsCountShownSoFar;
      injectionLastRelatedFragment = mainProgressBarFillFragmentsCount + 1;
      mainProgressBarFillStarted = false; //pause filling main progress bar for now
      injectionShowTime = new Date();
      mainProgressBarFillFragment.interactive = true;
      mainProgressBarFillFragment.buttonMode = true;
      injectionProgressBarSprite.on("mousedown", onInjectionProgressBarSelected);
      injectionElementYOffset=-1;
      startDissolving(injectionProgressBarSprite,timetoSelectInjection);
    } else {
      mainProgressBarFillFragment = new PIXI.Sprite(
        PIXI.loader.resources[
          SpriteDefinition["mainProgressBarFillElement"]
        ].texture
      );
      //flags:
      mainProgressBarFillStarted = true;
      injectionElementYOffset=0;
    }
  
    mainProgressBarFillFragment.x =
      mainProgressBarSprite.x +
      MAIN_PROGRESS_BAR_FRAGMENT_X_SPACE +
      mainProgressBarFillFragment.width * mainProgressBarFillFragmentsCount;
    mainProgressBarFillFragment.y = mainProgressBarSprite.y + 15+injectionElementYOffset;
    mainProgressBarFillFragment.name =
      "mainProgressBarFillElement_" + mainProgressBarFillFragmentsCount;
  
    mainProgressBarFillFragmentsCount += 1;
    mainProgressBarLastFillFragmentAppearTime = new Date();
    APP.stage.addChild(mainProgressBarFillFragment);
    addedFillFragments.push(mainProgressBarFillFragment);
  }
  

  function showMainProgressBar()
  {
     //show main progress bar
    mainProgressBarSprite = new PIXI.Sprite(
      PIXI.loader.resources[SpriteDefinition["mainProgressBar"]].texture
    );

    mainProgressBarSprite.x =2;
    mainProgressBarSprite.y = 2;
    mainProgressBarSprite.width=600;

    APP.stage.addChild(mainProgressBarSprite);
  }
  
    
  ////////////////////////////////
  ////////////////////////////////
  ////////// E V E N T S ///////////////////////////

  function onInjectionProgressBarSelected() {
    if (injectionProgressBarStarted || injectionProgressBarMarkAwaitingSelection) {
      return;
    }
    console.log("Injection selected!");
    stopDissolvingTween("injectionBar",injectionProgressBarSprite);
    injectionShowTime = new Date();
    unblockedInjections
    injectionProgressBarStarted = true;
    injectionProgressBarAwaitingSelection = false;
    destroyedInjectionMarks=[];
    //randomly selected at which indexes should red marks be shown
    injectionMarkSpawnDefinition = generateSpawnDefinition(INJECTION_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenInjectionMarks, maxInjectionMarks);
    addInjectionProgressBarFillElement();
    
  }
  
  function onInjectionProgressBarNotSelected() {
    console.log("Injection not selected!");
    APP.stage.removeChild(injectionProgressBarSprite);
    mainProgressBarFillFragmentsCount =0;
    for (var i=0;i<addedFillFragments.length;i++)
    {
        APP.stage.removeChild(addedFillFragments[i]);
    }
    //remove fill elements of injection progress bar if any
    clearAllInjectionProgressBarFillElements();
    addedFillFragments=[];
    injectionProgressBarAwaitingSelection = false;
    //reshuffle
    injectionSpawnDefinition = generateSpawnDefinition(MAIN_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenInjections, maxInjections);
    addMainProgressBarFillElement();
  
  }
  
  