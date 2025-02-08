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
		mapTileXPosThing = character.getGraphicMidpoint().x;

		makeMap();

		add(mapGRP);
		add(character);

		charWheel.screenCenter(X);
		charWheel.y = charWheel.height + 16;

		charWheel.animation.play('sinco');

		add(charWheel);
	}

	var mapTileXPosThing:Float = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustReleased([LEFT, RIGHT]) && character.animationname() != 'run')
		{
			canSwap = false;
			character.flipX = FlxG.keys.justReleased.LEFT;

			current_level += (character.flipX) ? -1 : 1;
			if (current_level > 3)
			{
				current_level -= 1;
				canSwap = true;
				return;
			}

			character.animation.play('run');
			FlxTween.tween(character, {x: character.x + ((character.flipX) ? -256 : 256)}, 1, {
				onComplete: tween ->
				{
					canSwap = true;
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
				// TODO: implement level unlocking PLEASE
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

			var level:FlxSprite = new FlxSprite(mapTileXPosThing - 12 + (i * 256), character.getGraphicMidpoint().y);
			var tileColor:FlxColor = FlxColor.BLACK;

			if (implementedLevels.get(character.lowercase_char())[i] != false)
			{
				tileColor = FlxColor.RED;

				// TODO: implement color change for when a level is finished
			}
			
			level.makeGraphic(24, 24, tileColor);

			mapGRP.add(level);

			i++;
		}
	}
}