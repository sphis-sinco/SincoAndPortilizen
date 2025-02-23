package sap.shaders;

import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;

class ColorMatrixFilterShaders extends BitmapFilter
{
        public var shader:ColorMatrixFilter;

        override public function new(matrix:Array<Float>) {
                super();

                shader = new ColorMatrixFilter(matrix);
        }

        public function getFilter():ColorMatrixFilter
        {
                return shader;
        }

        public function getFilterString():String
        {
                return 'colormatrixfilter';
        }
}