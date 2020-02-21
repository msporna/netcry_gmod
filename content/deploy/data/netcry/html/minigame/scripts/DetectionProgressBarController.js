

   var detectionProgressBarFillFragmentsCount = 0;
   var detectionProogressBarLastFillFragmentAppearTime;
   var detectionProgressbarFillStarted = false;
   var detectionProgressBarSprite;

  ////////////////////////////////
  ////////////////////////////////
  ////////// F U N C T I O N S ///////////////////////////

function showDetectionProgressBar() {
    detectionProgressBarSprite =new PIXI.Sprite(
      PIXI.loader.resources[SpriteDefinition["progressBar"]].texture
    );
  
    detectionProgressBarSprite.x = mainProgressBarSprite.x;
    detectionProgressBarSprite.y =
      mainProgressBarSprite.y + detectionProgressBarSprite.height + 150;
    detectionProgressBarSprite.width = mainProgressBarSprite.width;
    detectionProgressBarSprite.height = detectionProgressBarSprite.height * 0.4;
  
    APP.stage.addChild(detectionProgressBarSprite);
    addDetectionProgressBarFillElement();
  }


  function addDetectionProgressBarFillElement() {
    if (
      detectionProgressBarFillFragmentsCount + 1 >
      DETECTION_PROGRESS_BAR_MAX_FRAGMENTS
    ) {
      //console.log("DETECTION PROGRESS BAR FILLED!");
      detectionProgressBarFillStarted = false;
      onLose();
      return; //no more filling
    }
  
    var detectionProgressBarFillFragment = new PIXI.Sprite(
      PIXI.loader.resources[SpriteDefinition["progressBarFillElement"]].texture
    );
  
    detectionProgressBarFillFragment.x =
      detectionProgressBarSprite.x +
      DETECTION_PROGRESS_BAR_FRAGMENT_X_SPACE +
      detectionProgressBarFillFragment.width *
      detectionProgressBarFillFragmentsCount;
    detectionProgressBarFillFragment.y = detectionProgressBarSprite.y + 15;
    detectionProgressBarFillFragment.name =
      "progressBarFillElement_" + detectionProgressBarFillFragmentsCount;
    detectionProgressBarFillFragment.height =
      detectionProgressBarSprite.height/2;
    detectionProgressBarFillFragment.width =
      detectionProgressBarFillFragment.width * 0.8;
  
    detectionProgressbarFillStarted = true;
    detectionProgressBarFillFragmentsCount += 1;
    detectionProgressBarLastFillFragmentAppearTime = new Date();
    APP.stage.addChild(detectionProgressBarFillFragment);
  }