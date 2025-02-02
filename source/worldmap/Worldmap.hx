package worldmap;

class Worldmap extends FlxState
{
    var character:MapCharacter = new MapCharacter();

    override function create() {
        super.create();

        character.screenCenter();
        add(character);
    }
}