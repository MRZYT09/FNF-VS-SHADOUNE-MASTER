package;

import js.html.Animation;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Shulker extends FlxSprite
{
    public function new (x:Float, y:Float)
    {
        super(x,y);

        frames = Paths.getSparrowAtlas("fondito/shulket");
        animation.addByPrefix('idle', 'shulket', 20, true);
        animation.play('idle');
        antialiasing = true;

    }
}