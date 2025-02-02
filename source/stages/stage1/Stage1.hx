package stages.stage1;

import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import mainmenu.MainMenu;
import mainmenu.PlayMenu;

class Stage1 extends FlxState
{
	var background:FlxSprite = new FlxSprite();

	var sinco:Sinco = new Sinco();
	var osin:Osin = new Osin();

	var OSIN_HEALTH:Int = 10;
	var SINCO_HEALTH:Int = 10;

	var osinHealthIndicator:FlxText = new FlxText();
	var sincoHealthIndicator:FlxText = new FlxText();

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

		sincoPos = new FlxPoint(0, 0);
		sincoPos.set(sinco.x, sinco.y);

		osinPos = new FlxPoint(0, 0);
		osinPos.set(osin.x, osin.y);

		osinHealthIndicator.size = 16;
		add(osinHealthIndicator);

		sincoHealthIndicator.size = 16;
		add(sincoHealthIndicator);
	}

	var sincoPos:FlxPoint;
	var osinPos:FlxPoint;
	var sinco_jump_speed:Float = 0.25;
	var osin_jump_speed:Float = 0.3;

	var osin_canjump:Bool = true;
	var osin_warning:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		osinHealthIndicator.setPosition(osin.x, osin.y - 64);
		osinHealthIndicator.text = 'HP: $OSIN_HEALTH/10';
		if (osin_warning)
			osinHealthIndicator.text += '\nDODGE';

		sincoHealthIndicator.setPosition(sinco.x, sinco.y + 64);
		sincoHealthIndicator.text = 'HP: $SINCO_HEALTH/10';

		if (SINCO_HEALTH >= 1
			&& FlxG.random.int(0, 200) < 50
			&& (osin.animation.name != 'jump' && osin.animation.name != 'hurt')
			&& osin_canjump)
		{
			osin_canjump = false;
			osin_warning = true;
			FlxTimer.wait(FlxG.random.float(0, 2), () ->
			{
				osin_warning = false;
				osin.animation.play('jump');
				FlxTween.tween(osin, {x: sincoPos.x, y: sincoPos.y}, osin_jump_speed, {
					onComplete: _tween ->
					{
						var waitn = .25;

						if (osin.overlaps(sinco))
						{
							sincoHealthIndicator.color = 0xff0000;
							FlxTween.tween(sincoHealthIndicator, {color: 0xffffff}, 1);

							SINCO_HEALTH--;
							waitn = 0;

							if (SINCO_HEALTH < 1)
								return;
						}

						FlxTimer.wait(waitn, () ->
						{
							FlxTween.tween(osin, {x: osinPos.x, y: osinPos.y}, osin_jump_speed, {
								onComplete: _tween ->
								{
									osin.animation.play('run');
									osin_canjump = true;
								}
							});
						});
					}
				});
			});
		}

		if (FlxG.keys.justPressed.SPACE)
		{
			if (sinco.x != sincoPos.x)
				return;

			sinco.animation.play('jump');
			FlxTween.tween(sinco, {x: osinPos.x, y: osinPos.y}, sinco_jump_speed, {
				onComplete: _tween ->
				{
					if (sinco.overlaps(osin) && osin.animation.name != 'jump')
					{
						osinHealthIndicator.color = 0xff0000;
						FlxTween.tween(osinHealthIndicator, {color: 0xffffff}, 1);
						OSIN_HEALTH--;
						osin.animation.play('hurt');
					}

					FlxTween.tween(sinco, {x: sincoPos.x, y: sincoPos.y}, sinco_jump_speed, {
						onComplete: _tween ->
						{
							sinco.animation.play('run');
							if (osin.animation.name == 'hurt')
								osin.animation.play('run');
						}
					});
				}
			});
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (sinco.x != sincoPos.x)
				return;

			sinco.y += 64;
			sinco.animation.play('jump');
			FlxTween.tween(sinco, {x: osinPos.x}, sinco_jump_speed, {
				onComplete: _tween ->
				{
					FlxTween.tween(sinco, {x: sincoPos.x,}, sinco_jump_speed, {
						onComplete: _tween ->
						{
							sinco.animation.play('run');
							sinco.y -= 64;
						}
					});
				}
			});
		}

		if (SINCO_HEALTH < 1)
		{
			sinco.animation.play('ded');

			osin.animation.pause();
			background.animation.pause();

			FlxTween.tween(sinco, {y: FlxG.width * 2}, 1, {
				onComplete: _tween -> {
					FlxG.switchState(() -> new PlayMenu());
				}
			});
		}
	}
}
