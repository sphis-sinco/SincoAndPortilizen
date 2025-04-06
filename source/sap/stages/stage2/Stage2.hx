package sap.stages.stage2;

class Stage2 extends State
{
	public static var bg:FlxSprite;

	public static var sinco:Stage2Sinco;

	public static var rockGroup:FlxTypedGroup<Stage2Rock>;

	public static var timerText:FlxText;
	public static var time:Int = 0;

	public static var TEMPO_CITY_HEALTH:Int = StageGlobals.STAGE2_TEMPO_CITY_MAX_HEALTH;

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

		trace('Sinco y: '+sinco.y);

		rockGroup = new FlxTypedGroup<Stage2Rock>();
		add(rockGroup);

		spawnRocks(1);

		time = 0;
		FlxTimer.wait(StageGlobals.STAGE2_START_TIMER, () ->
		{
			levelComplete();
		});

		timerText = new FlxText(10, 10, 0, "60", 64);
		add(timerText);
		StageGlobals.waitSec(StageGlobals.STAGE2_START_TIMER, time, timerText);

		Global.changeDiscordRPCPresence('Stage 2: Tierra', null);
	}

	public static dynamic function levelComplete():Void
	{
		Global.beatLevel(2);
		moveToResultsMenu();
	}

	public static dynamic function moveToResultsMenu():Void
	{
		if (time == StageGlobals.STAGE2_START_TIMER)
		{
			MedalData.unlockMedal('Protector');
			if (TEMPO_CITY_HEALTH == StageGlobals.STAGE2_TEMPO_CITY_MAX_HEALTH)
			{
				MedalData.unlockMedal('True Protector');
			}
		}
		FlxG.switchState(() -> new ResultsMenu(TEMPO_CITY_HEALTH, StageGlobals.STAGE2_TEMPO_CITY_MAX_HEALTH, () -> new Worldmap("Sinco"), "sinco"));
	}

	static var decrease:Float = 0;

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
						bg.y += StageGlobals.STAGE2_BG_POSITION_DECREASE;
						sinco.y += StageGlobals.STAGE2_BG_POSITION_DECREASE;
						decrease += StageGlobals.STAGE2_BG_POSITION_DECREASE;
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
		TEMPO_CITY_HEALTH--;
		FlxG.camera.flash(FlxColor.WHITE, .1);
		if (sinco.animation.name != StageGlobals.JUMP_KEYWORD)
		{
			sinco.animation.play('fail');
			FlxTimer.wait(1, function()
			{
				if (sinco.animation.name != StageGlobals.JUMP_KEYWORD)
				{
					sinco.animation.play('idle');
				}
			});
		}

		if (TEMPO_CITY_HEALTH == 0)
		{
			FlxTween.tween(bg, {y: FlxG.height * 2}, .2);
			FlxTween.tween(sinco, {y: FlxG.height * 2 + start_y}, .2, {
				onComplete: _tween ->
				{
					FlxTimer.wait(1, function()
					{
						moveToResultsMenu();
					});
				}
			});
		}
	}

	public static dynamic function destroyRock(rock:Stage2Rock):Void
	{
		if (TEMPO_CITY_HEALTH != 0)
		{
			if (rockGroup.members.length < max_rocks)
			{
				spawnRocks(FlxG.random.int(1, 2));
			}
			else
			{
				spawnRocks(1);
			}
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
		FlxTween.tween(sinco, {y: (start_y + decrease)}, jump_speed + ((StageGlobals.STAGE2_TEMPO_CITY_MAX_HEALTH - TEMPO_CITY_HEALTH) / 100), {
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

			FlxTween.tween(sinco, {y: (start_y + decrease) - (jump_y_offset + (decrease / 1.45))},
				jump_speed + ((StageGlobals.STAGE2_TEMPO_CITY_MAX_HEALTH - TEMPO_CITY_HEALTH) / 100), {
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
