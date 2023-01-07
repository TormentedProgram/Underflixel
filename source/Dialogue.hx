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
import openfl.utils.Assets as OpenFlAssets;
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
	var xOffset:Float = 70;
	var yOffset:Float = 0;
	var textDistance:Float = 180;
	var pixelated:Bool = true;
	var flipped:Bool = false;
	var scale:Float = 1.5;
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

		head = new DialogHead(dialog_box.x - xOffset, dialog_box.y - yOffset, scale, Std.int(speed[0] * 10 * 4), character[0], mood[0], flipped, !pixelated);
		head.scrollFactor.set();
		head.antialiasing = !pixelated;
		head.cameras = [PlayState.camHUD];
		add(head);

		dialog_text = new FlxTypeText(head.x + textDistance, dialog_box.y, FlxG.width - 30, lines[0], 32, true);
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
			switch (character[currentLine])
			{
				case 'boyfriend':
					textDistance = 250;
					flipped = true;
					xOffset = 50;
					yOffset = 0;
					scale = 1.5;
					pixelated = false;
				default:
					textDistance = 180;
					flipped = false;
					xOffset = 70;
					yOffset = 0;
					scale = 1.5;
					pixelated = true;
			}
			if(currentLine >= lines.length) {
				removeDialogue();
            }else{
				remove(head);
				head = new DialogHead(dialog_box.x - xOffset, dialog_box.y - yOffset, scale, Std.int(speed[currentLine] * 10 * 4), character[currentLine], mood[currentLine], flipped, !pixelated);
				head.scrollFactor.set();
				head.antialiasing = !pixelated;
				head.cameras = [PlayState.camHUD];
				add(head);
				dialog_text.resetText(lines[currentLine]);
				dialog_text.x = head.x + textDistance;
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
	var animated:Bool;
    public function new(x:Float, y:Float, scale:Float, frameRate:Int, character:String, mood:String, flip:Bool, pixelated:Bool)
    {
        super(x, y);

		var file:String = Paths.rawSearch('images/dialogue/' + character + '/' + character + '-' + mood + '.xml');
		if (OpenFlAssets.exists(file)) {
			animated = true;
			frames = Paths.getSparrowAtlas('images/dialogue/' + character + '/' + character + '-' + mood);
			animation.addByPrefix('talk', 'talk0', 16 - frameRate, true);
			animation.addByPrefix('idle', 'idle0', 16 - frameRate, true);
		}else{
			animated = false;
			loadGraphic(Paths.image('images/dialogue/' + character + '/' + character + '-' + mood));
		}

        setGraphicSize(Std.int(width * scale));
        updateHitbox();
		flipX = flip;
        antialiasing = !pixelated;

        animation.play('talk');
    }

    public function resetAnim() {
		if (animated) {
			animation.play('idle');
		}
    }

	public function startAnim() {
		if (animated) {
			animation.play('talk');
		}
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