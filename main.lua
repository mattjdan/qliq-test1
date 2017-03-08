-----------------------------------------------------------------------------------------
--
-- main.lua
--


-----------------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

------------------------------
--testing/platform setup
------------------------------
buildMode = 1 -- 1,2,3,4. 1 is android, 2 is apple, 3 is amazon, 4 is windows
dev = false -- <<-- developer mode


-----------------------------------------------------------------------------------------
--
-- libraries
--
-----------------------------------------------------------------------------------------

if (buildMode~=2) then
	store = require( "plugin.google.iap.v3" )
else
	store = require( "store" )
end

widget = require ("widget") -- scroll and othertools
helperFunctions = require ( "helperFunctions" ) -- rescale, move, other functions
loadsave = require ( "loadsave" ) -- save, load
ads = require ( "ads" ) --- play ads

playGame = require ( "playGame" ) --- play game

--------------------------------
-- *****************************
-- PURCHASES ARRAY
-- *****************************
--------------------------------

iapServices = require ( "iapServices" ) --control iap purchases

-----------------------------------------------------------------------------------------
--
-- fonts and sounds
--
-----------------------------------------------------------------------------------------
-- Fonts

if "Win" == system.getInfo( "platformName" ) then
    font1 = "LuckiestGuy"
elseif "Android" == system.getInfo( "platformName" ) then
    font1 = "LuckiestGuy"
else
    -- Mac and iOS
    font1 = "Luckiest Guy"
end

--Sounds
--[[
copy this to insert sound to an event:

if (soundOn) then
      audio.play(resetSnd)
end

]]
bgMusic = audio.loadStream('audio/bgMusic2.mp3')
endMusic = audio.loadStream('audio/endMusic.mp3')

selectSnd = audio.loadSound('audio/menu.mp3')
passSnd = audio.loadSound('audio/tap.mp3')
vetoSnd = audio.loadSound('audio/miss.mp3')
applauseSnd = audio.loadSound('audio/applause.mp3')
sadSnd = audio.loadSound('audio/sadCrowd.mp3')
hailSnd = audio.loadSound('audio/hail.mp3')
mainMenuSnd = audio.loadSound('audio/menu.mp3')
outfitSnd = audio.loadSound('audio/customer.mp3')
deadSnd = audio.loadSound('audio/deadSnd.mp3')
bonusSnd = audio.loadSound('audio/alertSnd.mp3')
iapCompleteSnd = audio.loadSound('audio/victory.mp3')
iapRestoreSnd = audio.loadSound('audio/select.mp3')
menuSnd2 = audio.loadSound('audio/start.mp3')
buySnd = audio.loadSound('audio/buy.mp3')
levelupSnd = audio.loadSound('audio/levelupSnd.mp3')
randomizeSnd = audio.loadSound('audio/randomize.mp3')
bonusGetSnd = audio.loadSound('audio/packageGet.mp3')
bonusMissSnd = audio.loadSound('audio/packageMiss.mp3')
advisorSnd = audio.loadSound('audio/boost.mp3')
lockedSnd = audio.loadSound('audio/notification.mp3')
chestSnd = audio.loadSound('audio/chest.mp3')
moveSnd = audio.loadSound('audio/move.mp3')

swipeSnd = audio.loadSound('audio/swipe.mp3')
insufficientSnd = audio.loadSound('audio/slow.mp3')
raiderSnd = audio.loadSound('audio/aar.mp3')
raiderHitSnd = audio.loadSound('audio/tap2.mp3')
resetSnd = audio.loadSound('audio/reset.mp3')


function soundF ( soundTarg)
  if(soundOn) then
    audio.play( soundTarg )
  end
end


-----------------------------------------------------------------------------------------
--
-- shortcuts
--
-----------------------------------------------------------------------------------------
-- Screen Helpers
screenW = display.contentWidth
screenH = display.contentHeight
screenHalfW = screenW*0.5
screenHalfH = screenH*0.5
screenOriginX = display.screenOriginX
screenOriginY = display.screenOriginY
screenEdgeX = display.viewableContentWidth + -1* display.screenOriginX
screenEdgeY = display.viewableContentHeight + -1* display.screenOriginY

if (screenEdgeX>640) then
	scaleWidth = true
end

-----------------------------------------------------------------------------------------
--
-- admob
--
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
--
-- advertising setup
--[[
-----------------------------------------------------------------------------------------
local adAppId
if (buildMode==1) then--play
  store = require( "plugin.google.iap.v3" )
  store.init( iapListener )
  adAppId = "ca-app-pub-7802199558143474~1950527346"
  interstitialAppID = "ca-app-pub-7802199558143474/7857460149"
  textModifier = -7

elseif (buildMode==2) then--itunes
  store = require( "store" )
  store.init( iapListener )
  adAppId = "ca-app-pub-7802199558143474~9334193347"
  interstitialAppID = "ca-app-pub-7802199558143474/1810926541"
  textModifier = 0
elseif(buildMode==3) then--amazon
  --no store for amazon
  adAppId = "ca-app-pub-7802199558143474~3287659741"
  interstitialAppID = "ca-app-pub-7802199558143474/4764392947"
  textModifier = -7
end

function adListener( event )
    if (event.type == "interstitial") then
      if (event.phase == "closed") then
      elseif(event.phase == "clicked") then -- when ad closed
      elseif(event.phase == "failed") then -- when ad closed
      end--end  of ad state check
    end  
end--end of ad listener

if(devMode) then
  admob.init( adListener, { appId=adAppId, testMode = true } )
else
  admob.init( adListener, { appId=adAppId })
end

function showInterstitial () -- regular play ad
  if (iapArray[4].owned==false and saveArray.adsTimer>60*(60*1.5)) then --show if iap isn't purchased | play ad once every 90 seconds
    --check if ad  loaded
    if ( admob.isLoaded( "interstitial" ) == true ) then
      admob.show( "interstitial" )
      saveArray.adsTimer = 0
    else
      -- load ad
      admob.load( "interstitial", { adUnitId=interstitialAppID } )
    end
    end
end

if (adsCounterOn==false and iapArray[4].owned==false) then
  adsCounterOn = true
  local function backgroundUpdate ()
    saveArray.adsTimer = saveArray.adsTimer + 1
  end
  Runtime:addEventListener("enterFrame", backgroundUpdate)
end]]


-----------------------------------------------------------------------------------------
--
-- declarations and variables
--
-----------------------------------------------------------------------------------------

playGameF()
