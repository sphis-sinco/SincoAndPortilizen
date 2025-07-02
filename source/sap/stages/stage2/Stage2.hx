package sap.stages.stage2;

import sap.stages.stage2.PostStage2Cutscene;

class Stage2 extends PausableState
{
	public static var bg:FlxSprite;

	public static var sinco:Stage2Sinco;

	public static var rockGroup:FlxTypedGroup<Stage2Rock>;

	public static var timerText:FlxText;
	public static var time:Int = 0;

	public static var TEMPO_CITY_HEALTH:Int = 5;

	public static var DIFFICULTY:String = '';
	public static var diffJson:Stage2DifficultyJson;

	static var jump_speed:Float;
	static var start_y:Float;
	static var jump_y_offset:Float;

	static var max_rocks:Int;
	static var rock_speed_divider:Float;

	public static var RUNNING:Bool = false;

	override public function new(difficulty:String):Void
	{
		super(false);

		artEnabled = [true, false];
		artStrings = ['Stage2-sinco', ''];

		RUNNING = true;

		DIFFICULTY = difficulty;
		diffJson = FileManager.getJSON(FileManager.getDataFile('stages/stage2/${difficulty}.json'));

		jump_speed = diffJson.player_jump_speed;
		start_y = diffJson.player_start_y;
		jump_y_offset = diffJson.player_jump_y_offset;
		max_rocks = 2;
		rock_speed_divider = diffJson.rock_speed_divider;

		if (rockGroup != null)
		{
			TryCatch.tryCatch(function()
			{
				for (rock in rockGroup.members)
				{
					rock.destroy();
					rockGroup.members.remove(rock);
				}
			});
		}
	}

	public static var PROGRESS_BAR:FlxBar;
	public static var INFO_TEXTFIELD:FlxText;
	public static var INFO_TEXT:String;

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

		#if EXCESS_TRACES
		trace('Sinco y: ' + sinco.y);
		#end

		rockGroup = new FlxTypedGroup<Stage2Rock>();
		add(rockGroup);

		spawnRocks(1);

		time = 0;
		FlxTimer.wait(diffJson.start_timer, () ->
		{
			levelComplete();
		});

		timerText = new FlxText(10, 10, 0, "60", 64);
		add(timerText);
		StageGlobals.waitSec(diffJson.start_timer, time, timerText);

		Global.changeDiscordRPCPresence('Stage 2 (${DIFFICULTY.toUpperCase()}): Tierra', null);

		var tutorial:FlxSprite = new FlxSprite();
		tutorial.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Space-Attack'));
		tutorial.screenCenter();
		add(tutorial);

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial, {alpha: 0}, 1);
		});

		decrease = 0;

		TEMPO_CITY_HEALTH = diffJson.tempo_city_max_health;

		var dummyRock:Stage2Rock = new Stage2Rock();

		PROGRESS_BAR = new FlxBar(0, 0, RIGHT_TO_LEFT, Std.int(FlxG.width / 2), 16, this, 'health', 0, 100, true);
		add(PROGRESS_BAR);
		PROGRESS_BAR.screenCenter(X);
		PROGRESS_BAR.y = FlxG.height - PROGRESS_BAR.height - 64;
		PROGRESS_BAR.createFilledBar(Random.dominantColor(dummyRock), Random.dominantColor(sinco), true, FlxColor.BLACK, 4);

		INFO_TEXTFIELD = new FlxText(PROGRESS_BAR.x, PROGRESS_BAR.y + 16, 0, INFO_TEXT, 16);
		add(INFO_TEXTFIELD);
	}

	public static function levelComplete():Void
	{
		Global.beatLevel(2);
		cutsceneResults();
	}

	public static function cutsceneResults():Void
	{
		Global.switchState(new ResultsMenu(TEMPO_CITY_HEALTH, diffJson.tempo_city_max_health, new PostStage2Cutscene(), "sinco"));
	}

	public static function moveToResultsMenu():Void
	{
		Global.switchState(new ResultsMenu(TEMPO_CITY_HEALTH, diffJson.tempo_city_max_health, new Worldmap(), 'sinco'));
	}

	static var decrease:Float = 0;

	public static function spawnRocks(amount:Int = 1):Void
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
				FlxTween.tween(rock, {x: rock.width, y: positioncalc + (bg.y - 228)}, FlxG.random.float(2, 6) / 2, {
					onComplete: tween ->
					{
						bg.y += diffJson.bg_position_decrease;
						sinco.y += diffJson.bg_position_decrease;
						decrease += diffJson.bg_position_decrease;
						rockHitTempoCity();
						rock.blowUpSFX();
						destroyRock(rock);
					}
				});
			}

			index++;
		}
	}

	public static function rockHitTempoCity():Void
	{
		TEMPO_CITY_HEALTH--;

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
	}

	public static function destroyRock(rock:Stage2Rock):Void
	{
		if (TEMPO_CITY_HEALTH > 0)
		{
			#if EXCESS_TRACES
			trace('Spawning new rock');
			#end
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

	public static function destroyRockCheck():Void
	{
		for (rock in rockGroup.members)
		{
			if (rock.pixelsOverlapPoint(sinco.getPosition()))
			{
				FlxTween.cancelTweensOf(rock);
				FlxTween.tween(rock, {x: rock.x + FlxG.random.float(-20, 20), y: -500}, .5, {
					onComplete: _tween ->
					{
						destroyRock(rock);
						#if EXCESS_TRACES
						trace('Destroy rock because collided with sinco');
						#end
					},
					onStart: _tween ->
					{
						rock.blowUpSFX();
					}
				});
			}
		}
	}

	public static function unjump():Void
	{
		FlxTween.tween(sinco, {y: (start_y + decrease)}, jump_speed + ((diffJson.tempo_city_max_health - TEMPO_CITY_HEALTH) / 100), {
			onComplete: _tween ->
			{
				if (sinco.y != start_y + decrease)
				{
					unjump();
				}
				else
				{
					sinco.animation.play('idle');
				}
			}
		});
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Global.playMusic('TeenProdigy');

		if (Global.keyJustReleased(ESCAPE) && Std.parseInt(timerText.text) >= 1)
		{
			togglePaused();
		}

		sinco.animation.paused = paused;

		updateHealthIndicators();

		if (Global.keyJustReleased(SPACE) && sinco.animation.name != StageGlobals.JUMP_KEYWORD && !paused)
		{
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			Global.playSoundEffect('gameplay/sinco-jump');

			FlxTween.tween(sinco, {y: (start_y + decrease) - (jump_y_offset + (decrease / 1.45))},
				jump_speed + ((diffJson.tempo_city_max_health - TEMPO_CITY_HEALTH) / 100), {
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

		if (Global.keyJustReleased(R) && !paused)
		{
			Global.switchState(new Stage2(DIFFICULTY));
			FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}
	}

	public static function updateHealthIndicators():Void
	{
		INFO_TEXT = '${Global.getLocalizedPhrase('tempo-city')} ${Global.getLocalizedPhrase('HP')}: ${TEMPO_CITY_HEALTH}/${diffJson.tempo_city_max_health}';
		PROGRESS_BAR.percent = (TEMPO_CITY_HEALTH / diffJson.tempo_city_max_health) * 100;
		INFO_TEXTFIELD.text = INFO_TEXT;
		INFO_TEXTFIELD.screenCenter(X);
	}

	override function togglePaused() {
		super.togglePaused();
	}
}
