var background:SparrowSprite;
var track:FlxSprite;
var sinco:Sinco;
var osin:Osin;
var OSIN_HEALTH:Int = 10;
var SINCO_HEALTH:Int = 10;
var OSIN_MAX_HEALTH:Int = 10;
var SINCO_MAX_HEALTH:Int = 10;
var osinHealthIndicator:FlxText;
var sincoHealthIndicator:FlxText;

function create()
{
	sinco = new Sinco();
	osin = new Osin();

	osinHealthIndicator = new FlxText();
	sincoHealthIndicator = new FlxText();

	background = new SparrowSprite('gameplay/sinco stages/StageOneBackground');
	add(background);

	background.addAnimationByPrefix('idle', 'actualstagebg', 24);
	background.playAnimation('idle');

	background.screenCenter();

	track = new FlxSprite();
	track.loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage1BG'), true, 128, 128);

	track.animation.add('animation', [0, 1], 16);
	track.animation.play('animation');

	Global.scaleSprite(track, 1);
	track.screenCenter();
	add(track);

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

function postCreate()
{
	SINCO_MAX_HEALTH = StageGlobals.STAGE1_PLAYER_MAX_HEALTH;
	OSIN_MAX_HEALTH = StageGlobals.STAGE1_OPPONENT_MAX_HEALTH;

	SINCO_HEALTH = SINCO_MAX_HEALTH;
	OSIN_HEALTH = OSIN_MAX_HEALTH;
}

var sincoPos:FlxPoint;
var osinPos:FlxPoint;
var sinco_jump_speed:Float = 0.25;
var osin_jump_speed:Float = 0.3;
var osin_canjump:Bool = true;
var osin_warning:Bool = false;

function getOsinJumpCondition()
{
	return (SINCO_HEALTH >= 1
		&& OSIN_HEALTH >= 1
		&& FlxG.random.int(0, 200) < 50
		&& (osin.animation.name != 'jump' && osin.animation.name != 'hurt')
		&& osin_canjump);
}

function update(elapsed:Float)
{

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

function updateHealthIndicators()
{
	osinHealthIndicator.setPosition(osin.x, osin.y - 64);
	osinHealthIndicator.text = Global.getLocalizedPhrase('HP')+': $OSIN_HEALTH/$OSIN_MAX_HEALTH';
	if (osin_warning)
		osinHealthIndicator.text += '\n'+Global.getLocalizedPhrase('DODGE');

	sincoHealthIndicator.setPosition(sinco.x, sinco.y + 64);
	sincoHealthIndicator.text = Global.getLocalizedPhrase('HP')+': $SINCO_HEALTH/$SINCO_MAX_HEALTH';
}

function osinJumpWait()
{
	osin_canjump = false;
	FlxTimer.wait(FlxG.random.float(0, 2), () ->
	{
		osinWarning();
	});
}

function playerControls()
{
	if (FlxG.keys.justPressed.SPACE)
	{
		if (sinco.x != sincoPos.x)
			return;

		Global.playSoundEffect('gameplay/sinco-jump');
		sinco.animation.play('jump');
		sincoJump();
	}

	if (FlxG.keys.justPressed.RIGHT)
	{
		if (sinco.x != sincoPos.x)
			return;

		sinco.y += 64;
		sinco.animation.play('jump');
		Global.playSoundEffect('gameplay/sinco-spin');
		sincoDodge();
	}
}

function sincoDeathCheck()
{
	if (SINCO_HEALTH < 1)
	{
		sinco.animation.play('ded');

		osin.animation.pause();
		track.animation.pause();

		sincoDefeated();
	}
}

function osinDeathCheck()
{
	if (OSIN_HEALTH < 1)
	{
		osin_canjump = false;
		osin_warning = false;

		track.animation.pause();
		FlxTween.tween(sinco, {x: 1280}, .5);

		osin.animation.play('hurt');
		osinDefeated();
	}
}

function osinWarning()
{
	osin.animation.play('jump');
	osin_warning = true;
	FlxTween.tween(osin, {y: osinPos.y - 150}, FlxG.random.float(0.5, 1), {
		onComplete: _tween ->
		{
			osinJump();
		}
	});
}

function osinJump()
{
	osin_warning = false;
	osin.animation.play('jump');
	Global.playSoundEffect('gameplay/sinco-jump');
	FlxTween.tween(osin, {x: sincoPos.x, y: sincoPos.y}, osin_jump_speed, {
		onComplete: _tween ->
		{
			osinJumpDone();
		}
	});
}

function osinJumpDone()
{
	var waitn = .25;

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

function osinHitSincoCheck()
{
	sincoHealthIndicator.color = 0xff0000;
	FlxTween.tween(sincoHealthIndicator, {color: 0xffffff}, 1);

	SINCO_HEALTH--;
	Global.hitHurt();

	if (SINCO_HEALTH < 1)
		return;
}

function osinJumpBack()
{
	FlxTween.tween(osin, {x: osinPos.x, y: osinPos.y}, osin_jump_speed, {
		onComplete: _tween ->
		{
			osin.animation.play('run');
			osin_canjump = true;
		}
	});
}

function sincoJump()
{
	FlxTween.tween(sinco, {x: osinPos.x, y: osinPos.y}, sinco_jump_speed, {
		onComplete: _tween ->
		{
			sincoJumpBack();
		}
	});
}

function sincoJumpBack()
{
	osinHurtCheck();

	FlxTween.tween(sinco, {x: sincoPos.x, y: sincoPos.y}, sinco_jump_speed, {
		onComplete: _tween ->
		{
			sinco.animation.play('run');
			if (osin.animation.name == 'hurt')
				osin.animation.play('run');
		}
	});
}

function osinHurtCheck()
{
	if (sinco.overlaps(osin) && osin.animation.name != 'jump')
	{
		osinHealthIndicator.color = 0xff0000;
		FlxTween.tween(osinHealthIndicator, {color: 0xffffff}, 1);
		OSIN_HEALTH--;
		osin.animation.play('hurt');
		Global.hitHurt();
	}
}

function sincoDodge()
{
	FlxTween.tween(sinco, {x: osinPos.x}, sinco_jump_speed, {
		onComplete: _tween ->
		{
			sincoDodgeRecoil();
		}
	});
}

function sincoDodgeRecoil()
{
	FlxTween.tween(sinco, {x: sincoPos.x,}, sinco_jump_speed, {
		onComplete: _tween ->
		{
			sinco.animation.play('run');
			sinco.y -= 64;
		}
	});
}

function sincoDefeated()
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

function osinDefeated()
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

function deathSFX(name:String = 'dead')
{
	if (!playedDeathFX)
	{
		Global.playSoundEffect('gameplay/$name');
		playedDeathFX = true;
	}
}

function endCutsceneTransition()
{
	Global.beatLevel(1);
	FlxG.switchState(() -> new ResultsMenu(SINCO_HEALTH, SINCO_MAX_HEALTH, () -> new PostStage1Cutscene()));
}

var playedDeathFX:Bool = false;
