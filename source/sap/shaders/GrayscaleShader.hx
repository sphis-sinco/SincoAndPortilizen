package sap.shaders;

class GrayscaleShader extends ColorMatrixFilterShaders
{
	override public function new() {
                super([
                        0.5, 0.5, 0.5, 0, 0,
                        0.5, 0.5, 0.5, 0, 0,
                        0.5, 0.5, 0.5, 0, 0,
                          0,   0,   0, 1, 0,
                ]);
        }

        override function getFilterString():String {
                return 'grayscale';
        }
}
