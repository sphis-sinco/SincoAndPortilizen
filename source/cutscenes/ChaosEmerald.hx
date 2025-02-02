package cutscenes;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.typeLimit.NextState;
import mainmenu.MainMenu;

class ChaosEmeraldObject extends FlxSprite {

    public var emerld:Int = 0;

    override public function new(emerld:Int = 0) {
        super();

        loadGraphic(FileManager.getImageFile('gameplay/ChaosEmeralds-Regular'), true, 16,16);
        animation.add('all', [0,1,2,3,4,5,6], 0, false);
        animation.play('all');
        animation.pause();
        animation.frameIndex = emerld;

        this.emerld = emerld;

        Global.scaleSprite(this);
    }
    
}

class ChaosEmerald extends FlxState
{
    var chaosemerlds:FlxTypedGroup<ChaosEmeraldObject> = new FlxTypedGroup<ChaosEmeraldObject>();

    override public function new(?nextState:Dynamic = null) {
        super();

        this.nextState = nextState;
        this.nextState ??= () -> new MainMenu();
    }

    var nextState:Dynamic = () -> new MainMenu();

    override function create() {
        super.create();
        FlxG.camera.bgColor = FlxColor.WHITE;

        add(chaosemerlds);

        var wantedPos:Float = 0;

        var i = 6;
        while (i != -1)
        {
            var chaos_emerald = new ChaosEmeraldObject(i);
            chaos_emerald.screenCenter(Y);

            wantedPos = chaos_emerald.y;

            if (chaos_emerald.emerld + 1 > FlxG.save.data.gameplaystatus.chaos_emeralds)
                chaos_emerald.color = 0x000000;

            chaos_emerald.y = -640;
            chaos_emerald.x = (64 * (chaos_emerald.emerld + 1)) + 64;

            chaosemerlds.add(chaos_emerald);
            i--;
        }

        for (chaos_emerald in chaosemerlds)
        {
            FlxTimer.wait(1 + (chaos_emerald.emerld / 100), () -> {
                if (chaos_emerald.emerld == 0) Global.playSoundEffect('gameplay/chaos-emerald-flying');
                FlxTween.tween(chaos_emerald, {y: wantedPos}, 1.75, {
                    ease: FlxEase.sineInOut,
                    onComplete: _tween -> {
                        FlxTimer.wait(1 + (chaos_emerald.emerld / 100), () -> {
                            if (chaos_emerald.emerld == 0) Global.playSoundEffect('gameplay/chaos-emerald');
                            if (chaos_emerald.color == 0x000000)
                            {
                                FlxTween.tween(chaos_emerald, {y: -640}, 2, {
                                    ease: FlxEase.sineInOut
                                });
                            }
                            if (chaos_emerald.emerld == 0) {
                                FlxTimer.wait(2, () -> {
                                    FlxG.camera.fade(0x000000, 0.5, false, () -> {
                                        FlxG.switchState(nextState);
                                    });
                                });
                            }
                        });
                    }
                });
            });
        }
    }
    
}