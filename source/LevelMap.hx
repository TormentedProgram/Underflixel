package;

import Dialogue;
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
import Player;
import PlayState;
import flixel.math.FlxMath;

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
		var interact = FlxG.keys.anyJustPressed([Z, ENTER]);

		if (FlxG.overlap(PlayState.frisk, sans)) {
			dialogueActive_1 = true;
		}else{
			if(dialogueActive_1 == true) {
				dialogueActive_1 = false;
			}
		}
		if (interact && !dialogueActive_1 && dialogue_1) {
			Dialogue.removeDialogue();
		}
		if (interact && dialogueActive_1) {
			dialogueLine_1 += 1;
		}
		if (interact && dialogueLine_1 < 1 && dialogueActive_1) { 
			dialogue_1 = true;
			playDialogue('sans','default','hey kid.', 0.05);
		}
		if (interact && dialogueLine_1 == 1 && dialogueActive_1) {
			Dialogue.removeDialogue();
			playDialogue('sans','default','uh sorry this is a demo.', 0.05);
		}
		if (interact && dialogueLine_1 == 2 && dialogueActive_1) {
			Dialogue.removeDialogue();
			playDialogue('sans','default','so uh-', 0.035);
		}	
		if (interact && dialogueLine_1 == 3 && dialogueActive_1) {
			Dialogue.removeDialogue();
			playDialogue('papyrus','default','its not done sans.', 0.05);
		}	
		if (interact && dialogueLine_1 == 4 && dialogueActive_1) {
			Player.movement = true;
			Player.playAnimation = true;
			dialogue_1 = false;
			Dialogue.removeDialogue();
			dialogueLine_1 = -1;
		}
		super.update(elapsed);
	}

	public function playDialogue(character:String, mood:String, text:String, speed:Float) {
		Player.movement = false;
		Player.playAnimation = false;
		var currentDialog:Dialogue = new Dialogue(character, mood, '* ' + text, speed);
		add(currentDialog);
		Dialogue.dialog_text.start(null, true, false, null);
	}
}
