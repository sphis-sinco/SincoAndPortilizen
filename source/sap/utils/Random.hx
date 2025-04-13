package sap.utils;

class Random
{
	// https://haxe.motion-twin.narkive.com/BxeZgKeh/sort-an-array-string-alphabetically
	public static function StringSortAlphabetically(a:String, b:String):Int
	{
		a = a.toLowerCase();
		b = b.toLowerCase();

		if (a < b)
			return -1;
		if (a > b)
			return 1;
		return 0;
	}

	// stolen from psych engine
	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for (col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:FlxColor = sprite.pixels.getPixel32(col, row);
				if (colorOfThisPixel.alphaFloat > 0.05)
				{
					colorOfThisPixel = FlxColor.fromRGB(colorOfThisPixel.red, colorOfThisPixel.green, colorOfThisPixel.blue, 255);
					var count:Int = countByColor.exists(colorOfThisPixel) ? countByColor[colorOfThisPixel] : 0;
					countByColor[colorOfThisPixel] = count + 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; // after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for (key => count in countByColor)
		{
			if (count >= maxCount)
			{
				maxCount = count;
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}
}
