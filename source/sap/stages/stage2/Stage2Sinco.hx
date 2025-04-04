package sap.stages.stage2;

class Stage2Sinco extends FlxSprite
{

        override public function new():Void {
                super();

                loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage2Sinco'), true, 32, 32);
                animation.add('idle', [0], 0, true);
                animation.add('fail', [1], 0, false);
                animation.add('jump', [2], 0, false);

                animation.play('idle');

                Global.scaleSprite(this);
        }
        
}