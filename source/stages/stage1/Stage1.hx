package stages.stage1;

import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;

class Stage1 extends FlxState
{
	var background:FlxSprite = new FlxSprite();

	var sinco:Sinco = new Sinco();
	var osin:Osin = new Osin();

	override function create()
	{
		super.create();

		background.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

		background.animation.add('animation', [0, 1], 16);
		background.animation.play('animation');

		Global.scaleSprite(background, 1);
		background.screenCenter();
		add(background);

        osin.screenCenter();
        osin.y += osin.height * 2;
        osin.x += osin.width * 4;
        add(osin);

		sinco.screenCenter();
		sinco.y += sinco.height * 4;
		sinco.x -= sinco.width * 4;
		add(sinco);

        sincoPos = new FlxPoint(0,0);
		sincoPos.set(sinco.x, sinco.y);
	}

	var sincoPos:FlxPoint;
    var sinco_jump_speed:Float = 0.25;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
		{
            if (sinco.x != sincoPos.x) return;

			sinco.animation.play('jump');
			FlxTween.tween(sinco, {x: osin.x, y: osin.y}, sinco_jump_speed, {
				onComplete: _tween ->
				{
                    osin.animation.play('hurt');

					FlxTween.tween(sinco, {x: sincoPos.x, y: sincoPos.y}, sinco_jump_speed, {
						onComplete: _tween ->
						{
							sinco.animation.play('run');
                            osin.animation.play('run');
						}
					});
				}
			});
		}
	}
}
