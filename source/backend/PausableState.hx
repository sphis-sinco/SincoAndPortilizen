package backend;

import backend.mobile.BackButton;
import flixel.group.FlxGroup.FlxTypedGroup;
import menus.LevelSelect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;

class PausableState extends State
{
	public var paused:Bool = false;
	public var pauseButton:InteractableSpr;
	public var backButton:InteractableSpr;

	var builtInPausing:Bool = false;

	public var icon_left:Spr;
	public var icon_right:Spr;

	public var icon_left_id:Null<String> = null;
	public var icon_right_id:Null<String> = null;

	override public function new(builtInPausing:Bool = true):Void
	{
		this.builtInPausing = builtInPausing;

		super();
	}

	public var overlay:Spr;
	public var pauseText:FlxText;

	public var behindPauseButtonLayer:FlxTypedGroup<FlxBasic>;

	override function create():Void
	{
		super.create();

		behindPauseButtonLayer = new FlxTypedGroup<FlxBasic>();

		pauseButton = new InteractableSpr('mobile/pause');
		pauseButton.scaleOffset = -2;
		pauseButton.scaleSpr();
		pauseButton.desiredPosition.x = 32;
		pauseButton.desiredPosition.y = 32;
		pauseButton.justReleased.add(() ->
		{
			togglePaused();
		});
	}

	override function update(elapsed:Float):Void
	{
		if (Global.keyJustReleased(ESCAPE) && builtInPausing)
			togglePaused();

		if (Global.keyJustReleased(SPACE) && paused)
		{
			paused = false;
			Global.switchState(new LevelSelect());
		}

		FlxTween.globalManager.active = !paused;
		FlxTimer.globalManager.active = !paused;

		if (behindPauseButtonLayer.members.contains(backButton))
			backButton.visible = true;

		super.update(elapsed);
	}

	public function togglePaused():Void
	{
		paused = !paused;

		if (!paused)
		{
			pauseText.destroy();
			behindPauseButtonLayer.members.remove(pauseText);
			overlay.destroy();
			behindPauseButtonLayer.members.remove(overlay);
			backButton.destroy();
			behindPauseButtonLayer.members.remove(backButton);

			if (icon_left_id != null)
			{
				icon_left.destroy();
				behindPauseButtonLayer.members.remove(icon_left);
			}
			if (icon_right_id != null)
			{
				icon_right.destroy();
				behindPauseButtonLayer.members.remove(icon_right);
			}
		}
		else
		{
			overlay = Global.dummyBG([12, 12, 12]);
			overlay.alpha = 0.5;
			behindPauseButtonLayer.add(overlay);

			pauseText = new FlxText(0, 0, 0, 'PAUSED\n\n[SPACE] to go to the Level Select', 16);
			pauseText.alignment = 'center';
			pauseText.screenCenter(XY);
			behindPauseButtonLayer.add(pauseText);

			if (icon_left_id != null)
			{
				icon_left = new Spr((icon_left_id == MedalStrings.TRES) ? 0 : -2);
				icon_left.loadGraphic(Assets.getImagePath('pauseScreen/icons/$icon_left_id'));
				icon_left.scaleSpr();
				icon_left.screenCenter();
				icon_left.x -= icon_left.width / 2;

				behindPauseButtonLayer.add(icon_left);
			}

			if (icon_right_id != null)
			{
				icon_right = new Spr((icon_right_id == MedalStrings.TRES) ? 0 : -2);
				icon_right.loadGraphic(Assets.getImagePath('pauseScreen/icons/$icon_right_id'));
				icon_right.flipX = (icon_right_id == MedalStrings.TRES) ? false : true;
				icon_right.scaleSpr();
				icon_right.screenCenter();
				icon_right.x += icon_right.width / 2;

				behindPauseButtonLayer.add(icon_right);
			}

			#if MOBILE_BUILD
			pauseText.text = 'PAUSED\n\nTap the back button to go to the Level Select';
			pauseText.screenCenter(XY);

			backButton = new InteractableSpr('mobile/back');
			backButton.desiredPosition.set(FlxG.width - (backButton.width * 4), FlxG.height - (backButton.height * 4));
			backButton.justReleased.add(() ->
			{
				paused = false;

				FlxTween.globalManager.active = !paused;
				FlxTimer.globalManager.active = !paused;

				Global.switchState(new LevelSelect());
			});
			backButton.visible = false;
			behindPauseButtonLayer.add(backButton);
			#end
		}
	}
}
