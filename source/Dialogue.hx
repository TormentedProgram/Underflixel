package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import PlayState;
import Player;

class Dialogue extends FlxTypedGroup<FlxBasic>
{
	public static var dialog_box:FlxSprite;
	public static var head:DialogHead;
	public static var dialog_text:FlxTypeText;
	public static var stopTalking:FlxTimer;
	public var character:Array<String> = ["sans"];
	public var speed:Array<Float> = [0.1];
	public var mood:Array<String> = ["default"];
	public static var inDialogue:Bool;
    var lines:Array<String>;
    var currentLine:Int;

	public function new(character:Array<String>, mood:Array<String>, text:Array<String>, speed:Array<Float>)
	{
		super();

		lines = text;
        currentLine = 0;
		this.speed = speed;
		this.character = character;
		this.mood = mood;

		Player.movement = false;
		Player.playAnimation = false;

		dialog_box = new FlxSprite(0, 375).loadGraphic(Paths.image('images/dialogue/box'));
		dialog_box.scrollFactor.set();
		dialog_box.antialiasing = false;
		dialog_box.setGraphicSize(Std.int(dialog_box.width * 1.4));
		dialog_box.screenCenter(X);
		dialog_box.cameras = [PlayState.camHUD];
		add(dialog_box);

		head = new DialogHead(dialog_box.x - 70, dialog_box.y, 1.5, Std.int(speed[0] * 400), character[0], mood[0]);
		head.scrollFactor.set();
		head.antialiasing = false;
		head.cameras = [PlayState.camHUD];
		add(head);

		dialog_text = new FlxTypeText(dialog_box.x + 100, dialog_box.y, FlxG.width - 30, lines[0], 32, true);
		dialog_text.setFormat(Paths.font("fonts/" + character[0]), 40);
		dialog_text.bold = true;
		dialog_text.scrollFactor.set();
		dialog_text.skipKeys = ["X"];
		dialog_text.autoErase = false;
		dialog_text.delay = speed[0];
		dialog_text.cameras = [PlayState.camHUD];
		dialog_text.sounds = [
			FlxG.sound.load(Paths.sound('sounds/' + character[0])),
		];
		add(dialog_text);
		dialog_text.start(null, true, false, null);
		inDialogue = true;

		dialog_text.completeCallback = function()
			{
				head.resetAnim();
			}
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.anyJustPressed([Z, ENTER])) {
			currentLine++;
			trace(currentLine);
			if(currentLine >= lines.length) {
				removeDialogue();
            }else{
				remove(head);
				head = new DialogHead(dialog_box.x - 70, dialog_box.y, 1.5, Std.int(speed[currentLine] * 400), character[currentLine], mood[currentLine]);
				head.scrollFactor.set();
				head.antialiasing = false;
				head.cameras = [PlayState.camHUD];
				add(head);
				dialog_text.resetText(lines[currentLine]);
				dialog_text.setFormat(Paths.font("fonts/" + character[currentLine]), 40);
				dialog_text.sounds = [
					FlxG.sound.load(Paths.sound('sounds/' + character[currentLine])),
				];
				dialog_text.start(speed[currentLine], true, false, null);
				head.startAnim();
				dialog_text.completeCallback = function()
					{
						head.resetAnim();
					}
			}
		}
		super.update(elapsed);
		dialog_text.update(elapsed);
	}

	function removeDialogue() {
		currentLine = 0;
		inDialogue = false;
		kill();
		Player.movement = true;	
		Player.playAnimation = true;
	}
}

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

    public function resetAnim() {
		trace('worked?');
        animation.play('idle');
    }

	public function startAnim() {
        animation.play('talk');
    }

    override function update(elapsed:Float)
    {
        var skip = FlxG.keys.anyPressed([X]);
        if (skip) {
            resetAnim();
        }
        super.update(elapsed);
    }
}