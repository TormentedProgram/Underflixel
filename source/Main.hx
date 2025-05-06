package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import ClientPrefs;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState, ClientPrefs.framerate, ClientPrefs.framerate, true, false));
		addChild(new FPS(10, 10, 0xffffff));
	}
}
