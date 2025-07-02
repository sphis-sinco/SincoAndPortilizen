package sap.changelog;

import sap.mainmenu.MainMenu;
import sap.title.TitleState;

class ChangelogMenu extends State
{
	public static var instance:ChangelogMenu;

	public var paper:SparrowSprite;
	public var changelogText:FlxText;
	public var FAKEchangelogText:FlxText;
	public var CHANGELOG:Array<String> = FileManager.readFile('CHANGELOG.md').split('<version>');
	public var CHANGELOG_INDEX:Int = 1;
	public var CHANGELOG_MOVE:Int = 8;

	override function create()
	{
		super.create();

		paper = new SparrowSprite('changelog/ChangelogPaper');
		paper.addAnimationByPrefix('grab', 'grab', 24, false);
		paper.addAnimationByPrefix('open', 'open', 24, false);
		paper.addAnimationByPrefix('grab-rev', 'grab', 24, false);
		paper.addAnimationByPrefix('open-rev', 'open', 24, false);
		paper.addAnimationByPrefix('idle', 'idle', 24, false);
		paper.playAnimation('grab');
		Global.scaleSprite(paper, -2);
		paper.screenCenter();
		paper.antialiasing = false;
		add(paper);

		FAKEchangelogText = new FlxText(64, 32, 640 - 64 * 1.5, '', 16);
		FAKEchangelogText.color = FlxColor.BLACK;
		add(FAKEchangelogText);

		changelogText = new FlxText(64, 32, 640 - 64 * 1.5, '', 16);
		changelogText.color = FlxColor.BLACK;
		changelogText.alpha = 0;
		add(changelogText);

		instance = this;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMenuMusic();

		if (changelogText.text != CHANGELOG[CHANGELOG_INDEX])
		{
			changelogText.text = '';
			var i = 1;
			for (change in CHANGELOG[CHANGELOG_INDEX].split('\n'))
			{
				if (change.length > 1)
				{
					if (!change.startsWith('#'))
					{
						// changelogText.text += '$i ';
						i++;
					}
					else
					{
						changelogText.text += '$';
					}

					changelogText.text += '$change\n';

					if (change.startsWith('#'))
						changelogText.text += '$';
				}
			}

			FAKEchangelogText.text = changelogText.text.replace('$', '').replace('*', '').replace('`', '');

			var headers:FlxTextFormat = new FlxTextFormat(FlxColor.BLUE, true);
			var bold:FlxTextFormat = new FlxTextFormat(FlxColor.GREEN, true);
			var idkwtic:FlxTextFormat = new FlxTextFormat(FlxColor.ORANGE, true);

			changelogText.applyMarkup(changelogText.text, [
				new FlxTextFormatMarkerPair(headers, '$'),
				new FlxTextFormatMarkerPair(bold, '**'),
				new FlxTextFormatMarkerPair(idkwtic, '`')
			]);
		}

		if (paper.animation.finished && paper.animation.name != 'idle')
		{
			switch (paper.animation.name)
			{
				case 'grab-rev':
					Global.switchState(new MainMenu());
				case 'open-rev':
					paper.playAnimation('grab-rev', false, true);
				case 'grab':
					paper.playAnimation('open');
				case 'open':
					paper.playAnimation('idle');
					FlxTween.tween(changelogText, {alpha: 1.0}, 1.0, {
						onComplete: tween ->
						{
							FAKEchangelogText.visible = false;
						}
					});
			}
		}

		var math = -changelogText.text.length * CHANGELOG_MOVE;
		if (Global.keyPressed(UP))
		{
			changelogText.y += CHANGELOG_MOVE;
			if (changelogText.y >= 32)
			{
				changelogText.y = 32;
			}
		}
		if (Global.keyPressed(DOWN))
		{
			changelogText.y -= CHANGELOG_MOVE;
			if (changelogText.y < math)
			{
				changelogText.y = math;
			}
		}
		FAKEchangelogText.setPosition(changelogText.x, changelogText.y);

		if (Global.keyPressed(ESCAPE))
		{
			paper.playAnimation('open-rev', false, true);

			FlxTween.cancelTweensOf(changelogText);
			FAKEchangelogText.visible = true;
			FlxTween.tween(changelogText, {alpha: 0.0}, 0.2);
		}
	}
}
