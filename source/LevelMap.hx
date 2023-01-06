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
import Dialogue;
import Player;
import PlayState;

class Level1 extends FlxTypedGroup<FlxBasic>
{
	var collisionArrayX:Array<Float>;
	var collisionArrayY:Array<Float>;
	var collisionArrayScaleX:Array<Float>;
	var collisionArrayScaleY:Array<Float>;
	var collisionArrayAngle:Array<Float>;
	var currentDialog:Dialogue;

	//dialogue 1
	var sans:FlxSprite;
	var dialogueLine_1:Float = -1;
	var dialogueActive_1:Bool = false;
	var dialogue_1:Bool = false;

	public function new(part:String)
	{
		super();

		switch (part)
		{
			case 'collision':
				collisionArrayX = [-398.916,-534.75,-560.5,-521.416,-521.416,-461.666,-401.916,-341.166,79.833,137.833,1398.583,1398.583,262,261,136.5,261.5];
				collisionArrayY = [-92.083,-31.583,22.166,380.25,415,440.25,500.75,561.75,500.25,438.75,301,241.25,209.75,78.75,-29,26];
				collisionArrayScaleX = [2.7,0.7,0.2,0.3,0.3,0.3,0.3,2.1,0.3,6.399,0.3,0.3,5.8,0.3,1,0.3];
				collisionArrayScaleY = [0.3,-0.3,-1.8,-0.2,-0.3,-0.3,-0.3,-0.3,-0.3,-0.3,-0.7,-0.3,-0.3,-0.7,-0.3,-0.3];
				for (i in 0...collisionArrayX.length) {
					var cock:FlxSprite = new FlxSprite(collisionArrayX[i], collisionArrayY[i]).makeGraphic(200, 200, FlxColor.WHITE);
					cock.scale.set(collisionArrayScaleX[i], collisionArrayScaleY[i]);
					cock.immovable = true;
					add(cock);
					cock.updateHitbox();
				}
			case 'map':
				var land:FlxSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('images/map/begin'));
				land.antialiasing = false;
				land.setGraphicSize(Std.int(land.width * 3));
				add(land);

				sans = new FlxSprite(1240, 240).loadGraphic(Paths.image('images/map/sans_overworld'));
				sans.antialiasing = false;
				sans.immovable = true;
				sans.setGraphicSize(Std.int(sans.width * 0.2));
				sans.updateHitbox();
				add(sans);
		}
	}

	override function update(elapsed:Float)	
	{
		var interact = FlxG.keys.anyJustPressed([SPACE, G]);
		
		var dialog_speed:Array<Float> = [0.1, 0.2, 0.2];
		var dialog_moods:Array<String> = ["default", "default", "test"];
		var dialog_characters:Array<String> = ["papyrus", "sans", "sans"];
		var dialog_text:Array<String> = ["hey sans you suck!", "that's not very nice", "im now sans.exe"];
		
		if (interact) {
			playDialogue(dialog_characters, dialog_moods, dialog_text, dialog_speed);
		}

		super.update(elapsed);
	}

	public function playDialogue(character:Array<String>, mood:Array<String>, text:Array<String>, speed:Array<Float>) {
		if (!Dialogue.inDialogue) {
			var currentDialog:Dialogue = new Dialogue(character, mood, text, speed);
			add(currentDialog);
		}
	}
}