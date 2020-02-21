var timeToDetection;
var timeToFillMainBar;
var timeToFillInjection;
var maxInjections;
var intervalBetweenInjectionsPercent;
var timeToSelectInjection;
var allowFreezes;
var maxFreezes;
var intervalBetweenFreezesPercent;
var freezeSecondsMin;
var freezeSecondsMax;
var timeToSelectInjectionMark;
var maxInjectionMarks;
var actionOnFail;
var minimumSpaceBetweenInjectionMarksPercent;

var configObject;

function loadConfig(configJsonString) {
    //configJson should be only a combination object that was randomly chosen for this minigame
    //not the whole config
    configObject = JSON.parse(configJsonString);
    console.log("loaded config for combination of id: " + configObject.id);
    timeToDetection = configObject.secondsToDetection;
    timeToFillMainBar = configObject.secondsToFill;
    timeToFillInjection = configObject.secondsToFillInjection;
    maxInjections = configObject.injectionsCount;
    intervalBetweenInjectionsPercent = configObject.minimumSpaceBetweenInjectionsPercent;
    timetoSelectInjection = configObject.secondsToTapOnInjection;
    allowFreezes = configObject.allowFreezes;
    maxFreezes = configObject.maxFreezes;
    intervalBetweenFreezesPercent = configObject.minimumSpaceBetweenFreezesPercent;
    freezeSecondsMin = configObject.secondsFreezeValue1;
    freezeSecondsMax = configObject.secondsFreezeValue2;
    timeToSelectInjectionMark = configObject.secondsToTapOnInjectionMark;
    maxInjectionMarks = configObject.injectionMarksCount;
    actionOnFail = configObject.actionOnFail;
    minimumSpaceBetweenInjectionMarksPercent=configObject.minimumSpaceBetweenInjectionMarksPercent;
}