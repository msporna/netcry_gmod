//pixi api doc:http://pixijs.download/release/docs/PIXI.Application.html
//goal: make sure that the progress bar reaches end before detection; if injection is getting stuck, need to unstack it(green bars require input); if made a mistake
//in the green bar marking, then it starts filling again but detection time flies
var CONFIG =
  '{ "id": 0, "secondsToFill": 20, "secondsToDetection": 35, "secondsToFillInjection": 10,"injectionsCount": 2, "minimumSpaceBetweenInjectionsPercent": 0.2, "secondsToTapOnInjection": 1.5, "allowFreezes": false, "maxFreezes": 3, "minimumSpaceBetweenFreezesPercent": 0.1, "secondsFreezeValue1": 2, "secondsFreezeValue2": 4, "secondsToTapOnInjectionMark": 1, "injectionMarksCount": 3, "minimumSpaceBetweenInjectionMarksPercent":0.1, "actionOnFail": "no_consequence" }'; //json string goes here (inserted by lua)
var autohackPowerupCount=0;
var detectionSlowerPowerupCount=0;
var autohackLevelPowerup=1;
var detectionSlowerPowerupLevel=1;
var gameDone=false;



var APP;
var SpriteDefinition = {};
SpriteDefinition.mainProgressBar = "art/out/MainProgressBarFrame0.png";
SpriteDefinition.mainProgressBarFillElement =
  "art/out/MainProgressBarFillFragment.png";
SpriteDefinition.mainProgressBarInjectElement =
  "art/out/MainProgressBarInjectIndicator.png";
SpriteDefinition.progressBar = "art/out/ProgressBarOut.png";
SpriteDefinition.progressBarFillElement = "art/out/ProgressBarFragmentOut.png";
SpriteDefinition.injectIndicatorFillElement =
  "art/out/InjectIndicatorFillFragment.png";
SpriteDefinition.injectIndicatorRedMark = "art/out/RedMark.png";
SpriteDefinition.shutterParticle = "art/out/deathParticle.png";
SpriteDefinition.powerupSlowdownRegular = "art/out/powerup_slowdown.png";
SpriteDefinition.powerupSlowdownHighlighted = "art/out/powerup_slowdown_highlighted.png";
SpriteDefinition.powerupSlowdownSelected = "art/out/powerup_slowdown_selected.png";
SpriteDefinition.powerupWand= "art/out/powerup_wand.png";
SpriteDefinition.powerupWandHighlighted= "art/out/powerup_wand_highlighted.png";
SpriteDefinition.powerupWandSelected= "art/out/powerup_wand_selected.png";


//VARS
var freezeTimeSeconds;
var spaceBetweenFreezes;
var freezeDefinition=[];
var lastFreezeTime;
var isFrozen=false;
var frozenFragments=[];

//STATIC
var MAIN_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL = 1; //calculated based on config
var MAIN_PROGRESS_BAR_FRAGMENT_X_SPACE = 12;
var MAIN_PROGRESS_BAR_MAX_FRAGMENTS = 12;
var DETECTION_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL = 1; //calculated based on config
var DETECTION_PROGRESS_BAR_FRAGMENT_X_SPACE = 17;
var DETECTION_PROGRESS_BAR_MAX_FRAGMENTS = 52;
var INJECTION_PROGRESS_BAR_MAX_FRAGMENTS = 119;
var INJECTION_PROGRESS_BAR_FRAGMENT_Y_SPACE = 1;
var INJECTION_PROGRESS_BAR_ADD_INTERVAL = -1;

//This loads assets and after it's done Init() is called to init the game
PIXI.loader
  .add([
    SpriteDefinition["mainProgressBar"],
    SpriteDefinition["mainProgressBarFillElement"],
    SpriteDefinition["mainProgressBarInjectElement"],
    SpriteDefinition["progressBar"],
    SpriteDefinition["progressBarFillElement"],
    SpriteDefinition["injectIndicatorFillElement"],
    SpriteDefinition["injectIndicatorRedMark"],
    SpriteDefinition["shutterParticle"],
    SpriteDefinition["powerupSlowdownRegular"],
    SpriteDefinition["powerupSlowdownHighlighted"],
    SpriteDefinition["powerupSlowdownSelected"],
    SpriteDefinition["powerupWand"],
    SpriteDefinition["powerupWandHighlighted"],
    SpriteDefinition["powerupWandSelected"],
    
  ])
  .on("progress", loadProgressHandler)
  .load(init);

function loadProgressHandler() {
  console.log("loading");
}

function init() {
  var type = "WebGL";
  if (!PIXI.utils.isWebGLSupported()) {
    type = "canvas";
  }

  PIXI.utils.sayHello(type);

  //Create a Pixi Application
  APP = new PIXI.Application({
    width: 600,
    height: 400,
    antialias: true, // default: false
    transparent: false, // default: false
    resolution: 1
  });

  //fill whole window
  APP.renderer.view.style.position = "absolute";
  APP.renderer.view.style.display = "block";
  APP.renderer.autoResize = true;
  APP.renderer.resize(window.innerWidth, window.innerHeight);
  //APP.renderer.resize(600,400);
  //console.log("inner html width:"+window.innerWidth);
  //console.log("inner html height:"+window.innerHeight);

  //Render the stage
  document.body.appendChild(APP.view);

  //parse config
  loadConfig(CONFIG);

  //start a game loop
  APP.ticker.add(gameLoop);


  //calculate intervals for filling progress bars
  MAIN_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL =
    timeToFillMainBar / MAIN_PROGRESS_BAR_MAX_FRAGMENTS;
  console.log(
    "main progress bar fragment interval is " +
    MAIN_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL
  );
  DETECTION_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL =
    timeToDetection / DETECTION_PROGRESS_BAR_MAX_FRAGMENTS;
  console.log(
    "detection progress bar fragment interval is " +
    DETECTION_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL
  );
  INJECTION_PROGRESS_BAR_ADD_INTERVAL =
    timeToFillInjection / INJECTION_PROGRESS_BAR_MAX_FRAGMENTS;
  console.log(
    "injection progress bar fragment interval is " +
    INJECTION_PROGRESS_BAR_ADD_INTERVAL
  );

  //calculate space between injection marks
  spaceBetweenInjectionMarks = INJECTION_PROGRESS_BAR_MAX_FRAGMENTS * minimumSpaceBetweenInjectionMarksPercent;
  spaceBetweenInjections = MAIN_PROGRESS_BAR_MAX_FRAGMENTS * intervalBetweenInjectionsPercent;
  

  freezeTimeSeconds = generateRandomInt(freezeSecondsMax, freezeSecondsMin);
  spaceBetweenFreezes = maxFreezes * intervalBetweenFreezesPercent;
  console.log("freeze time:"+freezeTimeSeconds);

  //generate when to show injections
  injectionSpawnDefinition = generateSpawnDefinition(MAIN_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenInjections, maxInjections);
  injectionMarkSpawnDefinition = generateSpawnDefinition(INJECTION_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenInjectionMarks, maxInjectionMarks);
  freezeDefinition=generateSpawnDefinition(MAIN_PROGRESS_BAR_MAX_FRAGMENTS, spaceBetweenFreezes, maxFreezes);

  
  

  showtime();

  console.log("setup done");
  console.log("main progress bar injections count defined:"+injectionSpawnDefinition.length);
  console.log("main progress bar injections mark count defined:"+injectionMarkSpawnDefinition.length);
}



function showtime() {

 
  showMainProgressBar();
  addMainProgressBarFillElement();
  showDetectionProgressBar();

  //showPowerups(); //coming next
}


function onWin()
{

  console.log("HACK game won!");
  sendMessageToGmod("GameWin");

}

function onLose()
{
  console.log("HACK game lost!");
  sendMessageToGmod("GameLost");
}


function gameLoop(delta) {
  if(gameDone)
  {
    return;
  }

  PIXI.tweenManager.update();

  if(isFrozen)
  {
    //console.log("is frozen");
    if((new Date().getTime() - lastFreezeTime) / 1000 >freezeTimeSeconds) {
      isFrozen=false; //stop freezing
      //console.log("unfreezing");
    }
      return;
  }

  if (mainProgressBarFillStarted) {
    if (
      (new Date().getTime() - mainProgressBarLastFillFragmentAppearTime) /
      1000 >
      MAIN_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL
    ) {
      //add another
      addMainProgressBarFillElement();
    }
  }

  if (injectionProgressBarStarted) {
    if (
      (new Date().getTime() - injectionShowMarkTime) / 1000 >
      INJECTION_PROGRESS_BAR_ADD_INTERVAL
    ) {
      //add another
      addInjectionProgressBarFillElement();
    }
  }

  if (injectionProgressBarAwaitingSelection) {
    if (
      (new Date().getTime() - injectionShowTime) / 1000 >
      timetoSelectInjection
    ) {
      if (injectionProgressBarStarted) {
        return;
      }
      //time passed,injection becomes regular fragment if was not selected yet
      onInjectionProgressBarNotSelected();
    }
  }


  if (injectionProgressBarMarkAwaitingSelection) {
    if (
      (new Date().getTime() - injectionMarkShowTime) / 1000 >
      timeToSelectInjectionMark
    ) {
      onInjectionProgressBarMarkNotSelected();
    }
  }

  if (detectionProgressbarFillStarted) {
    if (
      (new Date().getTime() - detectionProgressBarLastFillFragmentAppearTime) /
      1000 >
      DETECTION_PROGRESS_BAR_FRAGMENT_ADD_INTERVAL
    ) {
      //add another
      addDetectionProgressBarFillElement();

      if((detectionProgressBarFillFragmentsCount/DETECTION_PROGRESS_BAR_MAX_FRAGMENTS) >=0.8 )
      {
        //less than 20% left to being detected
        //start flashing the detection bar
        startFlashing(detectionProgressBarSprite,1);
      }
    }
  }
}