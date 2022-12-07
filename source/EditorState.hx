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
import flixel.ui.FlxButton;

import sys.FileSystem;
import sys.io.File;

import flixel.addons.text.FlxTypeText;

class EditorState extends FlxState
{
	private var levelCol:FlxGroup;

	private static var camHUD:FlxCamera;
	private static var camGame:FlxCamera;
	private static var camOther:FlxCamera;

	private static var dick:Player;

	private var collideBox_x:Array<Float> = [];
	private var collideBox_y:Array<Float> = [];
	private var collideBox_scalex:Array<Float> = [];
	private var collideBox_scaley:Array<Float> = [];

	var visual:FlxSprite;
    var SPEED:Float = 0;
	var walkSpeed:Float = 75;
    var runSpeed:Float = 200;

	var fuck:Float = 0;

	var scaleSPEED:Float = 0.1;

	var angleSPEED:Float = 5;

	override public function create()
	{
		super.create();
		FlxG.mouse.visible = true;

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		camGame.zoom = 0.7;
		camHUD.zoom = 1;
		camOther.zoom = 0.7;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		levelCol = new FlxGroup();

		FlxG.worldBounds.set(-5000, -5000, 10000, 10000);

		var land:FlxSprite = new FlxSprite(100, 100).loadGraphic(Paths.image('images/editor/map'));
		land.antialiasing = false;
		land.setGraphicSize(Std.int(land.width * 3));
		add(land);

		dick = new Player(0, 0, 0.4, 250, 'frisk');
		dick.cameras = [camGame];
		add(dick);

		visual = new FlxSprite(0, 100).makeGraphic(200, 200, FlxColor.GREEN);
		visual.alpha = 0.6;
		add(visual);

		var saveButton:FlxButton = new FlxButton(50, 50, "Save to File", OnClickButton);
		saveButton.cameras = [camHUD];
        add(saveButton);

		FlxG.camera.follow(visual, TOPDOWN);
	}

	override public function update(elapsed:Float)
	{
		var ctrl = FlxG.keys.anyPressed([CONTROL]);

		var sprint = FlxG.keys.anyPressed([SHIFT]);
        var goUp = FlxG.keys.anyPressed([W]);
        var goDown = FlxG.keys.anyPressed([S]);
        var goLeft = FlxG.keys.anyPressed([A]);
        var goRight = FlxG.keys.anyPressed([D]);

		var cameraOne = FlxG.keys.anyPressed([ONE]);
		var cameraTwo = FlxG.keys.anyPressed([TWO]);

        visual.drag.x = SPEED * 6;
        visual.drag.y = SPEED * 6;

        if (sprint)
			{
				SPEED = runSpeed;
			}
			else
			{
				SPEED = walkSpeed;
			}

		if (cameraOne) {
			FlxG.camera.follow(visual, TOPDOWN);
		}

		if (cameraTwo) {
			FlxG.camera.follow(dick, TOPDOWN);
		}

        if (goDown && !ctrl)
        {
            visual.velocity.y = SPEED;
        }
        if (goUp && !ctrl)
        {
            visual.velocity.y = -SPEED;
        }
        if (goRight && !ctrl)
        {
            visual.velocity.x = SPEED;
        }

        if (goLeft && !ctrl)
        {
            visual.velocity.x = -SPEED;
        }

		if (goDown && ctrl)
		{
			visual.scale.y -= scaleSPEED;
			visual.updateHitbox();
		}
		if (goUp && ctrl)
		{
			visual.scale.y += scaleSPEED;
			visual.updateHitbox();
		}
		if (goRight && ctrl)
		{
			visual.scale.x += scaleSPEED;
			visual.updateHitbox();
		}

		if (goLeft && ctrl)
		{
			visual.scale.x -= scaleSPEED;
			visual.updateHitbox();
		}

		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new PlayState());
		}

		if (FlxG.keys.justPressed.SPACE) {
			fuck += 1;
			var fuck:FlxSprite = new FlxSprite(visual.x, visual.y).makeGraphic(200, 200, FlxColor.WHITE);
			fuck.alpha = 0.3;
			fuck.angle = visual.angle;
			fuck.scale.x = visual.scale.x;
			fuck.scale.y = visual.scale.y;
			levelCol.add(fuck);
			fuck.immovable = true;
			add(fuck);
			fuck.updateHitbox();

			collideBox_x.push(fuck.x);
			collideBox_y.push(fuck.y);
			collideBox_scalex.push(fuck.scale.x);
			collideBox_scaley.push(fuck.scale.y);
		}

		super.update(elapsed);

		FlxG.watch.addMouse();
		FlxG.collide(dick, levelCol);
	}

	function OnClickButton():Void
		{
			trace("clicked!");
			sys.io.File.saveContent('coords_x.txt',Std.string(collideBox_x));
			sys.io.File.saveContent('coords_y.txt',Std.string(collideBox_y));
			sys.io.File.saveContent('coords_scaleX.txt',Std.string(collideBox_scalex));
			sys.io.File.saveContent('coords_scaleY.txt',Std.string(collideBox_scaley));
		}
}
