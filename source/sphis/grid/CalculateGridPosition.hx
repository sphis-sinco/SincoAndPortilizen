package sphis.grid;

import flixel.math.FlxPoint;

class CalculateGridPosition
{

        public static function calculate(x:Int, y:Int):FlxPoint
                return new FlxPoint(x * GridGlobal.GRID_WIDTH,y * GridGlobal.GRID_HEIGHT);
        
}