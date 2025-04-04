package sap.stages.stage2;

import flixel.group.FlxSpriteGroup;

class Stage2 extends State
{
        public static var bg:FlxSprite;

	public static var sinco:Stage2Sinco;

	public static var rockGroup:FlxSpriteGroup;

	override function create():Void
	{
		super.create();

		bg = new FlxSprite().loadGraphic(FileManager.getImageFile('gameplay/sinco stages/Stage2Background'));
		add(bg);
		Global.scaleSprite(bg);
		bg.screenCenter();

		sinco = new Stage2Sinco();
		add(sinco);
		sinco.screenCenter();

		sinco.x += 4 * 8;
		sinco.y += 4 * 24;

		rockGroup = new FlxSpriteGroup();
		add(rockGroup);

		spawnRocks(1);
	}

	public static dynamic function spawnRocks(amount:Int = 1):Void
	{
		var index:Int = 0;

                while (index < amount)
                {
                        var rock:Stage2Rock = new Stage2Rock();
                        rock.setPosition(FlxG.width - rock.width, -rock.height);
                        rockGroup.add(rock);

                        FlxTween.tween(rock, {x: rock.width, y: (bg.graphic.height * Global.DEFAULT_IMAGE_SCALE_MULTIPLIER) / 2}, FlxG.random.float(2, 6), {
                                onUpdate: tween -> {},
                                onComplete: tween ->
                                {
                                        if (rockGroup.members.length < 2) {
                                                spawnRocks(FlxG.random.int(1, 2));
                                        } else {
                                                spawnRocks(1);
                                        }
                                        rock.destroy();
                                        rockGroup.members.remove(rock);
                                }
                        });

                        index++;
                }
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
