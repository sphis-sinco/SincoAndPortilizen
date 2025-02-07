package worldmap;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import mainmenu.MainMenu;
import stages.stage1.Stage1;
import stages.stage4.Stage4;

class Worldmap extends FlxState
{
	var character:MapCharacter;
	var charWheel:CharacterWheel = new CharacterWheel();

	var current_level:Int = 1;

	var mapGRP:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	var implementedLevels:Map<String, Array<Bool>> = [
		"sinco" => [true, false, false, false],
		"port" => [true, false, false, false]
	];

	override public function new(char:String = "Sinco") {
		super();

		character = new MapCharacter(char);
	}

	override function create()
	{
		super.create();

		var bg = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height);
		add(bg);

		character.screenCenter();
		character.x = 32 + character.width;

		makeMap();

		add(mapGRP);
		add(character);

		charWheel.screenCenter(X);
		charWheel.y = charWheel.height + 16;

		charWheel.animation.play('sinco');

		add(charWheel);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && character.animationname() != 'run')
		{
			character.flipX = FlxG.keys.justReleased.LEFT;

			current_level += (character.flipX) ? -1 : 1;
			if (current_level > 3)
			{
				current_level -= 1;
				return;
			}

			character.animation.play('run');
			FlxTween.tween(character, {x: character.x + ((character.flipX) ? -256 : 256)}, 1, {
				onComplete: tween ->
				{
					character.animation.play('idle');

					if (current_level < 1)
					{
						FlxG.switchState(() -> new MainMenu());
						current_level += 1;
					}
				}
			});
		}

		if (FlxG.keys.justReleased.ENTER && character.animationname() == 'idle')
		{
			switch (current_level)
			{
				case 1:
					FlxG.switchState(() -> ((character.lowercase_char() == 'sinco') ? new Stage1() : new Stage4()));
			}
		}

		if (FlxG.keys.justReleased.SPACE && canSwap)
		{
			canSwap = false;
			charWheel.animation.play('${character.lowercase_char()}-${character.swappedchar().toLowerCase()}');
			
			FlxTimer.wait(2 / 12, () -> {
				FlxG.camera.flash(0xffffff, 1, () -> {
					canSwap = true;
				});
				for (tile in mapGRP)
				{
					tile.destroy();
					mapGRP.remove(tile);
				}
				makeMap();
				character.swapCharacter();
			});
		}
	}

	var canSwap:Bool = true;

	public function makeMap() {
		var i = 0;
		while (i < 3)
		{
			// TODO: change these to use MapTile once you figure out the bug

			var level:FlxSprite = new FlxSprite(character.getGraphicMidpoint().x - 12 + (i * 256), character.getGraphicMidpoint().y);

			if (implementedLevels.get(character.lowercase_char())[i] == false)
				level.makeGraphic(24, 24, FlxColor.BLACK);
			else
				level.makeGraphic(24, 24, FlxColor.RED);

			mapGRP.add(level);

			i++;
		}
	}
}