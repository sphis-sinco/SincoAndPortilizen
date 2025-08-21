package menus;

import backend.levelselect.FolderSpr;

class LevelFolderSelect extends State
{
	public var cursor:Spr;

	public var base:FolderSpr;
	public var sidebits:FolderSpr;

	override function create()
	{
		super.create();

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		base = new FolderSpr('base', Assets.getFileJsonContent('level_folders/base.json'));
		add(base);
		base.file.screenCenter();
                base.file.x -= base.file.width / 2;
		base.file.desiredPosition = base.file.getPosition();

		sidebits = new FolderSpr('sidebits', Assets.getFileJsonContent('level_folders/sidebits.json'));
		add(sidebits);
		sidebits.file.screenCenter();
                sidebits.file.x += sidebits.file.width / 2;
		sidebits.file.desiredPosition = sidebits.file.getPosition();

		add(cursor);

		#if MOBILE_BUILD
		add(new backend.mobile.BackButton(new TitleScreen()));
		#end
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');
	}

	public function switchToLS(folder:String = 'base/')
	{
		LevelSelect.levelsFolder = folder;
		Global.switchState(new LevelSelect());
	}
}
