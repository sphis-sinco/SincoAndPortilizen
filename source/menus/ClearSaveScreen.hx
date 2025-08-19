package menus;

import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class ClearSaveScreen extends State
{
	public var clearSave:Spr;
	public var cursor:Spr;

	public var yes:Spr;
	public var no:Spr;

	public var confirmationText:FlxText;

	override function create()
	{
		super.create();

		clearSave = new Spr();
		clearSave.loadGraphic(Assets.getImagePath('settings/ClearSave'));
		clearSave.scaleSpr();
		clearSave.setPosition(SettingsMenu.clearSavePos.x, SettingsMenu.clearSavePos.y);
		add(clearSave);

		yes = new Spr(-2);
		yes.loadGraphic(Assets.getImagePath('clearSave/buttons'), true, 64, 64);
		yes.animation.add('yes', [0]);
		yes.animation.play('yes');
		yes.scaleSpr();
		yes.screenCenter(XY);
		yes.x -= yes.width;
		add(yes);

		no = new Spr(-2);
		no.loadGraphic(Assets.getImagePath('clearSave/buttons'), true, 64, 64);
		no.animation.add('no', [1]);
		no.animation.play('no');
		no.scaleSpr();
		no.screenCenter(XY);
		no.x += no.width;
		add(no);

		confirmationText = new FlxText();
		confirmationText.text = 'Are you sure?';
		confirmationText.size = 16;
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

		for (button in [yes, no])
		{
			button.scaleSpr();

			if (FlxCollision.pixelPerfectCheck(cursor, button))
			{
				cursor.animation.play('select');

				button.scale.set(button.scale.x - .1, button.scale.y - .1);

				if (FlxG.mouse.justReleased)
				{
					var ps = true;

					if (button == yes)
					{
						FlxTween.tween(no, {alpha: 0}, 1);
						confirmationText.text = 'Hope you meant it.';
						FlxG.save.erase();
						Global.change_saveslot(Global.SAVE_SLOT_SUFFIX);
					}
					else if (button == no)
					{
						FlxTween.tween(yes, {alpha: 0}, 1);
						confirmationText.text = 'Good choice';

						if (FlxG.save.data.levels_complete.contains(2))
							confirmationText.text += '\nI wouldn\'t either.';
					}

					if (ps)
						Global.playSoundEffect('blipSelect');

					Global.switchState(new SettingsMenu());
					FlxG.save.flush();
				}
			}
		}

		confirmationText.screenCenter();
		confirmationText.y -= (confirmationText.height * 4);
	}
}
