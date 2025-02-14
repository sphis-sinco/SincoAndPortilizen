package sap.adv_spr;

typedef AdvancedSpriteParams = {
        public var X:Null<Float>;
        public var Y:Null<Float>;
}

class AdvancedSprite extends FlxSprite
{
        public var params:AdvancedSpriteParams;

        override public function new(params:AdvancedSpriteParams) {
                this.params = params;

                var posX:Float = (this.params.X != null) ? this.params.X : 0;
                var posY:Float = (this.params.Y != null) ? this.params.Y : 0;

                super(posX, posY);
        }
        
}