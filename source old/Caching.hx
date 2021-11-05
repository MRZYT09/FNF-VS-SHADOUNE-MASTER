#if sys
package;

import lime.app.Application;	//game stuff
#if windows
import Discord.DiscordClient;	//fancy stuff
#end
import openfl.display.BitmapData;	//fancy stuff
import openfl.utils.Assets;
import flixel.addons.text.FlxTypeText;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.frontEnds.SoundFrontEnd;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var cachedThis:FlxText;
	var kadeLogo:FlxSprite;
	var iUseThisToFillTheIfThatCrashesTheGame:FlxText;

	var loadingbarBG:FlxSprite;
	var loadingbar:FlxBar;

	var swagText:FlxTypeText;

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var charts = [];

	var loadingPercent:Float = 1; //Increase to complete - MIN = 1 - MAX = 100

	var valueGet:Float = 1;


	override function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('BG5'));
		bg.antialiasing = true;
		bg.alpha = 0.1;
		add(bg);

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 2, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
		new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 2, new FlxPoint(0, 1),
		{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();
		
		loadingbarBG = new FlxSprite(0, 500).loadGraphic(Paths.image('loadingBar', 'shared'));
		loadingbarBG.screenCenter(X);
		loadingbarBG.scrollFactor.set();

		text = new FlxText(FlxG.width / 2, 635,0,"Loading...");
		text.size = 32;
		text.color = 0xFFFFFFFF;
		text.alignment = FlxTextAlign.CENTER;

		cachedThis = new FlxText(20, 680,0,"song");
		cachedThis.size = 32;
		cachedThis.color = 0xFFFFFFFF;
		cachedThis.alignment = FlxTextAlign.LEFT;

		loadingbar = new FlxBar(loadingbarBG.x + 4, loadingbarBG.y + 4, LEFT_TO_RIGHT, Std.int(loadingbarBG.width - 8), Std.int(loadingbarBG.height - 8), this, 'loadingPercent', 1, 100);
		loadingbar.createFilledBar(0xFF000000, 0xFFFFFFFF);

		kadeLogo = new FlxSprite(FlxG.width / 2, FlxG.height / 2).loadGraphic(Paths.image('KadeEngineLogo'));
		kadeLogo.x -= kadeLogo.width / 2;
		kadeLogo.y -= kadeLogo.height / 2 + 100;
		text.y -= kadeLogo.height / 2 - 125;
		text.x -= 170;
		kadeLogo.setGraphicSize(Std.int(kadeLogo.width * 0.6));
		kadeLogo.antialiasing = true;
		

		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			trace("caching images...");

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		toBeDone = Lambda.count(images) + Lambda.count(music);

		//var bar = new FlxBar(10,FlxG.height - 50,FlxBarFillDirection.LEFT_TO_RIGHT,FlxG.width,40,null,"done",0,toBeDone);
		//bar.color = FlxColor.PURPLE;

		//add(bar);

		add(kadeLogo);

		add(loadingbarBG);
		add(loadingbar);

		add(text);
		add(cachedThis);

		trace('starting caching..');
		
		#if cpp
		// update thread

		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						trace(cachedThis.y);
					}
			}
		
		});

		// cache thread

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	var calledDone = false;

	override function update(elapsed) 
	{
		switch (done) {
			case 1:
				if (loadingPercent < 50) {
					loadingPercent = loadingPercent + 2;
				}
			case 2:
				if (loadingPercent < 100) {
					loadingPercent = loadingPercent + 2;
				}
		
		}
		text.text = "Loading... (" + done + "/" + toBeDone + ")";

		cachedThis.alpha = cachedThis.alpha - 0.01;
		cachedThis.y = cachedThis.y + 0.2; 

		if (done == toBeDone) {
			new FlxTimer().start(2, function(tmr:FlxTimer)	
				{
					kadeLogo.alpha = kadeLogo.alpha - 0.01;
					text.alpha = text.alpha - 0.01;
					loadingbar.alpha = loadingbar.alpha - 0.01;
					loadingbarBG.alpha = loadingbarBG.alpha - 0.01;
					FlxG.switchState(new MCTitleScreen());
			});}
		super.update(elapsed);
	}

	function resetTextAlpha() {
		cachedThis.alpha = 1;
		cachedThis.y = 680;
	}

	function checkCompletion() {
		if (done != toBeDone) {
			loadingPercent = done / toBeDone;
		}
		else if (done == toBeDone) {
			loadingPercent = 1;
			text.text = "Loading complete!";
		}
	}

	function cache()
	{
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			trace('id ' + replaced + ' file - assets/shared/images/characters/' + i + ' ${data.width}');
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}

		for (i in music)
		{
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("Loading " + i);
			cachedThis.text = "Loading " + i;
			resetTextAlpha();
			done++;
		}


		trace("Finished caching...");

		loaded = true;

		trace(Assets.cache.hasBitmapData('GF_assets'));
	}
}
#end