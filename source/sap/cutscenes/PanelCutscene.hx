package sap.cutscenes;

typedef PanelCutsceneSettings =
{
	var max_panels:Null<Int>;

	var panel_folder:String;
	var panel_prefix:String;

        var ?rpc_details:String;
        var ?rpc_state:Null<String>;
}

class PanelCutscene extends State
{
	private var panel:FlxSprite;

	public var PANEL_FOLDER:String = 'intro/';
	public var PANEL_PREFIX:String = 'intro-';

	public var MAX_PANELS:Int = 5;
	public var CUR_PANEL:Int = 1;

        public var cutsceneSettings:PanelCutsceneSettings;

	override public function new(cutsceneSettings:PanelCutsceneSettings)
	{
		super();

                this.cutsceneSettings = cutsceneSettings;

		if (this.cutsceneSettings.panel_folder == null)
			this.cutsceneSettings.panel_folder = 'intro/';
		if (this.cutsceneSettings.panel_prefix == null)
			this.cutsceneSettings.panel_prefix = 'intro-';
		if (this.cutsceneSettings.max_panels == null)
			this.cutsceneSettings.max_panels = 5;
		if (this.cutsceneSettings.rpc_details == null)
			this.cutsceneSettings.rpc_details = 'In a panel cutscene';
	}

	override public function create()
	{
		PANEL_FOLDER = cutsceneSettings.panel_folder;
		PANEL_PREFIX = cutsceneSettings.panel_prefix;
		MAX_PANELS = cutsceneSettings.max_panels;
                
                Global.changeDiscordRPCPresence(cutsceneSettings.rpc_details, cutsceneSettings.rpc_state);

                panel = new FlxSprite();
		setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
		panel.antialiasing = true;
		panel.screenCenter();
		add(panel);

		Global.playSoundEffect('cutscenes/paper-rustle');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justReleased.SPACE)
		{
			CUR_PANEL++;
			if (CUR_PANEL > MAX_PANELS)
			{
				finishedCutscene();
			}
			Global.playSoundEffect('cutscenes/paper-rustle');
			setPanel('${PANEL_PREFIX}panel$CUR_PANEL');
			panelEvents(CUR_PANEL);
		}

		super.update(elapsed);
	}

	private function setPanel(panelpath:String = 'panel1')
	{
		panel.loadGraphic(FileManager.getImageFile('cutscenes/$PANEL_FOLDER$panelpath'));
	}

	public function finishedCutscene() {}

	public function panelEvents(panel:Int) {}
}
