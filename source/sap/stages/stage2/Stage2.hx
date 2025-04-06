package sap.stages.stage2;

class Stage2 extends State
{
	public static var bg:FlxSprite;

	public static var sinco:Stage2Sinco;

	public static var rockGroup:FlxTypedGroup<Stage2Rock>;

	override function create():Void
	{
		super.create();

		bg = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage2Background'));
		add(bg);
		Global.scaleSprite(bg);
		bg.screenCenter();

		sinco = new Stage2Sinco();
		add(sinco);
		sinco.screenCenter();

		sinco.x += 4 * 8;
		sinco.y += 4 * 24;

		trace(sinco.y);

		rockGroup = new FlxTypedGroup<Stage2Rock>();
		add(rockGroup);

		spawnRocks(1);
	}

	public static dynamic function spawnRocks(amount:Int = 1):Void
	{
		var index:Int = 0;

		while (index < amount)
		{
			var rock:Stage2Rock = new Stage2Rock();
			rock.setPosition(FlxG.width + (rock.width * 2), -(rock.height * 2));
			if (rockGroup.members.length < max_rocks)
			{
				rockGroup.add(rock);

				final positioncalc:Float = (bg.graphic.height * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER) / 2;
				FlxTween.tween(rock, {x: rock.width, y: positioncalc}, FlxG.random.float(2, 6), {
					onComplete: tween ->
					{
						rockHitTempoCity();
						rock.blowUpSFX();
						destroyRock(rock);
					}
				});
			}

			index++;
		}
	}

	public static dynamic function rockHitTempoCity():Void
	{
		FlxG.camera.flash(FlxColor.WHITE, .1);
		if (sinco.y == StageGlobals.STAGE2_PLAYER_START_Y)
		{
			sinco.animation.play('fail');
			FlxTimer.wait(.3, function()
			{
				sinco.animation.play('idle');
			});
		}
	}

	public static dynamic function destroyRock(rock:Stage2Rock):Void
	{
		if (rockGroup.members.length < max_rocks)
		{
			spawnRocks(FlxG.random.int(1, 2));
		}
		else
		{
			spawnRocks(1);
		}
		rock.destroy();
		rockGroup.members.remove(rock);
	}

	public static dynamic function destroyRockCheck():Void
	{
		for (rock in rockGroup.members)
		{
			if (rock.pixelsOverlapPoint(sinco.getPosition()))
			{
                                FlxTween.cancelTweensOf(rock);

				FlxTween.tween(rock, {x: rock.x + FlxG.random.float(-20, 20), y: 0 - rock.height * 5}, .5, {
					onComplete: _tween ->
					{
						destroyRock(rock);
					},
					onStart: _tween ->
					{
						rock.blowUpSFX();
					}
				});
			}
		}
	}

	public static dynamic function unjump():Void
	{
		FlxTween.tween(sinco, {y: start_y}, jump_speed, {
			onComplete: _tween ->
			{
				sinco.animation.play('idle');
			}
		});
	}

	static final jump_speed:Float = StageGlobals.STAGE2_PLAYER_JUMP_SPEED;
	static final start_y:Float = StageGlobals.STAGE2_PLAYER_START_Y;
	static final jump_y_offset:Float = StageGlobals.STAGE2_PLAYER_JUMP_Y_OFFSET;

	static final max_rocks:Float = StageGlobals.STAGE2_MAX_ROCKS;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.SPACE && sinco.animation.name != StageGlobals.JUMP_KEYWORD)
		{
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			Global.playSoundEffect('gameplay/sinco-jump');

			FlxTween.tween(sinco, {y: start_y - jump_y_offset}, jump_speed, {
				onUpdate: _tween ->
				{
					destroyRockCheck();
				},
				onComplete: _tween ->
				{
					unjump();
				}
			});
		}
	}
}
