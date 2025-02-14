package sap.cutscenes;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import sap.mainmenu.MainMenu;

class ChaosEmeraldObject extends FlxSprite
{
	public var emerld:Int = 0;

	override public function new(emerld:Int = 0)
	{
		super();

		loadGraphic(FileManager.getImageFile('gameplay/ChaosEmeralds-Regular'), true, 16, 16);
		animation.add('all', [0, 1, 2, 3, 4, 5, 6], 0, false);
		animation.play('all');
		animation.pause();
		animation.frameIndex = emerld;

		this.emerld = emerld;

		Global.scaleSprite(this);
	}
}

class ChaosEmerald extends FlxState
{
	var chaosemerlds:FlxTypedGroup<ChaosEmeraldObject> = new FlxTypedGroup<ChaosEmeraldObject>();

	override public function new(?nextState:Dynamic = null)
	{
		super();

		this.nextState = nextState;
		this.nextState ??= () -> new MainMenu();
	}

	var nextState:Dynamic = () -> new MainMenu();

	var wantedPos:Float = 0;

	override function create()
	{
		super.create();
		FlxG.camera.bgColor = FlxColor.WHITE;

		add(chaosemerlds);

		#if debug
		FlxG.save.data.gameplaystatus.chaos_emeralds = FlxG.random.int(0, 6);
		#end

		var i = 6;
		while (i != -1)
		{
			makeEmerald(i);
		}

		for (chaos_emerald in chaosemerlds)
		{
			FlxTimer.wait(1 + (chaos_emerald.emerld / 100), () ->
			{
				if (chaos_emerald.emerld == 0)
					Global.playSoundEffect('gameplay/chaos-emerald-flying');
				ceTween1(chaos_emerald);
			});
		}
	}

	public function makeEmerald(i:Int)
	{
		var chaos_emerald = new ChaosEmeraldObject(i);
		chaos_emerald.screenCenter(Y);

		wantedPos = chaos_emerald.y;

		if (chaos_emerald.emerld + 1 < FlxG.save.data.gameplaystatus.chaos_emeralds)
			chaos_emerald.color = 0xffffff;
		else
			chaos_emerald.color = 0x000000;

		chaos_emerald.y = -640;
		chaos_emerald.x = (64 * (chaos_emerald.emerld + 1)) + 64;

		chaosemerlds.add(chaos_emerald);
		i--;
	}

	public function ceTween1(chaos_emerald:ChaosEmeraldObject)
	{
		FlxTween.tween(chaos_emerald, {y: wantedPos}, 1.75, {
			ease: FlxEase.sineInOut,
			onComplete: _tween ->
			{
				ceTween2(chaos_emerald);
			}
		});
	}

	public function ceTween2(chaos_emerald:ChaosEmeraldObject)
	{
		FlxTimer.wait(1 + (chaos_emerald.emerld / 100), () ->
		{
			if (chaos_emerald.emerld == 0)
				Global.playSoundEffect('gameplay/chaos-emerald');

			endSequence(chaos_emerald);
		});
	}

	public function endSequence(chaos_emerald:ChaosEmeraldObject)
	{
		if (chaos_emerald.emerld + 1 > FlxG.save.data.gameplaystatus.chaos_emeralds)
		{
			chaosEmeraldFly(chaos_emerald);
		}
		else
		{
			FlxTween.tween(chaos_emerald, {color: 0xffffff}, 1);
		}

		if (chaos_emerald.emerld == 0)
		{
			fadeOut();
		}
	}

	public function chaosEmeraldFly(chaos_emerald:ChaosEmeraldObject)
	{
		FlxTween.tween(chaos_emerald, {y: -640}, 2, {
			ease: FlxEase.sineInOut
		});
	}

	public function fadeOut()
	{
		FlxTimer.wait(2, () ->
		{
			FlxG.camera.fade(0x000000, 0.5, false, () ->
			{
				FlxG.switchState(nextState);
			});
		});
	}
}
