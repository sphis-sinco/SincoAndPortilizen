import funkin.graphics.shaders.AdjustColorShader;
import sap.mainmenu.MainMenu;
import sap.mainmenu.PlayMenu;
import sap.stages.stage1.Stage1;
import sap.stages.stage2.Stage2;
import sap.stages.stage4.Stage4;
import sap.title.TitleState;

function initalizeMod()
{
	Version.MajorVersion = 1;
	Version.MinorVersion = 1;
	Version.PatchVersion = 0;
	Version.HotfixVersion = 1;
	Version.Suffix = '';
}

function statePostCreate()
{
	var curState:String = Global.getCurrentState();

	var coolShader:AdjustColorShader;
	coolShader = new AdjustColorShader();
	coolShader.hue = 255;

	if (curState == 'TitleState')
	{
		TitleState.CHARACTER_RING_CHARS_SHADER.hue = 255;
		TitleState.MINI_SINCO.shader = coolShader;
		TitleState.MINI_PORTILIZEN.shader = coolShader;
	}
	else if (curState == 'MainMenu' || curState == 'PlayMenu')
	{
		MainMenu.sinco.shader = coolShader;
		MainMenu.port.shader = coolShader;
	}
	else if (curState == 'Stage1')
	{
		Stage1.sinco.shader = coolShader;

		// lisn
		Stage1.osin.shader = coolShader;
	}
	else if (curState == 'Stage2')
	{
		Stage2.sinco.shader = coolShader;
	}
	else if (curState == 'Stage4')
	{
		Stage4.port.shader = coolShader;
	}
	else if (curState == 'Sidebit1')
	{
		Sidebit1.SINCO.shader = coolShader;
		Sidebit1.PORTILIZEN.shader = coolShader;
	}
}
