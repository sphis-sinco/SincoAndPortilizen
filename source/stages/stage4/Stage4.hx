package stages.stage4;

class Stage4 extends FlxState
{
    var port:PortS4 = new PortS4();

    override function create() {
        super.create();

        port.screenCenter();
        add(port);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}