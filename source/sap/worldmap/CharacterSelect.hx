package sap.worldmap;

class CharacterSelect extends State
{
	public static var CHARACTER_LIST:Array<String> = [];

	public static var CURRENT_SELECTION:Int = 0;

	public static var CHARACTER_SELECTION_BOX:CharSelector;

	public static var CHARACTER_ICON:CharIcon;

	override public function new()
	{
		super();

		init();
	}

	public static function init()
	{
		final hardcoded_charList:Array<String> = ['portilizen', 'sinco'];

		CHARACTER_LIST = [];
		#if !html5
		TryCatch.tryCatch(function()
		{
			for (file in FileManager.readDirectory('assets/data/playable_characters'))
			{
				final name:String = file.split('.')[0];
				final json:PlayableCharacter = PlayableCharacterManager.readPlayableCharacterJSON(name);

				if (json.unlocked_when_loaded)
				{
					unlockCharacter(name);
				}

				CHARACTER_LIST.push(name);
			}
		}, {
				errFunc: function()
				{
					CHARACTER_LIST = hardcoded_charList;
				}
		});
		#else
		CHARACTER_LIST = hardcoded_charList;
		#end
		trace(CHARACTER_LIST);

		CURRENT_SELECTION = CHARACTER_LIST.indexOf(Worldmap.CURRENT_PLAYER_CHARACTER);
	}

	public static function unlockCharacter(name:String)
	{
		#if html5
		if (!WebSave.CHARACTERS.contains(name))
		#else
		if (!FlxG.save.data.unlocked_characters.contains(name))
		#end
		{
			#if html5
			WebSave.CHARACTERS.push(name);
			#else
			FlxG.save.data.unlocked_characters.push(name);
			#end
			trace('Unlocked player character: ${name}');
		}
	}

	override function create()
	{
		super.create();

		var backdrop:FlxSprite = new FlxSprite();
		backdrop.loadGraphic(FileManager.getImageFile('worldmap/character_select/back'), true, 160, 152);
		backdrop.animation.add('idle', [0, 1], 2);
		backdrop.animation.play('idle');
		add(backdrop);
		Global.scaleSprite(backdrop);
		backdrop.screenCenter();

		CHARACTER_SELECTION_BOX = new CharSelector();
		add(CHARACTER_SELECTION_BOX);
		CHARACTER_SELECTION_BOX.screenCenter();
		CHARACTER_SELECTION_BOX.x += 64 + 8;
		CHARACTER_SELECTION_BOX.y -= 8;

		CHARACTER_ICON = new CharIcon(CHARACTER_LIST[CURRENT_SELECTION].toLowerCase());
		add(CHARACTER_ICON);
		CHARACTER_ICON.screenCenter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Worldmap.CURRENT_PLAYER_CHARACTER == CHARACTER_ICON.character)
		{
			if (CHARACTER_ICON.animation.name != 'confirm')
			{
				CHARACTER_ICON.animation.play('confirm');
				CHARACTER_SELECTION_BOX.animation.play('select');
			}
		}
		else
		{
			if (CHARACTER_ICON.animation.name != 'idle')
			{
				CHARACTER_ICON.animation.play('idle', false, true);
			}

			if (CHARACTER_SELECTION_BOX.animation.name != 'idle' && CHARACTER_SELECTION_BOX.animation.finished)
			{
				CHARACTER_SELECTION_BOX.animation.play('idle');
			}
		}

		if (Global.anyKeysJustReleased([LEFT, RIGHT]))
		{
			final left:Bool = Global.keyJustReleased(LEFT);

			CURRENT_SELECTION += (left) ? -1 : 1;

			if (CURRENT_SELECTION < 0)
			{
				CURRENT_SELECTION = 0;
			}
			else if (CURRENT_SELECTION > CHARACTER_LIST.length - 1)
			{
				CURRENT_SELECTION = CHARACTER_LIST.length - 1;
			}
			else
			{
				CHARACTER_ICON.character = CHARACTER_LIST[CURRENT_SELECTION];
				CHARACTER_ICON.refresh();
			}
		}
		else if (Global.keyJustReleased(ENTER))
		{
			var proceed:Bool = true;

			#if html5
			if (!WebSave.CHARACTERS.contains(CHARACTER_ICON.character))
			#else
			if (!SaveManager.getUnlockedCharacters().contains(CHARACTER_ICON.character))
			#end
			{
				trace('Locked character');
				proceed = false;
				CHARACTER_SELECTION_BOX.animation.play('cant-select');
			}

			if (Worldmap.CURRENT_PLAYER_CHARACTER != CHARACTER_ICON.character && proceed)
			{
				Worldmap.CURRENT_PLAYER_CHARACTER = CHARACTER_ICON.character;
			}
		}
		else if (Global.keyJustReleased(ESCAPE))
		{
			Global.switchState(new Worldmap(Worldmap.CURRENT_PLAYER_CHARACTER));
		}
	}
}

class CharSelector extends SparrowSprite
{
	override public function new()
	{
		super('worldmap/character_select/CharSelector');

		addAnimationByPrefix('idle', 'idle', 24, false);
		addAnimationByPrefix('blank', 'character-box', 24, false);
		addAnimationByPrefix('select', 'select', 24, false);
		addAnimationByPrefix('cant-select', 'cant-select', 24, false);

		playAnimation('idle');
		antialiasing = false;
		
		Global.scaleSprite(this, 1);
	}
}
