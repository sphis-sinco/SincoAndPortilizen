package sap.cutscenes;

class PanelCutscene extends State
{
	private var PANEL_SPRITE:FlxSprite;

	public var PANEL_FOLDER:String = 'intro/';
	public var PANEL_PREFIX:String = 'intro-';

	public var MAX_PANELS:Int = 5;
	public var CUR_PANEL:Int = 1;

	public var CUTSCENE_JSON:CutsceneJson;

	override public function new(cutscenePath:String):Void
	{
		super();

		this.CUTSCENE_JSON = FileManager.getJSON(FileManager.getDataFile('${cutscenePath}.json', CUTSCENES));

		if (this.CUTSCENE_JSON.panel_folder == null)
		{
			this.CUTSCENE_JSON.panel_folder = 'intro/';
		}
		if (this.CUTSCENE_JSON.panel_prefix == null)
		{
			this.CUTSCENE_JSON.panel_prefix = 'intro-';
		}
		if (this.CUTSCENE_JSON.max_panels == null)
		{
			this.CUTSCENE_JSON.max_panels = 5;
		}
		if (this.CUTSCENE_JSON.rpc_details == null)
		{
			this.CUTSCENE_JSON.rpc_details = 'In a panel cutscene';
		}
	}

	override public function create():Void
	{
		PANEL_FOLDER = CUTSCENE_JSON.panel_folder;
		PANEL_PREFIX = CUTSCENE_JSON.panel_prefix;
		MAX_PANELS = CUTSCENE_JSON.max_panels;

		Global.changeDiscordRPCPresence(CUTSCENE_JSON.rpc_details, CUTSCENE_JSON.rpc_state);

		PANEL_SPRITE = new FlxSprite();
		setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
		PANEL_SPRITE.antialiasing = true;
		PANEL_SPRITE.screenCenter();
		add(PANEL_SPRITE);

		Global.playSoundEffect('paper-rustle', CUTSCENES);
                panelEvents(CUR_PANEL);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justReleased.SPACE)
		{
			CUR_PANEL++;
			if (CUR_PANEL > MAX_PANELS)
			{
				finishedCutscene();
			}
			Global.playSoundEffect('paper-rustle', CUTSCENES);
			setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
			panelEvents(CUR_PANEL);
		}

		super.update(elapsed);
	}

	private function setPanel(panelpath:String = 'panel1'):Void
	{
		PANEL_SPRITE.loadGraphic(FileManager.getImageFile('$PANEL_FOLDER$panelpath', CUTSCENES));
	}

	public function finishedCutscene():Void {}

	public function panelEvents(panel:Int):Void {}
}
