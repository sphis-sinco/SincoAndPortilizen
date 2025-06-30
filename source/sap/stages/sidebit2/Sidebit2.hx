package sap.stages.sidebit2;

class Sidebit2 extends PausableState
{
	public static var DIFFICULTY:String = 'normal';
	public static var DIFFICULTY_JSON:Sidebit2DifficultyJson;

	public static var OP_ATK_CHANCE:Float = 45;

	override public function new(difficulty:String = 'normal')
	{
		super(false);

		DIFFICULTY = difficulty;
		DIFFICULTY_JSON = FileManager.getJSON(FileManager.getDataFile('stages/sidebit2/${difficulty}.json'));

		OP_ATK_CHANCE = DIFFICULTY_JSON.op_attack_chance;
	}

	public static var PLAYER:Sidebit2Character;
	public static var OPPONENT:Sidebit2Character;

	public static var TUTORIAL_SHADER:AdjustColorShader;

	override function create()
	{
		super.create();

		PLAYER = new Sidebit2Character('port');
		OPPONENT = new Sidebit2Character('osin');

		OPPONENT.addAnimationByPrefix('wind-up', 'osin wind-up', 24, false);

		PLAYER.setPosition(-200, 250);
		OPPONENT.setPosition(250, 128);

		add(OPPONENT);
		add(PLAYER);

		OPPONENT.animation.onFinish.add(animName -> {
			switch (animName)
			{
				case 'wind-up':
					OPPONENT.playAnimation('punch');
					if (PLAYER.animation.name != 'block')
						PLAYER.playAnimation('hit');

				default:
					OPPONENT.playAnimation('idle');
			}
		});

		PLAYER.animation.onFinish.add(animName -> {
			switch (animName)
			{
				default:
					PLAYER.playAnimation('idle');
			}
		});

		TUTORIAL_SHADER = new AdjustColorShader();
		TUTORIAL_SHADER.brightness = -50;

		var tutorial1:FlxSprite = new FlxSprite();
		tutorial1.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Left-Dodge'));
		tutorial1.screenCenter();
		tutorial1.y -= tutorial1.height;
		add(tutorial1);

		var tutorial2:FlxSprite = new FlxSprite();
		tutorial2.loadGraphic(FileManager.getImageFile('gameplay/tutorials/non-pixel/Space-Attack'));
		tutorial2.screenCenter();
		tutorial2.y += tutorial2.height;
		add(tutorial2);

		tutorial1.shader = TUTORIAL_SHADER;
		tutorial2.shader = TUTORIAL_SHADER;

		FlxTimer.wait(3, () ->
		{
			FlxTween.tween(tutorial1, {alpha: 0}, 1);
			FlxTween.tween(tutorial2, {alpha: 0}, 1);
		});
	}

	override function postCreate()
	{
		super.postCreate();
	}

	public static var keys:{attack:FlxKey, block:FlxKey} = {
		attack: SPACE,
		block: LEFT
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Global.keyJustReleased(ESCAPE))
		{
			togglePaused();
		}

		if (!paused)
		{
			if (FlxG.random.bool(OP_ATK_CHANCE))
			{
				OPPONENT.playAnimation('wind-up');
			}
			if (Global.anyKeysJustReleased([keys.attack, keys.block])) {}
		}
		PLAYER.animation.paused = paused;
		OPPONENT.animation.paused = paused;
	}
}
