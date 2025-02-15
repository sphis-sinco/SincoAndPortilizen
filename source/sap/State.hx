package sap;

import sap.modding.source.ModListManager;

class State extends FlxState
{
        override public function new() {
                super();
        }

        override function create() {
                super.create();
        }

        override function update(elapsed:Float) {
                ModListManager.update(elapsed);
                super.update(elapsed);
        }
}