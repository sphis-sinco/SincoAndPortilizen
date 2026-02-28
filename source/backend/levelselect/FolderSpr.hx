package backend.levelselect;

import flixel.group.FlxSpriteGroup;

class FolderSpr extends FlxSpriteGroup
{
	public var state:String = 'open';
	public var folder:String = 'base';

	public var folder_label:Spr;
	public var folder_front:Spr;
	public var file:InteractableSpr;
	public var folder_back:Spr;

	public var data:LevelFolderData;

	override public function new(folder:String = 'base', data:LevelFolderData)
	{
		super();

		this.data = data;
		this.folder = folder;

		final scaleOffset = #if MOBILE_BUILD 0 #else (-2) #end;

		folder_label = new Spr(scaleOffset);
		folder_front = new Spr(scaleOffset);
		file = new InteractableSpr('levelSelect/levelFolders/folder/$state-file');
		file.scaleOffset = scaleOffset;
		folder_back = new Spr(scaleOffset);

		folder_label.scaleSpr();
		folder_front.scaleSpr();
		file.scaleSpr();
		folder_back.scaleSpr();

		folder_label.screenCenter();
		folder_front.screenCenter();
		file.screenCenter();
		folder_back.screenCenter();

		folder_label.color = FlxColor.fromRGB(data.folder_color[0], data.folder_color[1], data.folder_color[2]);
		folder_front.color = FlxColor.fromRGB(data.folder_color[0], data.folder_color[1], data.folder_color[2]);
		file.color = FlxColor.fromRGB(data.file_color[0], data.file_color[1], data.file_color[2]);
		folder_back.color = FlxColor.fromRGB(data.folder_color[0], data.folder_color[1], data.folder_color[2]);

		add(folder_back);
		add(file);
		add(folder_front);
		add(folder_label);
		file.desiredPosition = file.getPosition();

		file.overlap.add(() ->
		{
			state = 'open';
		});
		file.unoverlap.add(() ->
		{
			state = 'closed';
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		folder_label.loadGraphic(Assets.getImagePath('levelSelect/levelFolders/$folder-$state'));
		folder_front.loadGraphic(Assets.getImagePath('levelSelect/levelFolders/folder/$state'));
		file.loadGraphic(Assets.getImagePath('levelSelect/levelFolders/folder/$state-file'));
		folder_back.loadGraphic(Assets.getImagePath('levelSelect/levelFolders/folder/$state-back'));

		folder_label.scale.set(file.scale.x, file.scale.y);
		folder_front.scale.set(file.scale.x, file.scale.y);
		folder_back.scale.set(file.scale.x, file.scale.y);

		final divisionValue = #if MOBILE_BUILD 1 #else 2 #end;
		final additionValue = #if MOBILE_BUILD 64 #else 0 #end;

		folder_back.setPosition(file.x
			+ (folder_back.width / divisionValue)
			+ additionValue, file.y
			+ (folder_back.height / divisionValue)
			+ additionValue);
		folder_front.setPosition(folder_back.x, folder_back.y);
		folder_label.setPosition(folder_front.x, folder_front.y);
	}
}
