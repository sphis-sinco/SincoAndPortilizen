package sap.stages;

typedef ProgressBarSettings =
{
	var player:String;
	var opponent:String;

	var player_healthIcon:HealthIcon;
	var opponent_healthIcon:HealthIcon;

	var ?player_healthIcon_flipX:Bool;
	var ?opponent_healthIcon_flipX:Bool;

	var player_health:Int;
	var player_max_health:Int;
	var opponent_health:Int;
	var opponent_max_health:Int;
}

class ProgressBarGroup extends FlxTypedGroup<FlxObject>
{
	final TOLOSS = 'toLoss';
	final LOSS = 'loss';
	final TOWIN = 'toWin';
	final WIN = 'win';
	final NEUTRAL = 'neutral';

	public var player:String;
	public var opponent:String;

	// These control health icon shit
	final MAXIMUM_PERCENT:Float = 100;
	final WINNING_THRESHOLD:Int = 3;
	final LOSING_THRESHOLD:Int = 7;
	final POSITION_OFFSET:Int = 64;

	public var PLAYER_HEALTH_ICON:HealthIcon;
	public var OPPONENT_HEALTH_ICON:HealthIcon;

	public var INFO_TEXTFIELD:FlxText;
	public var INFO_TEXT:String;

	public var PROGRESS_BAR:FlxBar;

	public var PLAYER_HEALTH:Float = 10;
	public var OPPONENT_HEALTH:Float = 10;

	public var PLAYER_MAX_HEALTH:Float = 10;
	public var OPPONENT_MAX_HEALTH:Float = 10;

	override public function new(settings:ProgressBarSettings)
	{
		super();

		player = settings.player;
		PLAYER_HEALTH_ICON = settings.player_healthIcon;
		PLAYER_HEALTH = settings.player_health;
		PLAYER_MAX_HEALTH = settings.player_max_health;

		opponent = settings.opponent;
		OPPONENT_HEALTH_ICON = settings.opponent_healthIcon;
		OPPONENT_HEALTH = settings.opponent_health;
		OPPONENT_MAX_HEALTH = settings.opponent_max_health;

                if (PLAYER_HEALTH_ICON == null) PLAYER_HEALTH_ICON = new HealthIcon('face-healthIcon', 'Face');
                if (OPPONENT_HEALTH_ICON == null) OPPONENT_HEALTH_ICON = new HealthIcon('face-healthIcon', 'Face');

		if (settings.player_healthIcon_flipX != null) PLAYER_HEALTH_ICON.flipX = settings.player_healthIcon_flipX;
		if (settings.opponent_healthIcon_flipX != null || settings.opponent_healthIcon == null ) OPPONENT_HEALTH_ICON.flipX = settings.opponent_healthIcon_flipX;

		PROGRESS_BAR = new FlxBar(0, 0, RIGHT_TO_LEFT, Std.int(FlxG.width / 2), 16, this, 'health', 0, 100, true);
		add(PROGRESS_BAR);
		PROGRESS_BAR.screenCenter(X);
		PROGRESS_BAR.y = FlxG.height - PROGRESS_BAR.height - 64;
		PROGRESS_BAR.createFilledBar(Random.dominantColor(PLAYER_HEALTH_ICON), Random.dominantColor(OPPONENT_HEALTH_ICON), true, FlxColor.BLACK, 4);

		INFO_TEXTFIELD = new FlxText(PROGRESS_BAR.x, PROGRESS_BAR.y + 16, 0, INFO_TEXT, 16);

		add(PLAYER_HEALTH_ICON);
		add(OPPONENT_HEALTH_ICON);

		add(INFO_TEXTFIELD);
	}

	public function updateHealthIndicators():Void
	{
		INFO_TEXT = '$player: ${Global.getLocalizedPhrase('HP')}: $PLAYER_HEALTH/$PLAYER_MAX_HEALTH || $opponent: ${Global.getLocalizedPhrase('HP')}: $OPPONENT_HEALTH/$OPPONENT_MAX_HEALTH';
		PROGRESS_BAR.percent = (OPPONENT_HEALTH / OPPONENT_MAX_HEALTH) * 100;
		INFO_TEXTFIELD.text = INFO_TEXT;
		INFO_TEXTFIELD.screenCenter(X);

		var percent:Float = MAXIMUM_PERCENT - PROGRESS_BAR.percent;

		if (percent < 0)
			percent = 0;

		PLAYER_HEALTH_ICON.x = PROGRESS_BAR.x + ((percent * PROGRESS_BAR.pxPerPercent) - 32);
		OPPONENT_HEALTH_ICON.x = PLAYER_HEALTH_ICON.x + POSITION_OFFSET;

		PLAYER_HEALTH_ICON.y = PROGRESS_BAR.getGraphicMidpoint().y - 48;
		OPPONENT_HEALTH_ICON.y = PLAYER_HEALTH_ICON.y - 4;

		if (OPPONENT_HEALTH_ICON.animation.name.toLowerCase().contains(LOSS))
		{
			OPPONENT_HEALTH_ICON.y = PLAYER_HEALTH_ICON.y + 4;
		}

		if (OPPONENT_HEALTH < WINNING_THRESHOLD)
		{
			if (PLAYER_HEALTH_ICON.animation.name == NEUTRAL && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(TOWIN);
			else if (PLAYER_HEALTH_ICON.animation.name == TOWIN && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(WIN);

			if (OPPONENT_HEALTH_ICON.animation.name == NEUTRAL && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(TOLOSS);
			else if (OPPONENT_HEALTH_ICON.animation.name == TOLOSS && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(LOSS);
		}
		else if (OPPONENT_HEALTH > LOSING_THRESHOLD)
		{
			if (OPPONENT_HEALTH_ICON.animation.name == NEUTRAL && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(TOWIN);
			else if (OPPONENT_HEALTH_ICON.animation.name == TOWIN && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(WIN);

			if (PLAYER_HEALTH_ICON.animation.name == NEUTRAL && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(TOLOSS);
			else if (PLAYER_HEALTH_ICON.animation.name == TOLOSS && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(LOSS);
		}
		else
		{
			if (OPPONENT_HEALTH_ICON.animation.name == WIN && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(TOWIN, false, true);
			else if (OPPONENT_HEALTH_ICON.animation.name == LOSS && OPPONENT_HEALTH_ICON.animation.finished)
				OPPONENT_HEALTH_ICON.playAnimation(TOLOSS, false, true);
			else
				OPPONENT_HEALTH_ICON.playAnimation(NEUTRAL);

			if (PLAYER_HEALTH_ICON.animation.name == WIN && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(TOWIN, false, true);
			else if (PLAYER_HEALTH_ICON.animation.name == LOSS && PLAYER_HEALTH_ICON.animation.finished)
				PLAYER_HEALTH_ICON.playAnimation(TOLOSS, false, true);
			else
				PLAYER_HEALTH_ICON.playAnimation(NEUTRAL);
		}
	}
}
