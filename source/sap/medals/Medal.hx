package sap.medals;

class Medal extends FlxTypedGroup<FlxObject>
{
        var medalBox:MedalBox;
        
        var medalIcon:FlxSprite;
        
        override public function new(medal:String = 'award'):Void {
                super();

                medalBox = new MedalBox();
                add(medalBox);
                final medalboxmid:FlxPoint = medalBox.getMidpoint();

                var path:String = FileManager.getImageFile('${medalBox.assetFolder}/awards/${medal}');

                if (!FileManager.exists(path))
                {
                        path.replace(medal, 'award');
                }

                medalIcon = new FlxSprite().loadGraphic(path);
                add(medalIcon);
                Global.scaleSprite(medalIcon, -2);

                final offset:Float = 2*4;
                medalIcon.setPosition(medalBox.HORIZONTAL_POSITION + offset, medalBox.VERTICAL_POSITION + offset);

                FlxTimer.wait(2, () -> {
                        FlxTween.tween(medalBox, {alpha: 0}, 1, {onComplete: tween -> { medalBox.destroy(); }});
                        FlxTween.tween(medalIcon, {alpha: 0}, 1, {onComplete: tween -> { medalIcon.destroy(); }});
                        FlxTimer.wait(1, () -> { this.destroy(); });
                });
        }
        
}