package sap.stages.stage1;

import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import funkin.graphics.shaders.DropShadowShader;
import sap.results.ResultsMenu;
class Stage1 extends State
{
	public static var RACE_TRACK:FlxSprite;

	public static var sinco:Sinco;
	public static var osin:Osin;

	public static var OSIN_HEALTH:Int = 10;
	public static var SINCO_HEALTH:Int = 10;

	public static var OSIN_MAX_HEALTH:Int = 10;
	public static var SINCO_MAX_HEALTH:Int = 10;

	public static var PLAYER_COMBO:Int = 0;
	public static var PLAYED_COMBO_ANIMATION:Bool = false;

	// Controls what combos will give sinco the combo animation
	public static var PLAYER_COMBO_ANIMATEDS:Array<Int> = [10, 20, 30];

	public static var DIFFICULTY:String = '';
	public static var diffJson:Stage1DifficultyJson;

	public static var INFO_TEXTFIELD:FlxText;
	public static var INFO_TEXT:String;

	public static var PROGRESS_BAR:FlxBar;

	public static var RUNNING:Bool = false;

	override public function new(difficulty:String):Void
	{
		super();

		RUNNING = true;

		DIFFICULTY = difficulty;
		diffJson = FileManager.getJSON(FileManager.getDataFile('stages/stage1/${difficulty}.json'));

		SINCO_MAX_HEALTH = diffJson.player_max_health;
		OSIN_MAX_HEALTH = diffJson.opponent_max_health;

		final combo_poses_filepath:String = FileManager.getDataFile('stages/stage1/combo_poses.txt');

		if (FileManager.exists(combo_poses_filepath))
		{
			var string_combo_array:Array<String> = FileManager.readFile(combo_poses_filepath).split('\n');
			var integer_combo_array:Array<Int> = [];

			if (string_combo_array.length < 1)
				return;

			trace('Combo poses file exists, replacing PLAYER_COMBO_ANIMATEDS...');
			for (string in string_combo_array)
			{
				trace('Text combo: ${string}');
				final int_string = Std.parseInt(string);
				if (!integer_combo_array.contains(int_string))
					integer_combo_array.push(int_string);
			}

			final og_combo_animateds:Array<Int> = PLAYER_COMBO_ANIMATEDS;
			PLAYER_COMBO_ANIMATEDS = integer_combo_array;

			var compareSign:String = '=';

			if (PLAYER_COMBO_ANIMATEDS.length > og_combo_animateds.length)
			{
				compareSign = '>';
			}
			else if (PLAYER_COMBO_ANIMATEDS.length < og_combo_animateds.length)
			{
				compareSign = '<';
			}

			final lengthCompare:String = 'Current length: ${PLAYER_COMBO_ANIMATEDS.length} ${compareSign} Original length: ${og_combo_animateds.length}';
			trace('PLAYER_COMBO_ANIMATEDS replaced (${lengthCompare})');
		}
	}

	override function create():Void
	{
		super.create();

		sinco = new Sinco();
		osin = new Osin();

		var sparrowBG = new SparrowSprite('gameplay/sinco stages/StageOneBackground');

		sparrowBG.addAnimationByPrefix('actualstagebg', 'actualstagebg', 24);
		sparrowBG.animation.play('actualstagebg');

		sparrowBG.screenCenter();
		add(sparrowBG);

		RACE_TRACK = new FlxSprite();
		RACE_TRACK.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

		RACE_TRACK.animation.add('animation', [0, 1], 16);
		RACE_TRACK.animation.play('animation');

		Global.scaleSprite(RACE_TRACK, 1);
		RACE_TRACK.screenCenter();
		add(RACE_TRACK);

		osin.screenCenter();
		osin.y += osin.height * 2;
		osin.x += osin.width * 4;
		add(osin);

		sinco.screenCenter();
		sinco.y += sinco.height * 4;
		sinco.x -= sinco.width * 4;
		add(sinco);

		var rim:DropShadowShader = new DropShadowShader();
		rim.setAdjustColor(-66, -10, 24, -23);
		rim.color = 0xFF373234;
		rim.antialiasAmt = 0;
		rim.distance = 5;

		rim.angle = 90;
		rim.maskThreshold = 1;
		rim.useAltMask = true;
		rim.loadAltMask(FileManager.getImageFile('gameplay/sinco stages/Stage1Sinco-ShaderMask'));

		// sinco.shader = rim;

		SINCO_POINT = new FlxPoint(0, 0);
		SINCO_POINT.set(sinco.x, sinco.y);

		OSIN_POINT = new FlxPoint(0, 0);
		OSIN_POINT.set(osin.x, osin.y);

		Global.changeDiscordRPCPresence('Stage 1 (${DIFFICULTY.toUpperCase()}): Osin', null);

		OSIN_CAN_ATTACK = true;

		PROGRESS_BAR = new FlxBar(0, 0, RIGHT_TO_LEFT, Std.int(FlxG.width / 2), 16, this, 'health', 0, 100, true);
		add(PROGRESS_BAR);
		PROGRESS_BAR.screenCenter(X);
		PROGRESS_BAR.y = FlxG.height - PROGRESS_BAR.height - 64;
		PROGRESS_BAR.createFilledBar(Random.dominantColor(sinco), Random.dominantColor(osin), true, FlxColor.BLACK, 4);

		INFO_TEXTFIELD = new FlxText(PROGRESS_BAR.x, PROGRESS_BAR.y + 16, 0, INFO_TEXT, 16);
		add(INFO_TEXTFIELD);

		COMBO_SPRITE = new Combo();
		add(COMBO_SPRITE);
		COMBO_SPRITE.visible = false;
		COMBO_SPRITE.screenCenter();

		PLAYER_COMBO = 0;
	}

	public static var ABILITY_CAN_ATTACK_PLAYER:Bool = true;

	override function postCreate():Void
	{
		super.postCreate();

		SINCO_HEALTH = SINCO_MAX_HEALTH;
		OSIN_HEALTH = OSIN_MAX_HEALTH;

		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Right-Dodge'));
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;
		add(tutorial1);

		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/pixel/Space-Attack'));
		tutorial2.screenCenter();
		tutorial2.y += tutorial2.height;
		add(tutorial2);

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial1, {alpha: 0}, 1);
			FlxTween.tween(tutorial2, {alpha: 0}, 1);
		});
	}

	public static var COMBO_SPRITE:Combo;

	public static var SINCO_POINT:FlxPoint;
	public static var OSIN_POINT:FlxPoint;
	public static var SINCO_JUMP_SPEED:Float = 0.25;
	public static var OSIN_JUMP_SPEED:Float = 0.3;

	public static var OSIN_CAN_ATTACK:Bool = true;

	public static function getOsinJumpCondition():Bool
	{
		return (SINCO_HEALTH >= 1
			&& OSIN_HEALTH >= 1
			&& FlxG.random.int(0, 200) < 50
			&& (osin.animation.name != StageGlobals.JUMP_KEYWORD && osin.animation.name != 'hurt')
			&& OSIN_CAN_ATTACK);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateHealthIndicators();

		if (getOsinJumpCondition())
		{
			osinJumpWait();
		}

		if (OSIN_HEALTH >= 1)
		{
			playerControls();
		}

		sincoDeathCheck();

		osinDeathCheck();
	}

	public static function updateHealthIndicators():Void
	{
		INFO_TEXT = 'Sinco: ${Global.getLocalizedPhrase('HP')}: $SINCO_HEALTH/$SINCO_MAX_HEALTH || Osin: ${Global.getLocalizedPhrase('HP')}: $OSIN_HEALTH/$OSIN_MAX_HEALTH';
		PROGRESS_BAR.percent = (OSIN_HEALTH / OSIN_MAX_HEALTH) * 100;
		INFO_TEXTFIELD.text = INFO_TEXT;
		INFO_TEXTFIELD.screenCenter(X);
	}

	public static function osinJumpWait():Void
	{
		OSIN_CAN_ATTACK = false;
		FlxTimer.wait(FlxG.random.float(0, 2), () ->
		{
			osinWarning();
		});
	}

	public static function playerControls():Void
	{
		if (Global.keyJustPressed(SPACE) && ABILITY_CAN_ATTACK_PLAYER)
		{
			if (sinco.x != SINCO_POINT.x)
			{
				return;
			}

			Global.playSoundEffect('gameplay/sinco-jump');
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			sincoJump();
		}
		else if (Global.keyJustPressed(RIGHT))
		{
			if (sinco.x != SINCO_POINT.x)
			{
				return;
			}

			sinco.y += 64;
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			Global.playSoundEffect('gameplay/sinco-spin');
			sincoDodge();
		}

		if (Global.keyJustPressed(R))
		{
			Global.switchState(new Stage1(DIFFICULTY));
			FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}
	}

	public static function sincoDeathCheck():Void
	{
		if (SINCO_HEALTH < 1)
		{
			sinco.animation.play('ded');

			osin.animation.pause();
			RACE_TRACK.animation.pause();

			sincoDefeated();
		}
	}

	public static function osinDeathCheck():Void
	{
		if (OSIN_HEALTH < 1)
		{
			OSIN_CAN_ATTACK = false;

			RACE_TRACK.animation.pause();
			FlxTween.tween(sinco, {x: 1280}, .5);

			osin.animation.play('hurt');
			osinDefeated();
		}
	}

	public static function osinWarning():Void
	{
		osin.animation.play(StageGlobals.JUMP_KEYWORD);
		FlxTween.tween(osin, {y: OSIN_POINT.y - 150}, FlxG.random.float(0.5, 1), {
			onComplete: _tween ->
			{
				osinJump();
			}
		});
	}

	public static function osinJump():Void
	{
		ABILITY_CAN_ATTACK_PLAYER = false;
		osin.animation.play(StageGlobals.JUMP_KEYWORD);
		Global.playSoundEffect('gameplay/sinco-jump');
		FlxTween.tween(osin, {x: SINCO_POINT.x, y: SINCO_POINT.y}, OSIN_JUMP_SPEED, {
			onComplete: _tween ->
			{
				osinJumpDone();
			}
		});
	}

	public static function osinJumpDone():Void
	{
		var waitn:Float = 0.25;

		if (osin.overlaps(sinco))
		{
			osinHitSinco();
			waitn = 0;
		}

		FlxTimer.wait(waitn, () ->
		{
			osinJumpBack();
		});
	}

	public static function osinHitSinco():Void
	{
		// Loss combo :(
		PLAYER_COMBO = 0;

		SINCO_HEALTH--;
		Global.hitHurt();

		if (SINCO_HEALTH < 1)
		{
			return;
		}
	}

	public static function osinJumpBack():Void
	{
		FlxTween.tween(osin, {x: OSIN_POINT.x, y: OSIN_POINT.y}, OSIN_JUMP_SPEED, {
			onComplete: _tween ->
			{
				osin.animation.play('run');
				OSIN_CAN_ATTACK = true;
				ABILITY_CAN_ATTACK_PLAYER = true;
			}
		});
	}

	public static function sincoJump():Void
	{
		FlxTween.tween(sinco, {x: OSIN_POINT.x, y: OSIN_POINT.y}, SINCO_JUMP_SPEED, {
			onComplete: _tween ->
			{
				sincoJumpBack();
			}
		});
	}

	public static function sincoJumpBack():Void
	{
		osinHurtCheck();

		if (PLAYER_COMBO_ANIMATEDS.contains(PLAYER_COMBO) && !PLAYED_COMBO_ANIMATION)
		{
			sinco.animation.play('combo');
			PLAYED_COMBO_ANIMATION = true;

			COMBO_SPRITE.visible = true;
			COMBO_SPRITE.scale.set(1.5 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, 1.5 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER);
			COMBO_SPRITE.alpha = 1;
			FlxTween.tween(COMBO_SPRITE,
				{alpha: 0, 'scale.x': 1 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER, 'scale.y': 1 * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER}, 1, {
					onComplete: tween ->
					{
						COMBO_SPRITE.visible = false;
					},
					ease: FlxEase.bounceInOut
				});
		}
		else
		{
			PLAYED_COMBO_ANIMATION = false;
		}

		FlxTween.tween(sinco, {x: SINCO_POINT.x, y: SINCO_POINT.y}, SINCO_JUMP_SPEED, {
			onComplete: _tween ->
			{
				sinco.animation.play('run');
				if (osin.animation.name == 'hurt')
				{
					osin.animation.play('run');
				}
			}
		});
	}

	public static function osinHurtCheck():Void
	{
		if (sinco.overlaps(osin) && osin.animation.name != StageGlobals.JUMP_KEYWORD)
		{
			PLAYER_COMBO++;
			PLAYED_COMBO_ANIMATION = false;

			OSIN_HEALTH--;
			osin.animation.play('hurt');
			Global.hitHurt();
		}
	}

	public static function sincoDodge():Void
	{
		FlxTween.tween(sinco, {x: OSIN_POINT.x}, SINCO_JUMP_SPEED, {
			onComplete: _tween ->
			{
				sincoDodgeRecoil();
			}
		});
	}

	public static function sincoDodgeRecoil():Void
	{
		FlxTween.tween(sinco, {x: SINCO_POINT.x}, SINCO_JUMP_SPEED, {
			onComplete: _tween ->
			{
				sinco.animation.play('run');
				sinco.y -= 64;
			}
		});
	}

	public static function sincoDefeated():Void
	{
		FlxTween.tween(sinco, {y: FlxG.width * 2}, 1, {
			onComplete: _tween ->
			{
				Global.switchState(new ResultsMenu((OSIN_MAX_HEALTH - OSIN_HEALTH), OSIN_MAX_HEALTH, new Worldmap()));
			},
			onStart: _tween ->
			{
				deathSFX();
			}
		});
	}

	public static function osinDefeated():Void
	{
		FlxTween.tween(osin, {y: FlxG.width * 2}, 1, {
			onComplete: _tween ->
			{
				endCutsceneTransition();
			},
			onStart: _tween ->
			{
				deathSFX('explosion');
			}
		});
	}

	public static function deathSFX(name:String = 'dead'):Void
	{
		if (!PLAYED_DEATH_SFX)
		{
			Global.playSoundEffect('gameplay/$name');
			PLAYED_DEATH_SFX = true;
		}
	}

	public static function endCutsceneTransition():Void
	{
		Global.beatLevel(1);

		FlxG.switchState(() -> new ResultsMenu(SINCO_HEALTH, SINCO_MAX_HEALTH, new PostStage1Cutscene()));
	}

	public static var PLAYED_DEATH_SFX:Bool = false;
}
