package worldmap;

class Worldmap extends FlxState
{
    var character:MapCharacter = new MapCharacter();

    var map:Map<Int, String> = [
        1 => "stage1",
        2 => "stage2",
        3 => "stage3"
    ];

    override function create() {
        super.create();

        character.screenCenter();
        add(character);
    }
}