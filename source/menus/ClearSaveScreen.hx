package menus;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class ClearSaveScreen extends State
{
	public var clearSave:Spr;
	public var cursor:Spr;

	public var yes:InteractableSpr;
	public var no:InteractableSpr;

	public var confirmationText:FlxText;

	override function create()
	{
		super.create();

		clearSave = new Spr(#if !MOBILE_BUILD 0 #else 2 #end);
		clearSave.loadGraphic(Assets.getImagePath('settings/ClearSave'));
		clearSave.scaleSpr();
		clearSave.setPosition(SettingsMenu.clearSavePos.x, SettingsMenu.clearSavePos.y);
		add(clearSave);

		yes = new InteractableSpr('clearSave/buttons');
		yes.loadGraphic(Assets.getImagePath('clearSave/buttons'), true, 64, 64);
		yes.animation.add('yes', [0]);
		yes.animation.play('yes');
		yes.scaleOffset = #if !MOBILE_BUILD - 2 #else 0 #end;
		yes.scaleSpr();
		yes.screenCenter(XY);
		yes.x -= yes.width;

		yes.desiredPosition = yes.getPosition();

		yes.justReleased.add(() ->
		{
			FlxTween.tween(no, {alpha: 0}, 1);
			FlxTween.tween(yes, {alpha: 0}, .5, {
				startDelay: .5
			});
			confirmationText.text = 'Hope you meant it.';
			FlxG.save.erase();

			WebSave.volume = 1;
			WebSave.levels_complete = [];
			WebSave.medals = [];
			WebSave.colored_levelSelect = false;

			Global.change_saveslot(Global.SAVE_SLOT_SUFFIX);

			leave();
		});

		add(yes);
		yes.overlap.add(() ->
		{
			cursor.animation.play('select');
		});

		no = new InteractableSpr('clearSave/buttons');
		no.loadGraphic(Assets.getImagePath('clearSave/buttons'), true, 64, 64);
		no.animation.add('no', [1]);
		no.animation.play('no');
		no.scaleOffset = #if !MOBILE_BUILD - 2 #else 0 #end;
		no.scaleSpr();
		no.screenCenter(XY);
		no.x += no.width;

		no.desiredPosition = no.getPosition();

		no.overlap.add(() ->
		{
			cursor.animation.play('select');
		});

		no.justReleased.add(() ->
		{
			FlxTween.tween(yes, {alpha: 0}, 1);
			FlxTween.tween(no, {alpha: 0}, .5, {
				startDelay: .5
			});
			confirmationText.text = 'Good choice';

			#if !html5
			if (FlxG.save.data.levels_complete.contains(2))
			#else
			if (WebSave.levels_complete.contains(2))
			#end
			{
				confirmationText.text += '\nI wouldn\'t either.';
			}

			leave();
		});
		add(no);

		confirmationText = new FlxText();
		confirmationText.text = 'Are you sure?';
		confirmationText.size = 16;
		#if MOBILE_BUILD confirmationText.size = 32; #end
		confirmationText.alignment = 'center';
		add(confirmationText);

		cursor = new Spr(-3);

		if (SettingsMenu.cursorSkin == 2)
		{
			cursor.loadGraphic(Assets.getImagePath('settings/cursors/sinco'), true, 64, 64);
			cursor.color = 0x4eb10c;
		}
		else
		{
			cursor.loadGraphic(Assets.getImagePath('settings/cursors/port'), true, 64, 64);
			cursor.color = 0x4e0c6f;
		}

		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');
		add(cursor);

		#if MOBILE_BUILD
		cursor.visible = false;
		#end

		Global.changeDiscordRPCPresence('Contemplating everything they went through.', 'Settings Menu / Clear Save Screen');

		yes.alpha = 0;
		no.alpha = 0;
		confirmationText.alpha = 0;

		FlxTween.tween(yes, {alpha: 1}, 1);
		FlxTween.tween(no, {alpha: 1}, 1);
		FlxTween.tween(confirmationText, {alpha: 1}, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMenuMusic();

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');

		confirmationText.screenCenter();
		confirmationText.y -= (confirmationText.height * 4);
	}

	public function leave()
	{
		yes.justReleased.removeAll();
		no.justReleased.removeAll();

		FlxTween.tween(confirmationText, {alpha: 0}, 1);
		FlxTimer.wait(1, () ->
		{
			Global.switchState(new SettingsMenu());
		});
		FlxG.save.flush();

		FlxG.sound.volume = FlxG.save.data.volume;
	}
}
