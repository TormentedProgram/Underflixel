package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Player extends FlxSprite
{
    var walking:Bool = false;
    var runSpeed:Float = 0;
    var SPEED:Float = 0;

    public static var playAnimation:Bool = true;
    public static var movement:Bool = true;
    public static var walkSpeed:Float = 0;

    public function new(x:Float, y:Float, scale:Float, characterSpeed:Float, skin:String)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas('images/player/' + skin);
        animation.addByPrefix('idle-down', 'down0003', 6, true);
        animation.addByPrefix('idle-up', 'up0003', 6, true);
        animation.addByPrefix('idle-side', 'side0001', 6, true);
        animation.addByPrefix('up', 'up', 6, true);
        animation.addByPrefix('down', 'down', 6, true);
        animation.addByPrefix('side', 'side', 6, true);

        setGraphicSize(Std.int(width * scale));
        updateHitbox();
        antialiasing = false;

        walkSpeed = characterSpeed;

        animation.play('idle-down');
        flipX = false;
    }

    override function update(elapsed:Float)
    {
        runSpeed = walkSpeed * 1;

        var sprint = FlxG.keys.anyPressed([SHIFT]);
        var interact = FlxG.keys.anyPressed([E, ENTER, SPACE]);
        var goUp = FlxG.keys.anyPressed([UP]);
        var goDown = FlxG.keys.anyPressed([DOWN]);
        var goLeft = FlxG.keys.anyPressed([LEFT]);
        var goRight = FlxG.keys.anyPressed([RIGHT]);

        var upJustPressed = FlxG.keys.justReleased.UP;
        var downJustPressed = FlxG.keys.justReleased.DOWN;
        var leftJustPressed = FlxG.keys.justReleased.LEFT;
        var rightJustPressed = FlxG.keys.justReleased.RIGHT;

        if(!playAnimation || !movement) {
            velocity.x = 0;
            velocity.y = 0;
        }

        drag.x = SPEED * 6;
        drag.y = SPEED * 6;

        if (sprint)
        {
            SPEED = runSpeed;
        }
        else
        {
            SPEED = walkSpeed;
        }

        walking = false;

        if (goDown && movement)
        {
            velocity.y = SPEED;
            if(!goLeft && !goRight && playAnimation) {
                animation.play('down');
            }
            flipX = false;
            walking = true;
        }
        if (goUp && movement)
        {
            velocity.y = -SPEED;
            if(!goLeft && !goRight && playAnimation) {
                animation.play('up');
                flipX = false;
            }
            walking = true;
        }
        if (goRight && movement)
        {
            velocity.x = SPEED;
            if(playAnimation) {
                animation.play('side');
                flipX = false;
            }
            walking = true;
        }

        if (goLeft && movement)
        {
            velocity.x = -SPEED;
            if(playAnimation) {
                animation.play('side');
                flipX = true;
            }
            walking = true;
        }

        if (walking == false && (upJustPressed)  && playAnimation && movement)
        {
            animation.play('idle-up');
            flipX = false;
        }
        if (walking == false && (downJustPressed) && playAnimation && movement)
        {
            animation.play('idle-down');
            flipX = false;
        }
        if (walking == false && (leftJustPressed)  && playAnimation && movement)
        {
            animation.play('idle-side');
            flipX = true;
        }
        if (walking == false && (rightJustPressed) && playAnimation && movement)
        {
            animation.play('idle-side');
            flipX = false;
        }


        super.update(elapsed);
    }
}