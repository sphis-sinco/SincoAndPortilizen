package sap.utils;

import sinlib.utilities.FileManager.PathTypes;

class SparrowSprite extends FlxSprite
{
        override public function new(Imagepath:String = '', ?PATH_TYPE:PathTypes, ?X:Float = 0, ?Y:Float = 0):Void {
                super(X,Y);

                frames = FileManager.getSparrowAtlas(Imagepath, PATH_TYPE);
        }

        public function addAnimationByPrefix(name:String, prefix:String, frameRate = 30.0, looped = true, flipX = false, flipY = false):Void
        {
                animation.addByPrefix(name, prefix, frameRate, looped, flipX, flipY);
                playAnimation(name);
        }

        public function playAnimation(animName:String, force = false, reversed = false, frame = 0):Void
        {
                animation.play(animName, force, reversed, frame);
        }
}