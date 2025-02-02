package stages.stage1;

import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Stage1 extends FlxState
{
	var background:FlxSprite = new FlxSprite();

	var sinco:Sinco = new Sinco();

	override function create()
	{
		super.create();

		background.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

		background.animation.add('animation', [0, 1], 16);
		background.animation.play('animation');

		Global.scaleSprite(background, 1);
		background.screenCenter();
		add(background);

		sinco.screenCenter();
		sinco.y += sinco.height * 4;
		sinco.x -= sinco.width * 4;
		add(sinco);

        sincoPos = new FlxPoint(0,0);
		sincoPos.set(sinco.x, sinco.y);
	}

	var sincoPos:FlxPoint;
    var sinco_jump_speed:Float = 0.5;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
			sinco.animation.play('jump');
			FlxTween.tween(sinco, {x: 0, y: 0}, sinco_jump_speed, {
				onComplete: _tween ->
				{
					FlxTween.tween(sinco, {x: sincoPos.x, y: sincoPos.y}, sinco_jump_speed, {
						onComplete: _tween ->
						{
							sinco.animation.play('run');
						}
					});
				}
			});
		}
	}
}
