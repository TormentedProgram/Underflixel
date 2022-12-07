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

class Dialogue extends FlxTypedGroup<FlxBasic>
{
	public static var dialog_box:FlxSprite;
	public static var head:DialogHead;
	public static var dialog_text:FlxTypeText;
	public static var speed:Float;
	public static var character:String = null;
	public static var stopTalking:FlxTimer;

	public function new(character:String, mood:String, text:String, speed:Float)
	{
		super();

		dialog_box = new FlxSprite(0, 375).loadGraphic(Paths.image('images/dialogue/box'));
		dialog_box.scrollFactor.set();
		dialog_box.antialiasing = false;
		dialog_box.setGraphicSize(Std.int(dialog_box.width * 1.4));
		dialog_box.screenCenter(X);
		dialog_box.cameras = [PlayState.camHUD];
		add(dialog_box);

		head = new DialogHead(dialog_box.x - 70, dialog_box.y, 1.5, Std.int(speed * 400), character, mood);
		head.scrollFactor.set();
		head.antialiasing = false;
		head.cameras = [PlayState.camHUD];
		add(head);

		stopTalking = new FlxTimer().start(speed * text.length, function(tmr:FlxTimer)
			{
				head.animation.play('idle');
			});

		dialog_text = new FlxTypeText(dialog_box.x + 100, dialog_box.y, FlxG.width - 30, text, 32, true);
		dialog_text.setFormat(Paths.font("fonts/" + character), 40);
		dialog_text.bold = true;
		dialog_text.scrollFactor.set();
		dialog_text.skipKeys = ["X"];
		dialog_text.autoErase = false;
		dialog_text.delay = speed;
		dialog_text.cameras = [PlayState.camHUD];
		dialog_text.sounds = [
			FlxG.sound.load(Paths.sound('sounds/' + character)),
		];
		add(dialog_text);
	}

	override function update(elapsed:Float)
	{
		//dialog_text.delay = speed;
		super.update(elapsed);
	}

	public static function removeDialogue() {
		stopTalking.cancel();
		dialog_box.destroy();
		dialog_text.destroy();
		head.destroy();
	}
}
