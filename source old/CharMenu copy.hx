package;

import flash.text.TextField;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import haxe.Json;
import Boyfriend.Boyfriend;
import Character.Character;
import HealthIcon.HealthIcon;
import flixel.ui.FlxBar;

typedef CharacterMenu = {
	var name:String;
	var characterName:String;
	var portrait:String;
}

class CharMenu extends MusicBeatState
{
	var menuItems:Array<String> = ['bf', 'shadoune'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var shitCharacter:FlxSprite;
	var shitCharacterBetter:Boyfriend;
	var icon:HealthIcon;
	var menuBG:FlxSprite;
	public static var SONG:SwagSong;
	public var targetY:Float = 0;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	public static var characterShit:Array<CharacterMenu>;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;
	var alreadySelectedShit:Bool = false;
	var doesntExist:Bool = false;
	private var iconArray:Array<Boyfriend> = [];

	var shittyNames:Array<String> = [
		"Boyfriend",
        "shadouine"
	];

	var txtOptionTitle:FlxText;



    override function create()
	{

		menuBG = new FlxSprite().loadGraphic(Paths.image('BG5'));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		grpMenuShiz = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShiz);

		for (i in 0...menuItems.length)
		{

			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
			var icon:Boyfriend = new Boyfriend(0, 0, menuItems[i]);
			

			
			icon.scale.set(0.8, 0.8);

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}

		txtDescription = new FlxText(FlxG.width * 0.075, menuBG.y + 200, 0, "", 32);
		txtDescription.alignment = CENTER;
		txtDescription.setFormat("assets/fonts/Minecraftia 2.0", 32);
		txtDescription.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		txtDescription.color = FlxColor.WHITE;
		add(txtDescription);

		// shitCharacter = new FlxSprite(0, -20);
		// shitCharacter.scale.set(0.45, 0.45);
		// shitCharacter.updateHitbox();
		// shitCharacter.screenCenter(XY);
		// shitCharacter.antialiasing = true;
		// shitCharacter.y += 30;
		// add(shitCharacter);

		var charSelHeaderText:Alphabet = new Alphabet(0, 50, 'Character Select', true, false);
		charSelHeaderText.screenCenter(X);
		add(charSelHeaderText);

		var shittyArrows:FlxSprite = new FlxSprite().loadGraphic(Paths.image('arrows'));
		shittyArrows.screenCenter();
		shittyArrows.antialiasing = true;
		add(shittyArrows);

		txtOptionTitle = new FlxText(FlxG.width * 0.7, 10, 0, "dfgdfgdg", 32);
        txtOptionTitle.setFormat("assets/fonts/Minecraftia 2.0", 32, FlxColor.WHITE, RIGHT);
		txtOptionTitle.alpha = 0.7;
		add(txtOptionTitle);

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	override function update(elapsed:Float)
	{
		txtOptionTitle.text = shittyNames[curSelected].toUpperCase();
		txtOptionTitle.x = FlxG.width - (txtOptionTitle.width + 10);
		if (txtOptionTitle.text == '')
		{
			trace('NO FUCKING TEXT LMAO');
			txtOptionTitle.text = 'NO DESCRIPTION';
		}

		if (iconArray[curSelected].animation.curAnim.name == 'idle' && iconArray[curSelected].animation.curAnim.finished && doesntExist)
			iconArray[curSelected].playAnim('idle', true);
			
		var upP = controls.LEFT_P;
		var downP = controls.RIGHT_P;
		var accepted = controls.ACCEPT;

		if (!alreadySelectedShit)
		{
			if (upP)
				{
					changeSelection(-1);
				}

				if (downP)
				{
					changeSelection(1);
				}
		
				if (accepted)
				{
					alreadySelectedShit = true;
					var daSelected:String = menuItems[curSelected];
					PlayState.hasPlayedOnce = true;
					if (menuItems[curSelected] != 'bf')
						PlayState.SONG.player1 = daSelected;


					FlxFlicker.flicker(iconArray[curSelected],0);
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				}
		
				if (controls.BACK)
                if (PlayState.isStoryMode)
                    FlxG.switchState(new StoryMenuState());
                else {
                    FlxG.switchState(new FreeplayState());
						}
					}

        super.update(elapsed);
    }

	function changeSelection(change:Int = 0):Void
	{

		curSelected += change;
	
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
	
		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}
	
		iconArray[curSelected].alpha = 1;
	
		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
			// item.setGraphicSize(Std.int(item.width * 0.8));
	
			if (item.targetY == 0)
			{
				// item.setGraphicSize(Std.int(item.width));
			}
		}

		charCheckLmao();
	}

	function charCheckLmao()
	{
		doesntExist = false;
		var daSelected:String = menuItems[curSelected];
		var storedColor:FlxColor = 0xFFFFFF;
		remove(icon);

		switch (daSelected)
		{
            case "bf":
                menuBG.loadGraphic('BG5');
                menuBG.color = 0x87ceeb;
            case "shadoune":
                menuBG.loadGraphic('BG5');
                menuBG.color = 0xFF6262;
            default:
                menuBG.loadGraphic('BG5');
                menuBG.color = 0xFFFFFF;
		}

		// shitCharacter.updateHitbox();
		// shitCharacter.screenCenter(XY);

		doesntExist = true;

		var healthBarBG:FlxSprite = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/shared/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = false;
		add(healthBarBG);
	
		var healthBar:FlxBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		healthBar.visible = false;
			// healthBar
		add(healthBar);
		icon = new HealthIcon(menuItems[curSelected], true);
		icon.y = healthBar.y - (icon.height / 2);
		icon.screenCenter(X);
		icon.setGraphicSize(-4);
		icon.y -= 20;
		add(icon);
	}

}