function create()
{
	time = 0;
	
	waitSec();

	Global.changeDiscordRPCPresence('Stage 4: Dimensional String', null);

	enemyCanAttack = true;
}

function waitSec()
{
	timerText.text = Std.string(StageGlobals.STAGE4_START_TIMER - time);

	FlxTimer.wait(1, () ->
	{
		time++;
		waitSec();
	});
}

var enemyCanAttack:Bool = true;
var portJumping:Bool = false;
var portJumpSpeed:Float = 0.5;

function update(elapsed:Float)
{
	if (FlxG.keys.justReleased.SPACE && !portJumping)
	{
		portPreJump();
	}

	if (enemyAttackCondition())
	{
		enemyCanAttack = false;
		enemyCharge();
	}
}

function enemyAttackCondition():Bool
{
	return (FlxG.random.bool(25) && enemyCanAttack);
}

function portPreJump()
{
	portJumping = true;

	var portjumpheight:Float = port.height * StageGlobals.DISMx2;

	port.animation.play('jump');
	portJump(portjumpheight);
}

function portJump(portjumpheight:Float)
{
	Global.playSoundEffect('portilizen-jump-stage4');
	FlxTween.tween(port, {y: port.y - portjumpheight}, portJumpSpeed, {
		onComplete: tween ->
		{
			portFall(portjumpheight);
		}
	});
}

function portFall(portjumpheight:Float)
{
	FlxTween.tween(port, {y: port.y + portjumpheight}, portJumpSpeed, {
		onComplete: tween ->
		{
			portJumping = false;
			port.animation.play('run');
		}
	});
}

function enemyCharge()
{
	FlxTween.tween(enemy, {x: port.x}, 1, {
		onComplete: tween ->
		{
			enemyChargeComplete();
		}
	});
}

function enemyChargeComplete()
{
	if (enemy.overlaps(port))
	{
		FlxG.camera.flash();
		moveToResultsMenu();
	}

	enemyRetreat();
}

function enemyRetreat()
{
	FlxTween.tween(enemy, {x: enemyX}, 1, {
		onComplete: enemyRetreatComplete()
	});
}

function enemyRetreatComplete():TweenCallback
{
	return tween ->
	{
		FlxTimer.wait(FlxG.random.int(1, 2), () ->
		{
			enemyCanAttack = true;
		});
	}
}
