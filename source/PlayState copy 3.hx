package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;
import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var mania:Int = 0;
	public static var maniaToChange:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	private var ctrTime:Float = 0;

	var canDrain:Bool = false;
	public static var fire:FlxSprite;


	public static var songPosBG:FlxSprite;
	public var visibleCombos:Array<FlxSprite> = [];
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	
	
	public static var hasPlayedOnce:Bool = false;




	var halloweenLevel:Bool = false;
	var flechita:Bool = true;
	var publico = new FlxSprite(-700, 625);
	var sonidomuerte:FlxSound; 
	//Termination-playable
	var bfDodging:Bool = false;
	var bfCanDodge:Bool = false;
	var bfDodgeTiming:Float = 0.22625;
	var bfDodgeCooldown:Float = 0.1135;
	var shad_attack_saw:FlxSprite;
	var shad_attack_alert:FlxSprite;
	public static var deathBySawBlade:Bool = false;
	public static var healthDrainVerifi:Bool = false;


	var fireTimer:FlxTimer;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var arrowSliced:Array<Bool> = [false, false, false, false, false, false, false, false, false]; //leak :)

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	var noteSplashes:FlxTypedGroup<NoteSplash>;
	private var unspawnNotes:Array<Note> = [];
	private var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var bfsDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	var replacableTypeList:Array<Int> = [3,4,7]; //note types do wanna hit
	var nonReplacableTypeList:Array<Int> = [1,2,6]; //note types you dont wanna hit

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	var grace:Bool = false;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it

	//no se xddd
	private var maxhealth:Float = 1;
	private var healthcap:Float = 0;


	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var campaignSicks:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignBads:Int = 0;
	public static var campaignShits:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;

	var hold:Array<Bool>;
	var press:Array<Bool>;
	var release:Array<Bool>;


	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var overhealthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var camSustains:FlxCamera;
	public var camNotes:FlxCamera;
	var cs_reset:Bool = false;
	public var cannotDie = false;
	private var camGame:FlxCamera;

	public static var offsetTesting:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var fantasma:FlxTrail;
	var isCutscene:Bool = false;
	var shake:Bool = false;
	var hazardRandom:Int = 1;
	


	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;
	var espada:FlxSprite;
	var uno:FlxSprite;

	//tetris vs mami
	var tetrisLight:FlxSprite;
	var colorCycle:Int = 0;

	var latched:Bool = false;

	var tetrisCrowd:FlxSprite;


	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var startedCountdown:Bool = false;

	var fondito:FlxSprite;

	var maniaChanged:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public var currentSection:SwagSection;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	public static var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis

	public static var highestCombo:Int = 0;

	private var executeModchart = false;
	public static var startTime = 0.0;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		FlxG.mouse.visible = false;
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;

  
		

		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;
		PlayStateChangeables.zoom = FlxG.save.data.zoom;
		PlayStateChangeables.bothSide = FlxG.save.data.bothSide;
		PlayStateChangeables.flip = FlxG.save.data.flip;
		PlayStateChangeables.randomNotes = FlxG.save.data.randomNotes;
		PlayStateChangeables.randomSection = FlxG.save.data.randomSection;
		PlayStateChangeables.randomMania = FlxG.save.data.randomMania;
		PlayStateChangeables.randomNoteTypes = FlxG.save.data.randomNoteTypes;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));


		noteSplashes = new FlxTypedGroup<NoteSplash>();
		var daSplash = new NoteSplash(100, 100, 0);
		daSplash.alpha = 0;
		noteSplashes.add(daSplash);


		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);
		// Making difficulty text for Discord Rich Presence.
		switch (storyDifficulty)
		{
			case 0:
				storyDifficultyText = "Easy";
			case 1:
				storyDifficultyText = "Normal";
			case 2:
				storyDifficultyText = "Hard";
			case 3:
				storyDifficultyText = "UHC";
		}

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
			case 'shadoune':
				iconRPC = 'shadoune';
			case 'shadounearmor':
				iconRPC = 'armor';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camSustains = new FlxCamera();
		camSustains.bgColor.alpha = 0;
		camNotes = new FlxCamera();
		camNotes.bgColor.alpha = 0;
  

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camSustains);
		FlxG.cameras.add(camNotes);

		camHUD.zoom = PlayStateChangeables.zoom;

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		mania = SONG.mania;

		if (PlayStateChangeables.bothSide)
			mania = 5;
		else if (FlxG.save.data.mania != 0 && PlayStateChangeables.randomNotes)
			mania = FlxG.save.data.mania;

		maniaToChange = mania;

		Note.scaleSwitch = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'permadeath':
				dialogue = CoolUtil.coolTextFile(Paths.txt('permadeath/dialog'));
			case 'you-are-mine':
				dialogue = CoolUtil.coolTextFile(Paths.txt('you-are-mine/dialog'));
		
			case 'decition':
				dialogue = CoolUtil.coolTextFile(Paths.txt('decition/dialog'));
		
			case 'shadoune':
				dialogue = CoolUtil.coolTextFile(Paths.txt('shadoune/dialog'));
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = FlxG.save.data.antialiasing;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = FlxG.save.data.antialiasing;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = FlxG.save.data.antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = FlxG.save.data.antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = FlxG.save.data.antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = FlxG.save.data.antialiasing;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = FlxG.save.data.antialiasing;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = FlxG.save.data.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = FlxG.save.data.antialiasing;
					add(evilSnow);
					}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					if (!PlayStateChangeables.Optimize)
						{
							var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
							var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
						}

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);

					/* 
							var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolBG'));
							bg.scale.set(6, 6);
							// bg.setGraphicSize(Std.int(bg.width * 6));
							// bg.updateHitbox();
							add(bg);
							var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.image('weeb/evilSchoolFG'));
							fg.scale.set(6, 6);
							// fg.setGraphicSize(Std.int(fg.width * 6));
							// fg.updateHitbox();
							add(fg);
							wiggleShit.effectType = WiggleEffectType.DREAMY;
							wiggleShit.waveAmplitude = 0.01;
							wiggleShit.waveFrequency = 60;
							wiggleShit.waveSpeed = 0.8;
						*/

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
								var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
								var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
								// Using scale since setGraphicSize() doesnt work???
								waveSprite.scale.set(6, 6);
								waveSpriteFG.scale.set(6, 6);
								waveSprite.setPosition(posX, posY);
								waveSpriteFG.setPosition(posX, posY);
								waveSprite.scrollFactor.set(0.7, 0.8);
								waveSpriteFG.scrollFactor.set(0.9, 0.8);
								// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
								// waveSprite.updateHitbox();
								// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
								// waveSpriteFG.updateHitbox();
								add(waveSprite);
								add(waveSpriteFG);
						*/
			}
			case 'aquinoby':
				{
				 defaultCamZoom = 0.9;
				 curStage = 'webadas';
				 var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('pared'));
				 bg.antialiasing = true;
				 bg.scrollFactor.set(0.9, 0.9);
				 bg.active = false;
				 add(bg);
	 
				 var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image(''));
				 stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				 stageFront.updateHitbox();
				 stageFront.antialiasing = true;
				 stageFront.scrollFactor.set(0.9, 0.9);
				 stageFront.active = false;
				 add(stageFront);
	 
				 var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image(''));
				 stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				 stageCurtains.updateHitbox();
				 stageCurtains.antialiasing = true;
				 stageCurtains.scrollFactor.set(1.3, 1.3);
				 stageCurtains.active = false;
	 
				 add(stageCurtains);
			 } 
			  case 'permadeath':
				{
				 defaultCamZoom = 0.90;
				 curStage = 'permadeath';
	 
				 var shulket = Paths.getSparrowAtlas('fondito_noche');
				 fondito = new FlxSprite(-700, -200);
				 fondito.frames = shulket;
				 fondito.animation.addByPrefix('idle', 'fondo animate pne');
				 fondito.animation.play('idle');
				 fondito.antialiasing = true;
				 fondito.scrollFactor.set(0.9, 0.9);
				 add(fondito);
	 
				 espada = new FlxSprite(0, 100);
				 espada.x += 500;
				 espada.frames = Paths.getSparrowAtlas("fondito/shulket");
				 espada.animation.addByPrefix('idle', 'shulket', 20, true);
				 espada.animation.play('idle');
				 espada.antialiasing = true;
				 add(espada);
			 
				 
				 publico.frames = Paths.getSparrowAtlas('fondito/publico61');
				 publico.animation.addByPrefix('idle', 'publico61', 24);
				 publico.animation.play('idle');
				 publico.updateHitbox();
				 publico.active = true;

				 
				   //Saw that one coming!
				   shad_attack_saw = new FlxSprite();
				   shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
				   shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
				   shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
				   shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
				   shad_attack_saw.antialiasing = true;
				   shad_attack_saw.setPosition(-860,615);

				   //Alert!
				   shad_attack_alert = new FlxSprite();
				   shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
				   shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
				   shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
				   shad_attack_alert.antialiasing = true;
				   shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
				   shad_attack_alert.cameras = [camHUD];
				   shad_attack_alert.screenCenter(XY);

				   var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
				   uno.setGraphicSize(Std.int(uno.width * 0.9));
				   uno.updateHitbox();
				   uno.antialiasing = FlxG.save.data.antialiasing;
				   uno.scrollFactor.set(1.3, 1.3);
				   uno.active = true;
				   uno.screenCenter(XY);
	  
				if (SONG.player1 == 'uwu')
					{
						defaultCamZoom = 0.90;
						curStage = 'permadeath';
						
						
						var shulket = Paths.getSparrowAtlas('fondito/bg_mc_noche');
						fondito = new FlxSprite(-700, -200);
						fondito.frames = shulket;
						fondito.animation.addByPrefix('idle', 'BG Noshe');
						fondito.animation.play('idle');
						fondito.antialiasing = true;
					
						add(fondito);

						//Saw that one coming!
						shad_attack_saw = new FlxSprite();
						shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
						shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
						shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
						shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
						shad_attack_saw.antialiasing = true;
						shad_attack_saw.setPosition(-860,615);

						//Alert!
						shad_attack_alert = new FlxSprite();
						shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
						shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
						shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
						shad_attack_alert.antialiasing = true;
						shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
						shad_attack_alert.cameras = [camHUD];
						shad_attack_alert.screenCenter(XY);

						publico.frames = Paths.getSparrowAtlas('fondito/publico61');
						publico.animation.addByPrefix('idle', 'publico61', 24);
						publico.animation.play('idle');
						publico.updateHitbox();
						publico.active = true;

						var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
						uno.setGraphicSize(Std.int(uno.width * 0.9));
						uno.updateHitbox();
						uno.antialiasing = FlxG.save.data.antialiasing;
						uno.scrollFactor.set(1.3, 1.3);
						uno.active = true;
						uno.screenCenter(XY);
					}
			 } 
			  case 'you-are-mine':
				 {
				  defaultCamZoom = 0.90;
				  curStage = 'you-are-mine';
	  
				  var shulket = Paths.getSparrowAtlas('fondito_noche');
				  fondito = new FlxSprite(-700, -200);
				  fondito.frames = shulket;
				  fondito.animation.addByPrefix('idle', 'fondo animate pne');
				  fondito.animation.play('idle');
				  fondito.antialiasing = true;
				  fondito.scrollFactor.set(0.9, 0.9);
				  add(fondito);
	  
				  espada = new FlxSprite(0, 100);
				  espada.x += 500;
				  espada.frames = Paths.getSparrowAtlas("fondito/shulket");
				  espada.animation.addByPrefix('idle', 'shulket', 20, true);
				  espada.animation.play('idle');
				  espada.antialiasing = true;
				  add(espada);
			  
				  
				  publico.frames = Paths.getSparrowAtlas('fondito/publico61');
				  publico.animation.addByPrefix('idle', 'publico61', 24);
				  publico.animation.play('idle');
				  publico.updateHitbox();
				  publico.active = true;

				  
					//Saw that one coming!
					shad_attack_saw = new FlxSprite();
					shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
					shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
					shad_attack_saw.antialiasing = true;
					shad_attack_saw.setPosition(-860,615);

					//Alert!
					shad_attack_alert = new FlxSprite();
					shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
					shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
					shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
					shad_attack_alert.antialiasing = true;
					shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
					shad_attack_alert.cameras = [camHUD];
					shad_attack_alert.screenCenter(XY);

					var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
					uno.setGraphicSize(Std.int(uno.width * 0.9));
					uno.updateHitbox();
					uno.antialiasing = FlxG.save.data.antialiasing;
					uno.scrollFactor.set(1.3, 1.3);
					uno.active = true;
					uno.screenCenter(XY);
	   
				  if (SONG.player1 == 'uwu')
					{
						defaultCamZoom = 0.90;
						curStage = 'you-are-mine';
						
						var shulket = Paths.getSparrowAtlas('fondito/bg_mc_noche');
						fondito = new FlxSprite(-700, -200);
						fondito.frames = shulket;
						fondito.animation.addByPrefix('idle', 'BG Noshe');
						fondito.animation.play('idle');
						fondito.antialiasing = true;
					
						add(fondito);

						//Saw that one coming!
						shad_attack_saw = new FlxSprite();
						shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
						shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
						shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
						shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
						shad_attack_saw.antialiasing = true;
						shad_attack_saw.setPosition(-860,615);

						//Alert!
						shad_attack_alert = new FlxSprite();
						shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
						shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
						shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
						shad_attack_alert.antialiasing = true;
						shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
						shad_attack_alert.cameras = [camHUD];
						shad_attack_alert.screenCenter(XY);

						publico.frames = Paths.getSparrowAtlas('fondito/publico61');
						publico.animation.addByPrefix('idle', 'publico61', 24);
						publico.animation.play('idle');
						publico.updateHitbox();
						publico.active = true;

						var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
						uno.setGraphicSize(Std.int(uno.width * 0.9));
						uno.updateHitbox();
						uno.antialiasing = FlxG.save.data.antialiasing;
						uno.scrollFactor.set(1.3, 1.3);
						uno.active = true;
						uno.screenCenter(XY);
					}
			  } 
			  case 'Termination':
				{
				 defaultCamZoom = 0.90;
				 curStage = 'Termination';
	 
				 var shulket = Paths.getSparrowAtlas('fondito_noche');
				 fondito = new FlxSprite(-700, -200);
				 fondito.frames = shulket;
				 fondito.animation.addByPrefix('idle', 'fondo animate pne');
				 fondito.animation.play('idle');
				 fondito.antialiasing = true;
				 fondito.scrollFactor.set(0.9, 0.9);
				 add(fondito);
	 
				 espada = new FlxSprite(0, 100);
				 espada.x += 500;
				 espada.frames = Paths.getSparrowAtlas("fondito/shulket");
				 espada.animation.addByPrefix('idle', 'shulket', 20, true);
				 espada.animation.play('idle');
				 espada.antialiasing = true;
				 add(espada);
			 
				 
				 publico.frames = Paths.getSparrowAtlas('fondito/publico61');
				 publico.animation.addByPrefix('idle', 'publico61', 24);
				 publico.animation.play('idle');
				 publico.updateHitbox();
				 publico.active = true;

				 
					   //Saw that one coming!
					   shad_attack_saw = new FlxSprite();
					   shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
					   shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					   shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					   shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
					   shad_attack_saw.antialiasing = true;
					   shad_attack_saw.setPosition(-860,615);

					   //Alert!
					   shad_attack_alert = new FlxSprite();
					   shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
					   shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
					   shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
					   shad_attack_alert.antialiasing = true;
					   shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
					   shad_attack_alert.cameras = [camHUD];
					   shad_attack_alert.screenCenter(XY);

					   var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
					   uno.setGraphicSize(Std.int(uno.width * 0.9));
					   uno.updateHitbox();
					   uno.antialiasing = FlxG.save.data.antialiasing;
					   uno.scrollFactor.set(1.3, 1.3);
					   uno.active = true;
					   uno.screenCenter(XY);
	  
				 if (SONG.player1 == 'uwu')
				   {
					   defaultCamZoom = 0.90;
					   curStage = 'Termination';
					   
					   var shulket = Paths.getSparrowAtlas('fondito/bg_mc_noche');
					   fondito = new FlxSprite(-700, -200);
					   fondito.frames = shulket;
					   fondito.animation.addByPrefix('idle', 'BG Noshe');
					   fondito.animation.play('idle');
					   fondito.antialiasing = true;
				   
					   add(fondito);

					   //Saw that one coming!
					   shad_attack_saw = new FlxSprite();
					   shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
					   shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					   shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					   shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
					   shad_attack_saw.antialiasing = true;
					   shad_attack_saw.setPosition(-860,615);

					   //Alert!
					   shad_attack_alert = new FlxSprite();
					   shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
					   shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
					   shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
					   shad_attack_alert.antialiasing = true;
					   shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
					   shad_attack_alert.cameras = [camHUD];
					   shad_attack_alert.screenCenter(XY);

					   publico.frames = Paths.getSparrowAtlas('fondito/publico61');
					   publico.animation.addByPrefix('idle', 'publico61', 24);
					   publico.animation.play('idle');
					   publico.updateHitbox();
					   publico.active = true;

					   var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
					   uno.setGraphicSize(Std.int(uno.width * 0.9));
					   uno.updateHitbox();
					   uno.antialiasing = FlxG.save.data.antialiasing;
					   uno.scrollFactor.set(1.3, 1.3);
					   uno.active = true;
					   uno.screenCenter(XY);
				   }
			 } 
			  case 'shadoune':
				 {
					defaultCamZoom = 0.90;
					curStage = 'shadoune';
		
					var shulket = Paths.getSparrowAtlas('fondito');
					fondito = new FlxSprite(-700, -200);
					fondito.frames = shulket;
					fondito.animation.addByPrefix('idle', 'fondo animate pne');
					fondito.animation.play('idle');
					fondito.antialiasing = true;
					fondito.scrollFactor.set(0.9, 0.9);
					add(fondito);
		
					espada = new FlxSprite(0, 100);
					espada.x += 500;
					espada.frames = Paths.getSparrowAtlas("fondito/shulket");
					espada.animation.addByPrefix('idle', 'shulket', 20, true);
					espada.animation.play('idle');
					espada.antialiasing = true;
					add(espada);
				
					
					publico.frames = Paths.getSparrowAtlas('fondito/publico61');
					publico.animation.addByPrefix('idle', 'publico61', 24);
					publico.animation.play('idle');
					publico.updateHitbox();
					publico.active = true;
					
   
					//Saw that one coming!
				   shad_attack_saw = new FlxSprite();
				   shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
				   shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
				   shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
				   shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
				   shad_attack_saw.antialiasing = true;
				   shad_attack_saw.setPosition(-860,615);
   
				   //Alert!
				   shad_attack_alert = new FlxSprite();
				   shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
				   shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
				   shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
				   shad_attack_alert.antialiasing = true;
				   shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
				   shad_attack_alert.cameras = [camHUD];
				   shad_attack_alert.screenCenter(XY);

				   var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
				   uno.setGraphicSize(Std.int(uno.width * 0.9));
				   uno.updateHitbox();
				   uno.antialiasing = FlxG.save.data.antialiasing;
				   uno.scrollFactor.set(1.3, 1.3);
				   uno.active = true;
				   uno.screenCenter(XY);
				   
					
					
		
				   if (SONG.player1 == 'uwu')
					   {
						   defaultCamZoom = 0.90;
						   curStage = 'shadoune';
						   
						   var shulket = Paths.getSparrowAtlas('fondito/bg_mc');
						   fondito = new FlxSprite(-700, -200);
						   fondito.frames = shulket;
						   fondito.animation.addByPrefix('idle', 'BGG');
						   fondito.animation.play('idle');
						   fondito.antialiasing = true;

						   add(fondito);
   
						   //Saw that one coming!
						   shad_attack_saw = new FlxSprite();
						   shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
						   shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
						   shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
						   shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
						   shad_attack_saw.antialiasing = true;
						   shad_attack_saw.setPosition(-860,615);
   
						   //Alert!
						   shad_attack_alert = new FlxSprite();
						   shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
						   shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
						   shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
						   shad_attack_alert.antialiasing = true;
						   shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
						   shad_attack_alert.cameras = [camHUD];
						   shad_attack_alert.screenCenter(XY);
   
						   publico.frames = Paths.getSparrowAtlas('fondito/publico61');
						   publico.animation.addByPrefix('idle', 'publico61', 24);
						   publico.animation.play('idle');
						   publico.updateHitbox();
						   publico.active = true;

						   var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
						   uno.setGraphicSize(Std.int(uno.width * 0.9));
						   uno.updateHitbox();
						   uno.antialiasing = FlxG.save.data.antialiasing;
						   uno.scrollFactor.set(1.3, 1.3);
						   uno.active = true;
						   uno.screenCenter(XY);
					   }
			 } 
			  case 'decition':
			 {
				 
				 defaultCamZoom = 0.90;
				 curStage = 'decition';
	 
				 var shulket = Paths.getSparrowAtlas('fondito');
				 fondito = new FlxSprite(-700, -200);
				 fondito.frames = shulket;
				 fondito.animation.addByPrefix('idle', 'fondo animate pne');
				 fondito.animation.play('idle');
				 fondito.antialiasing = true;
				 fondito.scrollFactor.set(0.9, 0.9);
				 add(fondito);
	 
				 espada = new FlxSprite(0, 100);
				 espada.x += 500;
				 espada.frames = Paths.getSparrowAtlas("fondito/shulket");
				 espada.animation.addByPrefix('idle', 'shulket', 20, true);
				 espada.animation.play('idle');
				 espada.antialiasing = true;
				 add(espada);
			 
				 
				 publico.frames = Paths.getSparrowAtlas('fondito/publico61');
				 publico.animation.addByPrefix('idle', 'publico61', 24);
				 publico.animation.play('idle');
				 publico.updateHitbox();
				 publico.active = true;
				 

				 //Saw that one coming!
				shad_attack_saw = new FlxSprite();
				shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
				shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
				shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
				shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
				shad_attack_saw.antialiasing = true;
				shad_attack_saw.setPosition(-860,615);

				//Alert!
				shad_attack_alert = new FlxSprite();
				shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
				shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
				shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
				shad_attack_alert.antialiasing = true;
				shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
				shad_attack_alert.cameras = [camHUD];
				shad_attack_alert.screenCenter(XY);

				var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
				uno.setGraphicSize(Std.int(uno.width * 0.9));
				uno.updateHitbox();
				uno.antialiasing = FlxG.save.data.antialiasing;
				uno.scrollFactor.set(1.3, 1.3);
				uno.active = true;
				uno.screenCenter(XY);
				
				 
				 
	 
				if (SONG.player1 == 'uwu')
					{
						defaultCamZoom = 0.90;
						curStage = 'decition';
						
						  
						var shulket = Paths.getSparrowAtlas('fondito/bg_mc');
						fondito = new FlxSprite(-700, -200);
						fondito.frames = shulket;
						fondito.animation.addByPrefix('idle', 'BGG');
						fondito.animation.play('idle');
						fondito.antialiasing = true;
						
						add(fondito);

						//Saw that one coming!
						shad_attack_saw = new FlxSprite();
						shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
						shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
						shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
						shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
						shad_attack_saw.antialiasing = true;
						shad_attack_saw.setPosition(-860,615);

						//Alert!
						shad_attack_alert = new FlxSprite();
						shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
						shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
						shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
						shad_attack_alert.antialiasing = true;
						shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
						shad_attack_alert.cameras = [camHUD];
						shad_attack_alert.screenCenter(XY);

						publico.frames = Paths.getSparrowAtlas('fondito/publico61');
						publico.animation.addByPrefix('idle', 'publico61', 24);
						publico.animation.play('idle');
						publico.updateHitbox();
						publico.active = true;

						var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
						uno.setGraphicSize(Std.int(uno.width * 0.9));
						uno.updateHitbox();
						uno.antialiasing = FlxG.save.data.antialiasing;
						uno.scrollFactor.set(1.3, 1.3);
						uno.active = true;
						uno.screenCenter(XY);
					}
				 
			  } 
			  case 'shadlocked':
			 {
				 defaultCamZoom = 0.90;
				 curStage = 'shadlocked';
	 
				 var shulket = Paths.getSparrowAtlas('fondito');
				 fondito = new FlxSprite(-700, -200);
				 fondito.frames = shulket;
				 fondito.animation.addByPrefix('idle', 'fondo animate pne');
				 fondito.animation.play('idle');
				 fondito.antialiasing = true;
				 fondito.scrollFactor.set(0.9, 0.9);
				 add(fondito);
	 
				 espada = new FlxSprite(0, 100);
				 espada.x += 500;
				 espada.frames = Paths.getSparrowAtlas("fondito/shulket");
				 espada.animation.addByPrefix('idle', 'shulket', 20, true);
				 espada.animation.play('idle');
				 espada.antialiasing = true;
				 add(espada);
		 
				 publico.frames = Paths.getSparrowAtlas('fondito/publico61');
				 publico.animation.addByPrefix('idle', 'publico61', 24);
				 publico.animation.play('idle');
				 publico.updateHitbox();
				 publico.active = true;

				 var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
				 uno.setGraphicSize(Std.int(uno.width * 0.9));
				 uno.updateHitbox();
				 uno.antialiasing = FlxG.save.data.antialiasing;
				 uno.scrollFactor.set(1.3, 1.3);
				 uno.active = true;
				 uno.screenCenter(XY);

				 if (SONG.player1 == 'uwu')
					{
						defaultCamZoom = 0.90;
						curStage = 'shadlocked';
						
						  
						var shulket = Paths.getSparrowAtlas('fondito/bg_mc');
						fondito = new FlxSprite(-700, -200);
						fondito.frames = shulket;
						fondito.animation.addByPrefix('idle', 'BGG');
						fondito.animation.play('idle');
						fondito.antialiasing = true;
						
						add(fondito);

						//Saw that one coming!
						shad_attack_saw = new FlxSprite();
						shad_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'shared');
						shad_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
						shad_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
						shad_attack_saw.setGraphicSize(Std.int(shad_attack_saw.width * 1.15));
						shad_attack_saw.antialiasing = true;
						shad_attack_saw.setPosition(-860,615);

						//Alert!
						shad_attack_alert = new FlxSprite();
						shad_attack_alert.frames = Paths.getSparrowAtlas('bonus/warningsword', 'shared');
						shad_attack_alert.animation.addByPrefix('alert', 'WarningSword', 24, false);	
						shad_attack_alert.animation.addByPrefix('alertDOUBLE', 'WarningSwordDouble', 24, false);	
						shad_attack_alert.antialiasing = true;
						shad_attack_alert.setGraphicSize(Std.int(shad_attack_alert.width * 1));
						shad_attack_alert.cameras = [camHUD];
						shad_attack_alert.screenCenter(XY);

						publico.frames = Paths.getSparrowAtlas('fondito/publico61');
						publico.animation.addByPrefix('idle', 'publico61', 24);
						publico.animation.play('idle');
						publico.updateHitbox();
						publico.active = true;

						var uno:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('uno'));
						uno.setGraphicSize(Std.int(uno.width * 0.9));
						uno.updateHitbox();
						uno.antialiasing = FlxG.save.data.antialiasing;
						uno.scrollFactor.set(1.3, 1.3);
						uno.active = true;
						uno.screenCenter(XY);
					}
			 }
			case 'stage':
				{
						defaultCamZoom = 0.9;
						curStage = 'stage';
						var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
						bg.antialiasing = FlxG.save.data.antialiasing;
						bg.scrollFactor.set(0.9, 0.9);
						bg.active = false;
						add(bg);
	
						var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
						stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
						stageFront.updateHitbox();
						stageFront.antialiasing = FlxG.save.data.antialiasing;
						stageFront.scrollFactor.set(0.9, 0.9);
						stageFront.active = false;
						add(stageFront);
	
						var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
						stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
						stageCurtains.updateHitbox();
						stageCurtains.antialiasing = FlxG.save.data.antialiasing;
						stageCurtains.scrollFactor.set(1.3, 1.3);
						stageCurtains.active = false;
	
						add(stageCurtains);
				}
			default:
			{
					defaultCamZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					add(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = FlxG.save.data.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					add(stageCurtains);
			}
		}
		}
		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gfnoche':
				curGf = 'gfnoche';
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			default:
				curGf = 'gf';
		}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		var dadxoffset:Float = 0;
		var dadyoffset:Float = 0;
		var bfxoffset:Float = 0;
		var bfyoffset:Float = 0;
		if (PlayStateChangeables.flip)
		{
			dad = new Character(770, 450, SONG.player1, true);
			boyfriend = new Boyfriend(100, 100, SONG.player2, false);
		}
		else
		{
			dad = new Character(100, 100, SONG.player2, false);
			boyfriend = new Boyfriend(770, 450, SONG.player1, true);
		}

		var dadcharacter:String = SONG.player2;


		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		if (PlayStateChangeables.flip)
			camPos.set(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

				case 'gfnoche':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dadyoffset += 200;
			case "monster":
				dadyoffset += 100;
			case 'monster-christmas':
				dadyoffset += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dadyoffset += 300;
			case 'parents-christmas':
				dadxoffset -= 500;
			case 'senpai':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				if (FlxG.save.data.distractions)
					{
						// trailArea.scrollFactor.set();
						if (!PlayStateChangeables.Optimize)
						{
							var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
							// evilTrail.changeValuesEnabled(false, false, false, false);
							// evilTrail.changeGraphic()
							add(evilTrail);
						}
						// evilTrail.scrollFactor.set(1.1, 1.1);
					}
				dadxoffset -= 150;
				dadyoffset += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'shadoune':
				dadxoffset += -220;
				dadyoffset += 120;
			case 'shadounearmor':
				dadxoffset += -180;
				dadyoffset += 100;	
		}


		


		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				bfyoffset -= 220;
				bfxoffset += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				bfxoffset += 200;

			case 'mallEvil':
				bfxoffset += 320;
				dadyoffset -= 80;
			case 'school':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
				
				case 'shadoune':
					gf.x += 200;
					gf.y += 1;
						
				case 'permadeath':
					gf.x += 200;
					gf.y += 1;

					if (dad.curCharacter == 'shadounearmor')
						{
							if (FlxG.save.data.distractions)
								{
									// trailArea.scrollFactor.set();
									if (!PlayStateChangeables.Optimize)
										{	
											fantasma = new FlxTrail(dad, null, 1, 10, 0.5, 0.070);
											add(fantasma);
										}
								}
						}

				
					
	
				case 'shadlocked':
					gf.x += 200;
					gf.y += 1;
				
				
	
				case 'you-are-mine':
						gf.x += 200;
						gf.y += 1;
	
				case 'decition':
					gf.x += 200;
					gf.y += 1;	

		}
		if (PlayStateChangeables.flip)
		{
			boyfriend.x += dadxoffset;
			boyfriend.y += dadyoffset;
			dad.x += bfxoffset;
			dad.y += bfyoffset;
		}
		else
		{
			dad.x += dadxoffset;
			dad.y += dadyoffset;
			boyfriend.x += bfxoffset;
			boyfriend.y += bfyoffset;
		}

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			add(dad);
			add(boyfriend);
			if (SONG.player1 == 'uwu')
				{
					if (curStage == 'decition')
						add(publico);	
					if (curStage == 'shadoune')
						add(publico);	
					if (curStage == 'permadeath')
						add(publico);	
					if (curStage == 'you-are-mine')
						add(publico);	
					if (curStage == 'shadlocked')
						add(publico);	
				}
		
		}


		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

  
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(noteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		/*for(i in unspawnNotes)
			{
				var dunceNote:Note = i;
				notes.add(dunceNote);
				if (executeModchart)
				{
					if (!dunceNote.isSustainNote)
						dunceNote.cameras = [camNotes];
					else
						dunceNote.cameras = [camSustains];
				}
				else
				{
					dunceNote.cameras = [camHUD];
				}
			}
	
			if (startTime != 0)
				{
					var toBeRemoved = [];
					for(i in 0...notes.members.length)
					{
						var dunceNote:Note = notes.members[i];
		
						if (dunceNote.strumTime - startTime <= 0)
							toBeRemoved.push(dunceNote);
						else 
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
							}
							else
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
							}
						}
					}
		
					for(i in toBeRemoved)
						notes.members.remove(i);
				}*/

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

			
		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);


		if (!PlayStateChangeables.flip)
			{
				healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
				switch (SONG.player2)
				{
					case 'shadoune':
						healthBar.createFilledBar(0xFF111111, 0xFF2E9AFE);
					case 'shadounearmor':
						healthBar.createFilledBar(0xFF3A105D, 0xFF2E9AFE);
					case 'gf' | 'gf-noche':
						healthBar.createFilledBar(0xFFFF0000, 0xFF0097C4);
					case 'dad' | 'mom-car' | 'parents-christmas':
						healthBar.createFilledBar(0xFF5A07F5, 0xFF0097C4);
					case 'spooky':
						healthBar.createFilledBar(0xFFF57E07, 0xFF0097C4);
					case 'monster-christmas' | 'monster':
						healthBar.createFilledBar(0xFFF5DD07, 0xFF0097C4);
					case 'pico':
						healthBar.createFilledBar(0xFF52B514, 0xFF0097C4);
					case 'senpai' | 'senpai-angry':
						healthBar.createFilledBar(0xFFF76D6D, 0xFF0097C4);
					case 'spirit':
						healthBar.createFilledBar(0xFFAD0505, 0xFF0097C4);
				}
			}
			else
			{
				healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, LEFT_TO_RIGHT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFF66FF33, 0xFFFF0000);
				switch (SONG.player2)
				{
				case 'shadoune':
					healthBar.createFilledBar(0xFF111111, 0xFF2E9AFE);
				case 'shadounearmor':
					healthBar.createFilledBar(0xFF3A105D, 0xFF2E9AFE);
					case 'gf' | 'gf-noche':
				healthBar.createFilledBar(0xFFFF0000, 0xFF0097C4);
				case 'dad' | 'mom-car' | 'parents-christmas':
				healthBar.createFilledBar(0xFF5A07F5, 0xFF0097C4);
				case 'spooky':
				healthBar.createFilledBar(0xFFF57E07, 0xFF0097C4);
				case 'monster-christmas' | 'monster':
				healthBar.createFilledBar(0xFFF5DD07, 0xFF0097C4);
				case 'pico':
				healthBar.createFilledBar(0xFF52B514, 0xFF0097C4);
				case 'senpai' | 'senpai-angry':
				healthBar.createFilledBar(0xFFF76D6D, 0xFF0097C4);
				case 'spirit':
				healthBar.createFilledBar(0xFFAD0505, 0xFF0097C4);
				}
			}
		// healthBar
		add(healthBar);

		overhealthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 2.2, 4);
		overhealthBar.scrollFactor.set();
		overhealthBar.createFilledBar(0x00000000, 0xFFFFFF00);
		// healthBar
		add(overhealthBar);

		
		/*if (healthDrainVerifi == true)
			{
					


							fire = new FlxSprite(0, FlxG.height * 1).loadGraphic(Paths.image('FIRE'));
							if (PlayStateChangeables.useDownscroll)
								{	
									fire.y = 50;
								}
								
							fire.screenCenter(X);
							fire.scrollFactor.set();
							add(fire);

							
							
							//new FlxTimer().start(0.01, ?OnComplete:FlxTimer ‑> Void, Loops:Int = 1):FlxTimer

							new FlxTimer().start(0.01, function(tmr:FlxTimer)
								{
									remove(fire);
									
									
									add(fire);

						

																
								}, 300);

								//no se timers ayudaaaa


								//talves sea el coso de fire dentro de {} , aun no lo compruebo xd
						
									//mrz acuerdate lo  del shadoune chikito que ya lleva mas de un mes sin fixear

									//ya el dommingo xd

								
								x - izquierda + derecha
								y - arriba + abajo
								
								 character.hx:
								x - derecha + izquierda
								y - abajo + arriba
								
								//xddddd
				
			} */
		
			

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,healthBarBG.y + 50,0,SONG.song + " - " + CoolUtil.difficultyFromInt(storyDifficulty) + (Main.watermarks ? "| VS SHADOUNE": ""), 16);
		kadeEngineWatermark.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		
			/*
			x - izquierda + derecha
			y - arriba + abajo
			*/
			/* character.hx:
			x - derecha + izquierda
			y - abajo + arriba
			*/
			//xddddd

			var credits:String;
			switch (SONG.song.toLowerCase())
			{
				case 'shadoune':
					credits = 'Original Song made by Fasion';
				case 'decition':
					credits = 'Original Song made by Sinesita';
				case 'you-are-mine':
					credits = 'Original Song made by Sinesita';
				case 'permadeath':
					credits = 'Original Song made by Spark Wolf';
				case 'shadlocked':
					credits = 'Original Song made by F-777';
				case 'rainbow':
					credits = 'Original Song made by Kitsune²';
				case 'Termination':
					credits = 'Original Song made by Hazardous24';
				default:
					credits = '';
			}
			var creditsText:Bool = credits != '';
			var textYPos:Float = healthBarBG.y + 50;
			if (creditsText)
			{
				textYPos = healthBarBG.y + 30;
			}
		/*if (SONG.song.toLowerCase() == 'decition')
			{
				var creditos:FlxText = new FlxText(0,healthBarBG.y + 60,0, "Original song by Sinesita", 12);
				creditos.scrollFactor.set();
				creditos.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				creditos.cameras = [camHUD];
				add(creditos);
				/*var creditos = new FlxText(0,healthBarBG.y + 50,0 + "riginal song by Sinesita", 16);
				creditos.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				creditos.scrollFactor.set();
				add(creditos);

				//aun no lo compreubo xd
			}*/
			if (creditsText)
				{
					var creditsWatermark = new FlxText(4, healthBarBG.y + 30, 0, credits, 16);
					creditsWatermark.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					creditsWatermark.scrollFactor.set();
					add(creditsWatermark);
					creditsWatermark.cameras = [camHUD];
				}


			//mrz del futuro tu lo arreglas ok xd
			//aun no lo compruebo xd


		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("minecraftia.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("minecraftia.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		noteSplashes.cameras = [camNotes];
		strumLineNotes.cameras = [camNotes];
		notes.cameras = [camNotes];
		healthBar.cameras = [camHUD];
		overhealthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
					case 'permadeath':
						schoolIntro(doof);
						camPos.set(dad.getGraphicMidpoint().x = 600, dad.getGraphicMidpoint().y);
						/*
						dad.alpha = 0;
						boyfriend.alpha = 0;
						//webada que salio mal xd
						*/
					case 'shadoune':
						schoolIntro(doof);
					case 'decition':
						schoolIntro(doof);
					case 'you-are-mine':
						schoolIntro(doof);	
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);

		super.create();
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'roses' || StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
		{
			remove(black);

			if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
			{
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					inCutscene = true;

					if (StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	var keys = [false, false, false, false, false, false, false, false, false];

	function startCountdown():Void
	{
		inCutscene = false;


		generateStaticArrows(0);
		generateStaticArrows(1);

		switch(mania) //moved it here because i can lol
		{
			case 0: 
				keys = [false, false, false, false];
			case 1: 
				keys = [false, false, false, false, false, false];
			case 2: 
				keys = [false, false, false, false, false, false, false, false, false];
			case 3: 
				keys = [false, false, false, false, false];
			case 4: 
				keys = [false, false, false, false, false, false, false];
			case 5: 
				keys = [false, false, false, false, false, false, false, false];
			case 6: 
				keys = [false];
			case 7: 
				keys = [false, false];
			case 8: 
				keys = [false, false, false];
		}
	
		


		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end
		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;


	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}
	



	private function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);

		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		var data = -1;
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
		}

		


		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
	}

	public var closestNotes:Array<Note> = [];

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);
		var data = -1;
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}

		}

			for (i in 0...binds.length) // binds
				{
					if (binds[i].toLowerCase() == key.toLowerCase())
						data = i;
				}
				if (data == -1)
				{
					trace("couldn't find a keybind with the code " + key);
					return;
				}
				if (keys[data])
				{
					trace("ur already holding " + key);
					return;
				}
		
				keys[data] = true;
		
				var ana = new Ana(Conductor.songPosition, null, false, "miss", data);
		
				var dataNotes = [];
				for(i in closestNotes)
					if (i.noteData == data)
						dataNotes.push(i);

				
				if (!FlxG.save.data.gthm)
				{
					if (dataNotes.length != 0)
						{
							var coolNote = null;
				
							for (i in dataNotes)
								if (!i.isSustainNote)
								{
									coolNote = i;
									break;
								}
				
							if (coolNote == null) // Note is null, which means it's probably a sustain note. Update will handle this (HOPEFULLY???)
							{
								return;
							}
				
							if (dataNotes.length > 1) // stacked notes or really close ones
							{
								for (i in 0...dataNotes.length)
								{
									if (i == 0) // skip the first note
										continue;
				
									var note = dataNotes[i];
				
									if (!note.isSustainNote && (note.strumTime - coolNote.strumTime) < 2)
									{
										trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
										// just fuckin remove it since it's a stacked note and shouldn't be there
										note.kill();
										notes.remove(note, true);
										note.destroy();
									}
								}
							}
				
							goodNoteHit(coolNote);
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							ana.hit = true;
							ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
							ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
						
						}
					else if (!FlxG.save.data.ghost && songStarted && !grace)
						{
							noteMiss(data, null);
							ana.hit = false;
							ana.hitJudge = "shit";
							ana.nearestNote = [];
							//health -= 0.20;
						}
				}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		bfCanDodge = true;
		hazardRandom = FlxG.random.int(1, 5);
		/*if(curSong.toLowerCase() == 'tutorial'){ //Change this so that they appear when the relevant function is first called!!!!
			add(shad_attack_alert);
			add(shad_attack_saw);
		}*/

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		if (FlxG.save.data.noteSplash)
			{
				switch (mania)
				{
					case 0: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red'];
					case 1: 
						NoteSplash.colors = ['purple', 'green', 'red', 'yellow', 'blue', 'darkblue'];	
					case 2: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 3: 
						NoteSplash.colors = ['purple', 'blue', 'white', 'green', 'red'];
						if (FlxG.save.data.gthc)
							NoteSplash.colors = ['green', 'red', 'yellow', 'darkblue', 'orange'];
					case 4: 
						NoteSplash.colors = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'darkblue'];
					case 5: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 6: 
						NoteSplash.colors = ['white'];
					case 7: 
						NoteSplash.colors = ['purple', 'red'];
					case 8: 
						NoteSplash.colors = ['purple', 'white', 'red'];
				}
			}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("minecraftia.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)



		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		//if (FlxG.save.data.randomNotes != "Regular" && FlxG.save.data.randomNotes != "None" && FlxG.save.data.randomNotes != "Section")
			//FlxG.save.data.randomNotes = "None";
		for (section in noteData)
		{
			var mn:Int = keyAmmo[mania];
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var dataForThisSection:Array<Int> = [];
			var randomDataForThisSection:Array<Int> = [];
			//var maxNoteData:Int = 3;
			switch (maniaToChange) //sets up the max data for each section based on mania
			{
				case 0: 
					dataForThisSection = [0,1,2,3];
				case 1: 
					dataForThisSection = [0,1,2,3,4,5];
				case 2: 
					dataForThisSection = [0,1,2,3,4,5,6,7,8];
				case 3: 
					dataForThisSection = [0,1,2,3,4];
				case 4: 
					dataForThisSection = [0,1,2,3,4,5,6];
				case 5: 
					dataForThisSection = [0,1,2,3,4,5,6,7];
				case 6: 
					dataForThisSection = [0];
				case 7: 
					dataForThisSection = [0,1];
				case 8: 
					dataForThisSection = [0,1,2];
			}
			if (PlayStateChangeables.randomNotes && PlayStateChangeables.randomSection)
			{
				for (i in 0...dataForThisSection.length) //point of this is to randomize per section, so each lane of notes will move together, its kinda hard to explain, but it give good charts so idc
				{
					var number:Int = dataForThisSection[FlxG.random.int(0, dataForThisSection.length - 1)];
					dataForThisSection.remove(number);
					randomDataForThisSection.push(number);
				}
			}

			for (songNotes in section.sectionNotes)
			{
				var isRandomNoteType:Bool = false;
				var isReplaceable:Bool = false;
				var newNoteType:Int = 0;
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % mn);
				var daNoteTypeData:Int = FlxG.random.int(0, mn - 1);


				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] >= mn)
				{
					gottaHitNote = !section.mustHitSection;

				}
				if (PlayStateChangeables.randomNotes)
				{
					switch(PlayStateChangeables.randomNoteTypes) //changes based on chance based on setting
					{
						case 0: 
							isRandomNoteType = false;
						case 1: 
							isRandomNoteType = FlxG.random.bool(1);
						case 2: 
							isRandomNoteType = FlxG.random.bool(5);
						case 3: 
							isRandomNoteType = FlxG.random.bool(15);
						case 4: 
							isRandomNoteType = FlxG.random.bool(75);
					}
				}

				if (isRandomNoteType && PlayStateChangeables.randomNotes)
				{
					if (FlxG.random.bool(50)) // 50/50 chance for a note type thats supposed to hit or a note that isnt supposed to be hit, ones that are supposed to be hit replace already existing notes, so it makes sense in the chart
					{
						isReplaceable = false;
						newNoteType = nonReplacableTypeList[FlxG.random.int(0,2)];
					}
					else
					{
						isReplaceable = true;
						newNoteType = replacableTypeList[FlxG.random.int(0,2)];
					}
				}

				if (PlayStateChangeables.bothSide)
				{
					if (!gottaHitNote)
					{
						switch(daNoteData) //did this cuz duets crash game / cause issues
						{
							case 0: 
								daNoteData = 4;
							case 1: 
								daNoteData = 5;
							case 2: 
								daNoteData = 6;
							case 3:
								daNoteData = 7;
							case 4: 
								daNoteData = 0;
							case 5: 
								daNoteData = 1;
							case 6: 
								daNoteData = 2;
							case 7:
								daNoteData = 3;
						}
					}
					else
						{
							switch(daNoteData)
							{
								case 0: 
									daNoteData = 0;
								case 1: 
									daNoteData = 1;
								case 2: 
									daNoteData = 2;
								case 3:
									daNoteData = 3;
								case 4: 
									daNoteData = 4;
								case 5: 
									daNoteData = 5;
								case 6: 
									daNoteData = 6;
								case 7:
									daNoteData = 7;
							}
						}
					if (daNoteData > 7) //failsafe
						daNoteData -= 4;
				}


				if (PlayStateChangeables.randomNotes && !PlayStateChangeables.randomSection)
					{
						if (daNoteData > 3) //fixes duets
							gottaHitNote = !gottaHitNote;
						daNoteData = FlxG.random.int(0, mn - 1); //regular randomizaton
					}
				else if (PlayStateChangeables.randomNotes && PlayStateChangeables.randomSection)
				{
					if (daNoteData > 3) //fixes duets
						gottaHitNote = !gottaHitNote;
					daNoteData = randomDataForThisSection[daNoteData]; //per section randomization
				}
				if (PlayStateChangeables.bothSide)
				{
					gottaHitNote = true; //both side
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];
				if (isRandomNoteType && newNoteType != 0 && isReplaceable)
				{
					daType = newNoteType;
				}

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);

				var fuckYouNote:Note; //note type placed next to other note

				if (daNoteTypeData == daNoteData && daNoteTypeData == 0) //so it doesnt go over the other note, even though it still happens lol
					daNoteTypeData += 1;
				else if(daNoteTypeData == daNoteData)
					daNoteTypeData -= 1;

				if (isRandomNoteType && !isReplaceable)
				{
					fuckYouNote = new Note(daStrumTime, daNoteTypeData, swagNote, false, newNoteType); //note types that you arent supposed to hit
					fuckYouNote.scrollFactor.set(0, 0);
				}
				else
				{
					fuckYouNote = null;
					//fuckYouNote.scrollFactor.set(0, 0);
				}
					

				

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (susLength > 0)
					swagNote.isParent = true;

				var type = 0;

				if (isRandomNoteType && !isReplaceable)
					unspawnNotes.push(fuckYouNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					if (PlayStateChangeables.flip)
						sustainNote.mustPress = !gottaHitNote;
					else
						sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
					sustainNote.parent = swagNote;
					swagNote.children.push(sustainNote);
					sustainNote.spotInLine = type;
					type++;
				}

				if (PlayStateChangeables.flip) //flips the charts epic
				{
					swagNote.mustPress = !gottaHitNote;
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.mustPress = !gottaHitNote;
				}
				else
				{
					swagNote.mustPress = gottaHitNote;
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.mustPress = gottaHitNote;
				}
					


				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.x += FlxG.width / 2;
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		var index = 0;
		strumLineNotes.forEach(function(babyArrow:FlxSprite)
		{
			if (isStoryMode && !FlxG.save.data.middlescroll || executeModchart)
				babyArrow.alpha = 1;
			if (index > 3 && FlxG.save.data.middlescroll)
				babyArrow.alpha = 1;
			index++;
		});

		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);



			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

			if (SONG.noteStyle == null) {
				switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
			} else {noteTypeCheck = SONG.noteStyle;}


			switch (noteTypeCheck)
			{
				case 'shadoune':

							babyArrow.frames = Paths.getSparrowAtlas('notes/cool_notes');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				
				
				case 'decition':

					babyArrow.frames = Paths.getSparrowAtlas('notes/cool_notes');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				

				case 'you-are-mine':

					babyArrow.frames = Paths.getSparrowAtlas('notes/cool_notes_noche');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = true;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));

					switch (Math.abs(i))
					{
						case 0:
							babyArrow.x += Note.swagWidth * 0;
							babyArrow.animation.addByPrefix('static', 'arrowLEFT');
							babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
						case 1:
							babyArrow.x += Note.swagWidth * 1;
							babyArrow.animation.addByPrefix('static', 'arrowDOWN');
							babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
						case 2:
							babyArrow.x += Note.swagWidth * 2;
							babyArrow.animation.addByPrefix('static', 'arrowUP');
							babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
						case 3:
							babyArrow.x += Note.swagWidth * 3;
							babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
							babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
							babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
					}
				
				case 'permadeath':

					babyArrow.frames = Paths.getSparrowAtlas('noteassets/NOTE_assets_noche');
					babyArrow.animation.addByPrefix('green', 'arrowUP');
					babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
					babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
					babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

					babyArrow.antialiasing = FlxG.save.data.antialiasing;
					babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));

					var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
					var pPre:Array<String> = ['purple', 'blue', 'green', 'red'];
						switch (mania)
						{
							case 1:
								nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
								pPre = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];

							case 2:
								nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
								pPre = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
								babyArrow.x -= Note.tooMuch;
							case 3: 
								nSuf = ['LEFT', 'DOWN', 'SPACE', 'UP', 'RIGHT'];
								pPre = ['purple', 'blue', 'white', 'green', 'red'];
								if (FlxG.save.data.gthc)
									{
										nSuf = ['UP', 'RIGHT', 'LEFT', 'RIGHT', 'UP'];
										pPre = ['green', 'red', 'yellow', 'dark', 'orange'];
									}
							case 4: 
								nSuf = ['LEFT', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'RIGHT'];
								pPre = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
							case 5: 
								nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
								pPre = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'];
							case 6: 
								nSuf = ['SPACE'];
								pPre = ['white'];
							case 7: 
								nSuf = ['LEFT', 'RIGHT'];
								pPre = ['purple', 'red'];
							case 8: 
								nSuf = ['LEFT', 'SPACE', 'RIGHT'];
								pPre = ['purple', 'white', 'red'];

						}
				
				babyArrow.x += Note.swagWidth * i;
				babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
				babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);

				
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('noteassets/pixel/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [11]);
					babyArrow.animation.add('red', [12]);
					babyArrow.animation.add('blue', [10]);
					babyArrow.animation.add('purplel', [9]);

					babyArrow.animation.add('white', [13]);
					babyArrow.animation.add('yellow', [14]);
					babyArrow.animation.add('violet', [15]);
					babyArrow.animation.add('black', [16]);
					babyArrow.animation.add('darkred', [16]);
					babyArrow.animation.add('orange', [16]);
					babyArrow.animation.add('dark', [17]);


					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom * Note.pixelnoteScale));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					var numstatic:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]; //this is most tedious shit ive ever done why the fuck is this so hard
					var startpress:Array<Int> = [9, 10, 11, 12, 13, 14, 15, 16, 17];
					var endpress:Array<Int> = [18, 19, 20, 21, 22, 23, 24, 25, 26];
					var startconf:Array<Int> = [27, 28, 29, 30, 31, 32, 33, 34, 35];
					var endconf:Array<Int> = [36, 37, 38, 39, 40, 41, 42, 43, 44];
						switch (mania)
						{
							case 1:
								numstatic = [0, 2, 3, 5, 1, 8];
								startpress = [9, 11, 12, 14, 10, 17];
								endpress = [18, 20, 21, 23, 19, 26];
								startconf = [27, 29, 30, 32, 28, 35];
								endconf = [36, 38, 39, 41, 37, 44];

							case 2: 
								babyArrow.x -= Note.tooMuch;
							case 3: 
								numstatic = [0, 1, 4, 2, 3];
								startpress = [9, 10, 13, 11, 12];
								endpress = [18, 19, 22, 20, 21];
								startconf = [27, 28, 31, 29, 30];
								endconf = [36, 37, 40, 38, 39];
							case 4: 
								numstatic = [0, 2, 3, 4, 5, 1, 8];
								startpress = [9, 11, 12, 13, 14, 10, 17];
								endpress = [18, 20, 21, 22, 23, 19, 26];
								startconf = [27, 29, 30, 31, 32, 28, 35];
								endconf = [36, 38, 39, 40, 41, 37, 44];
							case 5: 
								numstatic = [0, 1, 2, 3, 5, 6, 7, 8];
								startpress = [9, 10, 11, 12, 14, 15, 16, 17];
								endpress = [18, 19, 20, 21, 23, 24, 25, 26];
								startconf = [27, 28, 29, 30, 32, 33, 34, 35];
								endconf = [36, 37, 38, 39, 41, 42, 43, 44];
							case 6: 
								numstatic = [4];
								startpress = [13];
								endpress = [22];
								startconf = [31];
								endconf = [40];
							case 7: 
								numstatic = [0, 3];
								startpress = [9, 12];
								endpress = [18, 21];
								startconf = [27, 30];
								endconf = [36, 39];
							case 8: 
								numstatic = [0, 4, 3];
								startpress = [9, 13, 12];
								endpress = [18, 22, 21];
								startconf = [27, 31, 30];
								endconf = [36, 40, 39];


						}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.add('static', [numstatic[i]]);
					babyArrow.animation.add('pressed', [startpress[i], endpress[i]], 12, false);
					babyArrow.animation.add('confirm', [startconf[i], endconf[i]], 24, false);

					
				
					case 'normal':
						{
							babyArrow.frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');
		
							babyArrow.antialiasing = FlxG.save.data.antialiasing;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));
	
							var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
							var pPre:Array<String> = ['purple', 'blue', 'green', 'red'];
								switch (mania)
								{
									case 1:
										nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
	
									case 2:
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
										babyArrow.x -= Note.tooMuch;
									case 3: 
										nSuf = ['LEFT', 'DOWN', 'SPACE', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'white', 'green', 'red'];
										if (FlxG.save.data.gthc)
											{
												nSuf = ['UP', 'RIGHT', 'LEFT', 'RIGHT', 'UP'];
												pPre = ['green', 'red', 'yellow', 'dark', 'orange'];
											}
									case 4: 
										nSuf = ['LEFT', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
									case 5: 
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'];
									case 6: 
										nSuf = ['SPACE'];
										pPre = ['white'];
									case 7: 
										nSuf = ['LEFT', 'RIGHT'];
										pPre = ['purple', 'red'];
									case 8: 
										nSuf = ['LEFT', 'SPACE', 'RIGHT'];
										pPre = ['purple', 'white', 'red'];
	
								}
						
						babyArrow.x += Note.swagWidth * i;
						babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
						babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
						babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
						}						
			}
		

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				// babyArrow.alpha = 0;
				if (!FlxG.save.data.middlescroll || executeModchart || player == 1)
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				//babyArrow.y -= 10;
				//babyArrow.alpha = 0;
				//FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
					if (PlayStateChangeables.bothSide)
						babyArrow.x -= 500;
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;

			if (PlayStateChangeables.Optimize || FlxG.save.data.middlescroll)
				{	
					babyArrow.x -= 270;
				}
			

			if (PlayStateChangeables.flip)
			{
				
				switch (player)
				{
					case 0:
						babyArrow.x += ((FlxG.width / 2) * 1);
					case 1:
						babyArrow.x += ((FlxG.width / 2) * 0);
				}
			}
			else
				babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;

			if (PlayStateChangeables.bothSide)
				babyArrow.x -= 350;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;

	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;



	override public function update(elapsed:Float)
	{
		if (FlxG.save.data.shake)
			{
				if (shake == true)
					{
						FlxG.camera.shake(0.02, 0.02);
					}	
			}
		
		#if !debug
		perfectMode = false;
		#end

		if (generatedMusic)
			{
				for(i in notes)
				{
					var diff = i.strumTime - Conductor.songPosition;
					if (diff < 2650 && diff >= -2650)
					{
						i.active = true;
						i.visible = true;
					}
					else
					{
						i.active = false;
						i.visible = false;
					}
				}
			}

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				overhealthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				overhealthBar.visible = false;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...keyAmmo[mania])
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}

			camNotes.zoom = camHUD.zoom;
			camNotes.x = camHUD.x;
			camNotes.y = camHUD.y;
			camNotes.angle = camHUD.angle;
			camSustains.zoom = camHUD.zoom;
			camSustains.x = camHUD.x;
			camSustains.y = camHUD.y;
			camSustains.angle = camHUD.angle;
		}

		#end

		if (!FlxG.save.data.modchart)
			{
				#if windows
				if (luaModchart != null)
				{
					luaModchart.die();
					luaModchart = null;
				}
				#end
			}

		camNotes.zoom = camHUD.zoom;
		camNotes.x = camHUD.x;
		camNotes.y = camHUD.y;
		camNotes.angle = camHUD.angle;

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text =                                                                                                                                 Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 1250;

	

		if (controls.PAUSE && startedCountdown && canPause && !cannotDie)


		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}


		if (FlxG.keys.justPressed.SEVEN && songStarted)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			cannotDie = true;
			#if windows
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			Main.editor = true;
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if (!PlayStateChangeables.flip)
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);	
		}
		else
		{
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 100, 0, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}


		if (health > 4)
			health = 4;
		if (FlxG.save.data.health)
		{
			if (storyDifficulty == 3)
				if (health > 1)
					health = 1;
			if (SONG.song.toLowerCase() == "permadeath" && storyDifficulty == 3)
				if (health > 1.35)
					health = 1.35;
			//talves sea  health = health; pero me voy a comer chau mrz del futuro tu lo resuelves
			// no se, fuck you mrz del pasado	
		}
		
		



		if (!PlayStateChangeables.flip)
			{
				if (healthBar.percent < 20)
					iconP1.animation.curAnim.curFrame = 1;
				else
					iconP1.animation.curAnim.curFrame = 0;
		
				if (healthBar.percent > 80)
					iconP2.animation.curAnim.curFrame = 1;
				else
					iconP2.animation.curAnim.curFrame = 0;
			}
		else
		{
			if (healthBar.percent < 20)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;
	
			if (healthBar.percent > 80)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
		}

		/* if (FlxG.keys.justPressed.NINE)
			FlxG.switchState(new Charting()); */

			#if debug
			if (FlxG.keys.justPressed.EIGHT)
			{
				FlxG.switchState(new AnimationDebug(SONG.player2));
				#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end
			}
			
			#end

			if (FlxG.keys.pressed.SHIFT)
				
				{
					if (FlxG.keys.justPressed.EIGHT)
						{	
							FlxG.switchState(new AnimationDebug(SONG.player1));
					
							#if windows
							if (luaModchart != null)
							{
								luaModchart.die();
								luaModchart = null;
							}
							#end
						}
					
				}

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			currentSection = SONG.notes[Std.int(curStep / 16)];

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && currentSection != null)
		{
			closestNotes = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					closestNotes.push(daNote);
			}); // Collect notes that can be hit

			closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (closestNotes.length != 0)
				FlxG.watch.addQuick("Current Note",closestNotes[0].strumTime - Conductor.songPosition);
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",currentSection.mustHitSection);
			#end

			if (PlayStateChangeables.flip)
			{
				if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != dad.getMidpoint().x - 100)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
		
						camFollow.setPosition(dad.getMidpoint().x - 100 + offsetX, dad.getMidpoint().y - 200 + offsetY);
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoTurn', []);
						#end
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
						switch (curStage)
						{
							case 'limo':
								camFollow.x = dad.getMidpoint().x - 300;
							case 'mall':
								camFollow.y = dad.getMidpoint().y - 200;
							case 'school':
								camFollow.x = dad.getMidpoint().x - 200;
								camFollow.y = dad.getMidpoint().y - 200;
							case 'schoolEvil':
								camFollow.x = dad.getMidpoint().x - 200;
								camFollow.y = dad.getMidpoint().y - 200;
								case 'shadoune': 
									camFollow.x -= 385;
									camFollow.y -= 240;
								case 'shadounearmor':		
									camFollow.x -= 400;
									camFollow.y -= 240;
								case 'decition':
									camFollow.x -= 385;
									camFollow.y -= 240;
								case 'you-are-mine':
									camFollow.x -= 400;
									camFollow.y -= 240;
								case 'shadlocked':
									camFollow.x -= 385;
									camFollow.y -= 240;
									
						}

		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;
					}
		
					if (camFollow.x != boyfriend.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
						camFollow.setPosition(boyfriend.getMidpoint().x + 150 + offsetX, boyfriend.getMidpoint().y - 100 + offsetY);
		
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerOneTurn', []);
						#end
		


						/*
						x - izquierda + derecha
						y - arriba + abajo
						*/
						/* character.hx:
						x - derecha + izquierda
						y - abajo + arriba
						*/
						//xddddd
						switch (boyfriend.curCharacter)
						{
							case 'mom':
								camFollow.y = boyfriend.getMidpoint().y;
							case 'senpai':
								camFollow.y = boyfriend.getMidpoint().y - 430;
								camFollow.x = boyfriend.getMidpoint().x - 100;
							case 'senpai-angry':
								camFollow.y = boyfriend.getMidpoint().y - 430;
								camFollow.x = boyfriend.getMidpoint().x - 100;
								case 'bf':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'bfnoche':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'uwu':
									camFollow.x -= 200;
									camFollow.y -= 75;
								case 'shadlocked':
									camFollow.x -= 525;
									camFollow.y -= 280;
								case 'decition':
									camFollow.x -= 525;
									camFollow.y -= 280;
								case 'you-are-mine':
									camFollow.x -= 450;
									camFollow.y -= 75;
						}
					}
			}
			else
			{
				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
		
						camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoTurn', []);
						#end
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
		
						switch (dad.curCharacter)
						{
							case 'mom':
								camFollow.y = dad.getMidpoint().y;
							case 'senpai':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
							case 'senpai-angry':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
								case 'shadoune': 
									camFollow.x -= 385;
									camFollow.y -= 240;
								case 'shadounearmor':		
									camFollow.x -= 400;
									camFollow.y -= 240;
								case 'persimon':
									camFollow.x -= 400;
									camFollow.y -= 240;
								case 'you-are-mine':
									camFollow.x -= 400;
									camFollow.y -= 240;
								case 'shadlocked':
									camFollow.x -= 385;
									camFollow.y -= 240;
						}
		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 200 + offsetY);
		
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerOneTurn', []);
						#end
		
						switch (curStage)
						{
							case 'limo':
								camFollow.x = boyfriend.getMidpoint().x - 300;
							case 'mall':
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'school':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'schoolEvil':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;

								case 'shadoune':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'shadounearmor':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'permadeath':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'shadlocked':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'decition':
									camFollow.x -= 450;
									camFollow.y -= 75;
								case 'you-are-mine':
									camFollow.x -= 450;
									camFollow.y -= 75;
									//mrz del futuro revisa esto , aun no lo testeo yo


									//me da risa que si alguien ve esto va a pensar que tengo ezquisofrenia

									//pero si tienes

									//A 

									//tambien acuerdate de revisar lo del zoroforce engine no se xd
									// lo del middle scroll :VVVV


									// mrz del futuro el coso del cam ya esta listo pero acuerdate de hacer que los cosos del publico sea solo para el shadoune uwu

									// PTM de una vez has lo del middle scroll

									//ya lo hice pero esta raro xd
						}
					}
			}
		}

		if (camZooming)
		{
			if (FlxG.save.data.zoom < 0.8)
				FlxG.save.data.zoom = 0.8;
	
			if (FlxG.save.data.zoom > 1.2)
				FlxG.save.data.zoom = 1.2;
			if (!executeModchart)
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(FlxG.save.data.zoom, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
				else
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 && !cannotDie && FlxG.save.data.die)
		{
			
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			if(deathBySawBlade)
				{
					openSubState(new GameOverSWORD(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
				else
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					}

			

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (!inCutscene && FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					if(deathBySawBlade)
						{
							openSubState(new GameOverSWORD(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
						}
						else
							{
								openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
							}
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
			if (unspawnNotes[0] != null)	
			{
				if (unspawnNotes[0].strumTime - Conductor.songPosition < 3000) //backups
					{
						var dunceNote:Note = unspawnNotes[0];
						notes.add(dunceNote);
	
						var index:Int = unspawnNotes.indexOf(dunceNote);
						unspawnNotes.splice(index, 1);
					}
				if (unspawnNotes[0] != null)	
					{
						if (unspawnNotes[0].strumTime - Conductor.songPosition < 2500) //extra backup lol
							{
								var dunceNote:Note = unspawnNotes[0];
								notes.add(dunceNote);
				
								var index:Int = unspawnNotes.indexOf(dunceNote);
								unspawnNotes.splice(index, 1);
							}
					}
			}


		}

		switch(mania)
		{
			case 0: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 1: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
			case 2: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 3: 
				sDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'Hey', 'UP', 'RIGHT'];
			case 4: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'RIGHT'];
			case 5: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 6: 
				sDir = ['UP'];
				bfsDir = ['Hey'];
			case 7: 
				sDir = ['LEFT', 'RIGHT'];
				bfsDir = ['LEFT', 'RIGHT'];
			case 8:
				sDir = ['LEFT', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'Hey', 'RIGHT'];
		}

		if (generatedMusic)
			{
				switch(maniaToChange)
				{
					case 0: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
					case 1: 
						hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
					case 2: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 3: 
						hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
					case 4: 
						hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
					case 5: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
					case 6: 
						hold = [controls.N4];
					case 7: 
						hold = [controls.LEFT, controls.RIGHT];
					case 8: 
						hold = [controls.LEFT, controls.N4, controls.RIGHT];

					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT,false,false,false,false,false];
					case 11: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, false, controls.L2, false, false, controls.R2];
					case 12: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 13: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT, controls.N4,false,false,false,false];
					case 14: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, controls.N4, controls.L2, false, false, controls.R2];
					case 15:
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, false, controls.N5, controls.N6, controls.N7, controls.N8];
					case 16: 
						hold = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						hold = [controls.LEFT, false, false, controls.RIGHT, false, false, false, false, false];
					case 18: 
						hold = [controls.LEFT, false, false, controls.RIGHT, controls.N4, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;

				
				notes.forEachAlive(function(daNote:Note)
				{	


					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
		
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if (!PlayStateChangeables.botPlay)
									{
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
		
											daNote.clipRect = swagRect;
										}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
		
										daNote.clipRect = swagRect;
									}
								}
							}
							else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members[Math.floor(Math.abs(daNote.noteData))].y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
		
									if (!PlayStateChangeables.botPlay)
									{
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
		
											daNote.clipRect = swagRect;
										}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
		
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
						if (daNote.alt)
							altAnim = '-alt';

						dad.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);

					
						
								
								
					
							if (storyDifficulty == 3 && !FlxG.save.data.health)
							{
								if (health > 0.09)
									{
										health -= 0.06;
									}
									
								else if (health <= 0.021)
									{
										health -= 0;
									}		
									
							}	
								
							
								
									
							

							if (SONG.song.toLowerCase() == 'permadeath')
								{
									if (FlxG.save.data.shake)
									{
										
											  shake = true;

											  gf.playAnim('scared');
										
									}
								  
								}


						/*if (daNote.isSustainNote)
						{
							health -= SONG.noteValues[0] / 3;
						}
						else
							health -= SONG.noteValues[0];
						*/
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									switch(maniaToChange)
									{
										case 0: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 1: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 2: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 3: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 4: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 5: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 6: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 7: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 8:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 10: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 11: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 12: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 13: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 14: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 15: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 16: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 17: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 18:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
									}
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();

					}

					if (daNote.mustPress && !daNote.modifiedByLua)
						{
							daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}
						else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
						{
							daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}

						
						if (!daNote.mustPress && FlxG.save.data.middlescroll && !executeModchart)
							daNote.alpha = 0;

		
						if (daNote.isSustainNote)
						{
							daNote.x += daNote.width / 2 + 20;
							if (SONG.noteStyle == 'pixel')
								daNote.x -= 11;
						}
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (daNote.isSustainNote && daNote.wasGoodHit && Conductor.songPosition >= daNote.strumTime)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					
					else if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate
						&& PlayStateChangeables.useDownscroll)
						&& daNote.mustPress)
					{

							switch (daNote.noteType)
							{
						
								case 0: //normal
								{
									if (daNote.isSustainNote && daNote.wasGoodHit)
										{
											daNote.kill();
											notes.remove(daNote, true);
										}
										else
										{
											if (loadRep && daNote.isSustainNote)
											{
												// im tired and lazy this sucks I know i'm dumb
												if (findByTime(daNote.strumTime) != null)
													totalNotesHit += 1;
												else
												{
													vocals.volume = 0;
													if (theFunne && !daNote.isSustainNote)
													{
														noteMiss(daNote.noteData, daNote);
													}
													if (daNote.isParent)
													{
														health -= 0.15; // give a health punishment for failing a LN
														trace("hold fell over at the start");
														for (i in daNote.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
														}
													}
													else
													{
														if (!daNote.wasGoodHit
															&& daNote.isSustainNote
															&& daNote.sustainActive
															&& daNote.spotInLine != daNote.parent.children.length)
														{
															health -= 0.2; // give a health punishment for failing a LN
															trace("hold fell over at " + daNote.spotInLine);
															for (i in daNote.parent.children)
															{
																i.alpha = 0.3;
																i.sustainActive = false;
															}
															if (daNote.parent.wasGoodHit)
																misses++;
															updateAccuracy();
														}
														else if (!daNote.wasGoodHit
															&& !daNote.isSustainNote)
														{
															health -= 0.15;
														}
													}
												}
											}
											else
											{
												vocals.volume = 0;
												if (theFunne && !daNote.isSustainNote)
												{
													if (PlayStateChangeables.botPlay)
													{
														daNote.rating = "bad";
														goodNoteHit(daNote);
													}
													else
														noteMiss(daNote.noteData, daNote);
												}
				
												if (daNote.isParent)
												{
													health -= 0.15; // give a health punishment for failing a LN
													trace("hold fell over at the start");
													for (i in daNote.children)
													{
														i.alpha = 0.3;
														i.sustainActive = false;
														trace(i.alpha);
													}
												}
												else
												{
													if (!daNote.wasGoodHit
														&& daNote.isSustainNote
														&& daNote.sustainActive
														&& daNote.spotInLine != daNote.parent.children.length)
													{
														health -= 0.25; // give a health punishment for failing a LN
														trace("hold fell over at " + daNote.spotInLine);
														for (i in daNote.parent.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
															trace(i.alpha);
														}
														if (daNote.parent.wasGoodHit)
															misses++;
														updateAccuracy();
													}
													else if (!daNote.wasGoodHit
														&& !daNote.isSustainNote)
													{
														health -= 0.15;
													}
												}
											}
										}
				
										daNote.visible = false;
										daNote.kill();
										notes.remove(daNote, true);




								}

								case 1: //fire notes - makes missing them not count as one
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();

								}
								case 2: //halo notes, same as fire
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}

								case 3:  //warning notes, removes half health and then removed so it doesn't repeatedly deal damage
								{
									
									health = 0;

									if (FlxG.save.data.die)
										{
											dad.playAnim('SWORD', true);
											boyfriend.playAnim('hit', true);
											FlxG.sound.play(Paths.sound('sonidomuerte'));
											vocals.volume = 0;
										}
									
									
									
									
									misses++;
									updateAccuracy();
								
									daNote.active = true;
									daNote.visible = true;
								}
								case 4: //angel notes
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 6:  //bob notes
								{
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}
								case 7: //gltich notes
								{
									HealthDrain();
									daNote.kill();
									notes.remove(daNote, true);
									daNote.destroy();
								}




							}
						}
						if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
							!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
							{
									// Force good note hit regardless if it's too late to hit it or not as a fail safe
									if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
									PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
									{
										if(loadRep)
										{
											//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
											var n = findByTime(daNote.strumTime);
											trace(n);
											if(n != null)
											{
												goodNoteHit(daNote);
												boyfriend.holdTimer = daNote.sustainLength;
											}
										}else {
											if (!daNote.burning && !daNote.death && !daNote.bob)
												{
													goodNoteHit(daNote);
													boyfriend.holdTimer = daNote.sustainLength;
													playerStrums.forEach(function(spr:FlxSprite)
													{
														if (Math.abs(daNote.noteData) == spr.ID)
														{
															spr.animation.play('confirm', true);
														}
														if (spr.animation.curAnim.name == 'confirm' && SONG.noteStyle != 'pixel')
														{
															spr.centerOffsets();
															switch(maniaToChange)
															{
																case 0: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 1: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 2: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 3: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 4: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 5: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 6: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 7: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 8:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 10: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 11: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 12: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 13: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 14: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 15: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 16: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 17: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 18:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
															}
														}
														else
															spr.centerOffsets();
													});
												}
											}
											
									}
							}
								
					
				});
				
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
			if (PlayStateChangeables.botPlay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.animation.finished)
							{
								spr.animation.play('static');
								spr.centerOffsets();
							}
						});
				}
		}

		if (!inCutscene && songStarted)
			keyShit();


		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function fuegoDesaparecer(tmr:FlxTimer)
		{
			remove(fire);
		}

	function dodgeTimingOverride(newValue:Float = 0.22625):Void
		{
			bfDodgeTiming = newValue;
		}
	
		function dodgeCooldownOverride(newValue:Float = 0.1135):Void
		{
			bfDodgeCooldown = newValue;
		}	
	
		function SHADATTACK_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(shad_attack_saw);
			else
				remove(shad_attack_saw);
		}
	
		function SHADALERT_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(shad_attack_alert);
			else
				remove(shad_attack_alert);
		}


		// qt source code
	
		//False state = Prime!
		//True state = Attack!
		function SHADATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
		{
			if(!(SONG.song.toLowerCase() == "permadeath" || SONG.song.toLowerCase() == "decition" || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "termination")){
				trace("Sawblade Attack Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("HE ATACC!");
			if(state){
				// talves FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75); ok se que eso esta mal pero cambialo asi como el de atack o algo asi no se pero fixealo ok chau (de hecho si aun sigue funcionanado xd)
				//Play saw attack animation
				dad.playAnim('SWORD', true);
				
				/*shad_attack_saw.animation.finishCallback = function(pog:String){
					if(state) //I don't get it.
						remove(shad_attack_saw);
				}*/
	
				//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
				new FlxTimer().start(0.09, function(tmr:FlxTimer)
				{
					if(!bfDodging && !PlayStateChangeables.botPlay && !FlxG.save.data.botPlay){
						//MURDER THE BITCH!
						boyfriend.playAnim('hit', true);
						FlxG.sound.play(Paths.sound('sonidomuerte'));
						deathBySawBlade = true;
						health -= 404;
					}
				});
			}else{
				dad.playAnim('SWORD', true);
				
			}
		}
		function SHADATTACK_ALERT(pointless:Bool = false):Void //For some reason, modchart doesn't like functions with no parameter? why? dunno.
		{
			if(!(SONG.song.toLowerCase() == "permadeath" || SONG.song.toLowerCase() == "decition" || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "termination")){
				trace("Sawblade Alert Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("DANGER!");
			shad_attack_alert.animation.play('alert');
			FlxG.sound.play(Paths.sound('alert'));

			/*new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					remove(shad_attack_alert);
				});*/

				//aun no lo compruebo xd
		}
	
		//OLD ATTACK DOUBLE VARIATION
		function SHADATTACK_ALERTDOUBLE(pointless:Bool = false):Void
		{
			if(!(SONG.song.toLowerCase() == "permadeath" || SONG.song.toLowerCase() == "decition" || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "termination")){
				trace("Sawblade AlertDOUBLE Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("DANGER DOUBLE INCOMING!!");
			shad_attack_alert.animation.play('alertDOUBLE');
			FlxG.sound.play(Paths.sound('old/alertALT'));
		}
		

	function endSong():Void
	{
	/*	FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);*/
		if (useVideo)
			{
				GlobalVideo.get().stop();
				FlxG.stage.window.onFocusOut.remove(focusOut);
				FlxG.stage.window.onFocusIn.remove(focusIn);
				PlayState.instance.remove(PlayState.instance.videoSprite);
			}

		if (isStoryMode)
			campaignMisses = misses;

		/*if (!loadRep)
			rep.SaveReplay(saveNotes, saveJudge, replayAna);*/
		else
		{
			PlayStateChangeables.botPlay = false;
			PlayStateChangeables.scrollSpeed = 1;
			PlayStateChangeables.useDownscroll = false;
		}

		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);

		#if windows
		if (luaModchart != null)
		{
			luaModchart.die();
			luaModchart = null;
		}
		#end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.pause();
		vocals.pause();
		if (SONG.validScore)
		{
			// adjusting the highscore song name to be compatible
			// would read original scores if we didn't change packages
			var songHighscore = StringTools.replace(PlayState.SONG.song, " ", "-");
			switch (songHighscore) {
				case 'Dad-Battle': songHighscore = 'Dadbattle';
				case 'Philly-Nice': songHighscore = 'Philly';
			}

			#if !switch
			Highscore.saveScore(songHighscore, Math.round(songScore), storyDifficulty);
			Highscore.saveCombo(songHighscore, Ratings.GenerateLetterRank(accuracy), storyDifficulty);
			#end
		}

		if (offsetTesting)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			offsetTesting = false;
			LoadingState.loadAndSwitchState(new OptionsMenu());
			FlxG.save.data.offset = offsetTest;
		}
		else
		{
			if (isStoryMode)
			{
				campaignScore += Math.round(songScore);

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;



					paused = true;

					FlxG.sound.music.stop();
					vocals.stop();
					if (FlxG.save.data.scoreScreen)
						openSubState(new ResultsScreen());
					else
					{
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new MainMenuState());
					}

					#if windows
					if (luaModchart != null)
					{
						luaModchart.die();
						luaModchart = null;
					}
					#end

					// if ()
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}

					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
					FlxG.save.flush();
				}
				else
				{
					var difficulty:String = "";

					if (storyDifficulty == 0)
						difficulty = '-easy';

					if (storyDifficulty == 2)
						difficulty = '-hard';

					if (storyDifficulty == 3)
						difficulty = '-uhc';				

					
					// adjusting the song name to be compatible
					var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
					switch (songFormat) {
						case 'Dad-Battle': songFormat = 'Dadbattle';
						case 'Philly-Nice': songFormat = 'Philly';
					}

					var poop:String = Highscore.formatSong(songFormat, storyDifficulty);

					trace('LOADING NEXT SONG');
					trace(poop);

					if (StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() == 'eggnog')
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;


					PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (curSong.toLowerCase() == 'decition')
						{
							
							var video:MP4Handler = new MP4Handler();

					
							video.playMP4(Paths.video('pog'), new PlayState()); 
							isCutscene = true;
						
						}

					else if (curSong.toLowerCase() == 'permadeath')
						{
							
							var video:MP4Handler = new MP4Handler();

					
							video.playMP4(Paths.video('thanks'), new PlayState()); 
							isCutscene = true;
						
						}
						
					else
					{
						new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								
								LoadingState.loadAndSwitchState(new PlayState(), true);
							});
					}

				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');

				paused = true;


				FlxG.sound.music.stop();
				vocals.stop();

				if (FlxG.save.data.scoreScreen)
					{
						openSubState(new ResultsScreen());
					}
					
				else
					{
						FlxG.switchState(new FreeplayState());
					}
					
			}
		}
	}


	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	//tetris blockage bugs that i know and will prob fix tomorrow
	//pausing during a blockage will keep the blockage timer going and disappear
	//upscroll support
	// vs mami source code :trollface:	
	public function tetrisblockage(percentageBlockage:Int, duration:Int, instant:Bool = false)
		{
			canPause = true; //temp(hopefully) solution to people avoiding tetris blocking mechanic 
			/*var tetrisBlockagePiece:FlxSprite = new FlxSprite(0, -1080).loadGraphic(Paths.image('tetris/health_blockage'));
			tetrisBlockagePiece.cameras = [camHUD];
			tetrisBlockagePiece.antialiasing = false;

			tetrisBlockagePiece.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(100 - percentageBlockage, 0, 100, 100, 0) * 0.01)) - 240;
			tetrisBlockagePiece.y = -720;
			tetrisBlockagePiece.setGraphicSize(Std.int(tetrisBlockagePiece.width * 0.075));

			add(tetrisBlockagePiece);*/

			/*if(!instant)
				if (FlxG.save.data.downscroll)
					{
						tetrisBlockagePiece.y = 150;
						trace(tetrisBlockagePiece.y);
					}
				else
					{
						tetrisBlockagePiece.y = -1080;
						trace(tetrisBlockagePiece.y);
					}*/
				//FlxG.sound.play(Paths.sound('tetris/hpblockage_spawn','shared'));
				//FlxFlicker.flicker(tetrisBlockagePiece, 1, 0.2, true);
				/*new FlxTimer().start(1, function(tmr:FlxTimer) //ik this is ugly but it works lol
					{
						if (FlxG.save.data.downscroll)
							{
								tetrisBlockagePiece.y -= 75;
								trace(tetrisBlockagePiece.y);
							}
						else
							{
								tetrisBlockagePiece.y += 75;
								trace(tetrisBlockagePiece.y);
							}
						FlxG.sound.play(Paths.sound('tetris/hpblockage_move','shared'));
						new FlxTimer().start(.15, function(tmr:FlxTimer)
							{
								if (FlxG.save.data.downscroll)
									{
										tetrisBlockagePiece.y -= 75;
										trace(tetrisBlockagePiece.y);
									}
								else
									{
										tetrisBlockagePiece.y += 75;
										trace(tetrisBlockagePiece.y);
									}
								FlxG.sound.play(Paths.sound('tetris/hpblockage_move','shared'));
							},11);
					},1);*/
				new FlxTimer().start(duration + 99, function(tmr:FlxTimer)
					{
						camHUD.shake(0.002, 0.5);
						/*FlxG.sound.play(Paths.sound('tetris/hpblockage_thud','shared'));*/
						healthcap = (percentageBlockage / 50);
						/*if (FlxG.save.data.downscroll)
							{
								tetrisBlockagePiece.y -= 15;
								trace(tetrisBlockagePiece.y);
							}
						else
							{
								tetrisBlockagePiece.y += 15;
								trace(tetrisBlockagePiece.y);
							}
						//tetrisBlockagePiece.y = -100;*/
					},1);

				if(!instant)
					new FlxTimer().start(duration + 99, function(tmr:FlxTimer)
						{
							/*FlxG.sound.play(Paths.sound('tetris/hpblockage_clear','shared'));
							remove(tetrisBlockagePiece);*/
							healthcap = 0;
							canPause = true; //temp(hopefully) solution to people avoiding tetris blocking mechanic 
						},1);
		}

	private function popUpScore(daNote:Note = null):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;

			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					{
						score = -300;
						combo = 0;
						misses++;
						if (!FlxG.save.data.gthm)
							health -= 0.2;
						ss = false;
						shits++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit -= 1;
					}
					
					if (storyDifficulty == 3)
						{
							score = -700;
							combo = 0;
							misses++;
							if (!FlxG.save.data.gthm)
								{
									health -= 0.35;
								}
							
							if (FlxG.save.data.bestinputfornoobs)
								{
									health -= 0.17;
								}
							ss = false;
							shits++;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit -= 1;
						}

						if (dad.curCharacter == 'shadounearmor')
							{
								score = -300;
								combo = 0;
								misses++;
								if (!FlxG.save.data.gthm)
									health -= 0.4;
								ss = false;
								shits++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit -= 1;
							}
							
							 if (storyDifficulty == 3)
								{
									score = -700;
									combo = 0;
									misses++;
									if (!FlxG.save.data.gthm)
										{
											health -= 0.5;
										}
									
									if (FlxG.save.data.bestinputfornoobs)
										{
											health -= 0.25;
										}
									ss = false;
									shits++;
									if (FlxG.save.data.accuracyMod == 0)
										totalNotesHit -= 1;
								}
				case 'bad':	
					{
						daRating = 'bad';
						score = -200;
						if (!FlxG.save.data.gthm)
							health -= 0.06;
						
						ss = false;
						bads++;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.50;
					}
					
					if (storyDifficulty == 3)
						{
							daRating = 'bad';
							score = 0;
							if (!FlxG.save.data.gthm)
								health -= 0.070;
							if (FlxG.save.data.bestinputfornoobs)
								{
									health -= 0.045;
								}
							ss = false;
							bads++;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 0.50;
						}

						if (dad.curCharacter == 'shadounearmor')
							{
								daRating = 'bad';
								score = -200;
								if (!FlxG.save.data.gthm)
									health -= 0.07;
								
								ss = false;
								bads++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.50;
							}
							
							 if (storyDifficulty == 3)
								{
									daRating = 'bad';
									score = 0;
									if (!FlxG.save.data.gthm)
										health -= 0.075;
									if (FlxG.save.data.bestinputfornoobs)
										{
											health -= 0.055;
										}
									ss = false;
									bads++;
									if (FlxG.save.data.accuracyMod == 0)
										totalNotesHit += 0.50;
								}
				case 'good':
					{
						daRating = 'good';
						score = 200;
						ss = false;
						goods++;
						if (health < 2)
							health += 0.04;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 0.75;
					}
					
					if (storyDifficulty == 3)
						{
							daRating = 'good';
							score = 200;
							ss = false;
							goods++;
							if (health < 2)
								health += 0.027777777777777777777777;
							
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 0.75;
						}
						if (dad.curCharacter == 'shadounearmor')
							{

							daRating = 'good';
							score = 200;
							ss = false;
							goods++;
							if (health < 2)
								health += 0.018;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 0.75;
						}
						
						 if (storyDifficulty == 3)
							{
								daRating = 'good';
								score = 200;
								ss = false;
								goods++;
								if (health < 2)
									health += 0.008;
								
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.75;
							}
				case 'sick':
					{
						if (health < 2)
							health += 0.1;
						if (FlxG.save.data.accuracyMod == 0)
							totalNotesHit += 1;
						sicks++;
					}
					
					if (storyDifficulty == 3)
						{
							if (health < 2)
							health += 0;	
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 1;
							sicks++;
							
						}

						if (dad.curCharacter == 'shadounearmor')
							{

								if (health < 2)
									health += 0.05;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 1;
								sicks++;
							
							
								 if (storyDifficulty == 3)
									{
										if (health < 2)
										health += 0.045;	
										if (FlxG.save.data.accuracyMod == 0)
											totalNotesHit += 1;
										sicks++;
										
									}
									//xd

							}

			}	

			/*if (dad.curCharacter == 'shadounearmor')
				{

					switch(daRating)
					{
						case 'shit':
						{
							score = -300;
							combo = 0;
							misses++;
							if (!FlxG.save.data.gthm)
								health -= 0.4;
							ss = false;
							shits++;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit -= 1;
						}
						
						if (storyDifficulty == 3)
							{
								score = -700;
								combo = 0;
								misses++;
								if (!FlxG.save.data.gthm)
									{
										health -= 0.5;
									}
								
								if (FlxG.save.data.bestinputfornoobs)
									{
										health -= 0.25;
									}
								ss = false;
								shits++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit -= 1;
							}
					case 'bad':	
						{
							daRating = 'bad';
							score = -200;
							if (!FlxG.save.data.gthm)
								health -= 0.07;
							
							ss = false;
							bads++;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 0.50;
						}
						
						if (storyDifficulty == 3)
							{
								daRating = 'bad';
								score = 0;
								if (!FlxG.save.data.gthm)
									health -= 0.075;
								if (FlxG.save.data.bestinputfornoobs)
									{
										health -= 0.055;
									}
								ss = false;
								bads++;
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.50;
							}
					case 'good':
						{
							daRating = 'good';
							score = 200;
							ss = false;
							goods++;
							if (health < 2)
								health += 0.018;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 0.75;
						}
						
						if (storyDifficulty == 3)
							{
								daRating = 'good';
								score = 200;
								ss = false;
								goods++;
								if (health < 2)
									health += 0.008;
								
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 0.75;
							}
					case 'sick':
						{
							if (health < 2)
								health += 0.05;
							if (FlxG.save.data.accuracyMod == 0)
								totalNotesHit += 1;
							sicks++;
						}
						
						if (storyDifficulty == 3)
							{
								if (health < 2)
								health += 0.045;	
								if (FlxG.save.data.accuracyMod == 0)
									totalNotesHit += 1;
								sicks++;
								
							}
							//xd
					}

				
				}*/


						
						
			

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
	
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			if (PlayStateChangeables.bothSide)
			{
				rating.x -= 350;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = FlxG.save.data.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = FlxG.save.data.antialiasing;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = FlxG.save.data.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);

				visibleCombos.push(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						visibleCombos.remove(numScore);
						numScore.destroy();
					},
					onUpdate: function (tween:FlxTween)
					{
						if (!visibleCombos.contains(numScore))
						{
							tween.cancel();
							numScore.destroy();
						}
					},
					startDelay: Conductor.crochet * 0.002
				});

				if (visibleCombos.length > seperatedScore.length + 20)
				{
					for(i in 0...seperatedScore.length - 1)
					{
						visibleCombos.remove(visibleCombos[visibleCombos.length - 1]);
					}
				}
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;
		var l1Hold:Bool = false;
		var uHold:Bool = false;
		var r1Hold:Bool = false;
		var l2Hold:Bool = false;
		var dHold:Bool = false;
		var r2Hold:Bool = false;
	
		var n0Hold:Bool = false;
		var n1Hold:Bool = false;
		var n2Hold:Bool = false;
		var n3Hold:Bool = false;
		var n4Hold:Bool = false;
		var n5Hold:Bool = false;
		var n6Hold:Bool = false;
		var n7Hold:Bool = false;
		var n8Hold:Bool = false;
		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
		{
			
					//Dodge code only works on termination and Tutorial -Haz
					if(SONG.song.toLowerCase() == 'permadeath' || SONG.song.toLowerCase() == "decition" || SONG.song.toLowerCase()=='tutorial' || SONG.song.toLowerCase() == "termination")
						{
							//Dodge code, yes it's bad but oh well. -Haz
							//var dodgeButton = controls.ACCEPT; //I have no idea how to add custom controls so fuck it. -Haz
		
							if(FlxG.keys.justPressed.SPACE)
								trace('butttonpressed');
		
							if(FlxG.keys.justPressed.SPACE && !bfDodging && bfCanDodge){
								trace('DODGE START!');
								bfDodging = true;
								bfCanDodge = false;
								
								if (FlxG.random.bool(0.01))
									{
										boyfriend.playAnim('SHIELD');
										add(uno);
									}
									else
										boyfriend.playAnim('SHIELD');
									
		
								FlxG.sound.play(Paths.sound('dodge01'));
		
								//Wait, then set bfDodging back to false. -Haz
								//V1.2 - Timer lasts a bit longer (by 0.00225)
								//new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								//new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								{
									bfDodging=false;
									boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
									trace('DODGE END!');
									//Cooldown timer so you can't keep spamming it.
									//V1.3 = Incremented this by a little (0.005)
									//new FlxTimer().start(0.1135, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
									//new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
									new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
									{
										bfCanDodge=true;
										trace('DODGE RECHARGED!');
									});
								});
							}
						}
		
										
							
								/*	if (!FlxG.save.data.espacedodge)
									{
										if (FlxG.mouse.pressedRight)
											{
												trace('butttonpressed');
											}
											

										if(FlxG.mouse.pressedRight && !bfDodging && bfCanDodge)
										{
											trace('DODGE START!');
											bfDodging = true;
											bfCanDodge = false;
					
												boyfriend.playAnim('SHIELD');
					
											FlxG.sound.play(Paths.sound('dodge01'));
										}

										new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
											{
												bfDodging = false;
												boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
												trace('DODGE END!');
												//Cooldown timer so you can't keep spamming it.
												//V1.3 = Incremented this by a little (0.005)
												//new FlxTimer().start(0.1135, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
												//new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
												new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
												{
													bfCanDodge=true;
													trace('DODGE RECHARGED!');
												});
											});

									}
									*/
									

								//Wait, then set bfDodging back to false. -Haz
								//V1.2 - Timer lasts a bit longer (by 0.00225)
								//new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								//new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								
							
						
			
				

				
				// control arrays, order L D R U
				switch(maniaToChange)
				{
					case 0: 
						//hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 1: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 2: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N4_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N4_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 3: 
						//hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.N4_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.N4_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 4: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.N4_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.N4_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 5: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 6: 
						//hold = [controls.N4];
						press = [
							controls.N4_P
						];
						release = [
							controls.N4_R
						];
					case 7: 
					//	hold = [controls.LEFT, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.RIGHT_R
						];
					case 8: 
						//hold = [controls.LEFT, controls.N4, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.N4_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.N4_R,
							controls.RIGHT_R
						];
					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P,false,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R,false,false,false,false,false];
					case 11: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, false, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, false, controls.L2_R, false, false, controls.R2_R];
					case 12: 
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, controls.N4_P, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, controls.N4_R, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 13: 
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P, controls.N4_P,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R, controls.N4_R,false,false,false,false];
					case 14: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, controls.N4_P, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, controls.N4_R, controls.L2_R, false, false, controls.R2_R];
					case 15:
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, false, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, false, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 16: 
						press = [false, false, false, false, controls.N4_P, false, false, false, false];
						release = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, false, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, false, false, false, false, false];
					case 18: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, controls.N4_P, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, controls.N4_R, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;
				var pressArray:Array<Bool> = press;
				var releaseArray:Array<Bool> = release;
				
				#if windows
				if (luaModchart != null)
				{
					for (i in 0...pressArray.length) {
						if (pressArray[i] == true) {
						luaModchart.executeState('keyPressed', [sDir[i].toLowerCase()]);
						}
					};
					
					for (i in 0...releaseArray.length) {
						if (releaseArray[i] == true) {
						luaModchart.executeState('keyReleased', [sDir[i].toLowerCase()]);
						}
					};
					
				};
				#end
				
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					holdArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					pressArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					releaseArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
				} 

				var anas:Array<Ana> = [null,null,null,null];
				switch(mania)
				{
					case 0: 
						anas = [null,null,null,null];
					case 1: 
						anas = [null,null,null,null,null,null];
					case 2: 
						anas = [null,null,null,null,null,null,null,null,null];
					case 3: 
						anas = [null,null,null,null,null];
					case 4: 
						anas = [null,null,null,null,null,null,null];
					case 5: 
						anas = [null,null,null,null,null,null,null,null];
					case 6: 
						anas = [null];
					case 7: 
						anas = [null,null];
					case 8: 
						anas = [null,null,null];
				}

				for (i in 0...pressArray.length)
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				} //gt hero input shit, using old code because i can
				if (controls.GTSTRUM)
				{
					if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm || holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm)
						{
							var possibleNotes:Array<Note> = [];

							var ignoreList:Array<Int> = [];
				
							notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
								{
									possibleNotes.push(daNote);
									possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				
									ignoreList.push(daNote.noteData);
								}
				
							});

				
							if (possibleNotes.length > 0)
							{
								var daNote = possibleNotes[0];
				
								// Jump notes
								if (possibleNotes.length >= 2)
								{
									if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
											else
											{
												var inIgnoreList:Bool = false;
												for (shit in 0...ignoreList.length)
												{
													if (holdArray[ignoreList[shit]] || pressArray[ignoreList[shit]])
														inIgnoreList = true;
												}
												if (!inIgnoreList && !FlxG.save.data.ghost)
													noteMiss(1, null);
											}
										}
									}
									else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
									{
										if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
											goodNoteHit(daNote);
									}
									else
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
										}
									}
								}
								else // regular notes?
								{
									if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
										goodNoteHit(daNote);
								}
							}
						}

					}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						switch(mania)
						{
							case 0: 
								directionsAccounted = [false, false, false, false];
							case 1: 
								directionsAccounted = [false, false, false, false, false, false];
							case 2: 
								directionsAccounted = [false, false, false, false, false, false, false, false, false];
							case 3: 
								directionsAccounted = [false, false, false, false, false];
							case 4: 
								directionsAccounted = [false, false, false, false, false, false, false];
							case 5: 
								directionsAccounted = [false, false, false, false, false, false, false, false];
							case 6: 
								directionsAccounted = [false];
							case 7: 
								directionsAccounted = [false, false];
							case 8: 
								directionsAccounted = [false, false, false];
						}
						



						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											directionsAccounted[daNote.noteData] = true;
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						var hit = [false,false,false,false,false,false,false,false,false];
						switch(mania)
						{
							case 0: 
								hit = [false, false, false, false];
							case 1: 
								hit = [false, false, false, false, false, false];
							case 2: 
								hit = [false, false, false, false, false, false, false, false, false];
							case 3: 
								hit = [false, false, false, false, false];
							case 4: 
								hit = [false, false, false, false, false, false, false];
							case 5: 
								hit = [false, false, false, false, false, false, false, false];
							case 6: 
								hit = [false];
							case 7: 
								hit = [false, false];
							case 8: 
								hit = [false, false, false];
						}
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
								{
									for (i in 0...pressArray.length)
										{ // if a direction is hit that shouldn't be
											if (pressArray[i] && !directionList.contains(i))
												noteMiss(i, null);
										}
								}
							if (FlxG.save.data.gthm)
							{
	
							}
							else
							{
								for (coolNote in possibleNotes)
									{
										if (pressArray[coolNote.noteData] && !hit[coolNote.noteData])
										{
											/* if (FlxG.save.data.bestinputfornoobs)
												{
													trace ( "if (mashViolations != 0)
														mashViolations--;");
		
												}*/
											if (!FlxG.save.data.bestinputfornoobs)
												{
													if (mashViolations != 0)
														mashViolations--;
		
												}
											hit[coolNote.noteData] = true;
											scoreTxt.color = FlxColor.WHITE;
											var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
											anas[coolNote.noteData].hit = true;
											anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
											anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
											goodNoteHit(coolNote);
										}
									}
							}
							
						};
						if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay || PlayStateChangeables.bothSide && !currentSection.mustHitSection))
							{
								if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
									boyfriend.dance();
							}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...keyAmmo[mania])
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
					
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay || PlayStateChangeables.bothSide && !currentSection.mustHitSection))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.dance();
				}
		 
				if (!PlayStateChangeables.botPlay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (keys[spr.ID] && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'pressed')
							spr.animation.play('pressed', false);
						if (!keys[spr.ID])
							spr.animation.play('static', false);
			
						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							switch(maniaToChange)
							{
								case 0: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 1: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 2: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 3: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 4: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 5: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 6: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 7: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 8:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 10: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 11: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 12: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 13: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 14: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 15: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 16: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 17: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 18:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
							}
						}
						else
							spr.centerOffsets();
					});
				}
			}

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					//WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (dad.curCharacter == 'shadounearmor')
				{
					health -= 0.095;
					if (storyDifficulty == 3)
						{
							health -= 0.1;
						}
					
				}
			if (storyDifficulty == 3)
				{
					health -= 0.09;
				}
			health -= 0.04;
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else
				if (!loadRep)
				{
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			boyfriend.playAnim('sing' + sDir[direction] + 'miss', true);

			canDrain = true;

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end


			updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	


				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				/*if (FlxG.save.data.bestinputfornoobs)
					{
						trace ( "if (!resetMashViolation && mashViolations >= 1)
						mashViolations--;
	
					if (mashViolations < 0)
						mashViolations = 0;");

					}*/
				if (!FlxG.save.data.bestinputfornoobs)
					{
						if (!resetMashViolation && mashViolations >= 1)
							mashViolations--;
		
						if (mashViolations < 0)
							mashViolations = 0;

					}
				

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	
					var altAnim:String = "";

					if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
					if (note.alt)
						altAnim = '-alt';

					if (!PlayStateChangeables.bothSide)
					{
						if (boyfriend.curCharacter == 'bf')
							boyfriend.playAnim('sing' + bfsDir[note.noteData] + altAnim, true);

						if (SONG.song.toLowerCase() == 'permadeath')
							{
								if (boyfriend.curCharacter == 'bf')
									boyfriend.playAnim('sing' + bfsDir[note.noteData] + altAnim, true);
								if (FlxG.save.data.shake)
								{
									
										  shake = false;
									
								}
							  
							}
						else
							boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						boyfriend.holdTimer = 0;

						if (SONG.song.toLowerCase() == 'permadeath')
							{
								boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
								boyfriend.holdTimer = 0;
								if (FlxG.save.data.shake)
								{
									
										  shake = false;
									
								}
							  
							}
					}
					else if (note.noteData <= 3)
					{
						boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						boyfriend.holdTimer = 0;
					}
					else
					{
						dad.playAnim('sing' + sDir[note.noteData] + altAnim, true);
						dad.holdTimer = 0;
					
					}




		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end

					if (note.burning) //fire note
						{
							dad.playAnim('SWORD', true);
							boyfriend.playAnim('hit', true);
							health = 0;
							FlxG.sound.play(Paths.sound('sonidomuerte'));
							
							
							vocals.volume = 0;
							misses++;
							updateAccuracy();
						}

					else if (note.death) //halo note
						{
							dad.playAnim('SWORD', true);
							boyfriend.playAnim('hit', true);
							health = 0;
							FlxG.sound.play(Paths.sound('sonidomuerte'));
							
							
							vocals.volume = 0;
							misses++;
							updateAccuracy();

						}
					else if (note.angel) //angel note
						{
							switch(note.rating)
							{
								case "shit": 
									
									health -= 1;
								case "bad": 
									
									health -= 0.5;
								case "good": 
									health += 0.5;
								case "sick": 
									health += 1;

							}
						}
					else if (note.bob) //bob note
						{
							HealthDrain();
						}


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
		
					if (!note.isSustainNote)
						{
							if (note.rating == "sick")
								doNoteSplash(note.x, note.y, note.noteData);

							note.kill();
							notes.remove(note, true);
							note.destroy();

						}
						else
						{
							note.wasGoodHit = true;
						}
					
					updateAccuracy();

					if (FlxG.save.data.gracetmr)
						{
							grace = true;
							new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{
								grace = false;
							});
						}
					
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	function doNoteSplash(noteX:Float, noteY:Float, nData:Int)
		{
			var recycledNote = noteSplashes.recycle(NoteSplash);
			recycledNote.makeSplash(playerStrums.members[nData].x, playerStrums.members[nData].y, nData);
			noteSplashes.add(recycledNote);
			
		}

	function HealthDrain():Void //code from vs bob
		{
			healthDrainVerifi = true;
			FlxG.sound.play(Paths.sound('bob fire'));
			boyfriend.playAnim('hit', true);

			fire = new FlxSprite(0, FlxG.height * 1.2).loadGraphic(Paths.image('FIRE'));
			if (PlayStateChangeables.useDownscroll)
				{	
					fire.y = 50;
				}
				
			fire.screenCenter(X);
			fire.scrollFactor.set();

			add(fire);
			

							
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				remove(fire);
									
									
				
				health -= 0.005;
			}, 300);

			

			new FlxTimer().start(0.010001, function(tmr:FlxTimer)
				{
					
										
										
					add(fire);
				
				}, 300);


		}

	function badNoteHit():Void
		{
			boyfriend.playAnim('hit', true);
			FlxG.sound.play(Paths.soundRandom('badnoise', 1, 3), FlxG.random.float(0.7, 1));
		}

	var justChangedMania:Bool = false;

	public function switchMania(newMania:Int) //i know this is pretty big, but how else am i gonna do this shit
	{
		if (mania == 2) //so it doesnt break the fucking game
		{
			maniaToChange = newMania;
			justChangedMania = true;
			new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					justChangedMania = false; //cooldown timer
				});
			switch(newMania)
			{
				case 10: 
					Note.newNoteScale = 0.7; //fix the note scales pog
				case 11: 
					Note.newNoteScale = 0.6;
				case 12: 
					Note.newNoteScale = 0.5;
				case 13: 
					Note.newNoteScale = 0.65;
				case 14: 
					Note.newNoteScale = 0.58;
				case 15: 
					Note.newNoteScale = 0.55;
				case 16: 
					Note.newNoteScale = 0.7;
				case 17: 
					Note.newNoteScale = 0.7;
				case 18: 
					Note.newNoteScale = 0.7;
			}
	
			strumLineNotes.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							spr.animation.play('static'); //changes to static because it can break the scaling of the static arrows if they are doing the confirm animation
							spr.setGraphicSize(Std.int((spr.width / Note.prevNoteScale) * Note.newNoteScale));
							spr.centerOffsets();
							Note.scaleSwitch = false;
						}
					});
				});
	
			new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					cpuStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 0);
						});
					playerStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 1);
						});
				});
	
		}
	}

	public function moveKeyPositions(spr:FlxSprite, newMania:Int, player:Int):Void //some complex calculations and shit here
	{
		spr.x = 0;
		spr.alpha = 1;
		switch(newMania) //messy piece of shit, i wish there was an easier way to do this, but it has to be done i guess
		{
			case 10: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.x += (160 * 0.7) * 1;
					case 2: 
						spr.x += (160 * 0.7) * 2;
					case 3: 
						spr.x += (160 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 11: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (120 * 0.7) * 0;
					case 1: 
						spr.x += (120 * 0.7) * 4;
					case 2: 
						spr.x += (120 * 0.7) * 1;
					case 3: 
						spr.x += (120 * 0.7) * 2;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (120 * 0.7) * 3;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (120 * 0.7) * 5;
				}
			case 12: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (95 * 0.7) * 0;
					case 1: 
						spr.x += (95 * 0.7) * 1;
					case 2: 
						spr.x += (95 * 0.7) * 2;
					case 3: 
						spr.x += (95 * 0.7) * 3;
					case 4: 
						spr.x += (95 * 0.7) * 4;
					case 5: 
						spr.x += (95 * 0.7) * 5;
					case 6: 
						spr.x += (95 * 0.7) * 6;
					case 7: 
						spr.x += (95 * 0.7) * 7;
					case 8:
						spr.x += (95 * 0.7) * 8;
				}
				spr.x -= Note.tooMuch;
			case 13: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (130 * 0.7) * 0;
					case 1: 
						spr.x += (130 * 0.7) * 1;
					case 2: 
						spr.x += (130 * 0.7) * 3;
					case 3: 
						spr.x += (130 * 0.7) * 4;
					case 4: 
						spr.x += (130 * 0.7) * 2;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 14: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (110 * 0.7) * 0;
					case 1: 
						spr.x += (110 * 0.7) * 5;
					case 2: 
						spr.x += (110 * 0.7) * 1;
					case 3: 
						spr.x += (110 * 0.7) * 2;
					case 4: 
						spr.x += (110 * 0.7) * 3;
					case 5: 
						spr.x += (110 * 0.7) * 4;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (110 * 0.7) * 6;
				}
			case 15: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (100 * 0.7) * 0;
					case 1: 
						spr.x += (100 * 0.7) * 1;
					case 2: 
						spr.x += (100 * 0.7) * 2;
					case 3: 
						spr.x += (100 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (100 * 0.7) * 4;
					case 6: 
						spr.x += (100 * 0.7) * 5;
					case 7: 
						spr.x += (100 * 0.7) * 6;
					case 8:
						spr.x += (100 * 0.7) * 7;
				}
			case 16: 
				switch(spr.ID)
				{
					case 0: 
						spr.alpha = 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.alpha = 0;
					case 4: 
						spr.x += (160 * 0.7) * 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 17: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 1;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 18: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 2;
					case 4: 
						spr.x += (160 * 0.7) * 1;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
		}
		spr.x += 50;
		if (PlayStateChangeables.flip)
			{
				
				switch (player)
				{
					case 0:
						spr.x += ((FlxG.width / 2) * 1); //so flip mode works pog
					case 1:
						spr.x += ((FlxG.width / 2) * 0);
				}
			}
		else
			spr.x += ((FlxG.width / 2) * player);
	}
	

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	var danced:Bool = false;

	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		
		if (SONG.song.toLowerCase() == "tutorial" && curStep != stepOfLast && storyDifficulty == 2) //song events
			{
				switch(curStep) //guide for anyone looking at this, switching mid song needs to be mania + 10
				{
					case 56: //switched it to modcharts! (can still be hardcoded though)
						//2 key
						//switchMania(17);
					case 125: 
						//4 key
						//switchMania(10);
					case 189: 
						//6 key
						//switchMania(11);
					case 252: 
						//8 key
						//switchMania(15);
					case 323: 
						//9 key
						//switchMania(12);
					case 390: 
						//4 key
						//switchMania(10);
					case 410: 
						//9 key
						//switchMania(12);
				}
			}

			

			if (FlxG.save.data.dodge)
				{
					if (SONG.song.toLowerCase() == 'decition')
						{
							switch (curStep)
								{
									/* guia curstep

									case 1 :// el curbeat de la alerta que inicie
									add(shad_attack_alert);
									SHADATTACK_ALERT();
									SHADATTACK();
									
									case 5 : // direferencia entre 4 para doble sonido
									SHADATTACK_ALERT();

									case 9 : // diferencia de 4 para ataque
									SHADATTACK(true);

									*/

									
									
									case 204 :
										add(shad_attack_alert);
										SHADATTACK_ALERT();

										case 208 :
										
											SHADATTACK(true);	
									
									// mrz del futuro resuelve porque a cada rato el bf hace el idle y tambien elos timings de la alerta
								}
						
		
						}

						if (SONG.song.toLowerCase() == 'permadeath')
							{
								switch (curStep)
									{
										/* guia curstep
	
										case 1 :// el curbeat de la alerta que inicie
										add(shad_attack_alert);
										SHADATTACK_ALERT();
										SHADATTACK();
										
										case 5 : // direferencia entre 4 para doble sonido
										SHADATTACK_ALERT();
	
										case 9 : // diferencia de 4 para ataque
										SHADATTACK(true);
	
										*/
										case 120:
											add(shad_attack_alert);
											SHADATTACK_ALERT();
											SHADATTACK();
										case 124:
											SHADATTACK_ALERT();
										case 128:
											SHADATTACK(true);
										
											///////////////
										case 278:
											add(shad_attack_alert);
											SHADATTACK_ALERT();
											SHADATTACK();
										case 282:
											SHADATTACK_ALERT();
										case 286:
											SHADATTACK(true);

											///////////////

										case 352:
											add(shad_attack_alert);
											SHADATTACK_ALERT();
											SHADATTACK();
										case 356:
											SHADATTACK_ALERT();
										case 360:
											SHADATTACK(true);

											///////////////

											case 418:
												add(shad_attack_alert);
												SHADATTACK_ALERT();
												SHADATTACK();
											case 420:
												SHADATTACK_ALERT();
											case 424:
												SHADATTACK(true);
	
												///////////////

											case 488:
												add(shad_attack_alert);
												SHADATTACK_ALERT();
												SHADATTACK();
											case 492:
												SHADATTACK_ALERT();
											case 496:
												SHADATTACK(true);
	
												///////////////

											case 452:
												add(shad_attack_alert);
												SHADATTACK_ALERT();
												SHADATTACK();
											case 556:
												SHADATTACK_ALERT();
											case 560:
												SHADATTACK(true);
	
												///////////////

												case 608:
													add(shad_attack_alert);
													SHADATTACK_ALERT();
													SHADATTACK();
												case 612:
													SHADATTACK_ALERT();
												case 616:
													SHADATTACK(true);
		
													///////////////

													case 696:
														add(shad_attack_alert);
														SHADATTACK_ALERT();
														SHADATTACK();
													case 700:
														SHADATTACK_ALERT();
													case 704:
														SHADATTACK(true);
			
														///////////////

														case 752:
															add(shad_attack_alert);
															SHADATTACK_ALERT();
															SHADATTACK();
														case 756:
															SHADATTACK_ALERT();
														case 760:
															SHADATTACK(true);
				
															///////////////

															case 800:
																add(shad_attack_alert);
																SHADATTACK_ALERT();
																SHADATTACK();
															case 804:
																SHADATTACK_ALERT();
															case 808:
																SHADATTACK(true);
					
																///////////////

																case 812:
																	add(shad_attack_alert);
																	SHADATTACK_ALERT();
																	SHADATTACK();
																case 816:
																	SHADATTACK_ALERT();
																case 820:
																	SHADATTACK(true);
						
																	///////////////

																	case 952:
																		add(shad_attack_alert);
																		SHADATTACK_ALERT();
																		SHADATTACK();
																	case 956:
																		SHADATTACK_ALERT();
																	case 960:
																		SHADATTACK(true);
							
																		///////////////

																		case 1072:
																			add(shad_attack_alert);
																			SHADATTACK_ALERT();
																			SHADATTACK();
																		case 1076:
																			SHADATTACK_ALERT();
																		case 1080:
																			SHADATTACK(true);
								
																			///////////////

																			case 1248:
																				add(shad_attack_alert);
																				SHADATTACK_ALERT();
																				SHADATTACK();
																			case 1252:
																				SHADATTACK_ALERT();
																			case 1256:
																				SHADATTACK(true);
									
																				///////////////

																				case 1312:
																					add(shad_attack_alert);
																					SHADATTACK_ALERT();
																					SHADATTACK();
																				case 1316:
																					SHADATTACK_ALERT();
																				case 1320:
																					SHADATTACK(true);
										
																					///////////////

																					case 1342:
																						add(shad_attack_alert);
																						SHADATTACK_ALERT();
																						SHADATTACK();
																					case 1346:
																						SHADATTACK_ALERT();
																					case 1350:
																						SHADATTACK(true);
											
																						///////////////

																						case 1532:
																							add(shad_attack_alert);
																							SHADATTACK_ALERT();
																							SHADATTACK();
																						case 1536:
																							SHADATTACK_ALERT();
																						case 1540:
																							SHADATTACK(true);
												
																							///////////////

																							case 1542:
																								add(shad_attack_alert);
																								SHADATTACK_ALERT();
																								SHADATTACK();
																							case 1546:
																								SHADATTACK_ALERT();
																							case 1550:
																								SHADATTACK(true);
													
																								///////////////

																								case 1552:
																									add(shad_attack_alert);
																									SHADATTACK_ALERT();
																									SHADATTACK();
																								case 1556:
																									SHADATTACK_ALERT();
																								case 1560:
																									SHADATTACK(true);
														
																									///////////////

																									case 1562:
																										add(shad_attack_alert);
																										SHADATTACK_ALERT();
																										SHADATTACK();
																									case 1566:
																										SHADATTACK_ALERT();
																									case 1570:
																										SHADATTACK(true);
															
																										///////////////

																										case 1572:
																											add(shad_attack_alert);
																											SHADATTACK_ALERT();
																											SHADATTACK();
																										case 1576:
																											SHADATTACK_ALERT();
																										case 1580:
																											SHADATTACK(true);
																
																											///////////////

																											case 1582:
																												add(shad_attack_alert);
																												SHADATTACK_ALERT();
																												SHADATTACK();
																											case 1586:
																												SHADATTACK_ALERT();
																											case 1590:
																												SHADATTACK(true);
																	
																												///////////////

																												case 1592:
																													add(shad_attack_alert);
																													SHADATTACK_ALERT();
																													SHADATTACK();
																												case 1596:
																													SHADATTACK_ALERT();
																												case 1600:
																													SHADATTACK(true);
																		
																													///////////////

																													case 1712:
																														add(shad_attack_alert);
																														SHADATTACK_ALERT();
																														SHADATTACK();
																													case 1716:
																														SHADATTACK_ALERT();
																													case 1720:
																														SHADATTACK(true);
																			
																														///////////////

																														case 1752:
																															add(shad_attack_alert);
																															SHADATTACK_ALERT();
																															SHADATTACK();
																														case 1756:
																															SHADATTACK_ALERT();
																														case 1760:
																															SHADATTACK(true);
																				
																															///////////////

																															
																															case 1782:
																																add(shad_attack_alert);
																																SHADATTACK_ALERT();
																																SHADATTACK();
																															case 1786:
																																SHADATTACK_ALERT();
																															case 1790:
																																SHADATTACK(true);
																					
																																///////////////

																																case 1842:
																																	add(shad_attack_alert);
																																	SHADATTACK_ALERT();
																																	SHADATTACK();
																																case 1846:
																																	SHADATTACK_ALERT();
																																case 1850:
																																	SHADATTACK(true);
																						
																																	///////////////

																																	case 1862:
																																		add(shad_attack_alert);
																																		SHADATTACK_ALERT();
																																		SHADATTACK();
																																	case 1866:
																																		SHADATTACK_ALERT();
																																	case 1870:
																																		SHADATTACK(true);
																							
																																		///////////////

																																		case 1892:
																																			add(shad_attack_alert);
																																			SHADATTACK_ALERT();
																																			SHADATTACK();
																																		case 1896:
																																			SHADATTACK_ALERT();
																																		case 1900:
																																			SHADATTACK(true);
																								
																																			///////////////

																																			case 1902:
																																				add(shad_attack_alert);
																																				SHADATTACK_ALERT();
																																				SHADATTACK();
																																			case 1906:
																																				SHADATTACK_ALERT();
																																			case 1910:
																																				SHADATTACK(true);
																									
																																				///////////////

																																				case 1912:
																																					add(shad_attack_alert);
																																					SHADATTACK_ALERT();
																																					SHADATTACK();
																																				case 1916:
																																					SHADATTACK_ALERT();
																																				case 1920:
																																					SHADATTACK(true);
																										
																																					///////////////

																																					case 1962:
																																						add(shad_attack_alert);
																																						SHADATTACK_ALERT();
																																						SHADATTACK();
																																					case 1966:
																																						SHADATTACK_ALERT();
																																					case 1970:
																																						SHADATTACK(true);
																											
																																						///////////////

																																						case 1982:
																																							add(shad_attack_alert);
																																							SHADATTACK_ALERT();
																																							SHADATTACK();
																																						case 1986:
																																							SHADATTACK_ALERT();
																																						case 1990:
																																							SHADATTACK(true);
																												
																																							///////////////

																																							case 2012:
																																								add(shad_attack_alert);
																																								SHADATTACK_ALERT();
																																								SHADATTACK();
																																							case 2016:
																																								SHADATTACK_ALERT();
																																							case 2020:
																																								SHADATTACK(true);
																													
																																								///////////////

																																								
																																							case 2032:
																																								add(shad_attack_alert);
																																								SHADATTACK_ALERT();
																																								SHADATTACK();
																																							case 2036:
																																								SHADATTACK_ALERT();
																																							case 2040:
																																								SHADATTACK(true);
																													
																																								///////////////

																																								case 2042:
																																									add(shad_attack_alert);
																																									SHADATTACK_ALERT();
																																									SHADATTACK();
																																								case 2046:
																																									SHADATTACK_ALERT();
																																								case 2050:
																																									SHADATTACK(true);
																														
																																									///////////////

																																									case 2072:
																																										add(shad_attack_alert);
																																										SHADATTACK_ALERT();
																																										SHADATTACK();
																																									case 2076:
																																										SHADATTACK_ALERT();
																																									case 2080:
																																										SHADATTACK(true);
																															
																																										///////////////

																																										case 2082:
																																											add(shad_attack_alert);
																																											SHADATTACK_ALERT();
																																											SHADATTACK();
																																										case 2086:
																																											SHADATTACK_ALERT();
																																										case 2090:
																																											SHADATTACK(true);
																																
																																											///////////////

																																											case 2092:
																																												add(shad_attack_alert);
																																												SHADATTACK_ALERT();
																																												SHADATTACK();
																																											case 2096:
																																												SHADATTACK_ALERT();
																																											case 2100:
																																												SHADATTACK(true);
																																	
																																												///////////////

																																												case 2102:
																																													add(shad_attack_alert);
																																													SHADATTACK_ALERT();
																																													SHADATTACK();
																																												case 2106:
																																													SHADATTACK_ALERT();
																																												case 2110:
																																													SHADATTACK(true);
																																		
																																													///////////////

																																													case 2232:
																																														add(shad_attack_alert);
																																														SHADATTACK_ALERT();
																																														SHADATTACK();
																																													case 2236:
																																														SHADATTACK_ALERT();
																																													case 2240:
																																														SHADATTACK(true);
																																			
																																														///////////////

																																														case 2252:
																																															add(shad_attack_alert);
																																															SHADATTACK_ALERT();
																																															SHADATTACK();
																																														case 2256:
																																															SHADATTACK_ALERT();
																																														case 2260:
																																															SHADATTACK(true);
																																				
																																															///////////////

																																															case 2262:
																																																add(shad_attack_alert);
																																																SHADATTACK_ALERT();
																																																SHADATTACK();
																																															case 2266:
																																																SHADATTACK_ALERT();
																																															case 2270:
																																																SHADATTACK(true);
																																					
																																																///////////////

																																																case 2332:
																																																	add(shad_attack_alert);
																																																	SHADATTACK_ALERT();
																																																	SHADATTACK();
																																																case 2336:
																																																	SHADATTACK_ALERT();
																																																case 2340:
																																																	SHADATTACK(true);
																																						
																																																	///////////////

																																																	case 2552:
																																																		add(shad_attack_alert);
																																																		SHADATTACK_ALERT();
																																																		SHADATTACK();
																																																	case 2556:
																																																		SHADATTACK_ALERT();
																																																	case 2560:
																																																		SHADATTACK(true);
																																							
																																																		///////////////

																																																		case 2612:
																																																			add(shad_attack_alert);
																																																			SHADATTACK_ALERT();
																																																			SHADATTACK();
																																																		case 2616:
																																																			SHADATTACK_ALERT();
																																																		case 2620:
																																																			SHADATTACK(true);
																																								
																																																			///////////////

																																																			
																																																		case 2632:
																																																			add(shad_attack_alert);
																																																			SHADATTACK_ALERT();
																																																			SHADATTACK();
																																																		case 2636:
																																																			SHADATTACK_ALERT();
																																																		case 2640:
																																																			SHADATTACK(true);
																																								
																																																			///////////////
																																																			
																																																			case 2662:
																																																				add(shad_attack_alert);
																																																				SHADATTACK_ALERT();
																																																				SHADATTACK();
																																																			case 2666:
																																																				SHADATTACK_ALERT();
																																																			case 2670:
																																																				SHADATTACK(true);
																																									
																																																				///////////////	
																																																										
																																																				case 2812:
																																																					add(shad_attack_alert);
																																																					SHADATTACK_ALERT();
																																																					SHADATTACK();
																																																				case 2816:
																																																					SHADATTACK_ALERT();
																																																				case 2820:
																																																					SHADATTACK(true);
																																										
																																																					///////////////	

																																																					case 2842:
																																																						add(shad_attack_alert);
																																																						SHADATTACK_ALERT();
																																																						SHADATTACK();
																																																					case 2846:
																																																						SHADATTACK_ALERT();
																																																					case 2850:
																																																						SHADATTACK(true);
																																											
																																																						///////////////	

																																																						case 2862:
																																																							add(shad_attack_alert);
																																																							SHADATTACK_ALERT();
																																																							SHADATTACK();
																																																						case 2866:
																																																							SHADATTACK_ALERT();
																																																						case 2870:
																																																							SHADATTACK(true);
																																												
																																																							///////////////	

																																																							case 2872:
																																																								add(shad_attack_alert);
																																																								SHADATTACK_ALERT();
																																																								SHADATTACK();
																																																							case 2876:
																																																								SHADATTACK_ALERT();
																																																							case 2880:
																																																								SHADATTACK(true);
																																													
																																																								///////////////	

																																																								
																																																								case 2902:
																																																									add(shad_attack_alert);
																																																									SHADATTACK_ALERT();
																																																									SHADATTACK();
																																																								case 2906:
																																																									SHADATTACK_ALERT();
																																																								case 2910:
																																																									SHADATTACK(true);
																																														
																																																									///////////////																	

																																																									case 2922:
																																																										add(shad_attack_alert);
																																																										SHADATTACK_ALERT();
																																																										SHADATTACK();
																																																									case 2926:
																																																										SHADATTACK_ALERT();
																																																									case 2930:
																																																										SHADATTACK(true);
																																															
																																																										///////////////
																																																											
																																																										case 2932:
																																																											add(shad_attack_alert);
																																																											SHADATTACK_ALERT();
																																																											SHADATTACK();
																																																										case 2936:
																																																											SHADATTACK_ALERT();
																																																										case 2940:
																																																											SHADATTACK(true);
																																																
																																																											///////////////

																																																											case 3202:
																																																												add(shad_attack_alert);
																																																												SHADATTACK_ALERT();
																																																												SHADATTACK();
																																																											case 3206:
																																																												SHADATTACK_ALERT();
																																																											case 3210:
																																																												SHADATTACK(true);
																																																	
																																																												///////////////

																																																												case 3222:
																																																													add(shad_attack_alert);
																																																													SHADATTACK_ALERT();
																																																													SHADATTACK();
																																																												case 3226:
																																																													SHADATTACK_ALERT();
																																																												case 3230:
																																																													SHADATTACK(true);
																																																		
																																																													///////////////

																																																													case 3242:
																																																														add(shad_attack_alert);
																																																														SHADATTACK_ALERT();
																																																														SHADATTACK();
																																																													case 3246:
																																																														SHADATTACK_ALERT();
																																																													case 3250:
																																																														SHADATTACK(true);
																																																			
																																																														///////////////

																																																														case 3252:
																																																															add(shad_attack_alert);
																																																															SHADATTACK_ALERT();
																																																															SHADATTACK();
																																																														case 3256:
																																																															SHADATTACK_ALERT();
																																																														case 3360:
																																																															SHADATTACK(true);
																																																				
																																																															///////////////

																																																															case 3402:
																																																																add(shad_attack_alert);
																																																																SHADATTACK_ALERT();
																																																																SHADATTACK();
																																																															case 3406:
																																																																SHADATTACK_ALERT();
																																																															case 3410:
																																																																SHADATTACK(true);
																																																					
																																																																///////////////

																																																																
																																																																case 3412:
																																																																	add(shad_attack_alert);
																																																																	SHADATTACK_ALERT();
																																																																	SHADATTACK();
																																																																case 3416:
																																																																	SHADATTACK_ALERT();
																																																																case 3420:
																																																																	SHADATTACK(true);
																																																						
																																																																	///////////////

																																																																	
																																																																	case 3422:
																																																																		add(shad_attack_alert);
																																																																		SHADATTACK_ALERT();
																																																																		SHADATTACK();
																																																																	case 3426:
																																																																		SHADATTACK_ALERT();
																																																																	case 3430:
																																																																		SHADATTACK(true);
																																																							
																																																																		///////////////

																																																																		case 3432:
																																																																			add(shad_attack_alert);
																																																																			SHADATTACK_ALERT();
																																																																			SHADATTACK();
																																																																		case 3436:
																																																																			SHADATTACK_ALERT();
																																																																		case 3440:
																																																																			SHADATTACK(true);
																																																								
																																																																			///////////////

																																																																			case 3442:
																																																																				add(shad_attack_alert);
																																																																				SHADATTACK_ALERT();
																																																																				SHADATTACK();
																																																																			case 3446:
																																																																				SHADATTACK_ALERT();
																																																																			case 3450:
																																																																				SHADATTACK(true);
																																																									
																																																																				///////////////

																																																																				case 3612:
																																																																					add(shad_attack_alert);
																																																																					SHADATTACK_ALERT();
																																																																					SHADATTACK();
																																																																				case 3616:
																																																																					SHADATTACK_ALERT();
																																																																				case 3620:
																																																																					SHADATTACK(true);
																																																										
																																																																					///////////////	

																																																																					case 3622:
																																																																						add(shad_attack_alert);
																																																																						SHADATTACK_ALERT();
																																																																						SHADATTACK();
																																																																					case 3626:
																																																																						SHADATTACK_ALERT();
																																																																					case 3630:
																																																																						SHADATTACK(true);
																																																											
																																																																						///////////////	
																																																																						
																																																																						case 3702:
																																																																							add(shad_attack_alert);
																																																																							SHADATTACK_ALERT();
																																																																							SHADATTACK();
																																																																						case 3706:
																																																																							SHADATTACK_ALERT();
																																																																						case 3710:
																																																																							SHADATTACK(true);
																																																												
																																																																							///////////////	

																																																																							case 4102:
																																																																								add(shad_attack_alert);
																																																																								SHADATTACK_ALERT();
																																																																								SHADATTACK();
																																																																							case 4106:
																																																																								SHADATTACK_ALERT();
																																																																							case 4110:
																																																																								SHADATTACK(true);
																																																													
																																																																								///////////////	

																																																																								case 4122:
																																																																									add(shad_attack_alert);
																																																																									SHADATTACK_ALERT();
																																																																									SHADATTACK();
																																																																								case 4126:
																																																																									SHADATTACK_ALERT();
																																																																								case 4130:
																																																																									SHADATTACK(true);
																																																														
																																																																									///////////////
																																																																									
																																																																									case 4142:
																																																																										add(shad_attack_alert);
																																																																										SHADATTACK_ALERT();
																																																																										SHADATTACK();
																																																																									case 4146:
																																																																										SHADATTACK_ALERT();
																																																																									case 4150:
																																																																										SHADATTACK(true);
																																																															
																																																																										///////////////

																																																																										case 4172:
																																																																											add(shad_attack_alert);
																																																																											SHADATTACK_ALERT();
																																																																											SHADATTACK();
																																																																										case 4176:
																																																																											SHADATTACK_ALERT();
																																																																										case 4180:
																																																																											SHADATTACK(true);
																																																																
																																																																											///////////////

																																																																											case 4202:
																																																																												add(shad_attack_alert);
																																																																												SHADATTACK_ALERT();
																																																																												SHADATTACK();
																																																																											case 4206:
																																																																												SHADATTACK_ALERT();
																																																																											case 4210:
																																																																												SHADATTACK(true);
																																																																	
																																																																												///////////////

																																																																												case 4362:
																																																																													add(shad_attack_alert);
																																																																													SHADATTACK_ALERT();
																																																																													SHADATTACK();
																																																																												case 4366:
																																																																													SHADATTACK_ALERT();
																																																																												case 4370:
																																																																													SHADATTACK(true);
																																																																		
																																																																													///////////////
										


										// mrz del futuro resuelve porque a cada rato el bf hace el idle y tambien elos timings de la alerta
										//ya lo arregle lmao

										//me demore como unas 2 horas hacer el timing de los ataques xdasdasdasdasd

									}
							
			
							}
				
			
			
				if (curSong.toLowerCase() == 'termination')
				{
			
				
		
		
					switch (curStep)
					{
						//Commented out stuff are for the double sawblade variations.
						//It is recommended to not uncomment them unless you know what you're doing. They are also not polished at all so don't complain about them if you do uncomment them.
						
						
						//CONVERTED THE CUSTOM INTRO FROM MODCHART INTO HARDCODE OR WHATEVER! NO MORE INVISIBLE NOTES DUE TO NO MODCHART SUPPORT!
				
						
					
				case 48:
					add(shad_attack_saw);
					add(shad_attack_alert);
					SHADATTACK_ALERT();
					SHADATTACK();
				case 52:
					SHADATTACK_ALERT();
				case 56:
					SHADATTACK(true);
				case 112:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 116:
					SHADATTACK_ALERTDOUBLE();
				case 120:
					SHADATTACK(true, "old/attack_alt01");
				
				case 123:
					SHADATTACK();
				case 124:
				    //FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 2, {ease: FlxEase.sineInOut}); //for testing outro code
					SHADATTACK(true, "old/attack_alt02");
				

				case 272 | 304 | 404 | 416 | 504 | 544 | 560 | 612 | 664 | 696 | 752 | 816 | 868 | 880 | 1088 | 1204 | 1344 | 1400 | 1428 | 1440 | 1472 | 1520 | 1584 | 1648 | 1680 | 1712 | 1744:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 276 | 308 | 408 | 420 | 508 | 548 | 564 | 616 | 668 | 700 | 756 | 820 | 872 | 884 | 1092 | 1208 | 1348 | 1404 | 1432 | 1444 | 1476 | 1524 | 1588 | 1652 | 1684 | 1716 | 1748: 
					SHADATTACK_ALERT();
				case 280 | 312 | 412 | 424 | 512 | 552 | 568 | 620 | 672 | 704 | 760 | 824 | 876 | 888 | 1096 | 1212 | 1352 | 1408 | 1436 | 1448 | 1480 | 1528 | 1592 | 1656 | 1688 | 1720 | 1752:
					SHADATTACK(true);

				case 1776 | 1904 | 2576 | 2596 | 2624 | 2640 | 2660 | 2704 | 2736 | 3072 | 3104 | 3136 | 3152 | 3168 | 3184 | 3216 | 3248 | 3312:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 1780 | 1908 | 2580 | 2600 | 2628 | 2644 | 2664 | 2708 | 2740 | 3076 | 3108 | 3140 | 3156 | 3172 | 3188 | 3220 | 3252 | 3316:
					SHADATTACK_ALERT();
				case 1784 | 1912 | 2584 | 2604 | 2632 | 2648 | 2668 | 2712 | 2744 | 3080 | 3112 | 3144 | 3160 | 3176 | 3192 | 3224 | 3256 | 3320:
					SHADATTACK(true);

				case 1808 | 1840 | 1872 | 1952 | 2000 | 2112 | 2148 | 2176 | 2192 | 2228 | 2240 | 2272 | 2768 | 2788 | 2800 | 2864 | 2916 | 2928 | 3024 | 3264 | 3280 | 3300:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 1812 | 1844 | 1876 | 1956 | 2004 | 2116 | 2152 | 2180 | 2196 | 2232 | 2244 | 2276 | 2772 | 2792 | 2804 | 2868 | 2920 | 2932 | 3028 | 3268 | 3284 | 3304:
					SHADATTACK_ALERT();
				case 1816 | 1848 | 1880 | 1960 | 2008 | 2120 | 2156 | 2184 | 2200 | 2236 | 2248 | 2280 | 2776 | 2796 | 2808 | 2872 | 2924 | 2936 | 3032 | 3272 | 3288 | 3308:
					SHADATTACK(true);

                case 624 | 1136 | 2032 | 2608 | 2672 | 3084 | 3116 | 4140 | 4204 | 4464:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 628 | 1140 | 2036 | 2612 | 2676 | 3088 | 3120 | 4144 | 4208 | 4468:
					SHADATTACK_ALERTDOUBLE();
				case 632 | 1144 | 2040 | 2616 | 2680 | 3092 | 3124 | 4148 | 4212 | 4472:
					SHADATTACK(true, "old/attack_alt01");
				case 635 | 1147 | 2043 | 2619 | 2683 | 3095 | 3127 | 4151 | 4215 | 4475:
					SHADATTACK();
				case 636 | 1148 | 2044 | 2620 | 2684 | 3096 | 3128 | 4152 | 4216 | 4476:
					SHADATTACK(true, "old/attack_alt02");
				//Sawblades before bluescreen thing
				//These were seperated for double sawblade experimentation if you're wondering.
				//My god this organisation is so bad. Too bad!
				//Yes, this is too bad! -DrkFon376
				case 2304 | 2320 | 2340 | 2368 | 2384 | 2404 | 2496 | 2528:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 2308 | 2324 | 2344 | 2372 | 2388 | 2408 | 2500 | 2532:
					SHADATTACK_ALERT();
				case 2312 | 2328 | 2348 | 2376 | 2392 | 2412 | 2504 | 2536:
					SHADATTACK(true);

				case 2352 | 2416:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 2356 | 2420:
					SHADATTACK_ALERTDOUBLE();
				case 2360 | 2424:
					SHADATTACK(true, "old/attack_alt01");
				case 2363 | 2427:
					SHADATTACK();
				case 2364 | 2428:
					SHADATTACK(true, "old/attack_alt02");

				case 2560:
					SHADATTACK_ALERT();
					SHADATTACK();
					
				case 2564:
					SHADATTACK_ALERT();
				case 2568:
					SHADATTACK(true);
				
				
					

				case 2816: //404 section
					
				case 3328: //Final drop
				
				case 3360 | 3376 | 3396 | 3408 | 3424 | 3440 | 3504 | 3552 | 3576 | 3616 | 3636 | 3648 | 3664 | 3680 | 3696 | 3776 | 3808 | 3888 | 3824 | 3872 | 3924 | 3936 | 3952 | 3984:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 3364 | 3380 | 3400 | 3412 | 3428 | 3444 | 3508 | 3556 | 3580 | 3620 | 3640 | 3652 | 3668 | 3684 | 3700 | 3780 | 3812 | 3892 | 3828 | 3876 | 3928 | 3940 | 3956 | 3988:
					SHADATTACK_ALERT();
				case 3368 | 3384 | 3404 | 3416 | 3432 | 3448 | 3512 | 3560 | 3584 | 3624 | 3644 | 3656 | 3672 | 3688 | 3704 | 3784 | 3816 | 3896 | 3832 | 3880 | 3932 | 3944 | 3960 | 3992:
					SHADATTACK(true);

				case 4020 | 4032 | 4064 | 4080 | 4096 | 4108 | 4128 | 4160 | 4176 | 4192 | 4224 | 4256 | 4268 | 4288 | 4324 | 4336 | 4368 | 4400 | 4432 | 4496 | 4528 | 4560 | 4592 | 4656:
					SHADATTACK_ALERT();
					SHADATTACK();
				case 4024 | 4036 | 4068 | 4084 | 4100 | 4112 | 4132 | 4164 | 4180 | 4196 | 4228 | 4260 | 4272 | 4292 | 4328 | 4340 | 4372 | 4404 | 4436 | 4500 | 4532 | 4564 | 4596 | 4660:
					SHADATTACK_ALERT();
				case 4028 | 4040 | 4072 | 4088 | 4104 | 4116 | 4136 | 4168 | 4184 | 4200 | 4232 | 4264 | 4276 | 4296 | 4332 | 4344 | 4376 | 4408 | 4440 | 4504 | 4536 | 4568 | 4600 | 4664://<----LMAO this is the last sawblade placed on the penultimate beat of the level. Funny, right? 
					SHADATTACK(true);
								
				
						
						/*case 112:
							
							add(shad_attack_alert);
							SHADATTACK_ALERT();
							SHADATTACK();
						case 116:
							//SHADATTACK_ALERTDOUBLE();
							SHADATTACK_ALERT();
						case 120:
							//SHADATTACK(true, "old/attack_alt01");
							SHADATTACK(true);
					
						//case 123:
							//SHADATTACK();
						//case 124:
							//FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 2, {ease: FlxEase.sineInOut}); //for testing outro code
							//SHADATTACK(true, "old/attack_alt02");
					
		
						case 1776 | 1904 | 2032 | 2576 | 2596 | 2608 | 2624 | 2640 | 2660 | 2672 | 2704 | 2736 | 3072 | 3084 | 3104 | 3116 | 3136 | 3152 | 3168 | 3184 | 3216 | 3248 | 3312:
							SHADATTACK_ALERT();
							SHADATTACK();
						case 1780 | 1908 | 2036 | 2580 | 2600 | 2612 | 2628 | 2644 | 2664 | 2676 | 2708 | 2740 | 3076 | 3088 | 3108 | 3120 | 3140 | 3156 | 3172 | 3188 | 3220 | 3252 | 3316:
							SHADATTACK_ALERT();
						case 1784 | 1912 | 2040 | 2584 | 2604 | 2616 | 2632 | 2648 | 2668 | 2680 | 2712 | 2744 | 3080 | 3092 | 3112 | 3124 | 3144 | 3160 | 3176 | 3192 | 3224 | 3256 | 3320:
							SHADATTACK(true);
		
						//Sawblades before bluescreen thing
						//These were seperated for double sawblade experimentation if you're wondering.
						//My god this organisation is so bad. Too bad!
						case 2304 | 2320 | 2340 | 2368 | 2384 | 2404:
							SHADATTACK_ALERT();
							SHADATTACK();
						case 2308 | 2324 | 2344 | 2372 | 2388 | 2408:
							SHADATTACK_ALERT();
						case 2312 | 2328 | 2348 | 2376 | 2392 | 2412:
							SHADATTACK(true);
						case 2352 | 2416:
							SHADATTACK_ALERT();
							SHADATTACK();
						case 2356 | 2420:
							//SHADATTACK_ALERTDOUBLE();
							SHADATTACK_ALERT();
						case 2360 | 2424:
							SHADATTACK(true);
						case 2363 | 2427:
							//SHADATTACK();
						case 2364 | 2428:
							//SHADATTACK(true, "old/attack_alt02");
		
						case 2560:
							SHADATTACK_ALERT();
							SHADATTACK();

						case 2564:
							SHADATTACK_ALERT();
						case 2568:
							SHADATTACK(true);
		
		
						case 3376 | 3408 | 3424 | 3440 | 3576 | 3636 | 3648 | 3680 | 3696 | 3888 | 3936 | 3952 | 4096 | 4108 | 4128 | 4140 | 4160 | 4176 | 4192 | 4204:
							SHADATTACK_ALERT();
							SHADATTACK();
						case 3380 | 3412 | 3428 | 3444 | 3580 | 3640 | 3652 | 3684 | 3700 | 3892 | 3940 | 3956 | 4100 | 4112 | 4132 | 4144 | 4164 | 4180 | 4196 | 4208:
							SHADATTACK_ALERT();
						case 3384 | 3416 | 3432 | 3448 | 3584 | 3644 | 3656 | 3688 | 3704 | 3896 | 3944 | 3960 | 4104 | 4116 | 4136 | 4148 | 4168 | 4184 | 4200 | 4212:
							SHADATTACK(true);*/
					}
				}
				//????
			}
		
		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}





		if (currentSection != null)
		{
			if (!currentSection.mustHitSection)
			{
				switch (PlayStateChangeables.randomMania)
				{
					case 1: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(0.5) && !justChangedMania)
						{
							switchMania(randomNum);
						}
					case 2: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(5) && !justChangedMania)
						{
							switchMania(randomNum);
						}
					case 3: 
						var randomNum = FlxG.random.int(10, 15);
						if (FlxG.random.bool(15) && !justChangedMania)
						{
							switchMania(randomNum);
						}
				}
			}
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (currentSection.mustHitSection && dad.curCharacter != 'gf')
				{
						dad.dance();
				}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.dance();
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

			if (curBeat == 1 && curSong == 'permadeath' && storyDifficulty == 3) 
				{
					tetrisblockage(50, 60, false);
					tetrisblockage(45, 12, false);	
					tetrisblockage(45, 12, false);	
				}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;



}
