package sap.stages.stage2;

class Stage2 extends State
{
        public static var sinco:Stage2Sinco;

        override function create() {
                super.create();

                var bg:FlxSprite = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage2Background'));
                add(bg);
                Global.scaleSprite(bg);
                bg.screenCenter();

                sinco = new Stage2Sinco();
                add(sinco);
                sinco.screenCenter();

                sinco.x += 4 * 8;
                sinco.y += 4 * 24;

                var rock:Stage2Rock = new Stage2Rock();
                rock.setPosition(FlxG.width - rock.width, -rock.height);
                add(rock);

                FlxTween.tween(rock, {x: rock.width, y: (bg.graphic.height * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER) / 2}, 4, { onUpdate: tween -> {}, onComplete: tween -> {}});
        }

        override function update(elapsed:Float) {
                super.update(elapsed);
        }
        
}