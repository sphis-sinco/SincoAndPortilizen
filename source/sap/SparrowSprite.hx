package sap;

import flixel.graphics.frames.FlxAtlasFrames;

class SparrowSprite extends FlxSprite
{
        override public function new(Imagepath:String = '', ?X:Float = 0, ?Y:Float = 0) {
                super(X,Y);

                frames = FlxAtlasFrames.fromSparrow(FileManager.getImageFile(Imagepath), FileManager.getAssetFile('images/$Imagepath.xml'));
        }

        public function addAnimationByPrefix(name:String, prefix:String, frameRate = 30.0, looped = true, flipX = false, flipY = false)
        {
                animation.addByPrefix(name, prefix, frameRate, looped, flipX, flipY);
        }

        public function playAnimation(animName:String, force = false, reversed = false, frame = 0)
        {
                animation.play(animName, force, reversed, frame);
        }
}