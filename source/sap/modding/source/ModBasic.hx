package sap.modding.source;

class ModBasic extends FlxBasic
{
        /**
         * This controls if the mod runs or not
         */
        public var enabled:Bool = false;

        /**
         * New ModBasic.
         * @param enabled Should the mod already be enabled
         */
        override public function new(?enabled:Bool = false) {
                super();

                this.enabled = enabled;
        }

        /**
         * Initalization most likely to go here
         */
        function create():Void {}

        /**
         * Run every frame
         * @param elapsed elapsed
         */
        override function update(elapsed:Float) { super.update(elapsed); }
        
}