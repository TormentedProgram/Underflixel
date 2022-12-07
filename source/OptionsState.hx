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
import EditorState;
import flixel.util.FlxSave;
import ClientPrefs;
import flixel.addons.text.FlxTypeText;

class OptionsState extends FlxState
{
	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var camOther:FlxCamera;

	var shaders:FlxText;
	var frameRate:FlxText;
	var selector:FlxText;
	var selected:Float = 0;

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
		camOther.zoom = 1;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		selector = new FlxText(248, 19, 400, "<", 32);
		selector.setFormat(Paths.font("fonts/papyrus"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(selector);
		selector.cameras = [camHUD];

		frameRate = new FlxText(248, 19, 400, "Framerate: ", 32);
		frameRate.setFormat(Paths.font("fonts/papyrus"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(frameRate);
		frameRate.cameras = [camHUD];
		frameRate.screenCenter(X);

		shaders = new FlxText(248, frameRate.y * 1 * 5, 400, "Shaders: ", 32);
		shaders.setFormat(Paths.font("fonts/papyrus"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(shaders);
		shaders.cameras = [camHUD];
		shaders.screenCenter(X);
	}

	override public function update(elapsed:Float)
	{
		if(FlxG.keys.justPressed.ESCAPE) {
			ClientPrefs.saveSettings();
			FlxG.switchState(new PlayState());
		}
		if(FlxG.keys.justPressed.DOWN) {
			selected += 1;
		}
		if(FlxG.keys.justPressed.UP) {
			selected -= 1;
		}

		if(selected == 0 && FlxG.keys.justPressed.RIGHT) {
			ClientPrefs.framerate += 10;
		}
		if(selected == 0 && FlxG.keys.justPressed.LEFT) {
			ClientPrefs.framerate -= 10;
		}
		if(ClientPrefs.framerate < 1 || ClientPrefs.framerate > 240) {
			ClientPrefs.framerate = 30;
		}
		if(selected < 0 || selected > 1) {
			selected = 0;
		}

		if(selected == 1 && FlxG.keys.justPressed.ENTER) {
			if (ClientPrefs.shaders == true) {
				ClientPrefs.shaders = false;
			}else
				ClientPrefs.shaders = true;
		}

		selector.x = frameRate.x + 200;
		selector.y = frameRate.y * selected * 5;
		frameRate.text = 'Framerate: ' + ClientPrefs.framerate;
		shaders.text = 'Shaders: ' + ClientPrefs.shaders;
		super.update(elapsed);
	}
}
