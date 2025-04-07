package sap.stages.stage1;

import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sap.results.ResultsMenu;
import sap.worldmap.Worldmap;

class Stage1 extends State
{
	public static var background:FlxSprite;

	public static var sinco:Sinco;
	public static var osin:Osin;

	public static var OSIN_HEALTH:Int = 10;
	public static var SINCO_HEALTH:Int = 10;

	public static var OSIN_MAX_HEALTH:Int = 10;
	public static var SINCO_MAX_HEALTH:Int = 10;

	public static var osinHealthIndicator:FlxText;
	public static var sincoHealthIndicator:FlxText;

	override function create():Void
	{
		super.create();

		sinco = new Sinco();
		osin = new Osin();

		osinHealthIndicator = new FlxText();
		sincoHealthIndicator = new FlxText();

		var backgroundBack = new SparrowSprite('gameplay/sinco stages/StageOneBackground');

		backgroundBack.addAnimationByPrefix('actualstagebg', 'actualstagebg', 24);
		backgroundBack.animation.play('actualstagebg');

		backgroundBack.screenCenter();
		add(backgroundBack);

		background = new FlxSprite();
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

		Global.changeDiscordRPCPresence('Stage 1: Osin', null);

		osin_canjump = true;
	}

	override function postCreate():Void
	{
		super.postCreate();

		SINCO_MAX_HEALTH = StageGlobals.STAGE1_PLAYER_MAX_HEALTH;
		OSIN_MAX_HEALTH = StageGlobals.STAGE1_OPPONENT_MAX_HEALTH;

		SINCO_HEALTH = SINCO_MAX_HEALTH;
		OSIN_HEALTH = OSIN_MAX_HEALTH;

		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/Right-Dodge'));
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;
		add(tutorial1);

		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/Space-Attack'));
		tutorial2.screenCenter();
		tutorial2.y += tutorial2.height;
		add(tutorial2);

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial1, {alpha: 0}, 1);
			FlxTween.tween(tutorial2, {alpha: 0}, 1);
		});
	}

	public static var sincoPos:FlxPoint;
	public static var osinPos:FlxPoint;
	public static var sinco_jump_speed:Float = 0.25;
	public static var osin_jump_speed:Float = 0.3;

	public static var osin_canjump:Bool = true;
	public static var osin_warning:Bool = false;

	public static dynamic function getOsinJumpCondition():Bool
	{
		return (SINCO_HEALTH >= 1
			&& OSIN_HEALTH >= 1
			&& FlxG.random.int(0, 200) < 50
			&& (osin.animation.name != StageGlobals.JUMP_KEYWORD && osin.animation.name != 'hurt')
			&& osin_canjump);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		updateHealthIndicators();

		var osinJumpCondition:Bool = getOsinJumpCondition();

		if (osinJumpCondition)
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

	public static dynamic function updateHealthIndicators():Void
	{
		osinHealthIndicator.setPosition(osin.x, osin.y - 64);
		osinHealthIndicator.text = '${Global.getLocalizedPhrase('HP')}: $OSIN_HEALTH/$OSIN_MAX_HEALTH';
		if (osin_warning)
		{
			osinHealthIndicator.text += '\n${Global.getLocalizedPhrase('DODGE')}';
		}

		sincoHealthIndicator.setPosition(sinco.x, sinco.y + 64);
		sincoHealthIndicator.text = '${Global.getLocalizedPhrase('HP')}: $SINCO_HEALTH/$SINCO_MAX_HEALTH';
	}

	public static dynamic function osinJumpWait():Void
	{
		osin_canjump = false;
		FlxTimer.wait(FlxG.random.float(0, 2), () ->
		{
			osinWarning();
		});
	}

	public static dynamic function playerControls():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			if (sinco.x != sincoPos.x)
			{
				return;
			}

			Global.playSoundEffect('gameplay/sinco-jump');
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			sincoJump();
		}

		if (FlxG.keys.justPressed.RIGHT)
		{
			if (sinco.x != sincoPos.x)
			{
				return;
			}

			sinco.y += 64;
			sinco.animation.play(StageGlobals.JUMP_KEYWORD);
			Global.playSoundEffect('gameplay/sinco-spin');
			sincoDodge();
		}

		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(() -> new Stage1());
                        FlxG.camera.flash(FlxColor.WHITE, .25, null, true);
		}
	}

	public static dynamic function sincoDeathCheck():Void
	{
		if (SINCO_HEALTH < 1)
		{
			sinco.animation.play('ded');

			osin.animation.pause();
			background.animation.pause();

			sincoDefeated();
		}
	}

	public static dynamic function osinDeathCheck():Void
	{
		if (OSIN_HEALTH < 1)
		{
			osin_canjump = false;
			osin_warning = false;

			background.animation.pause();
			FlxTween.tween(sinco, {x: 1280}, .5);

			osin.animation.play('hurt');
			osinDefeated();
		}
	}

	public static dynamic function osinWarning():Void
	{
		osin.animation.play(StageGlobals.JUMP_KEYWORD);
		osin_warning = true;
		FlxTween.tween(osin, {y: osinPos.y - 150}, FlxG.random.float(0.5, 1), {
			onComplete: _tween ->
			{
				osinJump();
			}
		});
	}

	public static dynamic function osinJump():Void
	{
		osin_warning = false;
		osin.animation.play(StageGlobals.JUMP_KEYWORD);
		Global.playSoundEffect('gameplay/sinco-jump');
		FlxTween.tween(osin, {x: sincoPos.x, y: sincoPos.y}, osin_jump_speed, {
			onComplete: _tween ->
			{
				osinJumpDone();
			}
		});
	}

	public static dynamic function osinJumpDone():Void
	{
		var waitn:Float = 0.25;

		if (osin.overlaps(sinco))
		{
			osinHitSincoCheck();
			waitn = 0;
		}

		FlxTimer.wait(waitn, () ->
		{
			osinJumpBack();
		});
	}

	public static dynamic function osinHitSincoCheck():Void
	{
		sincoHealthIndicator.color = 0xff0000;
		FlxTween.tween(sincoHealthIndicator, {color: 0xffffff}, 1);

		SINCO_HEALTH--;
		Global.hitHurt();

		if (SINCO_HEALTH < 1)
		{
			return;
		}
	}

	public static dynamic function osinJumpBack():Void
	{
		FlxTween.tween(osin, {x: osinPos.x, y: osinPos.y}, osin_jump_speed, {
			onComplete: _tween ->
			{
				osin.animation.play('run');
				osin_canjump = true;
			}
		});
	}

	public static dynamic function sincoJump():Void
	{
		FlxTween.tween(sinco, {x: osinPos.x, y: osinPos.y}, sinco_jump_speed, {
			onComplete: _tween ->
			{
				sincoJumpBack();
			}
		});
	}

	public static dynamic function sincoJumpBack():Void
	{
		osinHurtCheck();

		FlxTween.tween(sinco, {x: sincoPos.x, y: sincoPos.y}, sinco_jump_speed, {
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

	public static dynamic function osinHurtCheck():Void
	{
		if (sinco.overlaps(osin) && osin.animation.name != StageGlobals.JUMP_KEYWORD)
		{
			osinHealthIndicator.color = 0xff0000;
			FlxTween.tween(osinHealthIndicator, {color: 0xffffff}, 1);
			OSIN_HEALTH--;
			osin.animation.play('hurt');
			Global.hitHurt();
		}
	}

	public static dynamic function sincoDodge():Void
	{
		FlxTween.tween(sinco, {x: osinPos.x}, sinco_jump_speed, {
			onComplete: _tween ->
			{
				sincoDodgeRecoil();
			}
		});
	}

	public static dynamic function sincoDodgeRecoil():Void
	{
		FlxTween.tween(sinco, {x: sincoPos.x}, sinco_jump_speed, {
			onComplete: _tween ->
			{
				sinco.animation.play('run');
				sinco.y -= 64;
			}
		});
	}

	public static dynamic function sincoDefeated():Void
	{
		FlxTween.tween(sinco, {y: FlxG.width * 2}, 1, {
			onComplete: _tween ->
			{
				FlxG.switchState(() -> new ResultsMenu((OSIN_MAX_HEALTH - OSIN_HEALTH), OSIN_MAX_HEALTH, () -> new Worldmap()));
			},
			onStart: _tween ->
			{
				deathSFX();
			}
		});
	}

	public static dynamic function osinDefeated():Void
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

	public static dynamic function deathSFX(name:String = 'dead'):Void
	{
		if (!playedDeathFX)
		{
			Global.playSoundEffect('gameplay/$name');
			playedDeathFX = true;
		}
	}

	public static dynamic function endCutsceneTransition():Void
	{
		Global.beatLevel(1);
		FlxG.switchState(() -> new ResultsMenu(SINCO_HEALTH, SINCO_MAX_HEALTH, () -> new PostStage1Cutscene()));
	}

	public static var playedDeathFX:Bool = false;
}
