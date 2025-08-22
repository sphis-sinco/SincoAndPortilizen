package menus;

import flixel.tweens.FlxTween;
import flixel.util.FlxCollision;
import flixel.text.FlxText;

class TitleScreen extends State
{
	public var logo:Spr;
	public var logoSuffixes:Array<String> = ['', '-dj', '-paul'];

	public var levelSelect:InteractableSpr;
	public var settings:InteractableSpr;
	public var creditsButton:InteractableSpr;

	public var cursor:Spr;

	override function create()
	{
		super.create();

		logo = new Spr(#if !MOBILE_BUILD (-3) #else (-2) #end);
		logo.loadGraphic(Assets.getImagePath('title/logo${logoSuffixes[FlxG.random.int(0, logoSuffixes.length - 1)]}'));
		logo.scaleSpr();
		logo.screenCenter();
		logo.y -= logo.height / 4;
		add(logo);

		cursor = new Spr(-3);
		cursor.loadGraphic(Assets.getImagePath('levelSelect/cursor'), true, 64, 64);
		cursor.animation.add('idle', [0], 24);
		cursor.animation.add('select', [1], 24);
		cursor.animation.play('idle');

		creditsButton = new InteractableSpr('levelSelect/credits');
		creditsButton.scaleOffset = #if !MOBILE_BUILD (-3) #else 0 #end;
		creditsButton.scaleSpr();
		creditsButton.setPosition(FlxG.width - creditsButton.width - 32, FlxG.height - creditsButton.height - 32);
		add(creditsButton);

		levelSelect = new InteractableSpr('title/levelSelect');
		levelSelect.scaleOffset = #if !MOBILE_BUILD (-2) #else 0 #end;
		levelSelect.scaleSpr();
		levelSelect.screenCenter();
		levelSelect.x -= (levelSelect.width / 2);
		levelSelect.y += (logo.height / 4);
		add(levelSelect);

		settings = new InteractableSpr('title/settings');
		settings.scaleOffset = #if !MOBILE_BUILD (-2) #else 0 #end;
		settings.scaleSpr();
		settings.screenCenter();
		settings.x += (settings.width / 2);
		settings.y += (logo.height / 4);
		add(settings);

		creditsButton.desiredPosition = creditsButton.getPosition();
		levelSelect.desiredPosition = levelSelect.getPosition();
		settings.desiredPosition = settings.getPosition();

		#if MOBILE_BUILD
		cursor.visible = false;
		#end

		var cursorAnimate = () ->
		{
			cursor.animation.play('select');
		}

		creditsButton.overlap.add(cursorAnimate);
		levelSelect.overlap.add(cursorAnimate);
		settings.overlap.add(cursorAnimate);

		creditsButton.justReleased.add(() ->
		{
			Global.switchState(new Credits());
		});
		levelSelect.justReleased.add(() ->
		{
			Global.switchState(new LevelFolderSelect());
		});
		settings.justReleased.add(() ->
		{
			Global.switchState(new SettingsMenu());
		});

		Global.changeDiscordRPCPresence('', 'Title Screen');

		var watermarkText = 'v${Global.VERSION}';
		#if NEWGROUNDS
		watermarkText += '-NG';
		#end
		watermarkText += ' (b${Global.BUILD})';

		add(new FlxText(3, FlxG.height - #if !MOBILE_BUILD 32 #else 64 #end, FlxG.width, watermarkText,
			#if !MOBILE_BUILD 16 #else 32 #end));
		add(cursor);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMenuMusic();

		cursor.setPosition(FlxG.mouse.x - (cursor.width / 2), FlxG.mouse.y - (cursor.height / 2));
		cursor.animation.play('idle');
	}
}
