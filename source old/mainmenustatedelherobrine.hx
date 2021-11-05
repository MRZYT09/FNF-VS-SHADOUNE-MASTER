package hero;

#if desktop
import Discord.DiscordClient;
#end
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
import lime.app.Application;
import openfl.Assets;
import flash.system.System;
//using System;

class MCMainMenu extends MusicBeatState
{
	public var bgCam:FlxCamera;
	public var camHUD:FlxCamera;

    var shitpost:String;
    var finalVar:Array<Dynamic> = [];

    // bitmap shits
    var menuBG:FlxSprite;
    var dsLogo:FlxSprite;

    // yellow shit
    var yellowShit:FlxText;

    // button shits
    var storymode:FlxButton;
    var freeplay:FlxButton;
    var credits:FlxButton;
    var options:FlxButton;
    var quitgame:FlxButton;

    override function create()
    {
        /*DateTime dateValue = new DateTime(2008, 6, 11);
        Console.WriteLine(dateValue.ToString("ddd"));*/

        bgCam = new FlxCamera();
		bgCam.bgColor.alpha = 0;
		FlxG.cameras.add(bgCam);

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
        camHUD.zoom = 3;

        camHUD.y += 150;

        FlxG.mouse.visible = true;

        getShit();

        menuBG = new FlxSprite();
        menuBG.frames = Paths.getSparrowAtlas('menu/menuBG');
		menuBG.animation.addByPrefix('idle', 'anim', 12, true);
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        menuBG.animation.play('idle', true);

        var fuckshit:String = 'minefunk';

        if (FlxG.random.int(1, 18000) == 1)
            fuckshit = 'minefuck';

        //if ()
            // fuckshit = 'chewsday';

        var menu:FlxSprite = new FlxSprite();
        menu.loadGraphic(Paths.image('menu/' + fuckshit));
        menu.screenCenter();
        menu.y -= 200;
        menu.antialiasing = true;
        menu.scale.x = 0.9;
        menu.scale.y = 0.9;
        if (fuckshit == 'chewsday'){
            menu.scale.x = 0.6;
            menu.scale.y = 0.6;}
        menu.animation.play('idle', true);

        dsLogo = new FlxSprite(FlxG.width - 184, FlxG.height - 184);
        dsLogo.loadGraphic(Paths.image('menu/discord logo'));
        dsLogo.antialiasing = true;
        dsLogo.scale.x = 0.5;
        dsLogo.scale.y = 0.5;

        yellowShit = new FlxText(0, 0, 0, finalVar[0] + '\n' + finalVar[1]);
		yellowShit.setFormat(Paths.font("minecraft.otf"), 32, FlxColor.YELLOW, CENTER);
        yellowShit.angle = -30;
        yellowShit.screenCenter();
        yellowShit.y -= 160;
        yellowShit.x += 340;

        storymode = new FlxButton(0, 0, "Story Mode", function()
        {
            FlxG.sound.play(Paths.sound('minecraft_click'), 2);
            //FlxG.mouse.visible = false;
            MusicBeatState.switchState(new StoryMenuState());
        });
        storymode.screenCenter(X);
        storymode.y += 290;

        freeplay = new FlxButton(0, 30, "Freeplay", function()
        {
            FlxG.sound.play(Paths.sound('minecraft_click'), 2);
            //FlxG.mouse.visible = false;
            MusicBeatState.switchState(new FreeplayState());
        });
        freeplay.screenCenter(X);
        freeplay.y += 286;

        credits = new FlxButton(0, 60, "Credits", function()
        {
            FlxG.sound.play(Paths.sound('minecraft_click'), 2);
            //FlxG.mouse.visible = false;
            MusicBeatState.switchState(new CreditsState());
        });
        credits.screenCenter(X);
        credits.y += 282;

        options = new FlxButton(0, 90, "Options", function()
        {
            FlxG.sound.play(Paths.sound('minecraft_click'), 2);
            FlxG.mouse.visible = false;
            MusicBeatState.switchState(new OptionsState());
        });
        options.screenCenter(X);
        options.y += 282;

        quitgame = new FlxButton(0, 120, "Quit game", function()
        {
            System.exit(0);
        });
        quitgame.screenCenter(X);
        quitgame.y += 278;

        menuBG.cameras = [bgCam];
        yellowShit.cameras = [bgCam];
        dsLogo.cameras = [bgCam];
        
		storymode.cameras = [camHUD];
        freeplay.cameras = [camHUD];
        credits.cameras = [camHUD];
        options.cameras = [camHUD];
        quitgame.cameras = [camHUD];

        // adds gay shit
        add(menuBG);
        add(menu);
        add(dsLogo);
        add(yellowShit);

        add(storymode);
        add(freeplay);
        add(credits);
        add(options);
        add(quitgame);

        fuckBump(0);

        trace ('lmao');
    }

    override function update(elapsed:Float)
    {
        if (FlxG.mouse.overlaps(dsLogo) && FlxG.mouse.justPressed)
            CoolUtil.browserLoad('https://discord.gg/m6Rjg78yuS');
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
}