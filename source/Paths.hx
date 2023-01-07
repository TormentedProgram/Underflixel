package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import haxe.xml.Access;
import lime.utils.Assets;
import openfl.geom.Rectangle;
import openfl.system.System;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
class Paths
{
	public static function getAsset(file:String, ?library:Null<String> = null)
	{
		var usesLib:Bool = false;

		if (library != null)
			usesLib = true;

		var fileLocation:String = library + ':assets/' + library + '/' + file;
		if (!usesLib)
			fileLocation = 'assets/' + file;

		var exists = exists(fileLocation);
		if (!exists)
			fileLocation = 'assets/images/placeholderskull.png';

		return fileLocation;
	}

	public static function exists(file:String)
	{
		var exists:Bool = false;
		if (OpenFlAssets.exists(file))
		{
			exists = true;
		}

		return exists;
	}

	inline static public function getSparrowAtlas(file:String, ?library:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(getAsset(file + '.png', library), getAsset(file + '.xml', library));
	}

	inline static public function image(file:String, ?library:String):String
	{
		return getAsset(file + '.png', library);
	}

	inline static public function rawSearch(file:String, ?library:String):String
	{
		return getAsset(file, library);
	}

	inline static public function sound(file:String, ?library:String):String
	{
		return getAsset(file + '.ogg', library);
	}

	
	inline static public function font(file:String, ?library:String):String
	{
		return getAsset(file + '.ttf', library);
	}
}
