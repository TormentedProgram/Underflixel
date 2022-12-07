package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class DialogHead extends FlxSprite
{
    public function new(x:Float, y:Float, scale:Float, frameRate:Int, character:String, mood:String)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('images/dialogue/' + character + '/' + character + '-' + mood);
        animation.addByPrefix('talk', 'talk0', frameRate, true);
        animation.addByPrefix('idle', 'talk0003', frameRate, true);

        setGraphicSize(Std.int(width * scale));
        updateHitbox();
        antialiasing = false;

        animation.play('talk');
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}