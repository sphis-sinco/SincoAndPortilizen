package sap.stages;

class HealthIcon extends SparrowSprite
{
	override public function new(iconPath:String, symbolPrefix:String)
	{
		super(iconPath, 0, 0);

                addAnimationByPrefix('neutral', '${symbolPrefix} neutral', 24, false);

                addAnimationByPrefix('loss', '${symbolPrefix} loss', 24, false);
                addAnimationByPrefix('win', '${symbolPrefix} win', 24, false);

                addAnimationByPrefix('toLoss', '${symbolPrefix} toLoss', 24, false);
                addAnimationByPrefix('toWin', '${symbolPrefix} toWin', 24, false);

                playAnimation('neutral');
	}
}
