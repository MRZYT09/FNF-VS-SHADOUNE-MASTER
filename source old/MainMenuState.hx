package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.input.gamepad.FlxGamepad;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import flash.system.System;


#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	public var bgCam:FlxCamera;
	public var camHUD:FlxCamera;
	var curSelected:Int = 0;
	var shitpost:String;
	var finalVar:Array<Dynamic> = [];

	var menuItems:FlxTypedGroup<FlxSprite>;

	var logoBl:FlxSprite; 

	  
		// yellow shit
	  var yellowShit:FlxText;
	  


	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options', 'quit', 'character', 'credits'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.4 KE" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	public static var bgPaths:Array<String> = 
	[
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/BG5',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/menuBG',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/baguette',
		'backgrounds/menuDesat',
		'backgrounds/menuDesat',
		'backgrounds/menuDesat',
		'backgrounds/menuDesat',
		'backgrounds/menuDesat',
		'backgrounds/menuDesat',
		'backgrounds/poto'
	];
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;


		FlxG.mouse.visible = true;

		getShit();

		var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.10;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');


				var menuItem:FlxSprite = new FlxSprite(20, 250);//omg
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[0] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[0] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 0;
				menuItem.updateHitbox();
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
			
				menuItem.antialiasing = true;
				

				var menuItem:FlxSprite = new FlxSprite(20, 345);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[1] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[1] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 1;
				menuItem.updateHitbox();
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
			
				menuItem.antialiasing = true;	


				var menuItem:FlxSprite = new FlxSprite(20, 430);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[2] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[2] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 2;
				menuItem.updateHitbox();
				menuItem.screenCenter(X);
				menuItems.add(menuItem);
				
				menuItem.antialiasing = true;
				

				var menuItem:FlxSprite = new FlxSprite(265, 520);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[3] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[3] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 3;
				menuItem.updateHitbox();
				//menuItem.screenCenter(X);
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.6));
				menuItems.add(menuItem);

				menuItem.antialiasing = true;


				var menuItem:FlxSprite = new FlxSprite(690, 522);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[4] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[4] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 4;
				menuItem.updateHitbox();
				//menuItem.screenCenter(X);
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.75));
				menuItems.add(menuItem);

				menuItem.antialiasing = true;


				var menuItem:FlxSprite = new FlxSprite(995, 440);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[5] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[5] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 5;
				menuItem.updateHitbox();
				//menuItem.screenCenter(X);
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.7));
				menuItems.add(menuItem);

				menuItem.antialiasing = true;


				var menuItem:FlxSprite = new FlxSprite(220, 440);
				menuItem.frames = tex;
				menuItem.animation.addByPrefix('idle', optionShit[6] + " basic", 24);
				menuItem.animation.addByPrefix('selected', optionShit[6] + " white", 24);
				menuItem.animation.play('idle');
				menuItem.ID = 6;
				menuItem.updateHitbox();
				//menuItem.screenCenter(X);
				menuItem.setGraphicSize(Std.int(menuItem.width * 0.6));
				menuItems.add(menuItem);

				menuItem.antialiasing = true;
			
		/*
		x - izquierda + derecha
		y - arriba + abajo
		*/
		/* character.hx:
		x - derecha + izquierda
		y - abajo + arriba
		*/

		yellowShit = new FlxText(0, 0, 0, finalVar[0] + '\n' + finalVar[1]);
		yellowShit.setFormat(Paths.font("minecraftia.ttf"), 18, FlxColor.YELLOW, CENTER);
        yellowShit.angle = -30;
        yellowShit.screenCenter();
        yellowShit.y -= 155;
        yellowShit.x += 250;

		

		add(menuItems);
		add(yellowShit);
		fuckBump(0);
		firstStart = false;

		//FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5,699 ,gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " - VS SHADOUNE" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Minecraftia 2.0", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}
			
	var selectedSomethin:Bool = false;

	var canClick:Bool = true;
	var usingMouse:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		menuItems.forEach(function(spr:FlxSprite)
			{
				if(usingMouse)
				{
					if(!FlxG.mouse.overlaps(spr))
						spr.animation.play('idle');
				}
		
				if (FlxG.mouse.overlaps(spr))
				{
					if(canClick)
					{
						curSelected = spr.ID;
						usingMouse = true;
						spr.animation.play('selected');
					}
						
					if(FlxG.mouse.pressed && canClick)
					{
						
					}
				}
	
		
				spr.updateHitbox();
			});

		if (!selectedSomethin)
		{
			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

			if (gamepad != null)
			{
				if (gamepad.justPressed.DPAD_UP)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(-1);
				}
				if (gamepad.justPressed.DPAD_DOWN)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					changeItem(1);
				}
			}

			if (FlxG.keys.justPressed.UP)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (FlxG.keys.justPressed.DOWN)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT || FlxG.mouse.pressed)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["http://twitch.tv/shadoune666", "http://instagram.com/shadoune666", "https://twitter.com/Shadoune666", " https://discord.gg/wWwdE3r"]);
					#else
					FlxG.openURL('https://www.youtube.com/user/Shadoune666Mc');
					FlxG.openURL('http://twitch.tv/shadoune666');
					FlxG.openURL('http://instagram.com/shadoune666');
					FlxG.openURL('https://twitter.com/Shadoune666');
					FlxG.openURL('https://discord.gg/wWwdE3r');
					#end				

					FlxG.switchState(new MainMenuState());
				}
				
				if (optionShit[curSelected] == 'quit')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://www.youtube.com/watch?v=dQw4w9WgXcQ"]);
					#else
					FlxG.openURL('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
					#end
					
					System.exit(0);
				}
					
				
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					canClick = false;

					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
		//spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());

				trace("Story Menu Selected");

			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());

				trace("use CHAD INPUT");

			case 'credits':
				FlxG.switchState(new MusicPlayerState());
				
				trace("c papu");
			
			case 'character':
				FlxG.switchState(new CreditsState());	

				trace("hazme un mundo sldg de nuevo");
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				//camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}

	public function getShit()
		{
			var text:String = Assets.getText(Paths.txt('MinecraftText'));
	
			var array:Array<String> = text.split('\n');
	
			shitpost = FlxG.random.getObject(array);
	
			finalVar = shitpost.split(' <> ');
		}

	function fuckBump(key:Int = 0)
		{
			if (key == 0)
			{
				FlxTween.tween(yellowShit.scale, {x: 1.2, y: 1.2}, 1, {
				onComplete: function(twn:FlxTween)
				{ 
					fuckBump(1);
				}});
			}
			else
			{
				FlxTween.tween(yellowShit.scale, {x: 1, y: 1}, 1, {
				onComplete: function(twn:FlxTween)
				{ 
					fuckBump(0);
				}});
			}
		}
		public static function randomizeBG():flixel.system.FlxAssets.FlxGraphicAsset
			{
				var chance:Int = FlxG.random.int(0, bgPaths.length - 1);
				return Paths.image(bgPaths[chance]);
			}
}
