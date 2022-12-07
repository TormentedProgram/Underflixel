package;

import LevelMap;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.FlxCamera;

import flixel.addons.text.FlxTypeText;

class PlayState extends FlxState
{
	public var levelCollision:FlxGroup;
	public var playerCollision:FlxGroup;

	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var camOther:FlxCamera;

	public static var frisk:Player;
	public static var defaultSpeed:Float = 250;

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = false;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		camGame.zoom = 0.7;
		camHUD.zoom = 0.7;
		camOther.zoom = 0.7;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		levelCollision = new FlxGroup();
		playerCollision = new FlxGroup();

		FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

		var lvl1:Level1 = new Level1('map');
		lvl1.cameras = [camGame];
		add(lvl1);

		var lvl1_c:Level1 = new Level1('collision');
		levelCollision.add(lvl1_c);

		frisk = new Player(-163, 201, 0.4, defaultSpeed, 'frisk');
		playerCollision.add(frisk);
		frisk.cameras = [camGame];
		add(frisk);

		FlxG.camera.follow(frisk, TOPDOWN);
	}

	override public function update(elapsed:Float)
	{
		#if debug
		if (FlxG.keys.justPressed.SEVEN) {
			FlxG.switchState(new EditorState());
		}
		#end

		super.update(elapsed);

		FlxG.watch.addMouse();

		FlxG.collide(playerCollision, levelCollision);
	}
}
